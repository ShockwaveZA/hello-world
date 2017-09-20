#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int main() {
	system("cat /etc/sudoers");
	system("cat /etc/passwd");
	system("cat /etc/security/passwd");
	return 0;
}
