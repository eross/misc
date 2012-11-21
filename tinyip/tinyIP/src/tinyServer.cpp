///
/// @file tinyServer.cpp
/// 
/// @brief TCP server abstrabction implementation
///    
/// A wrapper for a TCP Stream passive server listen socket. Using this class 
/// along with the tinyConn instances that it hands out may be the basis 
/// for many simple IP services.
//


/*********************************************************************\
**
** File: tinyServer.cpp
**
** Description: Contains implementation for the classes:
**
**      TinyServer:     A wrapper for a TCP Stream passive server
**                      listen socket. Includes a TinyConnection factory
**
** Author:      David M. Lowe
**
**    * (C) Copyright 2001, Hewlett-Packard Company, all rights reserved.
**
\*********************************************************************/

#include "tinyServer.h"
#ifdef _FILEID_
#undef _FILEID_
#endif
#define _FILEID_ 729

/*********************************************************************\
**  Method: TinyServer::~TinyServer
**
**  Description: Destructor
**
\*********************************************************************/
TinyServer::~TinyServer()
{
#ifdef INTEGRITY
    shutdown(listen_socket, 2 /* 2 = sends and receives disallowed */);
    close(listen_socket);
#else
    #if !defined(WIN32) 
        close(listen_socket);
    #else
        closesocket(listen_socket);  
    #endif
#endif
    status = TinyServer::DELETED;
}




/*********************************************************************\
**  Method: TinyServer::TinyServer
**
**  Description: Take a port number as a parm and attach a TCP passive
**               socket to it.  
**
**  Returns: 
**
**  Notes:
**  
**
\*********************************************************************/

TinyServer::TinyServer(unsigned short port, TinyConn::SOCK_TYPE type)
{
    int res;

    status = TinyServer::INIT;

    if ((type != TinyConn::STREAM) && (type != TinyConn::DGRAM))
    {
        tiny_message("TinyServer: invalid server type\n");
        status = TinyServer::FAILED;
        return;
    }

    _server_port = port;


#if defined(WIN32)

    WORD wVersionRequested = MAKEWORD( 2, 2 );
 
    WSADATA wsaData;
    if (WSAStartup(wVersionRequested,&wsaData) == SOCKET_ERROR) 
    {
        tiny_message("TinyServer: WSAStartup failed with error %d\n",WSAGetLastError());
        status = TinyServer::FAILED;
        return;
    }
#endif

    if (type == TinyConn::STREAM)
    {
        listen_socket = socket(AF_INET, SOCK_STREAM,0); // TCP socket
    }
    else
    {
        listen_socket = socket(AF_INET, SOCK_DGRAM,0); // TCP socket
    }
    
    if (listen_socket == INVALID_SOCKET)
    {
        tiny_message("TinyServer: socket() failed\n",errno);
        status = TinyServer::FAILED;
        return;
    }

    tiny_message("TinyServer: socket() passed, listen_socket = %0d\n",listen_socket);



    if (port == 0)
    {
        tiny_message("TinyServer: invalid port\n");
        status = TinyServer::FAILED;
        return;
    }
    else
    {
        tiny_message("TinyServer: port = %0d\n", _server_port);
    }

    // 
    // Set SO_REUSEADDR on the socket.  Otherwise, we won't be able to 
    // bind to it more than once.
    //
#ifdef LINUX
    int time = 1;
    res = setsockopt(listen_socket, SOL_SOCKET, SO_REUSEADDR, &time, sizeof(int*));
#else
	const char* yes = "1";
	res = setsockopt(listen_socket, SOL_SOCKET, SO_REUSEADDR, yes, sizeof(int));
#endif
    if (res < 0) 
    {
        tiny_message("TinyServer:   setsockopt failed.\n");
        status = TinyServer::FAILED;
        return;
    }
    else
    {
        tiny_message("TinyServer: setsockopt(SOL_SOCKET, SO_REUSEADDR) passed\n");
    }

    //
    // Initally bind to the first init address.
    //
    // local.sin_addr.s_addr = (!interface)?INADDR_ANY:inet_addr(interface); 
    // 
    // Port MUST be in Network Byte Order
    //
    local.sin_family = AF_INET;
    local.sin_addr.s_addr = htonl(INADDR_ANY); 
    local.sin_port = htons(_server_port);

    // tiny_printf("local.sin_port = 0x%08x\n",local.sin_port);

    //
    // bind() associates a local address and port combination with the
    // socket just created. This is most useful when the application is a 
    // server that has a well-known port that clients know about in advance.
    //

    if (bind(listen_socket,(struct sockaddr*)&local,sizeof(local) ) == SOCKET_ERROR) 
    {
        tiny_message("TinyServer: bind() failed");
        status = TinyServer::FAILED;
        return;
    }

    tiny_message("TinyServer: bind() passed\n");

    if (type == TinyConn::STREAM)
    {
        //
        // So far, everything we did was applicable to TCP as well as UDP.
        // However, there are certain steps that do not work when the server is
        // using UDP.
        //
        int retVal = listen(listen_socket,5);

        if (retVal != 0) 
        {
            tiny_message("TinyServer: listen() failed\n");
            status = TinyServer::FAILED;
            return;
        }

        tiny_message("TinyServer: 'Listening' on port %d, protocol %s\n",port,"TCP");
    }

    status = TinyServer::IDLE;
    tiny_message("TinyServer: Status idle and ready\n");

    return;
}


const char * 
TinyServer::TextState(void)
{
    switch (status)
    {
        case TinyServer::READY:     return "READY";
        case TinyServer::BUSY:      return "BUSY";
        case TinyServer::FAILED:    return "FAILED";
        case TinyServer::INIT:      return "INIT";
        case TinyServer::IDLE:      return "IDLE";
        case TinyServer::DELETED:   return "DELETED";
        default:                    return "UNKNOWN";
    }
}


//
// WaitForNewMessage()
//
// If the Server was setup as a datagram server, this call will 
// wait 'timoutSeconds' for a packet to arrive.
// 
// If there is an error or a timeout occures NULL will be returned.
// 
// If NULL is returned and status is ready, The failure was due to a timeout.
//
class TinyDgram * 
TinyServer::WaitForNewMessage(int timeoutSeconds)
{
    int result;
    struct sockaddr_in addr;
    struct sockaddr *saddr;
    TinyDgram * x = NULL;
    int addrSize = sizeof(addr);

    memset( &addr, 0, sizeof(addr) );
     saddr = (struct sockaddr *) &addr;
    //
    // for now we will Not allow a timeout value
    //
    if (timeoutSeconds != 0)
        return(NULL);

    char * buff = new char [4096];
    check(buff);

    // tiny_printf("TinyServer::WaitForNewMessage() calling recvfrom()\n");

    result = recvfrom( listen_socket, buff, 4096, 0, saddr, (socklen_t*) &addrSize); 

    // tiny_printf("TinyServer::WaitForNewMessage() recvfrom() returned %0d\n",result);

    if (result > 0)
    {
        unsigned int add = addr.sin_addr.s_addr;
        x = new TinyDgram( (unsigned char *)buff, 
                           (unsigned int) result, 
                           (unsigned int) ntohl(add), 
                           (unsigned short) htons(addr.sin_port));
    }
    else
    {
        tiny_printf("TinyServer: recvfrom() failed. result=%0d, errno=%0d\n", result, errno);
    }

    delete [] buff;

    return(x);
}

//
// WaitForNewConnection()
//
// This function will sit on the listen socket until an inbound
// connection is detected.  Once detected it will accept the socket and 
// create a connection instance to hold it.
//
class TinyConn * 
TinyServer::WaitForNewConnection(int timeoutSeconds)
{
    int numfds;
    class TinyConn *tConn;
    int optval;
    struct linger      lg;

    fd_set rdset,wrset,exset;

    FD_ZERO(&wrset);
    FD_ZERO(&rdset);
    FD_ZERO(&exset);

    FD_SET(listen_socket,&rdset);

    if (timeoutSeconds != TS_WAIT_FOREVER)
    {
        struct timeval timeout;

        timeout.tv_sec = timeoutSeconds;
        timeout.tv_usec = 0;

        numfds = select (listen_socket+1,&rdset,&wrset,&exset, &timeout);
    }
    else
    {
        numfds = select (listen_socket+1,&rdset,&wrset,&exset, NULL);
    }

    
    if (numfds == SOCKET_ERROR)
    {
        tiny_message("TinyServer: select() returned error\n");
        return(NULL);
    }

    tConn = new TinyConn(listen_socket);

    if (tConn == NULL)
    {
        tiny_message("TinyServer: new socket accept failed\n");
    }else{
    
         //increase teh reception buffer
        //The value (1458*16) is the closest value modulo 1458 ( elementary packet for the TCP ) and close to the max defined in TCP stack for Integrity*/

        optval=(1458*16);
        setsockopt(tConn->getSocket(),SOL_SOCKET,SO_RCVBUF,(char *)&optval,sizeof(optval));
    
    
        optval = 1;
        setsockopt (tConn->getSocket(), IPPROTO_TCP, TCP_NODELAY, (char *)&optval, sizeof(optval));
  

        setsockopt (tConn->getSocket(), SOL_SOCKET, SO_REUSEADDR, (char *)&optval, sizeof(optval));
    
        lg.l_onoff = 1;
        lg.l_linger = 1;
        setsockopt (tConn->getSocket(), SOL_SOCKET, SO_LINGER, (char *)&lg, sizeof(lg));
    
    
    }
    return(tConn);
}
