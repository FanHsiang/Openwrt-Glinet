//TCP header

#define TCP_HDRLEN  20

typedef struct{
    uint16_t     src_port;
    uint16_t     dst_port;
    uint32_t     seq;
    uint32_t     ack;
    uint8_t      x2:4; //(unused)
    uint8_t      off:4;
    uint8_t      flags;
    uint16_t     win;
    uint16_t     checksum;
    uint16_t     urp;
}tcp_hdr, *tcp;

