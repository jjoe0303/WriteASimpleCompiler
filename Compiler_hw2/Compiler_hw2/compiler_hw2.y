/*	Definition section */
%{
extern int yylineno;
extern int yylex();
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

extern FILE* yyin;

union datatype
{
	int i_val;
    double f_val;
    char* string;
};

struct Table
{
    int index;
    char* id;
    char* type;
	union datatype data;
	struct Table *next;
};

struct Table* head;
/* Symbol table function - you can add new function if need. */
int lookup_symbol();
int lookup_symbol2();
void create_symbol();
void insert_symbol();
void insert_symbol2();
void dump_symbol();
void yyerror();
char *idvalue;
char *typevalue;
char *strvalue;
int indexx=0;
union datatype gdata;
struct Table* g1;
struct Table* g2;
struct Table* gassign;
int errorflag=0;
int gflag=0;
int expr_float_flag=0;
int d_iflag=0;
int d_fflag=0;
%}

/* Using union to define nonterminal and token type */
%union {
    int i_val;
    double f_val;
    char* string;
}

/* Token without return */
%token PRINT PRINTLN 
%token IF ELSE FOR
%token VAR NEWLINE

/*Arithmetic*/
%token PLUS MINUS PRODUCT DIVIDE MOD INCREMENT DECREMENT

/*Relational*/
%token GREATER_THAN LESS_THAN GREATER_EQUAL LESS_EQUAL EQUAL NOT_EQUAL

/*Assignment*/
%token ASSIGN PLUS_ASSIGN MINUS_ASSIGN PRODUCT_ASSIGN DIVIDE_ASSIGN MOD_ASSIGN

/*Logical*/
%token AND OR NOT

/*Delimiters*/
%token LB RB LCB RCB

/*string */
%token LDQ
%token <string> RDQ

/*Declaration Keywords*/
%token <string> VOID 
%token <string> INT 
%token <string> FLOAT
%token <string> ID

/* Token with return, which need to sepcify type */
%token <i_val> I_CONST
%token <f_val> F_CONST
%token <string> STRING

/* Nonterminal with return, which need to sepcify type */
%type <f_val> stat
%type <f_val> expression_stat
%type <f_val> assignment_stat
%type <f_val> declaration
%type <f_val> logical_and
%type <f_val> comparison
%type <f_val> arithmetic_stat
%type <f_val> term
%type <f_val> pterm
%type <f_val> factor
%type <f_val> initializer
%type <string> type
%type <f_val> print_stat
%type <f_val> for_stat
%type <f_val> if_stat
%type <f_val> block_line


/* Yacc will start at this nonterminal */
%start program

/* Grammar section */
%%

program
    : program stat
    |
;

stat
    : declaration
    | expression_stat
	| assignment_stat
	| print_stat
	| for_stat
	| if_stat
	| block_line
;

for_stat
	: FOR LB expression_stat RB LCB program RCB  {printf("FOR LOOP\n");}
;

if_stat
	: IF expression_stat block_line{printf("IF\n");}
	| ELSE IF expression_stat block_line {printf("ELSE IF\n");}
	| ELSE block_line {printf("ELSE\n");}
;

block_line
	: LCB program RCB{}
;

print_stat
	: PRINT LB LDQ RDQ RB NEWLINE {printf("PRINT: \"%s\"\n",$4);}
	| PRINT LB expression_stat RB NEWLINE  {if(expr_float_flag==1){printf("PRINT: %lf\n",$3);}
											else{printf("PRINT: %d\n",(int)$3);}expr_float_flag==0; }
	| PRINTLN LB LDQ RDQ RB NEWLINE {printf("PRINTLN: \"%s\"\n\n",$4);}
	| PRINTLN LB expression_stat RB NEWLINE {if(expr_float_flag==1){printf("PRINTLN: %lf\n\n",$3);}
											else{printf("PRINTLN: %d\n\n",(int)$3);}expr_float_flag==0; }
;

assignment_stat
	: ID ASSIGN expression_stat {idvalue=(char *)malloc(strlen($1+1));strcpy(idvalue,$1); 
						printf("ASSIGN\n");
						if(errorflag==0){
							if(lookup_symbol2()==-1){printf("<ERROR> can’t find variable %s (line %d)\n",idvalue,yylineno);}
							else if((strcmp(gassign->type,"float32")==0)){gassign->data.f_val = $3;}
							else if((strcmp(gassign->type,"int")==0)){gassign->data.i_val = $3;}
						}						
						errorflag=0;
					}
	| ID PLUS_ASSIGN expression_stat{idvalue=(char *)malloc(strlen($1+1));strcpy(idvalue,$1); 
						printf("PLUS_ASSIGN\n");
						if(errorflag==0){
							if(lookup_symbol2()==-1){printf("<ERROR> can’t find variable %s (line %d)\n",idvalue,yylineno);}
							else if((strcmp(gassign->type,"float32")==0)){gassign->data.f_val = gassign->data.f_val+$3;}
							else if((strcmp(gassign->type,"int")==0)){gassign->data.i_val = gassign->data.i_val+$3;}
						}						
						errorflag=0;
					}
	| ID MINUS_ASSIGN expression_stat{idvalue=(char *)malloc(strlen($1+1));strcpy(idvalue,$1); 
						printf("MINUS_ASSIGN\n");
						if(errorflag==0){
							if(lookup_symbol2()==-1){printf("<ERROR> can’t find variable %s (line %d)\n",idvalue,yylineno);}
							else if((strcmp(gassign->type,"float32")==0)){gassign->data.f_val = gassign->data.f_val-$3;}
							else if((strcmp(gassign->type,"int")==0)){gassign->data.i_val = gassign->data.i_val-$3;}
						}						
						errorflag=0;
					}
	| ID PRODUCT_ASSIGN expression_stat{idvalue=(char *)malloc(strlen($1+1));strcpy(idvalue,$1); 
						printf("PRODUCT_ASSIGN\n");
						if(errorflag==0){
							if(lookup_symbol2()==-1){printf("<ERROR> can’t find variable %s (line %d)\n",idvalue,yylineno);}
							else if((strcmp(gassign->type,"float32")==0)){gassign->data.f_val = gassign->data.f_val*$3;}
							else if((strcmp(gassign->type,"int")==0)){gassign->data.i_val = gassign->data.i_val*$3;}
						}						
						errorflag=0;
					}
	| ID DIVIDE_ASSIGN expression_stat{idvalue=(char *)malloc(strlen($1+1));strcpy(idvalue,$1); 
						printf("DIVIDE_ASSIGN\n");
						if(errorflag==0){
							if(lookup_symbol2()==-1){printf("<ERROR> can’t find variable %s (line %d)\n",idvalue,yylineno);}
							else if($3==0){printf("<ERROR> The divisor can’t be 0 (line %d)\n",yylineno);}
							else if((strcmp(gassign->type,"float32")==0)){gassign->data.f_val = gassign->data.f_val/$3;}
							else if((strcmp(gassign->type,"int")==0)){gassign->data.i_val = gassign->data.i_val/$3;}
						}						
						errorflag=0;
					}
	| ID MOD_ASSIGN expression_stat {idvalue=(char *)malloc(strlen($1+1));strcpy(idvalue,$1); 
						printf("MOD_ASSIGN\n");
						if(errorflag==0){
							if(lookup_symbol2()==-1){printf("<ERROR> can’t find variable %s (line %d)\n",idvalue,yylineno);}
							else if((strcmp(gassign->type,"float32")==0) || expr_float_flag==1){printf("<ERROR> use float32 MOD computation(line %d)\n",yylineno);}
							else if((strcmp(gassign->type,"int")==0)){gassign->data.i_val = gassign->data.i_val/$3;}
						}						
						errorflag=0;
					}
;

expression_stat
	: expression_stat OR logical_and {$$ = ($1 || $3);if($1||$3){printf("true\n");} else{printf("false\n");}}
	| logical_and {$$ = $1;}
;

logical_and
	: logical_and AND comparison {$$ = ($1 && $3);if($1&&$3){printf("true\n");} else{printf("false\n");}}
	| comparison  {$$ = $1;}
;

comparison
	: comparison EQUAL arithmetic_stat {$$ = ($1 == $3);if($1==$3){printf("true\n");} else{printf("false\n");}}
	| comparison NOT_EQUAL arithmetic_stat {$$ = ($1 != $3);if($1!=$3){printf("true\n");} else{printf("false\n");}}
	| comparison LESS_THAN arithmetic_stat {$$ = ($1 < $3);if($1<$3){printf("true\n");} else{printf("false\n");}}
	| comparison LESS_EQUAL arithmetic_stat {$$ = ($1 <= $3);if($1<=$3){printf("true\n");} else{printf("false\n");}}
	| comparison GREATER_THAN arithmetic_stat {$$ = ($1 > $3);if($1>$3){printf("true\n");} else{printf("false\n");}}
	| comparison GREATER_EQUAL arithmetic_stat {$$ = ($1 >= $3);if($1>=$3){printf("true\n");} else{printf("false\n");}}
	| arithmetic_stat {$$ = $1;}
;

arithmetic_stat
	: arithmetic_stat PLUS term  { printf("Add\n");   $$ = $1 + $3;}
	| arithmetic_stat MINUS term { printf("Minus\n"); $$ = $1 - $3;}
	| term {$$ = $1;}
;

term
	: term PRODUCT pterm {printf("Mul\n"); $$ = $1 * $3;}
	| term DIVIDE pterm {if($3==0){printf("<ERROR> The divisor can’t be 0 (line %d)\n",yylineno);errorflag=1;}else{printf("Div\n"); $$ = $1 / $3;}}
	| term MOD pterm { if((strcmp(g1->type,"float32")==0) || (strcmp(g2->type,"float32")==0)){printf("<ERROR> use float32 MOD computation(line %d)\n",yylineno);errorflag=1;}
						else{printf("Mod\n"); $$ = (int)$1 % (int)$3;}}
	| pterm {$$ = $1;}
;

pterm
	: factor INCREMENT  {
			if((strcmp(gassign->type,"float32")==0)){gassign->data.f_val = gassign->data.f_val+1;}
			else if((strcmp(gassign->type,"int")==0)){gassign->data.i_val = gassign->data.i_val+1;}
			printf("Increment\n");
	}
	| factor DECREMENT  {
			if((strcmp(gassign->type,"float32")==0)){gassign->data.f_val = gassign->data.f_val-1;}
			else if((strcmp(gassign->type,"int")==0)){gassign->data.i_val = gassign->data.i_val-1;}
			printf("Decrement\n");
	}
	| factor {$$ = $1;}
;

factor
	: ID { idvalue=(char *)malloc(strlen($1+1));strcpy(idvalue,$1); if(lookup_symbol()==-1 || lookup_symbol2()==-1){printf("<ERROR> can’t find variable %s (line %d)\n",idvalue,yylineno+1);errorflag=1;}
	else if(gflag==1){if(strcmp(g1->type,"int")==0){$$=g1->data.i_val;}else{$$=g1->data.f_val;expr_float_flag=1;}}
	else if(gflag==0){if(strcmp(g2->type,"int")==0){$$=g2->data.i_val;}else{$$=g2->data.f_val;expr_float_flag=1;}}}
	| LB expression_stat RB {$$ = $2;}
	| I_CONST {d_iflag=1;$$ = $1;}
	| F_CONST {d_fflag=1;$$ = $1;expr_float_flag=1;}
	| NEWLINE {gflag=0;errorflag=0;expr_float_flag=0;$$ = 0;}
;

declaration
    : VAR ID type ASSIGN initializer NEWLINE{if(head==NULL){create_symbol();}
	idvalue=(char *)malloc(strlen($2+1));strcpy(idvalue,$2);
	typevalue=(char *)malloc(strlen($3+1));strcpy(typevalue,$3);
	if(lookup_symbol()==-1){insert_symbol2();}
	else{printf("<ERROR> re-declaration for variable %s (line %d)\n",idvalue,yylineno);}
	d_iflag=0;
	d_fflag=0;
	}
    | VAR ID type  NEWLINE{if(head==NULL){create_symbol();}
	idvalue=(char *)malloc(strlen($2+1));strcpy(idvalue,$2);
	typevalue=(char *)malloc(strlen($3+1));strcpy(typevalue,$3);
	if(lookup_symbol()==-1){insert_symbol();}
	else{printf("<ERROR> re-declaration for variable %s (line %d)\n",idvalue,yylineno);}
	d_iflag=0;
	d_fflag=0;
	}
;

initializer
		:expression_stat {if(d_iflag==1){gdata.i_val=$1;}else if(d_fflag==1){gdata.f_val=$1;}$$ = $1;}
;

type
 : INT { $$ = $1; }
 | FLOAT { $$ = $1; }
 | VOID { $$ = $1; }
;

%%
 void yyerror (char const *s) {
    fprintf (stderr, "%s\n", s);
	 }

/* C code section */
int main(int argc, char** argv)
{
	g1=(struct Table*)malloc(sizeof(struct Table));
	g2=(struct Table*)malloc(sizeof(struct Table));
	gassign=(struct Table*)malloc(sizeof(struct Table));
	yyin = fopen(argv[1],"r");
	yylineno = 0;
    yyparse();
	printf("\nTotal line: %d\n",yylineno);
	dump_symbol();
    return 0;
}

void create_symbol() {
	printf("Create a symbol table\n");
}
void insert_symbol() {
	if(head==NULL)
	{
		head =(struct Table*) malloc(sizeof(struct Table));
		head->index=indexx++;
		head->id=idvalue;
		head->type=typevalue;
	}
	else{
		struct Table * tmp = (struct Table*)malloc(sizeof(struct Table));
		struct Table * tmp2 = (struct Table*)malloc(sizeof(struct Table));
		
		tmp = head;
		while(tmp->next!=NULL){
			tmp=tmp->next;
		}
			
		tmp2->index=indexx++;
		tmp2->id=idvalue;
		tmp2->type = typevalue;
		tmp->next = tmp2;	
//		tmp = tmp->next;
	}
		printf("insert value: %s\n",idvalue);
}

void insert_symbol2() {
	if(head==NULL)
	{
		head =(struct Table*) malloc(sizeof(struct Table));
		head->index=indexx++;
		head->id=idvalue;
		head->type=typevalue;
		if(strcmp(head->type,"int")==0)head->data.i_val=gdata.i_val;
		else if(strcmp(head->type,"float32")==0)head->data.f_val=gdata.f_val;
	}
	else{
		struct Table * tmp = (struct Table*)malloc(sizeof(struct Table));
		struct Table * tmp2 = (struct Table*)malloc(sizeof(struct Table));
		
		tmp = head;
		while(tmp->next!=NULL){
			tmp=tmp->next;
		}
			
		tmp2->index=indexx++;
		tmp2->id=idvalue;
		tmp2->type = typevalue;
		if(strcmp(tmp2->type,"int")==0)tmp2->data.i_val=gdata.i_val;
		else if(strcmp(tmp2->type,"float32")==0)tmp2->data.f_val=gdata.f_val;
		tmp->next = tmp2;	
//		tmp = tmp->next;
	}
		printf("insert value: %s\n",idvalue);
}

int lookup_symbol() {
	if(head==NULL) return -1;
	struct Table * tmp = (struct Table*)malloc(sizeof(struct Table));
	tmp=head;
	while(tmp->next!=NULL)
	{
		if(strcmp(tmp->id,idvalue)==0)
		{
			if(gflag==0){gflag=1;g1=tmp;}
			else{gflag=0; g2=tmp;}
			return 1;
		}
		tmp=tmp->next;
	}
	if(strcmp(tmp->id,idvalue)==0)
	{
		if(gflag==0){gflag=1;g1=tmp;}
		else{gflag=0; g2=tmp;}
		return 1;
	}
	else{
		return -1;
	}

}

int lookup_symbol2() {
	if(head==NULL) return -1;
	struct Table * tmp = (struct Table*)malloc(sizeof(struct Table));
	tmp=head;
	while(tmp->next!=NULL)
	{
		if(strcmp(tmp->id,idvalue)==0)
		{
			gassign=tmp;
			return 1;
		}
		tmp=tmp->next;
	}
	if(strcmp(tmp->id,idvalue)==0)
	{
		gassign=tmp;
		return 1;
	}
	else{
		return -1;
	}

}

void dump_symbol() {
	struct Table * tmp = (struct Table*)malloc(sizeof(struct Table));
	if(head==NULL) return;
	printf("\nThe symbol table dump:\n");
	printf("Index\tID\tType\tData\n");
	while(head->next!=NULL){
		tmp = head;
		if(strcmp(head->type,"int")==0) printf("%d \t %s \t %s \t %d\n",head->index,head->id,head->type,head->data.i_val);
		else if(strcmp(head->type,"float32")==0)printf("%d \t %s \t %s \t%lf\n",head->index,head->id,head->type,head->data.f_val);
		head = head->next;
		free(tmp);
	}
	if(strcmp(head->type,"int")==0) printf("%d \t %s \t %s \t %d\n",head->index,head->id,head->type,head->data.i_val);
	else if(strcmp(head->type,"float32")==0)printf("%d \t %s \t %s \t%lf\n",head->index,head->id,head->type,head->data.f_val);
	free(head);
}
