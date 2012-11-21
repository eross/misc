#include <stdlib.h>
#if defined(__GNUC__)
#include <ppc_intrinsics.h>
#endif

int
null()
{
   int i, a = 0;
   (void)__mfspr(1023);
   for(i=0;i<16;i++)
	a += 3*i;
   (void)__mfspr(1023);
   return 0;
}
