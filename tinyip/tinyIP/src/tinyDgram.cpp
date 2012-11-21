///-
/// @FILE tinyDgram.cpp
/// 
/// @brief Tiny Datagram Interface
///    


#include <assert.h>
#include <string.h>
#ifndef TINYIP_THREADX
#include "draco_debug.h"
#endif
#include "tinyConn.h"


#define TINY_DGRAM_TIMEOUT   	(1000*1000*10) /* time out for the mutex semaphore - 10 sec*/
#define REPLY_STRING_SIZE 	255   
#define NUM_BYTES 		64    /* number of bytes to send as ping data */
#define NUM_PKTS  		2     /* Number of ping pkts to send */
#define INTERVAL_BTWN_PKTS 	500   /* 300 milli sec. */
#define TIME_OUT		4     /* 5 sec */

#ifndef TINYIP_THREADX
static int isSendToEnabled = 0;
static int isSendToError = 0;
#endif

#ifdef INTEGRITY

#include "RedOS_pub_api.h"
#include "udw.h"
#include "INTEGRITY.h"
#include "draco_utils.h" 
#ifdef _FILEID_
#undef _FILEID_
#endif
#define _FILEID_ 727

/* List of reachable and non reachable IP addresses */
typedef struct ipAddrList
{
    unsigned int ipAddress;   /* IP Address          */
    boolean_t    isReachable; /* TRUE  = Reachable   */
                              /* FALSE = Unreachable */

    struct ipAddrList *next;  /* Pointer to next node */
    struct ipAddrList *prev;  /* Pointer to next node */
} ipAddrList;



/* Head of the IP address list */
static ipAddrList *pIpAddrListHead = NULL;
static unsigned int gSendToCount = 0;

/* Semaphore to protect the list */
static tRedOSSem ipAddrMutex = NULL;
static tRedOSSem ipQStatMutex = NULL;



static char *ipBinToString(unsigned int val);

static char *forceIp = NULL;
static int  forcePort = 0;

extern "C" {
    extern void do_ping(int, int, int, int);
}

static tRedOSClock sendToClock = 0;
static tRedOSMessageQ sendToEventQ = 0;

static boolean_t MwflushIpAddrList(TMwArgs Args[]);
static boolean_t MwRemIpAddrList(TMwArgs Args[]);
static boolean_t MwShowIpAddrList(TMwArgs Args[]);
static boolean_t MwNumTinyDgramPktSent(TMwArgs Args[]);
static boolean_t MwForceUDPDest(TMwArgs Args[]);

static const UDW_mwTableEntry_t mwIpAddrList[] =
{
    { "flush_ip_addr_list", MwflushIpAddrList, "", FALSE,{0,0,0,0,0} },
    { "flush_ip_addr", MwRemIpAddrList, "s", FALSE,{0,0,0,0,0} },
    { "show_ip_addr_list", MwShowIpAddrList, "", FALSE,{0,0,0,0,0} },
    { "num_tinydgram_pkts_sent", MwNumTinyDgramPktSent, "", FALSE,{0,0,0,0,0} },
    { "force_udp_destination", MwForceUDPDest, "si", FALSE,{0,0,0,0,0} },
    { (char *) NULL, (bool(*)(TMwArgs *)) NULL, (char *) NULL }
};

static boolean_t MwForceUDPDest(TMwArgs Args[])
{
    forceIp = new char[strlen(Args[0].string)+1];
    check(forceIp);
    strcpy(forceIp, Args[0].string);
    forcePort = Args[1].integer;
    UDW_printf("All UDP Messages will be redirected to IP:Port %s:%0d\n", forceIp, forcePort);
    return TRUE;
}
/**
  * TinyDgram::initIpAddrList
  *
  * Pre:    None
  *
  * Post:   None
  *
  * Param:  None
  * 
  * Return: None
  *
  * Desc:   This function initialises the Ip address list.
  *	    Creates the mutex semaphore.
  */
static void initIpAddrList()
{
    /* First call to this function.
     * We dont have a "init" function 
     * So Create the mutex semaphore here */
    ipAddrMutex = RedOSSemMutexCreate();
    if (ipAddrMutex == NULL)
    {
        draco_message("ERROR: SendTo, failed to allocate ipAddrList Mutex\n");
        isSendToError ++;
    }
    
    /* register the mechware functions here */
   UDW_RegisterDevelopware(mwIpAddrList);

}

/**
  * TinyDgram::isAddressValid
  *
  * Pre:    None
  *
  * Post:   None
  *
  * Param:  IpAddress - Verify reachability of 
  *                     this IP address
  *
  * Return: TRUE, If the IP address is known to be reachable.
  *         FALSE otherwise.
  *
  * Desc:   This function searches in IP address
  * 	    list to find if the given IP address
  *	    is already present. If its present,
  *	    "isReachable" of the corresponding
  *	    node will be returned. Else, a Ping
  *         packet will be sent to the destination
  *	    to verify the reachability and the result 
  *	    will be updated in the Ip address list.
  */
boolean_t isAddressValid(const char *IpAddress)
{
    unsigned int ipAddress = inet_addr(IpAddress);
    ipAddrList *pTraverse;
    boolean_t isReachable;
    int       pingStatus;

    if (ipAddrMutex  == NULL)
    {
    initIpAddrList();
    }
    
    if (pIpAddrListHead != NULL)
    {
    /* Take mutex semaphore */
    RedOSSemTake(ipAddrMutex, TINY_DGRAM_TIMEOUT);
    
    pTraverse = pIpAddrListHead;
    /* Lookup for the given IP address */
    while (pTraverse != NULL)
    {
        if(pTraverse->ipAddress == ipAddress)
        {
        /* release the semaphore */
        RedOSSemGive(ipAddrMutex);
        
        /* If its found in our IP address list */
        return pTraverse->isReachable;
        }
        pTraverse = pTraverse->next;
    }

    /* release the semaphore */
    RedOSSemGive(ipAddrMutex);
    }

    /* Create a new ipAddress node */
    pTraverse = new ipAddrList;
    if (pTraverse == NULL)                                       
    {
        draco_message("ERROR: SendTo, pTaverse allocation failure\n");
        isSendToError ++;
    }
    pTraverse->ipAddress = ipAddress;
    pTraverse->isReachable = FALSE; /* Set as non reachable */
    
    pingStatus = ping_controller(IpAddress, 0);
    if(pingStatus != 0)
    {
	draco_debug(41, 0, ("INFO: ping could not reach ipAddress %s\n",IpAddress));
    }
    else
    {
	/* We got the ping reply */
        pTraverse->isReachable = TRUE;
    }

    /* Take mutex semaphore */
    RedOSSemTake(ipAddrMutex, TINY_DGRAM_TIMEOUT);
    
    /* Insert the new node to the begining of the list */
    pTraverse->next = pIpAddrListHead;
    if (pIpAddrListHead)
    pIpAddrListHead->prev = pTraverse;
    
    pIpAddrListHead = pTraverse;
    pIpAddrListHead->prev = NULL;
    isReachable = pTraverse->isReachable;

    /* release the semaphore */
    RedOSSemGive(ipAddrMutex);
        
    return isReachable;
}


/**
  * TinyDgram::updateIpAddrList
  *
  * Pre:    None
  *
  * Post:   None
  *
  * Param:  IpAddress - Creates an entry for this IP
  *			address in the list and marks the
  *			reachability as TRUE.
  *
  * Return: None
  *
  * Desc:   This function searches in IP address
  * 	    list to find if the given IP address
  *	    is already present. If its present,it
  *	    just returns. Else creates an entry for the
  *	    given IP address and isReachability is set to TRUE.
  */
void updateIpAddrList(unsigned int ipAddress)
{
    ipAddrList *pTraverse = NULL;
    
    if (ipAddrMutex  == NULL)
    {
    initIpAddrList();
    }
    
    /* verify if the IP address already present in the list */
    
    /* Take mutex semaphore */
    RedOSSemTake(ipAddrMutex, TINY_DGRAM_TIMEOUT);
    pTraverse = pIpAddrListHead;
    while (pTraverse != NULL)
    {
    if(pTraverse->ipAddress == ipAddress)
    {
        /* If the address is already present in the list, return */
        
        /* release the semaphore */
        RedOSSemGive(ipAddrMutex);
        return;
    }
    pTraverse = pTraverse->next;
    }
    
    /* Create a new ipAddress node */
    pTraverse = new ipAddrList;
    if (pTraverse == NULL)                                       
    {
        draco_message("ERROR: SendTo, pTaverse allocation failure 2\n");
        isSendToError ++;
    }
    pTraverse->ipAddress = ipAddress;
    pTraverse->isReachable = TRUE;

    /* Insert the new node to the begining of the list */
    pTraverse->next = pIpAddrListHead;
    if (pIpAddrListHead)
    pIpAddrListHead->prev = pTraverse;
    
    pIpAddrListHead = pTraverse;
    pIpAddrListHead->prev = NULL;

    RedOSSemGive(ipAddrMutex);
    return;
}

/************************************************************************
!BeginMechware

Category: IP Address List

Usage:  flush_ip_addr_list;

Description: Deletes the the entire IP address List

Parameter:

Author: Ram

Last Modified: Feb 8, 2005

!EndMechware
*****************************************************************************/
static boolean_t MwflushIpAddrList(TMwArgs Args[])
{
    ipAddrList *pTemp;
    
    if(pIpAddrListHead != NULL)
    {
    /* Take mutex semaphore */
    RedOSSemTake(ipAddrMutex, TINY_DGRAM_TIMEOUT);

    while(pIpAddrListHead != NULL)
    {
        pTemp = pIpAddrListHead->next;
        delete pIpAddrListHead;

        pIpAddrListHead = pTemp;
    }
    
    /* release the semaphore */
    RedOSSemGive(ipAddrMutex);
    }

    return TRUE;
}

/************************************************************************
!BeginMechware

Category: IP Address List

Usage:  flush_ip_addr sIpAddress;

Description: Deletes the given IP address from the LIst

Parameter:
           sIpAddress - IP address (format "15.252.51.22")


Author: Ram

Last Modified: Feb 8, 2005

!EndMechware
*****************************************************************************/
static boolean_t MwRemIpAddrList(TMwArgs Args[])
{
    ipAddrList *pTemp = NULL;
    const char *IpAddress;
    IpAddress = Args[0].string;
    
    unsigned int ipAddress = inet_addr(IpAddress);
    
    if(pIpAddrListHead != NULL)
    {
    /* Take mutex semaphore */
    RedOSSemTake(ipAddrMutex, TINY_DGRAM_TIMEOUT);

    pTemp = pIpAddrListHead;
    while(pTemp != NULL)
    {
        if(pTemp->ipAddress == ipAddress)
        {
        /* If this is the first node */
        if(pTemp == pIpAddrListHead)
        {
            pIpAddrListHead = pIpAddrListHead->next;
            pIpAddrListHead->prev = NULL;
        }
        else
        {
            pTemp->prev->next = pTemp->next;
            if(pTemp->next != NULL)
            pTemp->next->prev = pTemp->prev;
        }

        delete pTemp;
        UDW_printf("Deleted the IP address %s from the list\n", IpAddress);
        break;
        }
        pTemp = pTemp->next;
    }
    
    /* release the semaphore */
    RedOSSemGive(ipAddrMutex);
    }

    if(pTemp == NULL)
    UDW_printf("Given IP address not found in the list\n");

    return TRUE;
}


/************************************************************************
!BeginMechware

Category: IP Address List

Usage:  show_ip_addr_list;

Description: Display the contents of IP address list.

Parameter:

Author: Ram

Last Modified: Feb 8, 2005

!EndMechware
*****************************************************************************/
static boolean_t MwShowIpAddrList(TMwArgs Args[])
{
    ipAddrList *pTemp;
    const char *ipStr;
    
    if(pIpAddrListHead != NULL)
    {
    UDW_printf("\n  IP Address          Reachable");
    UDW_printf("\n**************        *********");
    
    /* Take mutex semaphore */
    RedOSSemTake(ipAddrMutex, TINY_DGRAM_TIMEOUT);
    pTemp = pIpAddrListHead;
    while(pTemp != NULL)
    {
        /* Convert the ip address from bin to string */
        ipStr = ipBinToString(pTemp->ipAddress);
        UDW_printf("\n%15s        %s",ipStr, (pTemp->isReachable) ? "Yes" : "No");

        pTemp = pTemp->next;
    }
    UDW_printf("\n");
    /* release the semaphore */
    RedOSSemGive(ipAddrMutex);
    }
    else
    {
    UDW_printf("IP Address list is empty\n");
    }
    return TRUE;
}
/************************************************************************
!BeginMechware

Category: IP Address List

Usage:  num_tinydgram_pkts_sent;

Description: Display number of tiny udp packets sent since last reboot
             along with some other delivery metrics.

Parameter:

Author: Ram

Last Modified: Feb 9, 2005

!EndMechware
*****************************************************************************/
static boolean_t MwNumTinyDgramPktSent(TMwArgs Args[])
{
    UDW_printf("\nNumber of Tiny UDP Packets Requested = %d\n", TinyDgram::udpPacketsRequested);
    UDW_printf("Number of Tiny UDP Packets Sent = %d\n", TinyDgram::udpPacketsSent);
    UDW_printf("Number of Tiny UDP Packets Currently Enqueued = %d\n", TinyDgram::udpPacketsEnqueued);
    UDW_printf("Number of Tiny UDP Packet Queue Highwater = %d\n", TinyDgram::udpQueueHighwater);
    UDW_printf("Number of Tiny UDP Packet Queue Overruns = %d\n", TinyDgram::udpQueueOverruns);
    UDW_printf("Number of Tiny UDP sendto hangs detected = %d\n", TinyDgram::udpHangsDetected);
    UDW_printf("Number of Tiny UDP Errors = %d\n", TinyDgram::udpErrors);
    return TRUE;
}

//
// Initalize the static class member variables
// Note that we are still in the INTEGRETY-ONLY block
//
unsigned long TinyDgram::udpPacketsRequested = 0;
unsigned long TinyDgram::udpPacketsEnqueued = 0;
unsigned long TinyDgram::udpPacketsSent = 0;
unsigned long TinyDgram::udpHangsDetected = 0;
unsigned long TinyDgram::udpQueueOverruns = 0;
unsigned long TinyDgram::udpQueueHighwater = 0;
unsigned long TinyDgram::udpErrors = 0;
stNode * TinyDgram::msgInWork = NULL;

#endif /* INTEGRITY */


TinyDgram::TinyDgram()
{
    _data = NULL;
    _ipVal = 0;
    _port = 0;
    _size = 0;
}

TinyDgram::TinyDgram(unsigned char * data, unsigned int size, unsigned int ipVal, unsigned short port)
{
    _data = new unsigned char[size];
    _size = size;
    if (_data == NULL || _size > 1024*64)                                       
    {
#ifdef INTEGRITY
        draco_message("ERROR: SendTo, TinyDgram allocation failure 2\n");
        isSendToError ++;
#endif
        _size = 0;
        _data = NULL;
        _ipVal = 0;
        _port = 0;
        return;
    }
    memcpy(_data, data, size);
    _ipVal = ipVal;
    _port = port;
}

TinyDgram::~TinyDgram()
{
    _size = 0;
    _port = 0;
    _ipVal = 0;
    delete [] _data;
    _data = 0;
}

unsigned char *
TinyDgram::Data(void)
{
    return(_data);
}

void
TinyDgram::Data(unsigned char * data, int size)
{
    if (data)
    {
        if (_data)
            delete [] _data;
        _data = new unsigned char[size];
        _size = size;
        if (_data == NULL || _size > 1024*64)                                       
        {
#ifdef INTEGRITY
            draco_message("ERROR: SendTo, TinyDgram allocation failure 2\n");
            isSendToError ++;
#endif
            _size = 0;
            _data = NULL;
            _ipVal = 0;
            _port = 0;
            return;
        }
        memcpy(_data, data, size);
    }
}

int 
TinyDgram::Size(void)
{
    return(_size);
}

static unsigned int
ipStringToBin(char * s)
{
    char iw[4];
    int b=0;
    unsigned int result;

    if (s==NULL)
        return(0);

    iw[0] = iw[1] = iw[2] = iw[3] = 0;
    while (*s != '\0')
    {
        if (*s == '.')
        {
            b++;
            if (b>3) return(0);
            continue;
        }

        if (! isdigit(*s))
            return(0);

        iw[b] = (iw[b] * 10) + (*s - '0');
    }
    if (b!=3) 
        return(0);

    result = iw[0];
    result = (result << 8) + iw[1];
    result = (result << 8) + iw[2];
    result = (result << 8) + iw[3];

    return(result);    
}

static char *
ipBinToString(unsigned int val)
{
    struct in_addr addr;
    addr.s_addr = htonl(val);
    return(inet_ntoa(addr));    
}

char * 
TinyDgram::SrcIP(void)
{
    return(ipBinToString(_ipVal));    
}

void 
TinyDgram::SrcIP(char *ip)
{
    _ipVal = ipStringToBin(ip);
}

int 
TinyDgram::SrcPort(void)
{
    return((int) _port);
}

void 
TinyDgram::SrcPort(int port)
{
    check((port > 0) && (port < (1024*64)));
    _port = (unsigned short int) port;
}


static int 
getDgramSocket(void)
{
    int status;
    static int s = INVALID_SOCKET;
    struct sockaddr_in myAddress;

    if (s == INVALID_SOCKET)
    {
#if defined(WIN32)

        extern int firstWinsockCall;
        if (firstWinsockCall)
        {
            WORD wVersionRequested = MAKEWORD( 2, 2 );
     
            WSADATA wsaData;
            if (WSAStartup(wVersionRequested,&wsaData) == SOCKET_ERROR) 
            {
                tiny_message("TinyConn: WSAStartup failed with error %d\n",WSAGetLastError());
                status = TinyConn::FAILED;
                return(-1);
            }
            firstWinsockCall = 0;
        }
#endif


        /* Create the socket */
        s = socket(AF_INET, SOCK_DGRAM, 0);
        if (s < 0) 
        {
            s=INVALID_SOCKET;
            tiny_message("ERROR: Failed to create datagram socket, errno=%0d\n",errno); 
        }
        else
        {

            /* We don't care about the sender's binding */
            myAddress.sin_family = AF_INET;
            myAddress.sin_addr.s_addr = INADDR_ANY;
            myAddress.sin_port = INADDR_ANY;

            /* Bind to an abritrary address */
            status = bind(s, (struct sockaddr *)&myAddress, sizeof(myAddress));

            if (status < 0) 
            {
                tiny_message("ERROR: Failed to bind datagram socket, errno=%0d\n",errno); 
#ifdef WIN32
                closesocket(s);
#else
                close(s);
#endif
                s=INVALID_SOCKET;
            }                                                                               
        }
    }

    tiny_message("tinyDgram: SocketInit completed s=%0d\n",s); 
    return(s);
}

#ifdef INTEGRITY
//
// To support a workaround in the Engine we need a series of therads to make this work
// also in the engine we send the packets on a seperate thread.
//

//
// Static method to allow UDP datagram send.
//

#define STNODE_VALID 0x212245ff
#define STNODE_FAIL  0x2122120f
#define STNODE_DEL   0x21220000
#define ST_MAX_ADDR_LEN 16
#define ST_QUEUE_SIZE 256

class stNode
{
public:
    int _cookie;
    char _address[ST_MAX_ADDR_LEN];
    int _port;
    int _datalen;
    char *_data;
    stNode(const char *address, int port, int datalen, const char *data)
    {
        _cookie = STNODE_FAIL;
        if ((address != NULL) && (strlen(address) < ST_MAX_ADDR_LEN))
            strcpy(_address, address);
        else
            return;

        if ((port > 0) && (port < 65535))
            _port = port;
        else
            return;

        if ((datalen > 0) && (datalen < 1500))
            _datalen = datalen;
        else
            return;

        if (data != NULL)
        {
            int size = (datalen > 256) ? datalen : 256;
            _data = new char[size];
            if (_data)
                memcpy(_data, data, datalen);
            else
                return;
        }
        else
            return;

        _cookie = STNODE_VALID;
    };

    bool isValid(void)
    {
        return(_cookie == STNODE_VALID);
    };

    ~stNode()
    
    {
        _cookie = STNODE_DEL;
        if (_data)          
        {
            delete [] _data;
            _data = NULL;
        }
        _datalen = _port = 0;
        _address[0] = '\0';
    }
};


static tRedOSMessageQ
getDgramQueue(void)
{
    static int firsttime = 1;
    static tRedOSMessageQ qHandle = 0;

    if (firsttime)
    {
        qHandle = RedOSMessageCreateQ(ST_QUEUE_SIZE,  sizeof(stNode *));
        if (qHandle == 0)
        {
            draco_message("ERROR: Failed to setup SendTo datagram queue.\n");
            isSendToError ++;
        }
        firsttime = 0;
    }
    return(qHandle);
}



void
TinyDgram::SendToStallMsg(void *p)
{
    // Operates in Interrupt context... Must be quick...
    tRedResult res;
    int val = 1;

    draco_message("WARNING:  SendTo Stall timer fired. %0d packets in Queue\n", TinyDgram::udpPacketsEnqueued);
    if (sendToEventQ != 0)
    {
        res = RedOSMessageSend(sendToEventQ, (char *) &val, sizeof(int), RED_NOWAIT);
        if (res != RED_SUCCESS)
            draco_message("ERROR: Can Not submit event sendTo hang event to monitir Queue");
    }
}



void 
TinyDgram::SendToTask(void * pParam)
{
    tRedOSMessageQ q = getDgramQueue();
    struct sockaddr_in destAddress;
    stNode * qp = NULL;
    tRedUInt32 bytesRead;
    tRedResult res;
    tRedSInt32 timeout = (1000*1000)*30;
    int s = getDgramSocket();
    int status;

    int count = 20;

    while(1)
    {
        while (1)
        {
            res = RedOSMessageReceive(q, (char *) &qp, sizeof(stNode *), &bytesRead, timeout);
            if (res == RED_SUCCESS) 
                break;
            if (res == RED_TIMED_OUT)
            {
                //draco_message("SendToTask: message receive timed out");
                continue;
            }
            draco_message("ERROR: SendTo, send task queue returned failure %0d\n", res);
            isSendToError ++;
            RedOSThreadDelay(1000*1000); // one second...
        }

        if ((qp==NULL) || (!qp->isValid()))
        {
            draco_message("ERROR: SendTo, send task queue data was invalid\n");
            isSendToError ++;
            RedOSThreadDelay(1024*1024); // one second...
            continue;
        }

        RedOSSemTake(ipQStatMutex, RED_WAIT_FOREVER);
        TinyDgram::udpPacketsEnqueued--;
        RedOSSemGive(ipQStatMutex);
        
        /* Setup the address to which we will send */
        destAddress.sin_family = AF_INET;
        destAddress.sin_addr.s_addr = inet_addr(qp->_address);
        destAddress.sin_port = htons(qp->_port);

        // If the alarm fires while we are trying to send the packet we may need to 
        // delete it in the monitor thread while this thread get's destroyed.
        //
        TinyDgram::msgInWork = qp;

        
        // set an alarm to determine if we've hung.
        // for now I allow 20 seconds...

        if (sendToClock == 0)
        {
            draco_message("ERROR: SendTo, send task alarm clock is invalid\n");
            isSendToError ++;
        }
        else
        {
            RedOSClockSetAlarm(sendToClock, SendToStallMsg, qp, (1000*1000)*20);
        }
    
        // Perform the actual UDP send...
        status = sendto(s, qp->_data, qp->_datalen, 0, (struct sockaddr *)&destAddress, sizeof(destAddress));

        if (status < 0)
        {
            draco_message("ERROR: SendTo, send encountered a failure, res = %0d, errno = %0d\n",status, errno);
            isSendToError ++;
        }
        else
        {
            TinyDgram::udpPacketsSent++;   
        }

        if (sendToClock != 0)
        {
            // The sendto Completed...
            RedOSClockCancelAlarm(sendToClock);
	    
        }

        if (qp->_cookie == STNODE_VALID)
            delete qp;
        TinyDgram::msgInWork = NULL;
        qp == NULL;
    }
}

//
// The send to monitor task has a few functions...
//   1) Own kernal resources that sendto uses
//   2) monitor a queue that will receive a message if the sendto alarm fires.
//   .. This thread will never go out of context
//
void
TinyDgram::SendToMonitorTask(void *parm)
{
    tRedOSThread dqThread = 0;
    tRedOSClock c = 0;
    tRedOSMessageQ dq;
    tRedOSMessageQ eq;
    tRedResult res;
    tRedOSSem syncSem = (tRedOSSem) parm;


    int s = getDgramSocket();
    if (s == INVALID_SOCKET)
    {
        draco_message("ERROR: tTinyDgram::SendTo() - INVALID_SOCKET\n");
        isSendToError ++;
    }
    
    c = RedOSClockCreate(RED_OS_CLOCK_TASK);
    if (c == 0)
    {
        draco_message("Failed to initalize sendToMonitor Clock\n");
        isSendToError ++;
    }
    sendToClock = c;

    dqThread = RedOSThreadNew( "tSendTo", TinyDgram::SendToTask, 0); 
    if (dqThread == 0)
    {
        draco_message("Failed to create sendTo Task\n");
        isSendToError ++;
    }

    dq = getDgramQueue();
    if (dq == 0)
    {
        draco_message("Failed to create sendTo datagram Queue\n");
        isSendToError ++;
    }
    
    eq = RedOSMessageCreateQ(10,  sizeof(int));
    if (eq == 0)
    {
        draco_message("Failed to create sendTo Event Queue Queue\n");
        isSendToError ++;
    }

    sendToEventQ = eq;  // Let the ISR know about it.....

    //
    // Turn loose the calling thread
    RedOSSemGive(syncSem);

    while (1)
    {
        int val;
        tRedUInt32 bytesRead;
        res = RedOSMessageReceive(eq, (char *)&val, sizeof(tRedUInt32), &bytesRead, RED_WAIT_FOREVER);
        if (res != RED_SUCCESS)
        {
            draco_message("WARNING: SendTo event thread received a Queue Receive failure.\n");
        }
        draco_message("WARNING: SendTo recycling Thread..\n");
        TinyDgram::udpHangsDetected++;
	
	RedOSThreadDelay(1000*100); // 100ms Delay to allow alarm to complete the message send

        //
        // Delete the suspected hung thread, It owned no resources so it should not
        // clean anything up.
        //
        RedOSThreadDelete(dqThread);

        //
        // Note: There may be a requirement to undo the initLibSocket that occures
        // on thread creation inside Red OS
        //

        // Give the OS Some Context .. 5 seconds ..
        RedOSThreadDelay(1024*1024*5);

        //
        // Check to see if we should delete the packet which the send thread was
        // working on
        //
        if (TinyDgram::msgInWork && TinyDgram::msgInWork->_cookie == STNODE_VALID)
        {
            delete TinyDgram::msgInWork;
            TinyDgram::msgInWork = NULL;
        }

        dqThread = RedOSThreadNew( "tSendTo", TinyDgram::SendToTask, 0); 
        if (dqThread == 0)
        {
            draco_message("Failed to create sendTo Task\n");
            isSendToError ++;
        }
        draco_message("INFO: SendTo thread created. %0d packets in Queue\n", TinyDgram::udpPacketsEnqueued);
    }
}




int
TinyDgram::SendTo(const char *address, int port, const char *data, int dataLen)
{
    int status;
    char buf[128];
    tRedOSMessageQ q;    
    tRedOSClock clock;
    int s;
    static int firsttime = 1;
    static int firstError = 1;
    static int firstQueueOverRun = 1;

    TinyDgram::udpErrors = isSendToError;
 
    if (firsttime)
    {
        // startup the monitor task, the sending task and secure OS resources
        // the monitir thread needs to create a slew of resources so we'll wait for it to 
        // initalize and run.
        tRedOSSem sendtoSyncSem = RedOSSemBinaryCreateEmpty();
        if (sendtoSyncSem == 0)
        {
            draco_message("Failed to create sendTo Event Queue Queue\n");
            RedOSThreadSuspend(RedOSThreadIdSelf());
        }
        RedOSThreadNew( "tSendToMon", SendToMonitorTask,  sendtoSyncSem); 
        tRedResult res = RedOSSemTake(sendtoSyncSem, (1000*1000)*20);
        if (res != RED_SUCCESS)
        {
            draco_message("ERROR: Failure to initalize sendTo monitor\n");
            RedOSThreadSuspend(RedOSThreadIdSelf());
        }

        ipQStatMutex = RedOSSemMutexCreate();
        
        firsttime = 0;
    }

    q = getDgramQueue();

    //
    // Some protection to make sure that we don't sent to an invalid address (which hapens 
    // sometimes after an NVM initalization
    //
    if (strcmp(address, "0.0.0.0") == 0) 
        return 0;


    if (isSendToError > 0)
    {
        if (firstError)
        {
            draco_message("WARNING: SendTo() UDP failures, All ServiceReport and Quartz messages not delivered\n");
            firstError = 0;
        }
        //
        // To keep the rash of messages down if we have a screwed up networking environment 
        // we'll return successful to any request to send after a failure returns.  It's an 
        // unreliable call and the return value means we tried but the underlying queueing mechanism is 
        // broken.
        return(0);
    }
    
    //
    // For testing this will allow a Mechware to direct all UDP traffic to a single destination
    //
    stNode *qp;
    if (forceIp == NULL)
        qp = new stNode(address, port, dataLen, data);
    else
        qp = new stNode(forceIp, forcePort, dataLen, data);

    if ((qp==NULL) || (! qp->isValid()))
    {
        draco_message("WARNING: UDP Message internal creation failure\n");
        if (qp!=NULL)
        {
            delete qp;
            qp = NULL;
        }
        return -1;
    }

    RedOSSemTake(ipQStatMutex, RED_WAIT_FOREVER);
    TinyDgram::udpPacketsRequested++;
    RedOSSemGive(ipQStatMutex);




    tRedResult res = RedOSMessageSend(q, (char *)&qp, sizeof(stNode*), RED_NOWAIT);
    if (res != RED_SUCCESS)
    {
        // Somthing bad happend here...
	if(firstQueueOverRun)
	{
            draco_message("ERROR: We have experianced a SendTo() Queue overrun, message will not be sent.\n");
	    draco_message("Number of UDP messages in the Queue = %d\n", 
			    TinyDgram::udpPacketsEnqueued);
	    firstQueueOverRun = 0;
	}
        RedOSSemTake(ipQStatMutex, RED_WAIT_FOREVER);
        TinyDgram::udpQueueOverruns++;
        RedOSSemGive(ipQStatMutex);
        delete qp;
        qp = NULL;

        return -1;
    }

    RedOSSemTake(ipQStatMutex, RED_WAIT_FOREVER);
    TinyDgram::udpPacketsEnqueued++;
    if (TinyDgram::udpPacketsEnqueued > TinyDgram::udpQueueHighwater)
         TinyDgram::udpQueueHighwater = TinyDgram::udpPacketsEnqueued;
    RedOSSemGive(ipQStatMutex);

    qp = NULL;  // We've given this node to the sending task...
    return(0);

}

#else // Linux and PC...


//
// Static method to allow UDP datagram send.
//
int
TinyDgram::SendTo(const char *address, int port, const char *data, int dataLen)
{
    int status;
    int s = getDgramSocket();
    struct sockaddr_in destAddress;
    char buf[128];

    /* Setup the address to which we will send */
    destAddress.sin_family = AF_INET;
    destAddress.sin_addr.s_addr = inet_addr(address);
    // uint32_t addr = destAddress.sin_addr.s_addr;
    // in_addr x;
    // x.s_addr = addr;
    destAddress.sin_port = htons(port);

    // tiny_printf("dest sin_port = 0x%08x\n",destAddress.sin_port);

    status = sendto(s, data, dataLen, 0, (struct sockaddr *)&destAddress, sizeof(destAddress));
    if (status < 0) 
    {
        strncpy(buf, strerror(errno), 128);
        buf[127] = '\0';
        tiny_message("ERROR: Datagram send failed, errno=%0d, %s\n",errno,(buf == NULL)?"null":buf); 
    }
    // tiny_message("TinyConn::SendTo complete (status = %0d)\n"
    //               "   address:port == %s:%0d\n"
    //               "   dataLen = %0d\n",
    //               status,
    //               inet_ntoa(x), ntohs(destAddress.sin_port), dataLen);

    return(status);
}


#endif
    
    
