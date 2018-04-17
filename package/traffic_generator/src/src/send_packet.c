
#include "../header/core.h"

void set_mac(uint8_t *mac, char *s);
void set_vlan(vlan_hdr *vlan, int pri, int cfi, int vlan_id);
void set_ip(ip_hdr *ip, char *s, char *d, int type, int dataLen);
void set_udp(udp_hdr *udp, int sport, int dport, int dataLen);
void set_tcp(tcp_hdr *tcp, int sport, int dport, int dataLen);
void set_eth(ether_hdr *eth, char *s, char *d, int type);

void send_packet(pcap_t *pcap, unsigned char *frame, int len);
void send_frame(unsigned char *frame,const char *interface,ip_hdr *ip ,int length, int packet_num);

void init_pcap(pcap_t **pcap,const char *interface);

uint16_t checksum (uint16_t *addr, int len);
uint16_t udp4_checksum (void *ip, void *udp, uint8_t *payload, int payloadlen);
uint16_t tcp4_checksum (void *, void *, uint8_t *, int);

int 
main(int argc, const char* argv[]) {
    unsigned char frame[4096];
    unsigned char *data;
    vlan_hdr *vlan;
    void *ip, *eth, *udp, *tcp;
    int dataLen = 0;
    int vlan_flag = 0;
    int packet_num = 0;
    int ip_type;
    int total_len = 0;
    int ip_total_len = 0;

    pcap_t* pcap = NULL;

    if (argc<2) {
        fprintf(stderr,"usage: send_ip <interface>\n");
        exit(1);
    }
	
	const char system_setup[]="{\
	\"Redis\":{\
		\"ip\": \"127.0.0.1\",\
		\"port\": 6379,\
		\"sec\": 1,\
		\"usec\": 500000,\
		\"setup\": \"my_capture_setup,\
		\"topic\": \"my_capture\"\
		}\
	}";
	redisContext *redis;	
	redisReply *reply;
	cJSON *obj;
	cJSON *json;
	json = cJSON_GetObjectItem(json, "Redis");
	json = cJSON_Parse(system_setup);
	obj = cJSON_GetObjectItem(json, "setup");
	reply = redisCommand(redis, "HGET setup interface");
	printf("%s", reply);

	


	
	
    /*
     * init conf variable 
     * vlan 0 - untag : 1 - 8021Q : 2 - 8021QinQ
     * ip type IPPROTO_UNKNOWN IPPROTO_TCP IPPROTO_UDP
     */
    dataLen = 10;
    vlan_flag = 1;
    packet_num = 2;
    //ip_type = IPPROTO_TCP;
    ip_type = IPPROTO_UDP;
    //ip_type = IPPROTO_UNKNOWN;
    
    eth = frame;

    //source mac, dst mac
    set_eth(eth, "aa:ff:ff:ff:ff:aa", "ff:ff:ff:ff:ff:ff", ETHERTYPE_IP);

    //check 8021Q
    switch (vlan_flag){
        case 0:
            ip = frame + ETH_HDRLEN;

            data = (frame + ETH_HDRLEN + IP_HDRLEN);
            total_len = ETH_HDRLEN;
            break;
        case 1:
            vlan = (vlan_hdr *) (frame + ETH_HDRLEN - 2);
            ip = (frame + ETH_HDRLEN + VLAN_HDRLEN);
            set_vlan(vlan, 4, 0, 4001);

            //reset eth type
            vlan = (vlan_hdr *) (frame + ETH_HDRLEN + VLAN_HDRLEN - 2);
            vlan->type = htons(ETHERTYPE_IP);
            
            data = frame + ETH_HDRLEN + VLAN_HDRLEN + IP_HDRLEN;
            total_len = ETH_HDRLEN + VLAN_HDRLEN;
            break;
        case 2:
            printf("vlan QinQ error\n");
            break;
        default:
            printf("vlan flag error!\n");
            return 0;
    }

    total_len += IP_HDRLEN;
    
    //check ip_type
    switch (ip_type){
        case IPPROTO_TCP:
            
            tcp = ip + IP_HDRLEN;
            data = tcp + TCP_HDRLEN; 
            set_tcp(tcp, 1024, 80, dataLen);
            total_len += TCP_HDRLEN;
            ip_total_len = TCP_HDRLEN + dataLen;
            break;
        case IPPROTO_UDP:
            
            udp = ip + IP_HDRLEN;
            data = udp + UDP_HDRLEN;
            set_udp(udp, 1024, 1024, dataLen);
            total_len += UDP_HDRLEN;
            ip_total_len = UDP_HDRLEN + dataLen;
            break;
        case IPPROTO_UNKNOWN:
            break;
        default:
            printf("ip type fail!\n");
            return 0;
    }

    //source ip, dst ip
    set_ip(ip, "192.168.1.1", "192.168.32.201", ip_type, ip_total_len);

    //copy data
    memcpy(data, "Test", 4);
    total_len += dataLen;

    //init pcap
    init_pcap(&pcap, argv[1]);
    send_frame(frame,
            argv[1],
            ip,
            total_len,
            packet_num
    );

    return 0;
}

void send_frame(unsigned char *frame,const char *interface, ip_hdr *ip ,int length, int packet_num){
    int i;
    pcap_t *pcap = NULL;
    
    //init pcap
    init_pcap(&pcap, interface);

    for(i = 0; i < packet_num; i++){

        //ip identification 0, 1, 2, 3 ....
        ip->id = htons(i);
            
        //checksum
        ip->checksum = 0;
        ip->checksum = checksum ((uint16_t *) ip, IP_HDRLEN);
    
        // Write the Ethernet frame to the interface.
        send_packet(pcap, frame, length);
    }

    // Close the PCAP descriptor.
    pcap_close(pcap);

}
void init_pcap(pcap_t **pcap, const char *interface){
    char pcap_errbuf[PCAP_ERRBUF_SIZE] = "";
    *pcap = pcap_open_live(interface, 96, 0, 0, pcap_errbuf);
    if (pcap_errbuf[0]!='\0') {
        fprintf(stderr,"%s\n",pcap_errbuf);
    }
    if (!*pcap) {
        exit(1);
    }
}

void send_packet(pcap_t *pcap, unsigned char *frame, int len){
    // Write the Ethernet frame to the interface.
    if (pcap_inject(pcap, frame, len)==-1) {
        pcap_perror(pcap, 0);
        pcap_close(pcap);
        exit(1);
    }
}
void set_udp(udp_hdr *udp, int sport, int dport, int dataLen){
    void *ip = (void *)(udp - IP_HDRLEN);
    udp->src_port = htons (sport);
    udp->dst_port = htons (dport);
    udp->len = htons(UDP_HDRLEN + dataLen);
    udp->checksum = udp4_checksum (ip, udp, (uint8_t *)(udp + UDP_HDRLEN), dataLen);
    
}
void set_ip(ip_hdr *ip, char *s, char *d, int type, int dataLen){
    
    //ip version
    ip->version = 0x04;
    ip->header_len = 0x05;
    ip->service_type = 0x00;
    ip->total_len = htons(IP_HDRLEN + dataLen);
    ip->id = htons(0);
    
    /* IP offset
     *
     * Reserved zero field
     * Don't fragment field
     * More fragments field
     * offset
     */
    ip->offset = htons ((0 << 15) //Reserved zero
            + (0 << 14) //Don't fragment
            + (0 << 13) //More fragments
            +  0); //

    ip->ttl = 255;
    ip->checksum = 0;
    ip->protocol = type;
    ip->src_ip = inet_addr(s);
    ip->dst_ip = inet_addr(d);
    
    //checksum
    ip->checksum = checksum ((uint16_t *) &ip, IP_HDRLEN);
    
}
void set_eth(ether_hdr *eth, char *s, char *d, int type){
    
    //ethernet header
    set_mac(eth->dst_mac, d);
    set_mac(eth->src_mac, s);

    //ETHERTYPE_IP
    eth->ether_type = htons(type);
}

void set_vlan(vlan_hdr *vlan, int pri, int cfi, int vlan_id){
    
    //ETHERTYPE_8021Q
    vlan->type = htons(ETHERTYPE_8021Q);
    vlan->priority_c_vid = pri << 5;
    vlan->priority_c_vid += cfi << 4;
    vlan->priority_c_vid += htons(vlan_id);
}

unsigned char hex_to_int(const char c)
{
    if( c >= 'a' && c <= 'f'){
        return c - 'a' + 10;
    }

    if( c >= 'A' && c <= 'F'){
        return c - 'A' + 10;
    }

    if( c >= '0' && c <= '9'){
        return c - '0';
    }

    return 0;
}

void set_mac(uint8_t *mac, char *s){
    int i;
    for( i = 0; i < 6; ++i){
        mac[i] = 0;
        while( ((*s) != '\0') && ((*s) != ':')){
            mac[i] <<= 4;
            mac[i] |= hex_to_int(*s);
            ++s;
        }
        if(*s == ':'){
            ++s;
        }
    }
}
uint16_t
checksum (uint16_t *addr, int len)
{
  int count = len;
  register uint32_t sum = 0;
  uint16_t answer = 0;

  // Sum up 2-byte values until none or only one byte left.
  while (count > 1) {
    sum += *(addr++);
    count -= 2;
  }

  // Add left-over byte, if any.
  if (count > 0) {
    sum += *(uint8_t *) addr;
  }

  // Fold 32-bit sum into 16 bits; we lose information by doing this,
  // increasing the chances of a collision.
  // sum = (lower 16 bits) + (upper 16 bits shifted right 16 bits)
  while (sum >> 16) {
    sum = (sum & 0xffff) + (sum >> 16);
  }

  // Checksum is one's compliment of sum.
  answer = ~sum;

  return (answer);
}

// Build IPv4 UDP pseudo-header and call checksum function.
uint16_t
udp4_checksum (void *ip, void *udp, uint8_t *payload, int payloadlen)
{
    struct ip iphdr = *(struct ip *)ip;
    struct udphdr udphdr = *(struct udphdr *)udp;
    char buf[IP_MAXPACKET];
    char *ptr;
    int chksumlen = 0;
    int i;

    ptr = &buf[0];  // ptr points to beginning of buffer buf

    // Copy source IP address into buf (32 bits)
    memcpy (ptr, &iphdr.ip_src.s_addr, sizeof (iphdr.ip_src.s_addr));
    ptr += sizeof (iphdr.ip_src.s_addr);
    chksumlen += sizeof (iphdr.ip_src.s_addr);

    // Copy destination IP address into buf (32 bits)
    memcpy (ptr, &iphdr.ip_dst.s_addr, sizeof (iphdr.ip_dst.s_addr));
    ptr += sizeof (iphdr.ip_dst.s_addr);
    chksumlen += sizeof (iphdr.ip_dst.s_addr);

    // Copy zero field to buf (8 bits)
    *ptr = 0; ptr++;
    chksumlen += 1;

    // Copy transport layer protocol to buf (8 bits)
    memcpy (ptr, &iphdr.ip_p, sizeof (iphdr.ip_p));
    ptr += sizeof (iphdr.ip_p);
    chksumlen += sizeof (iphdr.ip_p);

    // Copy UDP length to buf (16 bits)
    memcpy (ptr, &udphdr.len, sizeof (udphdr.len));
    ptr += sizeof (udphdr.len);
    chksumlen += sizeof (udphdr.len);

    // Copy UDP source port to buf (16 bits)
    memcpy (ptr, &udphdr.source, sizeof (udphdr.source));
    ptr += sizeof (udphdr.source);
    chksumlen += sizeof (udphdr.source);

    // Copy UDP destination port to buf (16 bits)
    memcpy (ptr, &udphdr.dest, sizeof (udphdr.dest));
    ptr += sizeof (udphdr.dest);
    chksumlen += sizeof (udphdr.dest);

    // Copy UDP length again to buf (16 bits)
    memcpy (ptr, &udphdr.len, sizeof (udphdr.len));
    ptr += sizeof (udphdr.len);
    chksumlen += sizeof (udphdr.len);

    // Copy UDP checksum to buf (16 bits)
    // Zero, since we don't know it yet
    *ptr = 0; ptr++;
    *ptr = 0; ptr++;
    chksumlen += 2;

    // Copy payload to buf
    memcpy (ptr, payload, payloadlen);
    ptr += payloadlen;
    chksumlen += payloadlen;

    // Pad to the next 16-bit boundary
    for (i=0; i<payloadlen%2; i++, ptr++) {
        *ptr = 0;
        ptr++;
        chksumlen++;
    }

    return checksum ((uint16_t *) buf, chksumlen);
}

/* TCP flags */
#define TH_FIN     0x01
#define TH_SYN     0x02
#define TH_RST     0x04
#define TH_PUSH    0x08
#define TH_ACK     0x10
#define TH_URG     0x20
#define TH_ECNECHO 0x40 /* ECN Echo */
#define TH_CWR     0x80 /* ECN Cwnd Reduced */

void set_tcp(tcp_hdr *tcp, int sport, int dport, int dataLen){
    void *ip = (void *)(tcp - IP_HDRLEN);
    tcp->src_port = htons (sport);
    tcp->dst_port = htons (dport);
    tcp->seq = htonl(0);
    tcp->ack = htonl(0);
    tcp->x2 = 0; //(unused)
    tcp->off = TCP_HDRLEN / 4;
    tcp->flags = TH_ACK;
    tcp->win = htons(4096);
    tcp->urp = htons(0);
    tcp->checksum = 0;
    tcp->checksum = tcp4_checksum (ip, tcp, (uint8_t *)(tcp + TCP_HDRLEN), dataLen);
}

// Build IPv4 TCP pseudo-header and call checksum function.
uint16_t
tcp4_checksum (void *ip, void *tcp, uint8_t *payload, int payloadlen)
{
    struct ip iphdr = *(struct ip *)ip;
    struct tcphdr tcphdr = *(struct tcphdr *)tcp;
    uint16_t svalue;
    char buf[IP_MAXPACKET], cvalue;
    char *ptr;
    int i, chksumlen = 0;

    ptr = &buf[0];  // ptr points to beginning of buffer buf

    // Copy source IP address into buf (32 bits)
    memcpy (ptr, &iphdr.ip_src.s_addr, sizeof (iphdr.ip_src.s_addr));
    ptr += sizeof (iphdr.ip_src.s_addr);
    chksumlen += sizeof (iphdr.ip_src.s_addr);

    // Copy destination IP address into buf (32 bits)
    memcpy (ptr, &iphdr.ip_dst.s_addr, sizeof (iphdr.ip_dst.s_addr));
    ptr += sizeof (iphdr.ip_dst.s_addr);
    chksumlen += sizeof (iphdr.ip_dst.s_addr);

    // Copy zero field to buf (8 bits)
    *ptr = 0; ptr++;
    chksumlen += 1;

    // Copy transport layer protocol to buf (8 bits)
    memcpy (ptr, &iphdr.ip_p, sizeof (iphdr.ip_p));
    ptr += sizeof (iphdr.ip_p);
    chksumlen += sizeof (iphdr.ip_p);

    // Copy TCP length to buf (16 bits)
    svalue = htons (sizeof (tcphdr) + payloadlen);
    memcpy (ptr, &svalue, sizeof (svalue));
    ptr += sizeof (svalue);
    chksumlen += sizeof (svalue);

    // Copy TCP source port to buf (16 bits)
    memcpy (ptr, &tcphdr.th_sport, sizeof (tcphdr.th_sport));
    ptr += sizeof (tcphdr.th_sport);
    chksumlen += sizeof (tcphdr.th_sport);

    // Copy TCP destination port to buf (16 bits)
    memcpy (ptr, &tcphdr.th_dport, sizeof (tcphdr.th_dport));
    ptr += sizeof (tcphdr.th_dport);
    chksumlen += sizeof (tcphdr.th_dport);

    // Copy sequence number to buf (32 bits)
    memcpy (ptr, &tcphdr.th_seq, sizeof (tcphdr.th_seq));
    ptr += sizeof (tcphdr.th_seq);
    chksumlen += sizeof (tcphdr.th_seq);

    // Copy acknowledgement number to buf (32 bits)
    memcpy (ptr, &tcphdr.th_ack, sizeof (tcphdr.th_ack));
    ptr += sizeof (tcphdr.th_ack);
    chksumlen += sizeof (tcphdr.th_ack);

    // Copy data offset to buf (4 bits) and
    // copy reserved bits to buf (4 bits)
    cvalue = (tcphdr.th_off << 4) + tcphdr.th_x2;
    memcpy (ptr, &cvalue, sizeof (cvalue));
    ptr += sizeof (cvalue);
    chksumlen += sizeof (cvalue);

    // Copy TCP flags to buf (8 bits)
    memcpy (ptr, &tcphdr.th_flags, sizeof (tcphdr.th_flags));
    ptr += sizeof (tcphdr.th_flags);
    chksumlen += sizeof (tcphdr.th_flags);

    // Copy TCP window size to buf (16 bits)
    memcpy (ptr, &tcphdr.th_win, sizeof (tcphdr.th_win));
    ptr += sizeof (tcphdr.th_win);
    chksumlen += sizeof (tcphdr.th_win);

    // Copy TCP checksum to buf (16 bits)
    // Zero, since we don't know it yet
    *ptr = 0; ptr++;
    *ptr = 0; ptr++;
    chksumlen += 2;

    // Copy urgent pointer to buf (16 bits)
    memcpy (ptr, &tcphdr.th_urp, sizeof (tcphdr.th_urp));
    ptr += sizeof (tcphdr.th_urp);
    chksumlen += sizeof (tcphdr.th_urp);

    // Copy payload to buf
    memcpy (ptr, payload, payloadlen);
    ptr += payloadlen;
    chksumlen += payloadlen;

    // Pad to the next 16-bit boundary
    for (i=0; i<payloadlen%2; i++, ptr++) {
        *ptr = 0;
        ptr++;
        chksumlen++;
    }

    return checksum ((uint16_t *) buf, chksumlen);
}
