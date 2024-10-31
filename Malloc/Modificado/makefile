CC = gcc
AS = as
CFLAGS = -g -no-pie
LFLAGS = -lm

main: main.o lib_malloc.o
	$(CC) $(CFLAGS) $(LFLAGS) -o main main.o lib_malloc.o

lib_malloc.o: lib_malloc.s 
	$(AS) $(CFLAGS) -c lib_malloc.s -o lib_malloc.o

main.o: main.c lib_malloc.h
	$(CC) $(CFLAGS) -c main.c -o main.o

clean:
	rm -rf ./*.o

purge:
	rm -rf ./*.o
	rm -rf main
