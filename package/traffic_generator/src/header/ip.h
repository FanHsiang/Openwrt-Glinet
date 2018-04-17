//Internet protocol version 4 header

#define IP_HDRLEN   20

typedef struct{
    uint8_t     header_len:4;
    uint8_t     version:4;
    uint8_t     service_type;
    uint16_t    total_len;
    uint16_t    id;
    uint16_t    offset;
    uint8_t     ttl;
    uint8_t     protocol;
    uint16_t    checksum;
    uint32_t    src_ip;
    uint32_t    dst_ip;
}ip_hdr, *ip;

