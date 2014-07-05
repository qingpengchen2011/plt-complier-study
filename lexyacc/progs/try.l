%{
%}

%x AA

%%

^AA ;
aa {;}
bb {printf("bbmatch\n");}

%%
main(){
	yylex();
}
