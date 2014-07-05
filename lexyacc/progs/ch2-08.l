%{
	/* This example deliberately doesn't work! */
%}

%s MAGIC

%%
magic		BEGIN MAGIC;

<MAGIC>.+ 	{ BEGIN 0; printf("Magic:");ECHO;  }

[^ \n]+		ECHO;
%%

main()
{
	yylex();
}
