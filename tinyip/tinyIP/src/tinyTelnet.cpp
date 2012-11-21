/***************************************************************************
**
** File:        tinyTelnet.cpp
**
** Author:      David M Lowe
** Created:     11/26/2001
**
** Description: Provides a 'very' lightweight command line capability
**              to the user
**      
** Notes:
**
** (C) Copyright 2000-2001, Hewlett-Packard Company, all rights reserved.
**
***************************************************************************
*/

#include "tinyTelnet.h"
#ifdef _FILEID_
#undef _FILEID_
#endif
#define _FILEID_ 730

#define BUF_MAX_LEN     4096

void
tinyTelnet::updateTTStatus(enum TT_Status newStatus, const char *reason)
{
    tt_status = newStatus;
    if (pProcess)
        pProcess->commStatusChange(newStatus, reason);
}
    

/***************************************************************************
**
** Function:    tinyTelnet::tinyTelnet
**
** Description: This constructor will create the server listen socket.
**
** Parameters:  portNumber - The port at which the service will be established
**
**              pResponder - a reference to a class implemted by the caller 
**                           that will take non-internal commands re read in  
**                           off the socket.
**
** Created:     11/26/2001
**              
** Assumptions:
**
**    --    
**
***************************************************************************
*/
tinyTelnet::tinyTelnet(int portNumber, class tinyCommandHandler *pResponder)
{
    cn = NULL;
    welcomeMsg = NULL;
    exitMsg = NULL;
    pProcess = NULL;
    inputBuffer = NULL;
    prompt = NULL;
    tt_options = 0;
    tt_status = TT_ERROR;
    
    if (pResponder == NULL)
    {
        tiny_message("Required intyCommandHandler reference missing");
        return;
    }

    pProcess = pResponder;

    ts = new TinyServer(portNumber, TinyConn::STREAM);

    if (ts == NULL || ts->getStatus()!=TinyServer::IDLE)
    {
        tiny_message("Telnet connection creatation failed");
        updateTTStatus(TT_ERROR, "Telnet connection creatation failed");
        return;
    }

    inputBuffer = new char[BUF_MAX_LEN];
    assert(inputBuffer);

    setWelcomeMessage("tinyTelent: default Welcome\n");
    setExitMessage("tinyTelent: default Exit\n");

    updateTTStatus(TT_READY, NULL);
}

tinyTelnet::~tinyTelnet()
{
    delete ts;
    ts = NULL;
    cn=NULL;
    pProcess = NULL;
    tt_status = TT_DELETED;

    if (welcomeMsg)
    {
        delete [] welcomeMsg;
        welcomeMsg = NULL;
    }
    if (exitMsg)
    {
        delete [] exitMsg;
        exitMsg = NULL;
    }
    if (inputBuffer)
    {
        delete [] inputBuffer;
        inputBuffer = NULL;
    }
}

int
tinyTelnet::setWelcomeMessage(const char *msg)
{
    if (tt_status == TT_DELETED)
        return(-1);
        
    int len = strlen(msg);
    if (len > TINY_MAX_MESSAGE_LEN)
        return(TINY_ERROR);

    if (welcomeMsg != NULL)
    {
        delete [] welcomeMsg;
        welcomeMsg = NULL;
    }

    welcomeMsg = new char[len + 1];
    assert(welcomeMsg);

    strcpy(welcomeMsg, msg);

    return(len);
}

int
tinyTelnet::setExitMessage(const char *msg)
{
    if (tt_status == TT_DELETED)
        return(-1);
        
    int len = strlen(msg);
    if (len > TINY_MAX_MESSAGE_LEN)
        return(TINY_ERROR);

    if (exitMsg != NULL)
    {
        delete [] exitMsg;
        exitMsg = NULL;
    }

    exitMsg = new char[len + 1];
    assert(exitMsg);

    strcpy(exitMsg, msg);

    return(len);
}

int
tinyTelnet::setPrompt(const char *msg)
{
    if (tt_status == TT_DELETED)
        return(-1);
        
    int len = strlen(msg);
    if (len > TINY_MAX_MESSAGE_LEN)
        return(TINY_ERROR);

    if (prompt != NULL)
    {
        delete [] prompt;
        prompt= NULL;
    }

    prompt = new char[len + 1];
    assert(exitMsg);

    strcpy(prompt, msg);

    return(len);
}

/***************************************************************************
**
** Function:    tinyTelnet::internalSetCommand
**
** Description: process calls to the tinyTelnet set command.
**
** Owner:       David M. Lowe
** Created:     8/15/2002
**              
** Assumptions:
**
**    --    
**
***************************************************************************
*/
void
tinyTelnet::internalSetCommand(char * cmdIndex[])
{
    if (cmdIndex[1] == NULL)
    {
        char * rd = new char[256];

        //
        // Settings Query.
        //
        sprintf(rd, 
            "Current Settings\n"
            "-------------------------\n"
            "prompt == %s\n"
            "crlf   == %s\n",
            prompt,
            ((tt_options & TT_CRLF) ? "on" : "off")
            );

        responseData(rd);

        delete [] rd;

    }
    else
    {
        if ((strcmp(cmdIndex[1], "prompt") == 0) && (cmdIndex[2] != NULL))
        {
            setPrompt(cmdIndex[2]);
        }
        else if (((strcmp(cmdIndex[1], "crlf") == 0) && (cmdIndex[2] != NULL)))
        {
            if (strcmp(cmdIndex[2],"on") == 0)
                tt_options |= (unsigned int) TT_CRLF;
            else
                tt_options &= ~((unsigned int) TT_CRLF);
        }
    }
}

/***************************************************************************
**
** Function:    tinyTelnet::internalTelnetCommand
**
** Description: Command processors within command processors..
**              as a control facility to the telent environment this 
**              functions
**
** Owner:       David M. Lowe
** Created:     08/15/2002
**              
** Assumptions:
**
**    --    
**
***************************************************************************
*/
int 
tinyTelnet::internalTelnetCommand(const char *cmd)
{
    int i;
    int retval = 0;
    int argCount = 0;
    char * cmdIndex[TELNET_INTERNAL_COMMAND_MAX_ARGS];
    char ** ppLast;
    char * rest = NULL;
    char * temp = rest;
    char * buf = NULL;

    for (i=0;i< TELNET_INTERNAL_COMMAND_MAX_ARGS; i++)
    {
        cmdIndex[i] = NULL;
    }

    // Bust the command line into multiple strings.  Space seperated

    buf = new char[strlen(cmd)+1];
    assert(buf);

    strcpy(buf, cmd);

    ppLast = &rest;
#ifdef MSVC
    temp = strtok_s(buf, " ", ppLast);
#else
    temp = strtok_r(buf, " ", ppLast);
#endif //MSVC
    
    if (temp)
    {
        cmdIndex[argCount] = new char[strlen(temp)+1];
        assert(cmdIndex[argCount]);
        strcpy(cmdIndex[argCount], temp);
        argCount++;

        while (rest && (*rest != '\0'))
        {
            if (*rest == '\"')
            {
                // we have a quoted string, march a pointer down to the end 
                // or the end of the string.
                rest++;
                char * pWalker = rest;
                while ((*pWalker != '\"') && (*pWalker != '\0'))
                {
                    pWalker++;
                }
                // allocate a buffer to hold the proper length
                int len = pWalker - rest;
                if (len > 0)
                {
                    cmdIndex[argCount] = new char[len+1];
                    // then use a backwards copy to fill the buffer
                    cmdIndex[argCount][len--] = '\0';
                    while (len >= 0)
                    {
                        cmdIndex[argCount][len] = *(rest+len);
                        len--;
                    }
                    argCount++;
                    if (argCount >= TELNET_INTERNAL_COMMAND_MAX_ARGS) break;
                }
                // check to see we encountered the end of the string, else 
                // advance 'rest'
                if (*pWalker == '\"')  pWalker++;

                // if we're at teh end of the string, we are done
                if (*pWalker == '\0')
                {
                    rest = NULL;
                }
                else
                {
                    // skip past white ans seperator characters
                    while(strchr(" ,\t",*pWalker)) pWalker++;
                    rest = pWalker;
                }
            }
            else
            {
                // normal, non-quoted command
#ifdef MSVC
                temp = strtok_s(NULL, " ,", ppLast);
#else
                temp = strtok_r(NULL, " ,", ppLast);
#endif // MSVC
		if (temp == NULL) break;
                cmdIndex[argCount] = new char[strlen(temp)+1];
                assert(cmdIndex[argCount]);
                strcpy(cmdIndex[argCount], temp);
                argCount++;
                if (argCount >= TELNET_INTERNAL_COMMAND_MAX_ARGS) break;
            }
        }
    }
        
    for (i=0; i<argCount; i++)
    {
        tiny_message("internalCommand: arg[%0d] = %s\n",i,(int) cmdIndex[i]);
    }

    if (argCount && cmdIndex[0])
    {
        if (strcmp(cmdIndex[0], "set") == 0)
        {
            internalSetCommand(cmdIndex);
            retval = 1;
        }
    }

    for (i=0; i<argCount; i++)
    {
        if (cmdIndex[i])
        {
            delete [] cmdIndex[i];
            cmdIndex[i] = NULL;
        }
    }

    if (buf)
        delete [] buf;

    return(retval);
}

/***************************************************************************
**
** Function:    tinyTelnet::mainLoop
**
** Description: The main loop of the telnet server will wait for an inbound 
**              connection and then pass only full lines to the command 
**              processor desired.
**
** Owner:       David M. Lowe
** Created:     11/26/2001
**              
** Assumptions:
**
**    --    
**
***************************************************************************
*/
void
tinyTelnet::mainLoop(void)
{
    int iBytes;
    int runForever = 1;
	//tt_statusTest *pST;
    int result;

    if ((tt_status == TT_DELETED) || (tt_status == TT_ERROR))
        return;
        
    while(runForever)
    {
        assert(cn == NULL); // "There can be only one!" 

        // Changed Timeout value from 10sec to forever  - Devinder
        cn = ts->WaitForNewConnection(TS_WAIT_FOREVER);

        //
        // We have a detected a new connection check that the 
        // endpoint is healthy.
        //
        if (cn == NULL || cn->getStatus()!=TinyConn::READY)
        {
            tiny_message("tinyTelnet: connection creation failed!\n");
            if (cn)
            {
                delete cn;
                cn = NULL;
            }

            continue;
        }

        updateTTStatus(TT_CONNECTED, NULL);
        tiny_message("tinyTelnet: connection created\n");

		//Let a user know that the connection is estabilshed:
		responseData(welcomeMsg);
 
		iCommandCount = 0;
        //
        // As long as the connection is healthy read and process our '\n' 
        // terminated command.
        //
        while (cn->getStatus()==TinyConn::READY)
        {
            //
            // If a prompt is set, spit it out!
            //
            if (prompt && (*prompt != '\0'))
            {
                responseData(prompt);
            }

            //
            // We have a valid connection, let's read till the end of 
            // the next line from the client.
            //
            assert(cn);
			iBytes = cn->ReadLine(inputBuffer, BUF_MAX_LEN);

            if (iBytes > 0) 
            {
                //
                // Echo the line back to the sender
                //
                tiny_message("tinyTelnet: command received --> %s\n",inputBuffer);
				// responseData(inputBuffer);

                // Yow! we have received a line of data!  and there may be more available.
                // Check if it's an internal command "set prompt yow>" or the like and 
                // if not pass it to the command processor.

                if (!internalTelnetCommand(inputBuffer))
                {
                    assert(pProcess);
                    result = pProcess->command(inputBuffer, this);

                    if (result == 0)
                    {
                        responseData(exitMsg);
    #if defined(INTEGRITY) || defined(LINUX)
                        sleep(1);
    #endif
    #ifdef WIN32
					    Sleep(1000);
    #endif
                        break;
                    }
                }

				iCommandCount++;
            }
            else
            {
                // The server has died or the connectin has closed.
                break;
            }
        }

        //
        // the connection has ended so...
        //
        delete cn;
        cn = NULL;

        updateTTStatus(TT_READY, "Connection closed\n");
        tiny_message("tinyTelnet Connection closed\n");
    }
}

/***************************************************************************
**
** Function:    responseData
**
** Description: Callback Function for a telnet Response
**    
**
** Returns:     number of bytes written or -1 if the connection 
**              has died.
**
** Owner:       David M. Lowe
** Created:     3/20/02
**
***************************************************************************
*/
int 
tinyTelnet::responseData(const char *szData)
{
    char * buf;

    if ((tt_status == TT_DELETED) || (tt_status == TT_ERROR))
        return(-1);

    int bytes = 0;

    if (cn && (cn->getStatus() == TinyConn::READY))
    {
        if (tt_options & TT_CRLF)
        {
            buf = new char[2*strlen(szData) + 1];
            assert(("Insfficient system memory to allocate response buffer",buf));

            int j=0;
            for (int i = 0; *(szData+i) != '\0' ; i++)
            {
                if (*(szData+i) == 0x0a)
                {
                    buf[j++] = 0x0d;
                    buf[j++] = *(szData+i);
                }
                else
                {
                    buf[j++] = *(szData+i);
                }
            }
            buf[j++] = 0x00;

            assert(cn);
            bytes = cn->WriteString(buf);

            if (buf)
            {
                delete [] buf; 
                buf=NULL;
            }
        }
        else
        {
            assert(cn);
            bytes = cn->WriteString(szData);
        }
    }
    else
    {
        return(TINY_ERROR);
    }

    return(bytes);
}

enum tinyTelnet::TT_Status 
tinyTelnet::getStatus(void)
{
    return(tt_status);
}

int
tinyTelnet::setOption(enum TT_Options x)
{
    switch (x)
    {
        case TT_CRLF:
            tt_options |= (unsigned int) TT_CRLF;
            break;
    }
    
    return(1);
}
