CC=gcc
INCLUDE=-I header/ \
	-I header/hiredis/ 
CFLAGS=$(INCLUDE) -Wall -O2 -lm -lpcap
OBJ = \
	src/json/cJSON.o \
	src/palloc/my_palloc.o \
	src/hiredis/hiredis.o \
	src/hiredis/sds.o \
	src/hiredis/net.o \
	src/hiredis/read.o \
	src/hiredis/async.o \
	src/my_init.o \
#	src/main.o
	src/sendpackage.o

%.o: src/%.c
	$(CC) -c -o $@ $< $(CFLAGS)
traffic_generator: $(OBJ)
	$(CC) -o $@ $^ $(CFLAGS)
clean:
	rm -f traffic_generator
	rm -f src/*.o
	rm -f src/json/*.o
	rm -f src/palloc/*.o
	rm -f src/hiredis/*.o

