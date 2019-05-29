#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <crypt.h>

void usage(char *cmd)
{
	printf("Usage: %s <password>\n", cmd);
}

int main(int argc, char *argv[])
{
	unsigned long seed[2];
	char salt[] = "$1$........";
	const char *const seedchars = "./0123456789ABCDEFGHIJKLMNOPQRST" "UVWXYZabcdefghijklmnopqrstuvwxyz";
	char *password;
	int i;

	if (argc != 2) {
		usage(argv[0]);
		exit(1);
	}

	/* Generate a (not very) random seed.  
	   You should do it better than this... */
	seed[0] = time(NULL);
	seed[1] = getpid() ^ (seed[0] >> 14 & 0x30000);

	/* Turn it into printable characters from `seedchars'. */
	for (i = 0; i < 8; i++)
		salt[3 + i] = seedchars[(seed[i / 5] >> (i % 5) * 6) & 0x3f];

	password = crypt(argv[1], salt);

	puts(password);
	return 0;
}
