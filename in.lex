%{
#pragma GCC diagnostic ignored "-Wformat"
int pos = 0, numStr = 1;
%}

%%


[0-9]+										{ printf("%s(%s,%d,%d,%d) ", "NUM", yytext, numStr, pos, pos + yyleng - 1); pos += yyleng;}			
"skip"|"write"|"read"|"if"|"then"|"else"|"do"|"while"		{ printf("%s(%s,%d,%d,%d) ", "KW", yytext, numStr, pos, pos + yyleng - 1); pos += yyleng;}		
:=											{ printf("%s(%d,%d,%d) ", "Assign", numStr, pos, pos + yyleng - 1); pos += yyleng;}			
[A-Za-z_][A-Za-z0-9_]* 						{ printf("%s(%s,%d,%d,%d) ", "VAR", yytext, numStr, pos, pos + yyleng - 1); pos += yyleng;}			
(\+)|(\-)|(\*)|(\/)|(\%)					{ printf("%s(%s,%d,%d,%d) ", "OP_ARIFMET", yytext, numStr, pos, pos + yyleng - 1); pos += yyleng;}
(&&)|(\|\|)									{ printf("%s(%s,%d,%d,%d) ", "OP_LOGIC", yytext, numStr, pos, pos + yyleng - 1); pos += yyleng;}
(==)|(!=)|(>)|(>=)|(<)|(<=)					{ printf("%s(%s,%d,%d,%d) ", "OP_COMP", yytext, numStr, pos, pos + yyleng - 1); pos += yyleng;}	
\(											{ printf("%s(%d,%d,%d) ", "OBRACKET", numStr, pos, pos + yyleng - 1); pos += yyleng;}			
\)											{ printf("%s(%d,%d,%d) ", "EBRACKET", numStr, pos, pos + yyleng - 1); pos += yyleng;}
\;											{ printf("%s(%d,%d,%d) ", "COLON", numStr, pos, pos + yyleng - 1); pos += yyleng;}		
\n 											{ numStr++; pos = 0;}				
[ |\f|\n|\r|\t|\v]							{};
.											{ printf("%s(%s,%d,%d,%d) ", "UNDEF", yytext, numStr, pos, pos + yyleng - 1); pos += yyleng;}
"**"										{ printf("%s(%d,%d,%d)\n", "POWER", numStr, pos, pos + yyleng - 1); pos += yyleng;}
"//".*\n									{printf("COMMENT(%d, %d, %d)\n" , numStr, pos, pos + yyleng - 1); numStr++; pos = 0;}
[(][*]((([^*])*([^)])*)|((([^*])*([^)])*[*][^)]+[)]([^*])*([^)])*))*)[*][)]     {
{
	int i;
	int begin_numStr=numStr;
	int begin_pos=pos;
	int end_pos;
	for(i=0; i<yyleng; i++)
	{
        end_pos=pos;
        pos=pos+1;
        if(yytext[i]=='\n')
        {
                pos=1;
                numStr=numStr+1;
        }
	}
printf("MCOMMENT(\"%s\", %d, %d, %d, %d); ", yytext, begin_numStr, numStr, begin_pos, end_pos);
}
}

%%

int main(int argc, char** argv)
{
	if (argc > 1)
	{
		if (!(yyin = fopen(argv[1], "r"))) 
		{
			printf("File not open: %s\n", argv[1] );
			yyterminate();
		}
	}
	else
	{
		printf("Missing file name\n");
		yyterminate();
	}
        yylex(); 
}
