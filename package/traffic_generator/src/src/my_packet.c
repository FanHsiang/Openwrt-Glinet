#include "../header/core.h"

#define ETHERMTU    1500
#define ETHERTYPE_8021Q     0x8100
#define ETHERTYPE_8021Q9100 0x9100
#define ETHERTYPE_8021Q9200 0x9200
#define ETHERTYPE_8021QinQ  0x88a8
#define ETHERTYPE_IP        0x0800
#define ETHERTYPE_ARP       0x0806
#define ETHERTYPE_AARP      0x80f3
#define ETHERTYPE_PPP       0x880b
#define ETHERTYPE_IPV6      0x86dd
#define ETHERTYPE_PPPOES    0x8864
#define ETHERTYPE_PPPOED2   0x3c12
#define ETHERTYPE_PPPOES2   0x3c13
#define ETHERTYPE_LLDP      0x88cc
#define ETHERTYPE_LOOPBACK  0x9000
#define ETHERTYPE_CFM       0x8902
#define ETHERTYPE_PUP       0x0200
#define ETHERTYPE_RRCP      0x8899

void print_8021Q(struct vlan_hdr * vlan, cJSON *output, int count){
    uint16_t v;
	cJSON *obj;
	char tmp[48];
    
	if(count == 0){
		cJSON_AddItemToObject(output, "Vlan", obj = cJSON_CreateObject());
	}else{
		sprintf(tmp, "Vlan%d",count);
		cJSON_AddItemToObject(output, tmp, obj = cJSON_CreateObject());
	}

    v = ntohs(vlan->priority_c_vid);
	cJSON_AddNumberToObject(obj,"cfi", (v & 0x1000) >> 12);
	cJSON_AddNumberToObject(obj,"pri", (v & 0xE000) >> 13);
	cJSON_AddNumberToObject(obj,"id", (v & 0x0FFF));
    
	v = ntohs(vlan->ether_type);
    switch(v){
        case ETHERTYPE_8021Q:
			print_8021Q((struct vlan_hdr *)((void *)vlan +4), output, count + 1);
			cJSON_AddStringToObject(obj,"type", "8021Q");
			break;
		default:
			break;
	}
}

#define IPPROTO_IPV4        4
#define IPPROTO_PIGP        9
#define IPPROTO_MOBILE      55
#define IPPROTO_ND      77
#define IPPROTO_EIGRP       88
#define IPPROTO_OSPF        89
#define IPPROTO_IPCOMP      108
#define IPPROTO_VRRP        112
#define IPPROTO_PGM             113
#define IPPROTO_MOBILITY    135

void print_ip4(const u_char *data, cJSON *output){
    struct ip_hdr *ip = (struct ip_hdr *)data;
    cJSON *obj;
    char tmp[40];
    
    cJSON_AddItemToObject(output, "IP", obj = cJSON_CreateObject());

	switch (IP_V(ip)) {
	    case 4:
            break;
	    default:
            return;
    }
    
    cJSON_AddNumberToObject(obj,"header_len", IP_HL(ip) * 4);
    sprintf(tmp,"0x%.2x", ip->tos);
	cJSON_AddStringToObject(obj, "tos", tmp);
    cJSON_AddNumberToObject(obj,"len", ntohs(ip->len));
    sprintf(tmp,"0x%.2x", ntohs(ip->id));
    cJSON_AddStringToObject(obj,"id", tmp);
    cJSON_AddNumberToObject(obj,"ttl", ip->ttl);
    cJSON_AddNumberToObject(obj,"reserved_bit", (ntohs(ip->off) & IP_RF) >> 15);
    cJSON_AddNumberToObject(obj,"dont_bit", (ntohs(ip->off) & IP_DF) >> 14);
    cJSON_AddNumberToObject(obj,"more_bit", (ntohs(ip->off) & IP_MF) >> 13);
    cJSON_AddNumberToObject(obj,"offset", (ntohs(ip->off) & IP_OFFMASK));
    sprintf(tmp,"0x%.2x", ip->sum);
	cJSON_AddStringToObject(obj, "checksum", tmp);
    sprintf(tmp,"%s", inet_ntoa(ip->dst));
	cJSON_AddStringToObject(obj, "dst", tmp);
    sprintf(tmp,"%s", inet_ntoa(ip->src));
	cJSON_AddStringToObject(obj, "src", tmp);
    
    switch (ip->p) {
	    case IPPROTO_TCP:
	        cJSON_AddStringToObject(obj, "protocol", "TCP");
            break;
	    case IPPROTO_UDP:
	        cJSON_AddStringToObject(obj, "protocol", "UDP");
            break;
	    case IPPROTO_ICMP:
	        cJSON_AddStringToObject(obj, "protocol", "ICMP");
            break;
	    case IPPROTO_IGMP:
	        cJSON_AddStringToObject(obj, "protocol", "IGMP");
            break;
	    case IPPROTO_HOPOPTS:
	        cJSON_AddStringToObject(obj, "protocol", "HOPOPTS");
            break;
	    case IPPROTO_IPV4:
	        cJSON_AddStringToObject(obj, "protocol", "IPV4");
            break;
	    case IPPROTO_DCCP:
	        cJSON_AddStringToObject(obj, "protocol", "DCCP");
            break;
	    case IPPROTO_IPV6:
	        cJSON_AddStringToObject(obj, "protocol", "IPV6");
            break;
	    case IPPROTO_ROUTING:
	        cJSON_AddStringToObject(obj, "protocol", "ROUTING");
            break;
	    case IPPROTO_GRE:
	        cJSON_AddStringToObject(obj, "protocol", "GRE");
            break;
	    case IPPROTO_ESP:
	        cJSON_AddStringToObject(obj, "protocol", "ESP");
            break;
	    case IPPROTO_MOBILE:
	        cJSON_AddStringToObject(obj, "protocol", "MOBILE");
            break;
	    case IPPROTO_ICMPV6:
	        cJSON_AddStringToObject(obj, "protocol", "ICMPV6");
            break;
	    case IPPROTO_NONE:
	        cJSON_AddStringToObject(obj, "protocol", "NONE");
            break;
	    case IPPROTO_DSTOPTS:
	        cJSON_AddStringToObject(obj, "protocol", "DSTOPTS");
            break;
	    case IPPROTO_AH:
	        cJSON_AddStringToObject(obj, "protocol", "AH");
            break;
	    case IPPROTO_EGP:
	        cJSON_AddStringToObject(obj, "protocol", "EGP");
            break;
	    case IPPROTO_PIGP:
	        cJSON_AddStringToObject(obj, "protocol", "PIGP");
            break;
	    case IPPROTO_FRAGMENT:
	        cJSON_AddStringToObject(obj, "protocol", "FRAGMENT");
            break;
	    case IPPROTO_ND:
	        cJSON_AddStringToObject(obj, "protocol", "ND");
            break;
	    case IPPROTO_EIGRP:
	        cJSON_AddStringToObject(obj, "protocol", "EIGRP");
            break;
	    case IPPROTO_OSPF:
	        cJSON_AddStringToObject(obj, "protocol", "OSPF");
            break;
	    case IPPROTO_PIM:
	        cJSON_AddStringToObject(obj, "protocol", "PIM");
            break;
	    case IPPROTO_IPCOMP:
	        cJSON_AddStringToObject(obj, "protocol", "IPCOMP");
            break;
	    case IPPROTO_VRRP:
	        cJSON_AddStringToObject(obj, "protocol", "VRRP");
            break;
	    case IPPROTO_PGM:
	        cJSON_AddStringToObject(obj, "protocol", "PGM");
            break;
	    case IPPROTO_SCTP:
	        cJSON_AddStringToObject(obj, "protocol", "SCTP");
            break;
	    case IPPROTO_MOBILITY:
	        cJSON_AddStringToObject(obj, "protocol", "MOBILITY");
            break;
	    case IPPROTO_RSVP:
	        cJSON_AddStringToObject(obj, "protocol", "RSVP");
            break;
        default:
	        cJSON_AddStringToObject(obj, "protocol", "Unknown");
            break;
    }
}

int print_eth(const u_char *data, cJSON *output){
	cJSON *obj;
    uint16_t eth_type;
    char mac[32], tmp[48];
	int i;
    struct ether_hdr *eth = (struct ether_hdr *)data;
    eth_type = ntohs(eth->ether_type);
	
    //802.3
    if(eth_type <= ETHERMTU ){
        return MY_ERROR;
    }
	
	cJSON_AddItemToObject(output, "Ethernet", obj = cJSON_CreateObject());
	
	sprintf(mac, "%.2X:%.2X:%.2X:%.2X:%.2X:%.2X",eth->dst_mac[0],eth->dst_mac[1],eth->dst_mac[2],eth->dst_mac[3],eth->dst_mac[4],eth->dst_mac[5]);
    cJSON_AddStringToObject(obj,"dst", mac);

    sprintf(mac, "%.2X:%.2X:%.2X:%.2X:%.2X:%.2X",eth->src_mac[0],eth->src_mac[1],eth->src_mac[2],eth->src_mac[3],eth->src_mac[4],eth->src_mac[5]);
    cJSON_AddStringToObject(obj,"src", mac);

    //Ethernet II
    switch(eth_type){
        case ETHERTYPE_8021Q:
			cJSON_AddStringToObject(obj,"type", "8021Q");
			print_8021Q((struct vlan_hdr *)((void *)eth +12), output, 0);
            break;
        case ETHERTYPE_8021QinQ:
			cJSON_AddStringToObject(obj,"type", "8021QinQ");
			print_8021Q((struct vlan_hdr *)((void *)eth +12), output, 0);
            break;
        case ETHERTYPE_8021Q9100:
			cJSON_AddStringToObject(obj,"type", "8021Q9100");
			print_8021Q((struct vlan_hdr *)((void *)eth +12), output, 0);
            break;
        case ETHERTYPE_8021Q9200:
			cJSON_AddStringToObject(obj,"type", "8021Q9200");
			print_8021Q((struct vlan_hdr *)((void *)eth +12), output, 0);
            break;
		default:
			break;
	}

	
	sprintf(tmp, "Vlan");
	for(i = 1; i < 30; i++){
    	obj = cJSON_GetObjectItem(output, tmp);
		if(!obj){
			break;
		}
		sprintf(tmp, "Vlan%d", i);
        data += 4;
	}
    
   
    eth = (struct ether_hdr *)(data);

    if(i == 1){
        obj = cJSON_GetObjectItem(output, "Ethernet");
    }else{
        if(i == 2){
		    sprintf(tmp, "Vlan");
        }else{
		    sprintf(tmp, "Vlan%d", i-1);
        }
        obj = cJSON_GetObjectItem(output, tmp);
    }
    
    data += 14;
    eth_type = ntohs(eth->ether_type);
    switch(eth_type){
        case ETHERTYPE_IP:
            cJSON_AddStringToObject(obj,"type", "IP");
            print_ip4(data, output);
            break;
        case ETHERTYPE_ARP:
            cJSON_AddStringToObject(obj,"type", "ARP");
            break;
        case ETHERTYPE_IPV6:
            cJSON_AddStringToObject(obj,"type", "IPV6");
            break;
        case ETHERTYPE_CFM:
            cJSON_AddStringToObject(obj,"type", "CFM");
            break;
        case ETHERTYPE_PPPOES:
            cJSON_AddStringToObject(obj,"type", "PPPOES");
            break;
        case ETHERTYPE_LOOPBACK:
            cJSON_AddStringToObject(obj,"type", "LOOPBACK");
            break;
        case ETHERTYPE_PUP:
            cJSON_AddStringToObject(obj,"type", "PUP");
            break;
        case ETHERTYPE_AARP:
            cJSON_AddStringToObject(obj,"type", "AARP");
            break;
        case ETHERTYPE_LLDP:
            cJSON_AddStringToObject(obj,"type", "LLDP");
            break;
        case ETHERTYPE_PPPOES2:
            cJSON_AddStringToObject(obj,"type", "PPPOES2");
            break;
        case ETHERTYPE_PPPOED2:
            cJSON_AddStringToObject(obj,"type", "PPPOED2");
            break;
        case ETHERTYPE_RRCP:
            cJSON_AddStringToObject(obj,"type", "RRCP");
            break;
        default:
            cJSON_AddStringToObject(obj,"type", "---");
    }
	return MY_OK;
}
    
