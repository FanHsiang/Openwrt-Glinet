//PPP-over-Ethernet Session header

#define PPP_SESSION_HDRLEN 6

typedef struct {
	uint8_t		version:4;
	uint8_t		type:5;
	uint8_t		code:0;
	uint16_t 	ID;
}ppp_session_hdr, *ppp_session;		
