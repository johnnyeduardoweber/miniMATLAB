%token PROCRAND PROCPRINT
%token ID INTEGER DOUBLE
%token OPARRAYMULT OPARRAYPOW OPARRAYLDIV OPARRAYRDIV 
%right '='
%left '+' '-'
%left '*' '/' OPARRAYMULT OPARRAYLDIV OPARRAYRDIV
%left UMINUS 
%nonassoc '\''
%nonassoc OPARRAYTPOSE
%%

program:
	stmt_list
      ;
stmt_list: /* empty */
      | S ';' stmt_list
      ;
S:
	ID{push();} '='{push();} E{ codegen_assign();}
      | PROCPRINT '(' ID{push();} ')' {codegen_print();}
      ;
B:
	'[' row_specs ']' {codegen_buildmatrix();}
      ;
row_specs:
       INTEGER ':' INTEGER ':' INTEGER {codegen_buildrow($1,$3,$5);}
      | INTEGER ':' INTEGER ':' INTEGER ';' row_specs {codegen_buildrow($1,$3,$5);}
      | INTEGER ':' INTEGER {codegen_buildrow($1,1,$3);}
      | INTEGER ':' INTEGER ';' row_specs {codegen_buildrow($1,1,$3);}
      ;
N    :  PROCRAND '(' INTEGER ')' {codegen_rand($3,$3); }
      | PROCRAND '(' INTEGER ',' INTEGER ')' {codegen_rand($3,$5);}
      ;
E    :    E '+'{push();} T{codegen();}
      |    E '-'{push();} T{codegen();}
      |    T
      ;
T    :    T '*'{push();} X{codegen();}
      |   T OPARRAYMULT {push();} X{codegen();}
      |    T '/'{push();} X{codegen();}
      |   T OPARRAYLDIV {push();} X{codegen();}
      |   T OPARRAYRDIV {push();} X{codegen();}
      |    X
      ;
X    :    F '^'{push();} X{codegen();}
      |   F OPARRAYPOW{push();} X{codegen();}
      |   F
F    :    '(' E ')'
      |    '-'{push();} F{codegen_umin();} %prec UMINUS
      |    F'\''{ push(); codegen_trans();}
      |    F OPARRAYTPOSE{push(); codegen_trans();}
      |    ID{push();}
      |    INTEGER{push();}
      |    DOUBLE{push();}
      |    B
      |    N
      ;

%%

#include "lex.yy.c"
#include<ctype.h>
#include<string.h>
char st[100][100]; 
int top=0,ptr=0;
int tint=0; int tintar[200];

char vecbuildst[100][500];
int  vecbuildtop = 0;

extern int yylex();
extern int yyparse();
extern FILE *yyin;

FILE *output;

main(int argc, char* argv[])
{
    if( argc != 2) {
	printf("Usage: miniMATLAB [filename]\n");
	exit(1);
    }

    yyin = fopen(argv[1], "r");
    if( yyin == NULL ) {
	printf("miniMATLAB: no input files.\n");
	exit(2);
    }

    output = fopen(strcat(argv[1],".out"),"w");
    if( output == NULL ) {
	printf("miniMATLAB: can't open output file.\n");
	exit(3);
    }

    do {
    	yyparse();
    } while(!feof(yyin));

    fclose(yyin);
    fclose(output);
    exit(0);
}
void yyerror(char* s)
{
    printf("Error: %s\n",s);
}

push()
{
  strcpy(st[++top],yytext);
  ptr++;
}

codegen()
{
    fprintf(output,"_t%d = %s",tint,st[top-2]);
    printnum(2);
    fprintf(output," %s %s",st[top-1],st[top]);
    printnum(0);
    fprintf(output,"\n");
    top-=2;ptr-=2;
    strcpy(st[top],"_t");
    tintar[ptr]=tint;
    tint++;
}

codegen_umin()
{
    fprintf(output,"_t%d = %s * -1\n",tint,st[top]);
    printnum(0);
    top--;ptr--;
    strcpy(st[top],"_t");
    tintar[ptr]=tint;
    tint++;
}
codegen_trans()
{
    fprintf(output,"_t%d = %s\'\n",tint,st[top-1]);
    printnum(0);
    top--;ptr--;
    strcpy(st[top],"_t");
    tintar[ptr]=tint;
    tint++;
}
codegen_assign()
{
    fprintf(output,"symt %s\n", st[top-2]);
    fprintf(output,"%s = ",st[top-2]);
    printnum(2);
    fprintf(output,"%s",st[top]);
    printnum(0);
    fprintf(output,"\n");
    top-=2;ptr-=2;
}
codegen_buildmatrix()
{
    char build_instruction[100];
    strcpy(build_instruction,"[");
    while(vecbuildtop > 0) {
	strcat(build_instruction,vecbuildst[vecbuildtop]);
	vecbuildtop--;
    }
    strcat(build_instruction,"]");
    strcpy(st[++top],build_instruction);
}
codegen_buildrow(double m, double inc, double n)
{
    sprintf(vecbuildst[++vecbuildtop],"(%f,%f,%f)",m,n,inc);
}
codegen_rand(int n, int m)
{
    sprintf(st[++top],"{%d,%d}",n,m);
}
codegen_print()
{
    fprintf(output,"print %s\n",st[top--]);
}
printnum(int n)
{
    if( strcmp(st[top-n],"_t")==0)
    {
         fprintf(output,"%d",tintar[ptr-n]);
    }
}

