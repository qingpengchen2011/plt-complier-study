%{
#include "ch3hdr2.h"
#include <string.h>
#include <math.h>
%}

%union {
	double dval;
	struct symtab *symp;
}
%token <symp> NAME
%token <dval> NUMBER
%left '-' '+'
%left '*' '/'
%nonassoc UMINUS

%type <symp> expression
%%
statement_list:	statement '\n'
	|	statement_list statement '\n'
	;

statement:	NAME '=' expression	{ $1->value = $3->value; }
	|	expression		{ printf("= %g\n", $1->value); }
	;

expression:	expression '+' expression { $$->value = $1->value + $3->value; }
	|	expression '-' expression { $$->value = $1->value - $3->value; }
	|	expression '*' expression { $$->value = $1->value * $3->value; }
	|	expression '/' expression
				{	if($3->value == 0.0)
						yyerror("divide by zero");
					else
						$$->value = $1->value / $3->value;
				}
	|	'-' expression %prec UMINUS	{ $$->value = -($2->value); }
	|	'(' expression ')'	{ $$->value = $2->value; }
	|	NUMBER                  { $$->value=$1; }
	|	NAME			{ $$->value = $1->value; }
	|	NAME '(' expression ')'	{
			if($1->funcptr)
				$$->value = ($1->funcptr)($3->value);
			else {
				printf("%s not a function\n", $1->name);
				$$->value = 0.0;
			}
		}
	;
%%
/* look up a symbol table entry, add if not present */
struct symtab *
symlook(s)
char *s;
{
	char *p;
	struct symtab *sp;
	
	for(sp = symtab; sp < &symtab[NSYMS]; sp++) {
		/* is it already here? */
		if(sp->name && !strcmp(sp->name, s))
			return sp;
		
		/* is it free */
		if(!sp->name) {
			sp->name = strdup(s);
			return sp;
		}
		/* otherwise continue to next */
	}
	yyerror("Too many symbols");
	exit(1);	/* cannot continue */
} /* symlook */

addfunc(name, func)
char *name;
double (*func)();
{
	struct symtab *sp = symlook(name);
	sp->funcptr = func;
}

main()
{
//	extern double sqrt(), exp(), log();

	addfunc("sqrt", sqrt);
	addfunc("exp", exp);
	addfunc("log", log);
	yyparse();
}
