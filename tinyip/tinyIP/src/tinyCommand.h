/*********************************************************************\
**
** File: tinyCommand.h
**
** Description: Contains specification for the classes:
**
**      HttpCommand:    A class to aid in the processing of simple 
**                      HTTP server side requests.
**
** Author:      David M. Lowe
**
**    * (C) Copyright 2001, Hewlett-Packard Company, all rights reserved.
**
\*********************************************************************/

#ifndef INCLUDE_TINY_COMMAND_H
#define INCLUDE_TINY_COMMAND_H

#include "tinyConn.h"

class HeaderLine
{
public:
    char *header;
    char *value;
    class HeaderLine * next;

    HeaderLine()
    {
        header = NULL;
        value = NULL;
        next = NULL;
    };

    ~HeaderLine()
    {
        delete header;
        delete value;
    }
};

class HttpCommand
{
public:
    HttpCommand(TinyConn * connection, const char *root);
    ~HttpCommand();
    void dumpHeader(void);
    void processCommand(void);
    void postAttackInfo(void);

private:
    enum { GET, HEAD, POST, UNKNOWN } thisCommand;
    char * initialLine;
    class HeaderLine * headerList;
    int status;
    class TinyConn * cmdCon;
    char *rootPath;

    HttpCommand();
    void processGet(void);
	void writeHeader(FILE *fp);
};

#endif // INCLUDE_TINY_COMMAND_H
