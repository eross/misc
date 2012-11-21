///
/// @file tinyServer.h
/// 
/// @brief TCP server abstrabction definition
///    
/// A wrapper for a TCP Stream passive server listen socket. Using this class 
/// along with the tinyConn instances that it hands out may be the basis 
/// for many simple IP services.
///
/// Author:      David M. Lowe
///
/// (C) Copyright 2001, Hewlett-Packard Company, all rights reserved.
///


/*********************************************************************\
**
** File: tinyServer.h
**
** Description: Contains specification for the classes:
**
**      TinyServer:     A wrapper for a TCP Stream passive server
**                      listen socket. Includes a TinyConnection factory
**
** 
**
**    * (C) Copyright 2001, Hewlett-Packard Company, all rights reserved.
**
\*********************************************************************/


#ifndef INCLUDE_TINY_SERVER_H
#define INCLUDE_TINY_SERVER_H

#include "tinyConn.h"

#define TS_WAIT_FOREVER (-1)

///
/// Encapsulation of the passive socket.
///
/// The user will instanciate this class and set the well known port for 
/// the arbitrary service.  TinyConn connected socket instances are returned
/// via a blocking call when the listen socket accepts a connection.
///
class DllExport TinyServer
{
public:

    enum status 
    { 
        READY,  
        BUSY,   
        FAILED, 
        INIT,   
        IDLE,   
        DELETED
    };

    TinyServer(unsigned short port, TinyConn::SOCK_TYPE type);
    ~TinyServer();
    int getStatus(void) {return status;};
    const char * TextState(void);
    void HttpMain(void);
    class TinyConn * WaitForNewConnection(int timeoutSeconds);
    class TinyDgram * WaitForNewMessage(int timeoutSeconds);

private:
    TinyServer();
    int status;
    struct sockaddr_in local;
    SOCKET listen_socket;
    unsigned short _server_port;
};

#endif // INCLUDE_TINY_SERVER_H

