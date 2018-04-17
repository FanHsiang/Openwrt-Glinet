//Point-To-Point protocol header

#define PtoP_HDRLEN 2

typedef struct {
	uint16_t	prtocol:0xc021;
}ptop_hdr, *ptop;
