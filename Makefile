test: test.c options.c options.h Makefile
	$(CC) -Wall -o test test.c options.c
