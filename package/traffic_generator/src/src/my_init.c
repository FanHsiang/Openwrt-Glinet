#include "../header/core.h"

int
try_connect_redis(const char *system_setup, redisContext **r){
	redisContext *redis;
    struct timeval timeout;
    cJSON *sys, *ip, *port, *sec, *usec;
	sys = cJSON_Parse(system_setup);
	if (!sys) {
		return MY_ERROR;
	}
    
	sys = cJSON_GetObjectItem(sys, "Redis");
    if(!sys){
        return MY_ERROR;
    }
    
	ip = cJSON_GetObjectItem(sys, "ip");
    if(!ip){
		return MY_ERROR;
	}
	
	port = cJSON_GetObjectItem(sys, "port");
    if(!port){
		return MY_ERROR;
	}
	
	sec = cJSON_GetObjectItem(sys, "sec");
    if(!sec){
		return MY_ERROR;
	}

	usec = cJSON_GetObjectItem(sys, "usec");
    if(!usec){
		return MY_ERROR;
	}
	
	timeout.tv_sec = sec->valueint;
	timeout.tv_usec = usec->valueint;

    redis = redisConnectWithTimeout(ip->valuestring, port->valueint, timeout);
    if (redis == NULL || redis->err) {
        if (redis) {
            printf("Connection error: %s\n", redis->errstr);
            redisFree(redis);
        } else {
            printf("Connection error: can't allocate redis context\n");
        }
        return MY_ERROR;
    }
	
	*r = redis;
	
	cJSON_Delete(NULL);
	return MY_OK;
}
