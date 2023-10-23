%{
/************************************************************************
expr1.y
YACC file
Date: 2023/10/6
************************************************************************/
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#ifndef YYSTYPE
#define YYSTYPE double //定义求值结果类型
#endif
int yylex();
extern int yyparse();
FILE* yyin;
void yyerror(const char* s);

%}//定义段，用于添加头文件、函数定义、全局变量等

%token NUMBER
%token ADD
%token SUB
%token MUL
%token DIV
%token LB
%token RB

%left ADD SUB
%left MUL DIV
%right UMINUS

%%

lines   :   lines expr ';' {printf("%f\n",$2);}
        |   lines ';' 
        |
        ;

expr    :   expr ADD expr {$$ = $1 + $3;}
        |   expr SUB expr {$$ = $1 - $3;}
        |   expr MUL expr {$$ = $1 * $3;}
        |   expr DIV expr {$$ = $1 / $3;}
        |   LB expr RB {$$ = $2;}
        |   SUB expr %prec UMINUS {$$ = -$2;}
        |   NUMBER {$$ = $1;}
        ;
%%

int yylex() {
    int t;
    while(1) {
        t = getchar();
        if (t == ' ' || t== '\t' || t == '\n'){
            //do nothing
        }else if(isdigit(t)) {
            yylval = 0;
            while(isdigit(t)) {
                yylval = yylval * 10 + t - '0';
                t = getchar();
            }
            ungetc(t, stdin);
            return NUMBER;
        }else if(t == '+') return ADD;
        else if(t == '-') return SUB;
        else if(t == '*') return MUL;
        else if(t == '/') return DIV;
        else if(t == '(') return LB;
        else if(t == ')') return RB;
        else return t;
    }
}

void yyerror(const char* s) {
    fprintf(stderr, "Parse error: %s\n", s);
    exit(1);
}

int main() {
    yyin = stdin;
    do {
        yyparse();
    }while(!feof(yyin));
    return 0;
}