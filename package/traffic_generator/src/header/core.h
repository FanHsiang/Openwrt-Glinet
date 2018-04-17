#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pcap.h>
#include <arpa/inet.h>
#include <net/if.h>
#include <net/ethernet.h>
#include <netinet/if_ether.h>
#include <sys/ioctl.h>
//#include <sys/types.h>
//#include <netinet/ip.h>		//struct ip and IP_MAXPACKET (which is 65535)
//#include <netinet/udp.h>	//struct udphdr
//#include <netinet/tcp.h>	//struct tcphdr

#include "../header/netinet/tcp.h"
#include "../header/netinet/udp.h"
#include "../header/netinet/ip.h"

#include "../header/cJSON.h"
#include "../header/hiredis/hiredis.h"

#include "../header/tcp.h"
#include "../header/udp.h"
#include "../header/ip.h"
#include "../header/802_1Q.h"
#include "../header/ethernet.h"

#define ETHERTYPE_8021Q		0x8100
#define ETHERTYPE_IP		0x0800
#define IPPROTO_UNKNOWN		253
