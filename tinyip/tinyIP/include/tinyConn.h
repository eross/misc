/*********************************************************************\
**
** File: tinyConn.h
**
** Description: Contains specification for the classes:
**
**      TinyConn:       A wrapper for connections that attach to 
**                      the TinyServer
**
** Author:      David M. Lowe
**
**    * (C) Copyright 2001, Hewlett-Packard Company, all rights reserved.
**
\*********************************************************************/

#ifndef INCLUDE_TINY_CONN_H
#define INCLUDE_TINY_CONN_H

#include "tinyPortability.h"
//#include "RedOS_pub_api.h"

#define SENTO_IN_TASK
//#undef  SENTO_IN_TASK

#ifdef SENTO_IN_TASK
///WORAROUND for the SendTo Issue()
// allow UDP datagram send in its own task
//


typedef struct {

    int s;
    unsigned char * data;
    size_t dataLen;
    struct sockaddr saddr;
  
}SendToTaskParam,*pSendToTaskParam;

#endif

// Forward reference of the internal stNode
class stNode;

class TinyConnection;

class TinyDgram
{

#ifdef SYS_OZ
public:
  void* operator new(size_t size) { return CustomAllocator(size, 0); }
  void* operator new[](size_t size) { return CustomAllocator(size, 0); }
  void operator delete(void *p) { return CustomDeallocator(p); }
  void operator delete[](void *p) { return CustomDeallocator(p); }
#endif
public:


    TinyDgram();
    TinyDgram(unsigned char * data, unsigned int size, unsigned int ipval, unsigned short port);
    ~TinyDgram();
    unsigned char * Data(void);
    void Data(unsigned char * data, int size);
    int Size(void);
    char * SrcIP(void);
    void SrcIP(char *ip);
    int SrcPort(void);
    void SrcPort(int);

    static int SendTo(const char *ip, int port, const char *data, int dataLen);

    #ifdef INTEGRITY

    static unsigned long udpPacketsRequested;
    static unsigned long udpPacketsEnqueued;
    static unsigned long udpPacketsSent;
    static unsigned long udpHangsDetected;
    static unsigned long udpQueueOverruns;
    static unsigned long udpQueueHighwater;
    static unsigned long udpErrors;

    static void SendToTask(void * pParam);    
    static void SendToStallMsg(void * pParam);    
    static void SendToMonitorTask(void *parm);
    static stNode * msgInWork;

    #endif

private:
    unsigned int _ipVal;
    unsigned short int _port;
    unsigned char * _data;
    int _size;

};

class TinyConn
{
public:

    enum status 
    { 
        INIT,  
        READY,  
        FAILED, 
        CLOSED,
        DELETED
    };

    enum SOCK_TYPE 
    { 
        STREAM,
        DGRAM
    };

    enum SOCK_OPT
    {
        SO_NONE = 0,
        SO_NOVERIFYADDR = 1
    };

    static int InitTinyConn(unsigned long mode);
    static int Pulse(void);
    
    
    ~TinyConn();
    TinyConn(SOCKET listen_socket);   // accept() constructor
    TinyConn(enum SOCK_TYPE, const char * IPaddr, int port, unsigned int flags = 0);     // Client constructor.
    int getStatus(void) {return status;};
    int WriteLine(const char *s);
	int WriteString(const char *s);
    int Write(void *buff, int len);
    int Read(void *buff, int len);
    int ReadLine(char * buff, int bufLen);
    void Close(void);


    int getConnectionIpString(char *buf, int maxLength);
    const char * getPeerInfo(void);
    SOCKET getSocket(void);
    
private:
    TinyConn();
    int status;
    char *peerInfo;

    struct sockaddr_in from;
    int fromlen;
    struct sockaddr_in server; // used in client mode
    SOCKET connSock;
    unsigned int _flags;
};


#endif // INCLUDE_TINY_CONN_H


