%{ 
   #include <stdio.h>
   #include <stdlib.h>
%}
%token NAME NUMBER
%%
statement:	NAME '=' expression
	|	expression		{ printf("= %d\n", $1); }
	;

expression:	expression '+' NUMBER	{ $$ = $1 + $3; }
	|	expression '-' NUMBER	{ $$ = $1 - $3; }
	|	NUMBER			{ $$ = $1; printf("NUMBER=%d\n",$1); }
	;
