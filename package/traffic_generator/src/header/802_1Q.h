//802.1Q header

#define VLAN_HDRLEN 4

typedef struct {
    uint16_t    type;
    uint16_t    priority_c_vid;
}vlan_hdr, *vlan;
