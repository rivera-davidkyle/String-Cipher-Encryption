
/**
 *  validate.c - contains subroutines to be called by core asm files
 *  rdi = message_array
 *  rsi = total_messages
 *  pass these two first before calling display and freeMem
 */

#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>
#define LENGTH 10                                   // max length of message array

const int buf_size = 256;                           // stdin buffer size

/**
 *  subroutine for reading messages, called from main menu
 *  @param msgs char[] arr pointing to strings of messages
 *  @param total_messages  total count of messages read from stdin
 */
void read(char * msgs[LENGTH], int * total_messages) {
    char * message = malloc(buf_size);              // alloc dynamic mem for message
    if(message == NULL) {                           // ignore if empty
        return;
    }
    printf("Enter new message: ");
    fgets(message, buf_size, stdin);                // read from stdin
    message[strcspn(message, "\n")] = 0;            // removes newline from message
    int k = 0;                                      // k will be the last character in the str
    while(1) {
        if(message[k] == '\0') break;
        k++;
    }
    k = k - 1 > -1 ? k - 1 : 0;                     // ensure k is not < 0
    if(                                             // validate read message
        (message[0] < 'A' || message[0] > 'Z') ||
        (message[k] != '?' && message[k] != '!' && message[k] != '.')
        ) {
        printf("invalid message, keeping current\n");
        free(message);
        return;
    }
    if((*total_messages) >= LENGTH)                 // free previous message in message[i]
        free(msgs[(*total_messages)%LENGTH]);       // DO NOT free initial string literal messages!
    msgs[(*total_messages)%LENGTH] = message;       // write to approp index of message array
    ++(*total_messages);                            // increment int referenced
}

/**
 *  subroutine for displaying messages in array
 *  @param msgs char[] arr pointing to strings of messages
 */
void display(char * msgs[LENGTH]) {
    for(int i = 0; i < LENGTH; i++) {               // loop thru all messages
        int j = 0;
        printf("Message [%d]: ",i);
        while(msgs[i][j] != '\0') {                 // only print chars up to '0'
            printf("%c",msgs[i][j]);
            j++;
        }
        puts("");                                   // add newline
    }
}

/**
 *  subroutine for calculating sqrt
 *  @param x int to be sqrted
 *  @return int sqrt(x)
 */
int squareRoot(int x) {return sqrt(x);}

/**
 *  subroutines for freeing alloc memory before prog exit
 *  @param msgs char[] of messages
 *  @param total_messages count of read messages from start of prog
 */
void freeMem(char * msgs[LENGTH], int * total_messages) {
    int MAX_LEN = (*total_messages) < LENGTH ? (*total_messages) : LENGTH;
    for(int i = 0; i < MAX_LEN; i++)                // make sure only to free dynamically alloc mem
        free(msgs[i]);                              // loop thru arr and free messages
}

void easterEgg()
{
	int user_hp = 100;
	int mem_hp = 100;
	char choice;
	char val_choice = 'n';
	int val = 0;
	printf("*queue Pokemon Battle Music*\n");
	printf("A wild Memory Leak has appeared!\n\n");
	while((user_hp != 0)&&(mem_hp != 0))
	{
		if((user_hp != 20)||(val_choice == 'n'))
		{
			printf("\nAmateur Programmer HP: %d \n", user_hp);
			printf("MemLeak HP: %d \n", mem_hp);
			printf("What would you want to do?\n");
			printf("CHOICES: \n");
			printf("d - DEBUG	r - RUN\n");
			scanf(" %c", &choice);
			if(choice == 'd')
			{
				printf("You used DEBUG!\n");
				printf("Nothing happened!\n");
				if(user_hp == 100)
				{
					printf("MemLeaks used CONFUSION!\n");
					printf("Amateur Programmer is now confused!\n");
				}
				if(user_hp <= 80)
				{
					printf("MemLeaks used FRUSTRATION!\n");
					printf("It was super effective!\n");
				}
				user_hp -= 20;
				if (user_hp == 20)
				{
					printf("Amateur Programmer is trying to learn VALGRIND!\n");
		                        printf("Let Amateur Programmer learn VALGRIND? (y/n) \n");
                		        scanf(" %c", &val_choice);
                        		if(val_choice == 'y')
                   			     {
                                		printf("Amateur Programmer learned VALGRIND!\n");
                       			     }
					if(val_choice == 'n')
					{
						printf("Amateur Programmer did not learn VALGRIND.\n");
					}
				}
			}
			else if (choice == 'r')
			{
				printf("There's no escape from Memory Leak!\n");
			}

		}
		else
		{
			printf("\nAmateur Programmer HP: %d \n", user_hp);
                        printf("MemLeak HP: %d \n", mem_hp);
                        printf("What would you want to do?\n");
                        printf("CHOICES: \n");
                        printf("v - VALGRIND	d - DEBUG       r - RUN\n");
                        scanf(" %c", &choice);
			if(choice == 'd')
			{
				if(val == 1)
				{
					printf("You used DEBUG!\n");
					printf("Effects from VALGRIND made DEBUG super effective!\n");
					mem_hp -= 100;
				}
				else
				{
                        		printf("You used DEBUG!\n");
                                	printf("Nothing happened!\n");
					printf("MemLeaks used FRUSTRATION!\n");
                                	printf("It was super effective!\n");
					user_hp -= 20;
				}
			}
			else if(choice == 'v')
			{
				printf("You used VALGRIND!\n");
				printf("It rendered MemLeaks unconscious!\n");
				printf("MemLeaks misses a turn!\n");
				val = 1;
			}
			else if(choice == 'r')
			{
				printf("There's no escape from Memory Leak!\n");
			}

		}
	}
	if(user_hp == 0)
	{
		printf("\nAmateur Programmer has fainted!\n");
		printf("You have no other programmers left!\n");
		printf("Better luck next time!\n");
	}
	else if (mem_hp == 0)
	{
		printf("\nMemLeaks has fainted!\n");
		printf("Amateur Programmer is victorious!!\n");
		printf("Amateur Prgorammer manages to submit project on time!\n");
	}
	getchar();
	return;

}



