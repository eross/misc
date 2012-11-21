/***************************************************************************
**
** File:        tinyTelnet.h
**
** Author:      David M Lowe
** Created:     11/26/2001
**
** Description: This class is designed to encapsulate a terminal session
**              for typical telnet use.  The server will manage connections
**              and IO.  The user must provide a reference to the command 
**              handler.
**
**              As commands are discovered at the server the command handler 
**              will be called to process them.
**      
** (C) Copyright 2000-2001, Hewlett-Packard Company, all rights reserved.
**
***************************************************************************
*/
#ifndef TINY_TELNET_H_INCLUDED
#define TINY_TELNET_H_INCLUDED

#include "tinyServer.h"

#define TINY_ERROR (-1)
#define TINY_MAX_MESSAGE_LEN (4096)
#define TELNET_INTERNAL_COMMAND_MAX_ARGS 20

class tinyTelnet; 
class tinyCommandHandler; 

class DllExport tinyTelnet
{
public:
    enum TT_Status 
    {
        TT_READY, // means Disconnected..
        TT_ERROR,
        TT_CONNECTED,
        TT_DELETED
    };

    enum TT_Options 
    {
        TT_CRLF = 0x00000001
    };

    tinyTelnet(int portNumber, class tinyCommandHandler *pResponder);
    ~tinyTelnet();
    enum TT_Status getStatus(void);
    int setOption(enum TT_Options x);
    int setWelcomeMessage(const char *szWelcomeMsg);
    int setPrompt(const char *szPrompt);
    int setExitMessage(const char *szExitMsg);
    int responseData(const char *szData);
    void mainLoop(void);
    TinyServer *ts;
    TinyConn *cn;

private:
    tinyTelnet();
    void updateTTStatus(enum TT_Status, const char *reason);
    int internalTelnetCommand(const char *line);
    void internalSetCommand(char * cmdIndex[]);
    int iCommandCount;
    class tinyCommandHandler *pProcess;
    char *inputBuffer;
    char *welcomeMsg;
    char *prompt;
    char *exitMsg;
    enum TT_Status tt_status;
    unsigned int tt_options;
    
};



//
// This class must be implemented by the user of the 
// telnet server.  The command handler will be called whenever 
// the server determines that a command has been requested.
//
class tinyCommandHandler
{
public:
    //
    // tinyCommandHandler will go process whatever command the server was
    // designed to do.  The return value is ueed to determine if the server 
    // should disconnect the session or not.  If tinyCommandHandler
    // should normally return a non-zero value.  If zero is returned
    // the telnet server will initialte a server-side disconnect.
    //
    virtual int command(const char *szCommand, class tinyTelnet *pServer) = 0;

    //
    // commStatusChange will be called whenever a change has been 
    // detected on the telnet server communications.
    //
    virtual int commStatusChange(enum tinyTelnet::TT_Status ttStatus, const char *reason)
	{ return 0; };
};


#endif // TINY_TELNET_H_INCLUDED


