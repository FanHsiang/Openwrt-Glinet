// Ethernet header

#define ETH_HDRLEN  14

typedef struct {
    uint8_t     dst_mac[6];
    uint8_t     src_mac[6];
    uint16_t    ether_type;
}ether_hdr, *eth;

