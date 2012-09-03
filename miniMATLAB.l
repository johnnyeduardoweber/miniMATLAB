
ALPHA [A-Za-z]
DIGIT [0-9]

%%

rand					return PROCRAND;
print					return PROCPRINT;
{ALPHA}({ALPHA}|{DIGIT})*		return ID;
[0-9]+	 				{yylval=atoi(yytext); return INTEGER;}
[0-9]*"."[0-9]+				{yylval=atof(yytext); return DOUBLE;}
"./"					return OPARRAYRDIV;
".\\"					return OPARRAYLDIV;
".*"					return OPARRAYMULT;
".^"					return OPARRAYPOW;
".\'"					return OPARRAYTPOSE;
[ \t]+		                  	/* ignore whitespace */;
\n                      		/* ignore newlines */;
.					return yytext[0];
%%
