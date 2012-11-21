#ifndef _TINY_PORTING_CODE_HEADER_
#define _TINY_PORTING_CODE_HEADER_

#include <assert.h>
//#include <draco_types.h>

#ifdef INTEGRITY
    #include <INTEGRITY.h>
    #include <sys/types.h>
    #include <sys/socket.h>
    #include <arpa/inet.h>
    #include <netinet/in.h>
    #include <netinet/tcp.h>
    #include <unistd.h>
    #include <netdb.h>
    #include <errno.h>
    #include "draco_types.h"
    #include "draco_debug.h"
    typedef int SOCKET;
    #define DllExport
#elif !defined (SYS_OZ)   // For SYS_OZ, check is defined in draco_types.h
    #ifndef check
    #define check(x) assert(x)
    #endif
#endif /* INTEGRETY */
#ifdef TINYIP_THREADX
	#define draco_message printf
#endif

    #ifdef _FILEID_
    #undef _FILEID_
    #endif
    #define _FILEID_ 786

#include <string.h>
#include <stdio.h>
#include <ctype.h>

#define tiny_message tiny_printf
int tiny_printf(const char *format, ...);

#ifdef WIN32
    #define WINSOCKETS
    #ifndef MSVC
        #define MSVC
    #endif
    #include <winsock2.h>

    #define STRTOK_R
    #ifdef __cplusplus
    extern "C" {
    #endif
    char * strtok_r(char *s1, const char *s2, char **last);

    #ifdef __cplusplus
    }
    #endif

    #ifdef TINY_DLL
    #ifdef TINYIP_EXPORTS
        #pragma	message("Building tinyConn DLL")
        #define DllExport   __declspec( dllexport )
    #else
        #pragma	message("linkage to of tinyConn DLL")
        #define DllExport   __declspec( dllimport )
    #endif
    #else /* ! TINY_DLL (static lib) */
        #pragma	message("tinyConn Static Library")
        #define DllExport
    #endif

    typedef int socklen_t;

#ifndef _DRACO_DEBUG_DEFINED_
#define _DRACO_DEBUG_DEFINED_
	#define draco_message	tiny_printf
	#if (!defined(NDEBUG) || defined(KEEP_DRACO_DEBUG))
		  #define draco_debug(SCTN, LVL, PRNT) \
		   ((LVL) > 1 ) ? (void) 0 : (void) tiny_printf PRNT
	#else
	#define draco_debug(SCTN, LVL, PRNT) 
	#endif
#endif

#endif /* WIN32 */

 
// For the formatter (SYS_OZ), LINUX is not defined, but DRACO_OS is set to OS_LINUX
#if defined(LINUX) || (DRACO_OS == OS_LINUX)
    #include <arpa/inet.h> 
    #include <netinet/tcp.h>
    #include <netinet/in.h>
    #include <sys/types.h>
    #include <sys/socket.h>
    #include <unistd.h>
    #include <netdb.h>
    #include <errno.h>
    #include <stdarg.h>

    typedef int SOCKET;
    #define DllExport
#endif





#ifndef MAXHOSTNAMELEN   
#define MAXHOSTNAMELEN   64
#endif


#ifndef INVALID_SOCKET
#define INVALID_SOCKET (-1)
#endif

#ifndef SOCKET_ERROR
#define SOCKET_ERROR -1
#endif



#undef _FILEID_ 
#endif // _TINY_PORTING_CODE_HEADER_

