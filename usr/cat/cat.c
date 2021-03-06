#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <fcntl.h>
#include <errno.h>

#include "../../include/syscalls.h"

extern int argc;
extern char** argv;
extern char** environ;


int main() {
	char buffer[1024];
	for (int i=1;i<argc;i++) {
		int fd = _open(argv[i], O_RDONLY);
		if (fd >= 0) {
			int n;
			while((n = _read(fd, buffer, 1023)) > 0) {
				for (int i=0;i<n;i++) {
					printf("%c", buffer[i]);
				}
			}
			_close(fd);
		} else {
			sprintf(buffer, "cat: %s", argv[i]);
			perror(buffer);
		}
	}
}
