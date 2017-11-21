#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>


int main(int argc, char **argv)
{
long cnt;
long i;
char *pt;
	cnt = strtol(argv[1], NULL, 10);
printf("Allocating %ld\n",cnt*1024*1024);
pt = (char *) malloc(cnt*1024*1024);
if (pt == NULL)
{
   perror("malloc");
   return -1;
}
for(i=0;i<cnt;i+=512)
{
   pt[i] = 0x22;
}
sleep(10);
return 0;   
}
