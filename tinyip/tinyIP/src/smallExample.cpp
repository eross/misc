/***************************************************************************
**
** File:        smallExample.cpp
**
** Author:      David M Lowe
** Created:     10/09/2002
**
** Description: Example functions via a telnet Connection
**      
** Notes:
**
**    -- 
**
** (C) Copyright 2000-2001, Hewlett-Packard Company, all rights reserved.
**
***************************************************************************
*/
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <assert.h>

#include "tinyPortability.h"
#include "tinyTelnet.h"

#define MAX_DB_COMMAND_LEN 255
#define MAX_DB_RESULT_LEN (4096 * 10)
#define nib2char(x) ((x) < 10)?((x) + '0'):(((x)-10) + 'A')

#ifdef _FILEID_
#undef _FILEID_
#endif
#define _FILEID_ 793

//
// Private type and structure definitions
//
typedef int (*dbfn)(const char *cmd, char *result);
typedef unsigned (*spfn)(unsigned int p1,
                         unsigned int p2,
                         unsigned int p3,
                         unsigned int p4,
                         unsigned int p5,
                         unsigned int p6,
                         unsigned int p7,
                         unsigned int p8);

struct dbgFcn 
{
    struct dbgFcn *next;
    char *szCmd;
    dbfn fp;
    char *szDescription;
};

class debugHandler:public tinyCommandHandler
{
public:
    int command(const char *szData, class tinyTelnet *pServer);   
};

//
// Debug Function Prototypes
//
extern "C" {
int tdbgExit(const char *cmd, char *result);
int tdbgTestEcho(const char *cmd, char *result);
int tdbgHelp(const char *cmd, char *result);
}

//
// Private Storage
//

static class debugHandler * pCEDbg = NULL;


static struct dbgFcn 
dbgTable[] = 
{
    {NULL, "q",        NULL,                         "  Exit the tool"},    // Required First entry in table!
    {NULL, "e",        tdbgTestEcho,                 "  Echo command to response"},
    {NULL, "h",        tdbgHelp,                     "  This Screen\n"},
    {NULL, NULL, NULL, NULL}  // Required End of Table.
};


//
// Private functions to support the tiny debugger...
//

char *strtok_r(char *s, const char *delim, char **save_ptr)
{
	char *token;

	token = 0;					/* Initialize to no token. */

	if (s == 0) {				/* If not first time called... */
		s = *save_ptr;			/* restart from where we left off. */
	}
	
	if (s != 0) {				/* If not finished... */
		*save_ptr = 0;

		s += strspn(s, delim);	/* Skip past any leading delimiters. */
		if (*s != '\0') {		/* We have a token. */
			token = s;
			*save_ptr = strpbrk(token, delim); /* Find token's end. */
			if (*save_ptr != 0) {
				/* Terminate the token and make SAVE_PTR point past it.  */
				*(*save_ptr)++ = '\0';
			}
		}
	}

	return token;
}

#ifndef INTEGRITY

static unsigned int
text2uint32(const char *s)
{
    unsigned int result = 0;
    unsigned int tmp;

    //
    // Don't dereference a NULL
    //
    if (s == NULL)
        return(result);

    //
    // Strip any leading white space.
    //
    while (((*s == ' ') || (*s == '\t') || (*s == '\n')) && (*s != '\0')) 
        s++;

    //
    // Is it a hex or decimal number
    //
    if ((*s == '0') && (*(s+1) == 'x'))
    {
        //
        // Decode Hex Value
        //
        s+=2;
        while (isdigit(*s) || ((tolower(*s) >= 'a') && (tolower(*s) <= 'f')))
        {
            if ((tolower(*s) >= 'a') && (tolower(*s) <= 'f'))
            {
                tmp = (tolower(*s) - 'a') + 10;
            }
            else
            {
                tmp = (*s - '0');
            }
   
            result = (result * 16) + tmp;
            s++;
        }
    }
    else
    {
        //
        // Decode Decimal Value
        //
        while (isdigit(*s))
        {
            result = (result * 10) + (*s - '0');
            s++;
        }
    }

    return(result);

}

#define ABUFF_SIZE 33
#define HBUFF_SIZE 33*3
#define PBUFF_SIZE 256

static void
formatBinDump(void * baseaddr , int hextoo, unsigned int len, char *result)
{
    char * pBase =  (char *) baseaddr;
    char abuff[ABUFF_SIZE];
    char hbuff[HBUFF_SIZE];
    char pbuff[PBUFF_SIZE];

    unsigned int x;
    int ac=0;
    int hc=0;

    assert(baseaddr);
    assert(result);

    if (len > 256)
    {
        sprintf(result, "... formatBinDump, will allow a max dump of 256 bytes\n");
        return;
    }

    *result = '\0';
    *pbuff = '\0';

    for(x = 0; x < len; x++)
    {
        if (hextoo)
        {
            if(0 == (x%16))
            {
                assert(hc < HBUFF_SIZE);
                assert(ac < ABUFF_SIZE);
                hbuff[hc++] = '\0';
                abuff[ac++] = '\0';

                if (x)
                    sprintf(pbuff,"0x%08x: %s   %s\n",(pBase+x-16),hbuff,abuff);

                strcat(result, pbuff);

                hc = ac = 0;
            }
        }
        else
        {
            if(0 == (x%32))
            {
                assert(hc < HBUFF_SIZE);
                assert(ac < ABUFF_SIZE);
                hbuff[hc++] = '\0';
                abuff[ac++] = '\0';

                if (x)
                {
                    sprintf(pbuff,"0x%08x: %s\n",(pBase+x-32), abuff);
                    assert(strlen(pbuff) < PBUFF_SIZE);
                }
                strcat(result, pbuff);

                hc = ac = 0;
            }
        }

        assert(hc < HBUFF_SIZE-1);
        hbuff[hc++] = nib2char((pBase[x] >> 4) & 0x0f);
        hbuff[hc++] = nib2char(pBase[x] & 0x0f);

        if((pBase[x]=='\n') || (pBase[x]=='\t') || (pBase[x]=='\r') || (pBase[x] & 128))
        {
            assert(ac < ABUFF_SIZE);
            abuff[ac++] = '.';
        }
        else if(isprint(pBase[x]))
        {
            assert(ac < ABUFF_SIZE);
            abuff[ac++] = pBase[x];
        }
        else
        {
            assert(ac < ABUFF_SIZE);
            abuff[ac++] = '.';
        }
    }
    if (hc)
    {
        int off;
        //
        // There are undumped hes and possibly ascii characters.
        //
        if (hextoo)
        {
            char padbuff[32];

            padbuff[0] = '\0';

            assert(hc < HBUFF_SIZE);
            assert(ac < ABUFF_SIZE);
            hbuff[hc++] = '\0';
            abuff[ac++] = '\0';

            for (int i=0; i<=(32 - hc); i++)
            {
                strcat(padbuff," ");
            }


            off = ((int) pBase+x) - hc/2;
            sprintf(pbuff,"0x%08x: %s%s   %s\n",off,hbuff,padbuff,abuff);
            assert(strlen(pbuff) < PBUFF_SIZE);
            strcat(result, pbuff);
        }
        else
        {
            assert(hc < HBUFF_SIZE);
            assert(ac < ABUFF_SIZE);
            hbuff[hc++] = '\0';
            abuff[ac++] = '\0';

            off = ((int) pBase+x) - hc/2;
            sprintf(pbuff,"0x%08x: %s\n",off, abuff);
            assert(strlen(pbuff) < PBUFF_SIZE);
            strcat(result, pbuff);

            hc = ac = 0;
        }
    }

    return;
}

#endif
//
// Debug Function Implementations.
//

int 
tdbgTestEcho(const char *cmd, char *result)
{
    assert(cmd);
    assert(result);
    strcpy(result, cmd);
    return(0);
}

int 
tdbgHelp(const char *szCmd, char *result)
{
    int i;
    char buff[256];

    assert(result);
    *result = '\0';

    for (i=0; dbgTable[i].szCmd != NULL; i++)
    {
        sprintf(buff, "%s  %s\n", dbgTable[i].szCmd, dbgTable[i].szDescription);
        assert(strlen(buff) < 256);
        strcat(result, buff);
    }
    return(0);
}

#ifndef INTEGRITY
static class tinyTelnet *mwpServer = NULL;
#endif


int 
debugHandler::command(const char *szData, class tinyTelnet *pServer)
{
    char buff[MAX_DB_COMMAND_LEN+1];
    int i;
    char * cdata = NULL;
    char ** ppLast;
    static char *sb = NULL;
    char *cmd;
    int cmdResult;
    int result = 0;

    //
    // Initalize the response buffer
    //
    if (sb == NULL)
    {
        sb = new char[MAX_DB_RESULT_LEN];
        assert(sb);
    }
    *sb = '\0';

    if (szData && (strlen(szData) < MAX_DB_COMMAND_LEN))
    {
        if (*szData == '\0')
            return(1);
            
        strcpy(buff,szData);

        //
        // Break off the command
        //
        
        ppLast = &cdata;
        cmd = strtok_r(buff, " \t\n", ppLast);

        for (char *cp = cmd; *cp != '\0'; cp++)
            *cp = tolower(*cp);

        for (i=0; dbgTable[i].szCmd != NULL; i++)
        {
            if (strcmp(cmd, dbgTable[i].szCmd) == 0)
            {
                //
                // Check for 'q' (exit) command.
                if (i == 0)
                {
#ifndef INTEGRITY
                    //
                    // disconnect the mechware back channel
                    // 
                    mwpServer = NULL;

#endif
                    //
                    // clean up the local bufers
                    //
                    delete [] sb; sb = NULL;
                    result = 0;
                    break;
                }
                
                //
                // Found the function, send it the rest of the string.
                //
                // If the command has a failure it will return that 
                // failure as a number, zero indicates success.
                //

                result = 1;
                if (dbgTable[i].fp)
                {             
                    sb[0]='\0';

#ifndef INTEGRITY
                    if (strcmp(cmd,"mm") == 0)
                    {
                        // Special case for mechware command.
                        mwpServer = pServer;
                    }
#endif 

                    cmdResult = (dbgTable[i].fp)(cdata, sb);

                    //
                    // Check for an unruly response
                    //
                    assert(strlen(sb) <MAX_DB_RESULT_LEN); 

                    if (cmdResult != 0)
                    {
                        sprintf(sb,"dbgError: Command [%s] returned a failure code of %0d\n",cmd, cmdResult);
                    }
                    break;
                }
                else
                {
                    sprintf(sb,"dbgError: Internal function not defined for [%s]\n",cmd);
                }
            }
        }

        if (dbgTable[i].szCmd == NULL)
        {
            //
            // We rolled off theend of the command table
            //
            sprintf(sb,"dbgError: Command [%s] unknown\n",cmd);
            result = 1;
            
        }
    }
    else
    {
        sprintf(sb,"dbgError: Command length exceeded max (%0d)\n",MAX_DB_COMMAND_LEN);
        result = 1;
    }

    //
    // For command response, we must route the command to the calling pServer or to 
    // the mechware backchannel if callwd with a null pServer.
    //
    //
    if (sb && *sb != '\0')
    {
        if (pServer)
        {
            pServer->responseData(sb);
            return(result);
        }
    }

    return(result);
}

/***************************************************************************
**
** Function:    uwDebugServer
**
** Description: Will start the telnet service to control simple debug functions
**
** Owner:       David M. Lowe
** Created:     3/20/02
**              
** Assumptions:
**
**    --    
**
***************************************************************************
*/
extern "C" int smallexample_main(int argc, char *argv[])
{
    int port;
    class tinyTelnet *tt;

    if (argc <= 1)
        port = 2215;
    else
        port = atoi(argv[1]);

    printf("smallExample Setting up for port %0d\n",port);

    if (pCEDbg == NULL)
    {
        pCEDbg = new debugHandler;
        assert(pCEDbg);
    }

    tt = new tinyTelnet(port, pCEDbg);
    if ((tt != NULL) && (tt->getStatus() != tinyTelnet::TT_ERROR))
    {
        tt->setWelcomeMessage("Welcome to the tinyIP Example..\nEnter 'h' for help or 'q' to exit.\n\n");
        tt->setPrompt("tinyIP > ");
        tt->setOption(tinyTelnet::TT_CRLF);
        
        printf("uwDebugServer: Running Debug Server on port %0d\n",port);

        tt->mainLoop();

    }
    else
    {
        printf("Warning: Example telnet session initalization failure\n");
    }
    exit(0);
}


