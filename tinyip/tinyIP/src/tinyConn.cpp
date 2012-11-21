/*********************************************************************\
**
** File: tinyConn.cpp
**
** Description: Contains implementation for the classes:
**
**      TinyConn:       A wrapper for connections that attach to 
**                      the TinyServer
**
** Author:      David M. Lowe
**
**    * (C) Copyright 2001, Hewlett-Packard Company, all rights reserved.
**
\*********************************************************************/

//#include <draco_debug.h>

#ifdef SYS_OZ
// per oz include rules this has to be the first include file!
#include <SysFirstInc.h> 
#include <draco_utils.h>
#endif


#include <tinyConn.h>
#ifdef LINUX
#include <draco_utils.h>
#include <draco_debug.h>
#endif
#ifdef _FILEID_
#undef _FILEID_
#endif
#define _FILEID_ 726


#ifdef WIN32
int firstWinsockCall = 1;
#endif

#ifdef INTEGRITY
extern void updateIpAddrList(unsigned int ipAddress);
extern boolean_t isAddressValid(const char *IpAddress);
#endif /* INTEGRITY */

//static function used to initialize the neccessary objects to create TinyConn and TinyDgram
//This function is called by the InitAllModules() function.
//parameter: mode is for RFU
int TinyConn::InitTinyConn(unsigned long mode)
{

    /*create the mutex semaphore */

    // TinyDgram::semSendTo = RedOSSemBinaryCreate();
    // check(TinyDgram::semSendTo != NULL);
    
    return 0;
}

int TinyConn::Pulse(void)
{

    draco_message("--------------\n");
    draco_message("TinyConn Pulse:\n");
#ifdef INTEGRITY
    draco_message("    Number of Tiny UDP Packets Requested = %d\n", TinyDgram::udpPacketsRequested);
    draco_message("    Number of Tiny UDP Packets Sent = %d\n", TinyDgram::udpPacketsSent);
    draco_message("    Number of Tiny UDP Packets Currently Enqued = %d\n", TinyDgram::udpPacketsEnqueued);
    draco_message("    Number of Tiny UDP Packet Queue Highwater = %d\n", TinyDgram::udpQueueHighwater);
    draco_message("    Number of Tiny UDP Packet Queue Overruns = %d\n", TinyDgram::udpQueueOverruns);
    draco_message("    Number of Tiny UDP sendto hangs detected = %d\n", TinyDgram::udpHangsDetected);
    draco_message("    Number of Tiny UDP Errors = %d\n", TinyDgram::udpErrors);
#endif

#if 0
     draco_message("\tTinyDgram::SendTo() - lockSendTo=%d - cntSendTo=%d - the latest task: %s \n",TinyDgram::lockSendTo,TinyDgram::cntSendTo,TinyDgram::lastTaskSendTo);
     draco_message("\tsocket=%d - ip=%s - port=%d - dataLen=%d - socketError=%d - semExpiredSendTo=%d -  semExpiredSendTo1=%d  delaySendTo=%d\n",
	    TinyDgram::s_save, inet_ntoa(TinyDgram::destAddress_save.sin_addr),ntohs(TinyDgram::destAddress_save.sin_port),
	    TinyDgram::dataLen_save,TinyDgram::socketError,TinyDgram::semExpiredSendTo,TinyDgram::semExpiredSendTo1,TinyDgram::delaySendTo);
    
#endif
  

    return 0;
}

//
// TinyCon destructor for a connected socket.
//
TinyConn::~TinyConn()
{
#if defined(__INTEGRITY)
    shutdown(connSock,2);
    close(connSock);
#else
    #if !defined(MSVC)
        close(connSock);
    #else
        closesocket(connSock);  
    #endif
#endif
#ifdef SYS_OZ
    DeallocCharArray(peerInfo);
#else
    delete [] peerInfo;
#endif
    peerInfo = (char *) NULL;
    status = TinyConn::DELETED;
}

//
// TinyCon constructor for a connected socket.
//
TinyConn::TinyConn(SOCKET listen_socket)
{
    status = TinyConn::INIT;
    peerInfo = (char *) NULL;

#if defined(MSVC)

    if (firstWinsockCall)
    {
	    WORD wVersionRequested = MAKEWORD( 2, 2 );
 
        WSADATA wsaData;
        if (WSAStartup(wVersionRequested,&wsaData) == SOCKET_ERROR) 
        {
            tiny_message("TinyConn: WSAStartup failed with error %d\n",WSAGetLastError());
            status = TinyConn::FAILED;
            return;
        }
        firstWinsockCall = 0;
    }
#endif

    fromlen = sizeof(from);
    connSock = accept(listen_socket,(struct sockaddr*)&from, (socklen_t*) &fromlen);

    if (connSock == INVALID_SOCKET) {

#ifdef _DEBUG
        //??fprintf(stderr,"TinyConn: accept() error %d\n",WSAGetLastError());
        perror("TinyConn: accept() error");
#endif
        status = TinyConn::FAILED;
        return;
    }

    //
    // gather the peer info data..
    //
#ifdef SYS_OZ
    peerInfo = AllocCharArray(64);
#else
    peerInfo = new char[64];
#endif

    sprintf(peerInfo,"IP=%s, Port=%0d", inet_ntoa(from.sin_addr),  htons(from.sin_port));

#if defined(_DEBUG) && defined(TINYCONN_LOG)
    printf("TinyConn: accepted connection from %s, port %d\n", inet_ntoa(from.sin_addr),  htons(from.sin_port)) ;
#endif

#ifdef INTEGRITY
    updateIpAddrList(from.sin_addr.s_addr); /* Update the IP address list */
#endif /* INTEGRITY */
    
    status = TinyConn::READY;
}

//
// TinyCon constructor for a client socket.
//
TinyConn::TinyConn(enum SOCK_TYPE type, const char *address, int port, unsigned int flags)
{
    int result;
    char ip[64];

    _flags = flags;
    status = TinyConn::INIT;
    peerInfo = (char *) NULL;

    tiny_message("TinyConn : Engine is trying a TCP connect to \
                        IP address = %s Port = %d", address, port);

    if ((address == NULL) || (*address == '\0'))
    {
        tiny_message("TinyConn: NULL or empty address provided\n");
        status = TinyConn::FAILED;
        return;
    }


#if defined(MSVC)

    if (firstWinsockCall)
    {
	    WORD wVersionRequested = MAKEWORD( 2, 2 );
 
        WSADATA wsaData;
        if (WSAStartup(wVersionRequested,&wsaData) == SOCKET_ERROR) 
        {
            tiny_message("TinyConn: WSAStartup failed with error %d\n",WSAGetLastError());
            status = TinyConn::FAILED;
            return;
        }
        firstWinsockCall = 0;
    }
#endif

    //
    // Initalize and setup the address block.
    //
#if defined(_DEBUG) && defined(TINYCONN_LOG)
    printf("TinyConn: Attempting a connection to %s:%0d\n", address,port);
#endif

    memset(&server, 0, sizeof(struct sockaddr_in));
    server.sin_family = AF_INET;

    // 
    // Get IP address either from DNS or from an explicit IP number.
    //
    if (*address > '9')
    {
        // if the first character of the ip is not a digit, We're going to assume 
        // that the user has provided a dns name in place of an IP port number.
        struct hostent * he = gethostbyname (address);
        if (he == NULL)
        {
            tiny_message("TinyConn: Could not resolve hostent for %s\n",address);
            status = TinyConn::FAILED;
            return;
        }
        if (he->h_addrtype != AF_INET)
        {
            tiny_message("TinyConn: Invalid network family\n",address);
            status = TinyConn::FAILED;
            return;
        }
        
        //
        // Set the connection address
        //
        struct in_addr temp;
        memcpy( (void *) &temp, (void *) he->h_addr_list[0], sizeof(temp));
        strcpy(ip, inet_ntoa(temp));
        server.sin_addr.s_addr = inet_addr(ip);
        
    }
    else
    {
        //
        // address is supplied as a 000.000.000.000 type address.
        //
        server.sin_addr.s_addr = inet_addr(address);
        strcpy(ip, address);
    }

    //
    // initalize the socket port number 
    // Port MUST be in Network Byte Order
    //
    server.sin_port = htons(port);



    //
    // Create the socket..
    //
    switch (type)
    {
        case TinyConn::STREAM:
            connSock = socket(AF_INET, SOCK_STREAM,0); // TCP socket
            break;
        case TinyConn::DGRAM:
            assert(0); // Not tested yet.
            connSock = socket(AF_INET, SOCK_DGRAM,0); // UDP socket
            break;
    }

#ifdef INTEGRITY
    if ((_flags & SO_NOVERIFYADDR) == 0)
    {
        // 
        // Verify the reachability of the destination before 
        // attempting to connect, This is used to make sure that 
        // we don't spend a bunch of time retrying an invalid address
        //
        if(isAddressValid(address) == FALSE) 
            return;
    }
#endif /* INTEGRITY */
    
    //
    // Connect to the requested service.
    //
    result = connect(connSock, (struct sockaddr *)&server, sizeof(struct sockaddr_in));


    if (result)
    {
        // a connection error occcured.
        status = TinyConn::FAILED;
#if defined(_DEBUG) && defined(TINYCONN_LOG)
        printf("TinyConn: connection attempt failed to %s:%0d\n", ip,port);
        switch (errno)
        {
            case ECONNREFUSED:
                printf("TinyConn: ECONNREFUSED: No one listening on the remote address.\n");
                break;

            case ETIMEDOUT:
                printf("TinyConn: ETIMEDOUT: Timeout while attempting connection.\n");
                break;

            default:
                printf("TinyConn: Other Error, errno = %0d\n",errno);
                break;
        }
#endif
    }
    else
    {
        status = TinyConn::READY;

#ifdef INTEGRITY
	updateIpAddrList(inet_addr(address)); /* Update the IP address list */
#endif
	
#if defined(_DEBUG) && defined(TINYCONN_LOG)
        printf("TinyConn: connection created to %s:%0d\n", ip,port);
#endif
    }
    
}

//int getConnectionIpString(char *buf, int maxLength);
//const char * getPeerInfo(void);

int
TinyConn::getConnectionIpString(char *buf, int maxLength)
{
    if (peerInfo)
    {
        char *walker = peerInfo;
        int i = 0;
        // skip "IP="
        walker += 3;
        while((*(walker) != ',') && (i < maxLength))
        {
            buf[i] = *walker;
            i++;
            walker++;
        }
        if (i<maxLength)
        {
            // Success
            buf[i] = '\0';
            return(1);
        }
    }
    return(0);
}

const char *
TinyConn::getPeerInfo(void)
{
    return((const char *) peerInfo);
}

SOCKET TinyConn::getSocket(void)
{

    return(connSock);
}


//
// Close the connected socket and set it's state to CLOSED. This 
// will allow subsequent calls to other socket methods and allow
// a graceful return.
//
void
TinyConn::Close(void)
{
#ifdef INTEGRITY
    shutdown(connSock,2/* 2 = sends and receives disallowed */);
#else
    #if !defined(MSVC) 
        close(connSock);
    #else
        closesocket(connSock);  
    #endif
#endif
    status = TinyConn::CLOSED;
}


//
// Write string data to a connection socket.
//
int
TinyConn::WriteLine(const char *s)
{
    int bytes;
    int dlen;

    if (status != TinyConn::READY)
    {
#ifdef _DEBUG
        fprintf(stderr,"TinyConn: attempt to write on not-ready connection\n");
#endif
        return(-1);
    }


    dlen = strlen(s);
#ifdef SYS_OZ
    char * line = AllocCharArray(dlen + 10);
#else
    char * line = new char [dlen + 10];
#endif
    strcpy(line, s);
    strcat(line, "\r\n");//append newline
    bytes = send(connSock,line,dlen+2,0);
#ifdef SYS_OZ
    DeallocCharArray(line);
#else
    delete [] line;
#endif

    if (bytes == SOCKET_ERROR)
    {
#ifdef _DEBUG
        //??fprintf(stderr,"TinyConn: send() error %d\n",WSAGetLastError());
        perror("TinyServer: select() returned error");
#endif
        return(-1);
    }

    return(bytes);
}

//
// Write string data to a connection socket.
//
int
TinyConn::WriteString(const char *s)
{
    int bytes;
    int dlen;

    if (status != TinyConn::READY)
    {
#ifdef _DEBUG
        fprintf(stderr,"TinyConn: attempt to write on not-ready connection\n");
#endif
        return(-1);
    }


    dlen = strlen(s);

    bytes = send(connSock,(char *) s,dlen,0);

    if (bytes == SOCKET_ERROR)
    {
#ifdef _DEBUG
        //??fprintf(stderr,"TinyConn: send() error %d\n",WSAGetLastError());
        perror("TinyConn: send() error");
#endif
        return(-1);
    }

    return(bytes);
}


//
// Write arbitrary data to a connection socket.
//
int
TinyConn::Write(void *buf, int len)
{
    int bytes;

    if (status != TinyConn::READY)
    {
#ifdef _DEBUG
        fprintf(stderr,"TinyConn: attempt to write on not-ready connection\n");
#endif
        return(-1);
    }

    bytes = send(connSock,(char *)buf,len,0);

    if (bytes == SOCKET_ERROR)
    {
#ifdef _DEBUG
        //??fprintf(stderr,"TinyConn: send() error %d\n",WSAGetLastError());
        perror("TinyConn: send() error");
#endif
        return(-1);
    }
    else if (bytes != len)
    {
        draco_message("TinyConn:Warning !!! %d bytes sent %d bytes requested\n", bytes, len);
    }

    return(bytes);
}


//
// Read arbitrary data to a connection socket.
//
// Note that the EINTR signal is tossed out and ignored.
//
int
TinyConn::Read(void *buf, int len)
{
    int bytes = 0;

    if (status != TinyConn::READY)
    {
#ifdef _DEBUG
        fprintf(stderr,"TinyConn: attempt to read on not-ready connection\n");
#endif
        return(-1);
    }

    while(bytes < len)
    {
        int thisRead;

        thisRead = recv(connSock,(char *)buf,len-bytes,0);

#ifndef MSVC
        if ((thisRead == SOCKET_ERROR) && (errno != EINTR))
#else
        if ((thisRead == SOCKET_ERROR) && ( WSAGetLastError() != WSAEINTR ))
#endif
        {
#ifdef _DEBUG
            perror("TinyConn: read() error");
#endif
            return(-1);
        }
        else if (thisRead == 0)
        {
            // remote socket was closed.
            return(bytes);
        }
        else
        {
           // a partial read occured for whatever reason.
           // if we received an EINTR we want to just go read again.
            if (thisRead > 0)
            {
               bytes += thisRead;
               buf = (void *) (int ( (int)buf) + thisRead);
            }
        }
    }

    return(bytes);
}

//
// Read Text up to a CR but do not include it...
//
int
TinyConn::ReadLine(char * buff, int bufLen)
{
    int i=0;
    int bytes=0;

    if (status != TinyConn::READY)
    {
#ifdef _DEBUG
        fprintf(stderr,"TinyConn: attempt to read on not-ready connection\n");
#endif
        return(-1);
    }

    while (i < bufLen)
    {
        bytes = recv(connSock,(buff+i),1,0);
#if !defined(MSVC)
        if (bytes == SOCKET_ERROR && (errno != ECONNRESET)
                                  && (errno != ECONNABORTED))
#else
        if (bytes == SOCKET_ERROR && (WSAGetLastError() != WSAECONNRESET)
                                  && (WSAGetLastError() != WSAECONNABORTED))
#endif
        {
#ifdef _DEBUG
            //??fprintf(stderr,"TinyConn: read() error %d\n",WSAGetLastError());
            perror("TinyConn: read() error");
#endif
            status = TinyConn::FAILED;
            return(-1);
        }
#if !defined(MSVC)
        if (bytes == 0 || ((bytes == SOCKET_ERROR) && ((errno == ECONNRESET) || 
                                                       (errno == ECONNABORTED))))
#else
        if (bytes == 0 || ((bytes == SOCKET_ERROR) && ((WSAGetLastError() == WSAECONNRESET) || 
                                                       (WSAGetLastError() == WSAECONNABORTED))))
#endif
        {
            if (i>0)
            {
                //
                // There was some data then the other side closed the connection
                //
                status = TinyConn::CLOSED;
                *(buff+i) = '\0';
                return(i);
            }
            else
            {
                //
                // Other side has hung up..  and no data has been received..
                //
                status = TinyConn::CLOSED;
                *buff = '\0';
                return(0);
            }
        }
        if (*(buff+i) == 0x0d)
        {
            //
            // we've received a nasty newline...  Ignore it...
            //
            continue;
        }
        if (*(buff+i) == '\n')
        {
            *(buff+i) = '\0';
            return(i+1);
        }
        i++;
    }
    return(i);
}
