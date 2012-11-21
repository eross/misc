#include "tinyPortability.h"

#ifdef STRTOK_R
char * 
strtok_r(char *s, const char *delim, char **save_ptr)
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
#endif
