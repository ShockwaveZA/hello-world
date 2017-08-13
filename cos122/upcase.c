#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>

#define p_read	0
#define c_write	1
#define c_read	2
#define	p_write	3

void main(int argc, char **argv) {
	int l, c = 0, debug = 0, fd[4];
	char buff[4000], *s;
	pid_t pid;
	
	for (int k = 0; k < argc; k++)
		if (strcmp(argv[k], "debug") == 0)
			debug = 1;
	
	while ((l = getchar()) != EOF)
		buff[c++] = (char) l;

	s = malloc(c * sizeof(char));
	for (int k = 0; k < c - 1; k++)
		s[k] = buff[k];
	
	
	for (int k = 0; k < 2; k++)
		pipe(fd + k * 2);

	pid = fork();
	
	if (pid == 0) {
		close(fd[p_read]);
		close(fd[p_write]);
		
		read(fd[c_read], s, strlen(s));
		if (debug)
			printf("Child : Received '%s'\n", s);
		for (int k = 0; k < strlen(s); k++) {
			l = (int) s[k];
			if (l >= 'a' && l <= 'z')
				l -= 32;
			s[k] = (char) l;
		}
		if (debug)
			printf("Child : Sending '%s' to parent\n", s);
		write(fd[c_write], s, strlen(s));
		
		close(fd[c_read]);
		close(fd[c_write]);
		
		return;
	}
	
	close(fd[c_read]);
	close(fd[c_write]);
	
	if (debug)
		printf("Parent: Sending '%s' to child\n", s);
	write(fd[p_write], s, strlen(s));
	
	read(fd[p_read], s, strlen(s));
	if (debug)
    	printf("Parent: Received '%s'\n", s);
    else
        printf("%s\n", s);

	close(fd[p_read]);
	close(fd[p_write]);
	
	wait(NULL);
	
	return;
}
