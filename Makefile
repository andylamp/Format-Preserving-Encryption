UNAME = $(shell uname)
CFLAGS = -O2 -Wall -fPIC -pg
SO_LINKS = -lm -lcrypto

LIB = libfpe.a libfpe.so
EXAMPLE_SRC = example.c
EXAMPLE_EXE = example
FPE_BENCH_SRC = fpe_bench.c
FPE_BENCH_EXE = fpe_bench
OBJS = src/ff1.o src/ff3.o src/fpe_locl.o

# mac specific
ifeq ($(UNAME),Darwin)
	ADD_LIB_LOC = -L/usr/local/opt/openssl/lib
	ADD_INC_LOC = -I/usr/local/opt/openssl/include
	SONAME_ARG=-install_name
	LD_FLAG =
endif

ifeq ($(UNAME),Linux)
	LD_FLAG = -Wl
	SONAME_ARG = -Wl,-soname
	ADD_LIB_LOC = 
	ADD_INC_LOC = 
endif

all: $(LIB) $(EXAMPLE_EXE) $(FPE_BENCH_EXE)

libfpe.a: $(OBJS)
	ar rcs $@ $(OBJS)

libfpe.so: $(OBJS)
	cc -shared -fPIC $(SONAME_ARG),libfpe.so $(OBJS) $(SO_LINKS) -o $@ \
	$(ADD_INC_LOC) $(ADD_LIB_LOC)

.PHONY = all clean remake

src/ff1.o: src/ff1.c
	cc $(CFLAGS) -c src/ff1.c -o $@ $(ADD_INC_LOC)

src/ff3.o: src/ff3.c
	cc $(CFLAGS) -c src/ff3.c -o $@ $(ADD_INC_LOC)

src/fpe_locl.o: src/fpe_locl.c
	cc $(CFLAGS) -c src/fpe_locl.c -o $@ $(ADD_INC_LOC)

$(EXAMPLE_EXE): $(EXAMPLE_SRC) $(LIB)
	gcc $(LD_FLAG) $(EXAMPLE_SRC) -L. -lfpe -Isrc -O2 -o $@ \
	$(ADD_INC_LOC) $(ADD_LIB_LOC)

$(FPE_BENCH_EXE): $(FPE_BENCH_SRC) $(LIB)
	gcc $(LD_FLAG) $(FPE_BENCH_SRC) -L. -lfpe -Isrc -O2 -o $@ \
	$(ADD_INC_LOC) $(ADD_LIB_LOC)

clean:
	rm $(OBJS) *.so* *.a

remake:
	-make clean
	make all

