%{
/************************************************************************
expr2.y
YACC file
Date: 2023/10/6
************************************************************************/
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifndef YYSTYPE
#define YYSTYPE char* //定义求值结果类型
#endif 
char idStr[50];
char numStr[50];
char* yylex();
extern int yyparse();
FILE* yyin;
void yyerror(const char* s);

%}//定义段，用于添加头文件、函数定义、全局变量等

%token NUMBER
%token ID
%token ADD
%token SUB
%token MUL
%token DIV
%token ASSIGN
%token EQ
%token INT CHAR
%token LBB RBB
%token LSB RSB
%token LMB RMB
%token WHILE
%token EQ
%token IF
%token ELSE

%left ADD SUB
%left MUL DIV
%right UMINUS

%%

lines   :   lines expr ';' {printf("%s\n",$2);}
        |   lines stmt
        |
        ;

type    :   INT
        |   CHAR
        ;

stmt: if_stmt
    | while_stmt
    | assign_stmt ';'
    ;

if_stmt: IF LSB expr RSB stmt ELSE stmt {$$ = (char*)malloc(50*sizeof(char));}
       | IF LSB expr RSB stmt {$$ = (char*)malloc(50*sizeof(char));}
       ;

while_stmt: WHILE LSB expr RSB stmt {$$ = (char*)malloc(50*sizeof(char));}
          ;

assign_stmt: type ID {$$ = (char*)malloc(50*sizeof(char));}
        |   type ID ASSIGN expr  {$$ = (char*)malloc(50*sizeof(char));}
        |   expr ASSIGN expr {$$ = (char*)malloc(50*sizeof(char));}
        ;

expr    :   expr ADD expr {$$ = (char*)malloc(50*sizeof(char));}
        |   expr SUB expr {$$ = (char*)malloc(50*sizeof(char));}
        |   expr MUL expr {$$ = (char*)malloc(50*sizeof(char));}
        |   expr DIV expr {$$ = (char*)malloc(50*sizeof(char));}
        |   expr EQ expr  {$$ = (char*)malloc(50*sizeof(char));}
        |   LSB expr RSB {$$ = (char*)malloc(50*sizeof(char));}
        |   LMB expr RMB {$$ = (char*)malloc(50*sizeof(char));}
        |   LBB expr RBB {$$ = (char*)malloc(50*sizeof(char));}
        |   NUMBER {$$ = (char*)malloc(50*sizeof(char));}
        |   ID {$$ = (char*)malloc(50*sizeof(char));}
        |   SUB expr %prec UMINUS {$$ = (char*)malloc(50*sizeof(char));}
        ;
%%

char* yylex() {
    char t;
    while(1) {
        t = getchar();
        //printf("in yylex\n");
        if (t == ' ' || t== '\t' || t == '\n'){
            //do nothing
        }else if(t >= '0' && t <= '9') {
            int ti = 0;
            while(t >= '0' && t <= '9') {
                numStr[ti] = t;
                t = getchar();
                ti ++;
            }
            numStr[ti] = '\0';
            for(int i = 0;i < ti;i++)
                printf("%c",numStr[i]);
            yylval = numStr;
            memset(numStr,0,50*sizeof(char));
            ungetc(t, stdin);
            printf(" NUMBER\n");
            return NUMBER;
        }else if((t >= 'a' && t <= 'z') || (t >= 'A' && t <= 'Z') || (t == '_')) {
            int ti = 0;
            while((t >= 'a' && t <= 'z') || (t >= 'A' && t <= 'Z') || (t == '_') || (t >= '0' && t <= '9')) {
                idStr[ti] = t;
                ti ++;
                t = getchar();
                //printf("%c\n",t);
            }
            idStr[ti] = '\0';

            if(ti == 5 && idStr[0] == 'w' && idStr[1] == 'h' && idStr[2] == 'i' && idStr[3] == 'l' && idStr[4] == 'e'){
                memset(idStr,0,50*sizeof(char));
                ungetc(t, stdin);
                printf("WHILE RESERVED WORD\n");
                return WHILE;
            }
            else if(ti == 2 && idStr[0] == 'i' && idStr[1] == 'f'){
                memset(idStr,0,50*sizeof(char));
                ungetc(t, stdin);
                printf("IF RESERVED WORD\n");
                return IF;
            }
            else if(ti == 4 && idStr[0] == 'e' && idStr[1] == 'l' && idStr[2] == 's' && idStr[3] == 'e'){
                memset(idStr,0,50*sizeof(char));
                ungetc(t, stdin);
                printf("ELSE RESERVED WORD\n");
                return ELSE;
            }
            else if(ti == 3 && idStr[0] == 'i' && idStr[1] == 'n' && idStr[2] == 't'){
                memset(idStr,0,50*sizeof(char));
                ungetc(t, stdin);
                printf("INT TYPE\n");
                return INT;
            }
            else if(ti == 4 && idStr[0] == 'c' && idStr[1] == 'h' && idStr[2] == 'a' && idStr[3] == 'r'){
                memset(idStr,0,50*sizeof(char));
                ungetc(t, stdin);
                printf("CHAR TYPE\n");
                return CHAR;
            }
            else{
                for(int i = 0;i < ti;i++)
                    printf("%c",idStr[i]);
                yylval = idStr;
                memset(idStr,0,50*sizeof(char));
                ungetc(t, stdin);
                printf(" ID\n");
                return ID;
            }
        }
        else if(t == '='){
            t = getchar();
            if(t == '='){
                printf("== EQ\n");
                //ungetc(t,stdin);
                return EQ;
            }
            else{
                printf("= ASSIGN\n");
                ungetc(t,stdin);
                return ASSIGN;
            }
        }
        else if(t == '+') {
            printf("+ ADD\n");
            return ADD;
        }
        else if(t == '-') {
            printf("- SUB\n");
            return SUB;
        }
        else if(t == '*') {
            printf("* MUL\n");
            return MUL;
        }
        else if(t == '/') {
            printf("/ DIV\n");
            return DIV;
        }
        else if(t == '(') {
            printf("( LSB\n");
            return LSB;
        }
        else if(t == ')') {
            printf(") RSB\n");
            return RSB;
        }
        else if(t == '[') {
            printf("[ LMB\n");
            return LMB;
        }
        else if(t == ']') {
            printf("] RMB\n");
            return RMB;
        }
        else if(t == '{') {
            printf("{ LBB\n");
            return LBB;
        }
        else if(t == '}') {
            printf("} RBB\n");
            return RBB;
        }
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