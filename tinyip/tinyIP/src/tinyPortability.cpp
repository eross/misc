
#ifdef SYS_OZ
// per oz include rules this has to be the first include file!
#include <SysFirstInc.h> 
#include <EILIBAllocID.h>
#endif

#include <stdarg.h>
#include <stdio.h>

//#include <draco_types.h>
//#include <draco_debug.h>
#include <tinyPortability.h>

#ifndef MSVC
#ifndef TINYIP_THREADX
#include <RedOS_pub_api.h>
#endif
#endif

#ifdef _FILEID_
#undef _FILEID_
#define _FILEID_ 728
#endif
#ifdef INTEGRITY
static char buf[1024*5];
static tRedOSThread  bufTID;
#endif



int 
tiny_printf(const char *format, ...)
{
    int result = 0;

#ifdef INTEGRITY
    if (dracoDebug_levels[41] < 3)
        return(0);

    bufTID = RedOSThreadIdSelf();
#else
   #ifdef SYS_OZ
      char *buf = AllocCharArray(1024*5);
   #else
      char *buf = new char [1024*5];
   #endif
#endif
    
    va_list ap;                        
    va_start(ap, format);
    vsprintf(buf, format, ap);
    va_end(ap);

    // fail if the printf is greater than my buffer size..  
    // this should be a MUCH larger buffer and protected by semaphores.
    

#ifdef MSVC
    OutputDebugString(buf);
    result = strlen(buf);
#endif

#if defined(LINUX) || (DRACO_OS == OS_LINUX)
    result = printf(buf);
#endif

#ifdef INTEGRITY
    draco_debug(41,3,(buf));
    result = strlen(buf);
    if (bufTID != RedOSThreadIdSelf())
        draco_message("WARNING: tiny_printf() has detected a buffer Conflict\n");
#else
   #ifdef SYS_OZ
        DeallocCharArray(buf);
   #else
	delete [] buf;
   #endif
#endif

    return(result);
}

