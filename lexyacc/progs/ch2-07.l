%s MAGIC

%%
<MAGIC>[a-z]+	{ BEGIN 0; printf("Magic:"); }
magic		BEGIN MAGIC;
[a-z]+	ECHO;
%%

main()
{
	yylex();
}
