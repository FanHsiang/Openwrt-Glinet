//UDP header

#define UDP_HDRLEN  8

typedef struct{
    uint16_t     src_port;
    uint16_t     dst_port;
    uint16_t     len;
    uint16_t     checksum;
}udp_hdr, *udp;



