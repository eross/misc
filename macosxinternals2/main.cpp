#include <stdio.h>
#include <stdlib.h>
#include <mach-o/dyld.h>
#include <sys/types.h>
#include <dlfcn.h>

int test1(void) {  // list dynamic libraries used.
    // insert code here...
    const char *s;
	uint32_t i, image_max;
	
	image_max = _dyld_image_count();
	for(i=0;i < image_max; i++)
		if((s = _dyld_get_image_name(i)))
			printf("%10p %s\n", _dyld_get_image_header(i), s);
		else {
			printf("image at index %u (no name?)\n", i);
		}
			
			return 0;
}


u_int64_t mftb64(void);
void mftb32(u_int32_t *h, u_int32_t *l);

void test2(void) { //display timebase register

	u_int64_t tb64;
	u_int32_t tb32u, tb32l;
	tb64= mftb64();
	mftb32(&tb32u, &tb32l);
	
	printf("%llx %x%08x\n", tb64, tb32l, tb32u);

}

u_int64_t
mftb64(void)
{
	u_int64_t tb64;
	
	__asm("mftb %0\n\t"
		  : "=r" (tb64)
		  :
		  );
	
	return tb64;
}

void
mftb32(u_int32_t *u, u_int32_t *l)
{
	u_int32_t tmp;
	
	__asm(
		  "loop:             \n\t"
		        "mftbu       %0     \n\t"
		        "mftb        %1     \n\t"
		        "mftbu       %2     \n\t"
		        "cmpw        %2,%0  \n\t"
		        "bne         loop   \n\t"
		        : "=r"(*u), "=r"(*l),  "=r"(tmp)
		        :
		  );
}

void
test3()
{
	vector float v1, v2, v3;
	
	v1 = (vector float)(1.0, 2.0, 3.0, 4.0);
	v2 = (vector float)(2.0, 3.0, 4.0, 5.0);
	
	v3 = vec_add(v1, v2);
	
	printf("%vf\n", v3);
}

void 
printframeinfo(unsigned int level, void *fp, void *ra) // print call stack frame
{
	int ret;
	Dl_info info;
	
	// find the image containing the given address
	ret = dladdr(ra, &info);
	printf("#%u %s%s in %s, fp = %p, pc = %p\n",
		   level,
		   (ret)?info.dli_sname: "?",
		   (ret)?"()" : "",
		   (ret)?info.dli_fname : "?", fp, ra);
}

void
stacktrace()
{
	unsigned int level = 0;
	void *saved_ra = __builtin_return_address(0);
	void **fp = (void **)__builtin_frame_address(0);
	void *saved_fp = __builtin_frame_address(1);
	
	printframeinfo(level, saved_fp, saved_ra);
	level++;
	fp = (void **)saved_fp;
	while(fp)
	{
		saved_fp = *fp;
		fp = (void **)saved_fp;
		if(*fp == NULL)
			break;
		saved_ra = *(fp + 2);
		printframeinfo(level, saved_fp, saved_ra);
		level++;
	}
}

int main (int argc, char * const argv[])
{
	stacktrace();
	return 0;
}

