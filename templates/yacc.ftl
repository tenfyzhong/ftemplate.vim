/**
 * @file `!v expand("%:t")`
 * @brief  
 * @author {AUTHOR}
 * @email {EMAIL}
 * @created `!v strftime('%F %T')`
 */

/* statement */
%{
#include <stdio.h>
void yyerror(const char *s);
%}

/* declare tokens */

/* BNF */
%%
%%

/* c code */
int main(int argc, char *argv[])
{
    return 0;
}

void yyerror(const char *s)
{
    fprintf(stderr, "error: %s\n", s);
}
