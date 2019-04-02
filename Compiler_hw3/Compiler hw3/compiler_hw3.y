/*	Definition section */
%{
#include "common.h" //Extern variables that communicate with lex

extern int yylineno;
extern int yylex();

SYMBOL* symbol_head = NULL;

FILE *file;

void yyerror(const char* error);

struct Table
{
    int index;
    char* id;
    char* type;
	int i_data;
	double d_data;
}table[1000];

int count=0;//table index
int scope_flag=0;//current scope
/* symbol table function */
SYMBOL* lookup_symbol(char *id);
void create_symbol();
void insert_symbol(SEMTYPE type, char *id, int reg_num);
void dump_symbol();

%}

%union {
    RULE_TYPE rule_type;
    int intVal;
}

/* Token definition */
%token INC DEC
%token MTE LTE EQ NE
%token <rule_type> ADDASGN SUBASGN MULASGN DIVASGN MODASGN
%token AND OR NOT
%token PRINT PRINTLN
%token IF ELSE FOR
%token VAR
%token QUOTA
%token NEWLINE

%token <rule_type> I_CONST
%token <rule_type> F_CONST
%token <rule_type> VOID INT FLOAT STRING ID

%type <rule_type> initializer expr equality_expr relational_expr
%type <rule_type> additive_expr multiplicative_expr prefix_expr postfix_expr
%type <rule_type> primary_expr constant
%type <rule_type> type

%type <intVal> add_op mul_op print_func_op assignment_op equality_op relational_op

%start program

%right ')' ELSE

/* Grammar section */
%%


program
    : program stat 
    |
;

stat
    : declaration
    | compound_stat
    | expression_stat
    | print_func
    | selection_stat
;

declaration
    : VAR ID type '=' initializer NEWLINE 
	{
		if(count==0) create_symbol();
		if(insert_symbol($2.id,$3.type))
		{
			count++;
			int n = lookup_symbol($2.id,2);
			if(strcmp(table[n].type,"int")==0)
			{
				table[n].i_data = $5.f_val;
			}		
			else if(strcmp(table[n].type,"float32")==0)
			{
				table[n].d_data = $5.f_val;
			}	
		}
		printf("declare %s in block of depth %d\n", $2.id, scope_flag);
	}
    | VAR ID type NEWLINE
	{
		if(count==0) create_symbol();
		if(insert_symbol($2.id,$3.type))
		{
			count++;
			int n = lookup_symbol($2.id,2);
			if(strcmp(table[n].type,"int")==0)
			{
				table[n].i_data = 0;
			}		
			else if(strcmp(table[n].type,"float32")==0)
			{
				table[n].d_data = 0;
			}	
		}
		printf("declare %s in block of depth %d\n", $2.id, scope_flag);
	}
;

type
    : INT
    | FLOAT
    | VOID
;

initializer
    : equality_expr
;

compound_stat
    : '{' '}'
    | '{' block_item_list '}'
;

block_item_list
    : block_item
    | block_item_list block_item 
;

block_item
    : stat
;

selection_stat
    : IF '(' expr ')' stat ELSE stat
    | IF '(' expr ')' stat
;

expression_stat
    : expr NEWLINE
    | NEWLINE
;

expr
    : equality_expr
    | ID '=' expr
    | prefix_expr assignment_op expr
;

assignment_op
    : ADDASGN
    | SUBASGN
    | MULASGN
    | DIVASGN
    | MODASGN
;

equality_expr
    : relational_expr
    | equality_expr equality_op relational_expr
;

equality_op
    : EQ
    | NE
;

relational_expr
    : additive_expr
    | relational_expr relational_op additive_expr
;

relational_op
    : '<'
    | '>'
    | LTE
    | MTE
;

additive_expr
    : multiplicative_expr
    | additive_expr add_op multiplicative_expr
;

add_op
    : '+'
    | '-'
;

multiplicative_expr
    : prefix_expr
    | multiplicative_expr mul_op prefix_expr
;

mul_op
    : '*'
    | '/'
    | '%'
;

prefix_expr
    : postfix_expr
    | INC prefix_expr
    | DEC prefix_expr
;

postfix_expr
    : primary_expr
    | postfix_expr INC
    | postfix_expr DEC
;

primary_expr
    : ID
    | constant
    | '(' expr ')'
;

constant
    : I_CONST {$$ = $1;}
    | F_CONST {$$ = $1; }
;

print_func
    : print_func_op '(' equality_expr ')' NEWLINE
    | print_func_op '(' QUOTA STRING QUOTA ')' NEWLINE
;

print_func_op
    : PRINT
    | PRINTLN
;

%%

/* C code section */

int main(int argc, char** argv)
{
	count=0;
    yylineno = 0;
    yyparse();
    return 0;
}

void yyerror (char const *s) {
    fprintf (stderr, "%s\n", s);
}


void create_symbol() {
	if(count==0) printf("Create a symbol table\n");
}

int insert_symbol(char id[1000], char type[1000]) {
    if(lookup_symbol(id, 1)) {
        printf("Insert symbol %s\n", id);
        strcpy(table[count].id, id);
        strcpy(table[count].type, type);
        table[count].scope = scope_flag;
        return 1;
    }
    else {
        printf("<ERROR> re-declaration for variable %s(line %d)\n", id, yylineno);
        return 0;
    }
}

int lookup_symbol(char id[1000], int mode) {
    int i;
    if(mode == 1) {
        for(i = 0; i < count; i++) {
            if(strcmp(table[i].id, id) == 0 && table[i].scope == scope_flag)
                return 0;
        }
        return 1;
    }
    else if(mode == 2){
        int position = -1; // return value, in case multiple same variable name
        for(i = 0; i < count; i++) {
            if(strcmp(table[i].id, id) == 0)
                position = i;
            else if(strcmp(table[i].id, id) == 0 && table[i].scope == scope_flag) {
                position = i;
                break;
            }
                
        }
        return position;
    }
}

void dump_symbol() {
    int tmp = 0;
    printf("\nSymbol table dump\n");
    printf("ID\ttype\tData\n");
    if(count != 0) {
        int i = 0;
        for(i = 0; i < count; i++) {
            if(table[i].scope == scope_flag) {
                if(strcmp(table[i].type, "int") == 0)
                    printf("%s\t%s\t%d\n", table[i].id, table[i].type, table[i].int_val);
                else if(strcmp(table[i].type, "float32") == 0)
                    printf("%s\t%s\t%lf\n", table[i].id, table[i].type, table[i].double_val);
                strcpy(table[i].type, "");
                strcpy(table[i].id, "");
                table[i].int_val = 0;
                table[i].double_val = 0.0;
                tmp++;
            }
        }
        
        if(tmp == 0) 
            printf("No symbol to be dumped\n\n");
        else
            printf("\n");
        count -= tmp;
    }
}

