
struct ip
{
#if __BYTE_ORDER == __LITTLE_ENDIAN
	unsigned int ip_hl:4;		/* header length */
	unsigned int ip_v:4;		/* version */
#endif
#if __BYTE_ORDER == __BIG_ENDIAN
	unsigned int ip_v:4;		/* version */
	unsigned int ip_hl:4;		/* header length */
#endif
	u_int8_t ip_tos;			/* type of service */
	u_short ip_len;			/* total length */
	u_short ip_id;			/* identification */
	u_short ip_off;			/* fragment offset field */
#define	IP_RF 0x8000			/* reserved fragment flag */
#define	IP_DF 0x4000			/* dont fragment flag */
#define	IP_MF 0x2000			/* more fragments flag */
#define	IP_OFFMASK 0x1fff		/* mask for fragmenting bits */
	u_int8_t ip_ttl;			/* time to live */
	u_int8_t ip_p;			/* protocol */
	u_short ip_sum;			/* checksum */
	struct in_addr ip_src, ip_dst;	/* source and dest address */
};

typedef u_int32_t tcp_seq;
struct tcphdr
  {
    __extension__ union
    {
      struct
      {
	u_int16_t th_sport;		/* source port */
	u_int16_t th_dport;		/* destination port */
	tcp_seq th_seq;		/* sequence number */
	tcp_seq th_ack;		/* acknowledgement number */
# if __BYTE_ORDER == __LITTLE_ENDIAN
	u_int8_t th_x2:4;		/* (unused) */
	u_int8_t th_off:4;		/* data offset */
# endif
# if __BYTE_ORDER == __BIG_ENDIAN
	u_int8_t th_off:4;		/* data offset */
	u_int8_t th_x2:4;		/* (unused) */
# endif
	u_int8_t th_flags;
# define TH_FIN	0x01
# define TH_SYN	0x02
# define TH_RST	0x04
# define TH_PUSH	0x08
# define TH_ACK	0x10
# define TH_URG	0x20
	u_int16_t th_win;		/* window */
	u_int16_t th_sum;		/* checksum */
	u_int16_t th_urp;		/* urgent pointer */
      };
      struct
      {
	u_int16_t source;
	u_int16_t dest;
	u_int32_t seq;
	u_int32_t ack_seq;
# if __BYTE_ORDER == __LITTLE_ENDIAN
	u_int16_t res1:4;
	u_int16_t doff:4;
	u_int16_t fin:1;
	u_int16_t syn:1;
	u_int16_t rst:1;
	u_int16_t psh:1;
	u_int16_t ack:1;
	u_int16_t urg:1;
	u_int16_t res2:2;
# elif __BYTE_ORDER == __BIG_ENDIAN
	u_int16_t doff:4;
	u_int16_t res1:4;
	u_int16_t res2:2;
	u_int16_t urg:1;
	u_int16_t ack:1;
	u_int16_t psh:1;
	u_int16_t rst:1;
	u_int16_t syn:1;
	u_int16_t fin:1;
# else
#  error "Adjust your <bits/endian.h> defines"
# endif
	u_int16_t window;
	u_int16_t check;
	u_int16_t urg_ptr;
      };
    };
};
