%{
unsigned charCount = 0, wordCount = 0, lineCount = 0;
%}

word [^ \t\n]+
eol  \n
%%
{word}	{ wordCount++; charCount += yyleng; }
{eol}	{ charCount++; lineCount++; }
.	charCount++;
%%
main(int argc,char* argv[]){
	FILE * file;
	file=fopen(argv[1],"r");
	if(!file){
		fprintf(stderr,"could not open file %s\n",argv[1]);
		return 0;
	}
	yyin=file;
	yylex();
	printf("linecount:%d,wordcount:%d,charcount:%d\n",lineCount,wordCount,charCount);
	return 0;
}
