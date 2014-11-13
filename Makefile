test: test.c options.c options.h Makefile
	$(CC) -Wall -pedantic -std=c99 -o test test.c options.c
