/* Definition section */
%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#define  T_IDENTIFIER  300
	#define  T_INTEGER     301
	#define  T_REAL        302
	#define  T_STRING      303
	#define  T_ASSIGN      304
	#define  T_ELSE        305
	#define  T_IF          306
	#define  T_THEN        307
	#define  T_EQ          308
	#define  T_LT          309
	#define  T_NE          310
	#define  T_GE					 311
	#define  T_GT      		 312
	#define	 T_NEWLINE		 313
	/* Symbol table function */
	struct Table
	{
		int index;
		char* id;
		char* type;
		struct Table *next;
	};
	struct Table* head;
	void create_symbol();
	void insert_symbol();
	int lookup_symbol();
	void dump_symbol();
	int flag=0;
	int line=0;
	int comment=0;
	int commentline=0;
	int commentflag=0;
	int setstr=0;
	int strfirst=1;
	char *idvalue;
	char *typevalue;
	char *strvalue;
	int indexx=0;
%}

/* Define regular expression label */
letter [a-zA-Z]
digit [0-9]
id {letter}+({letter}|{digit})*
str ([^"]|\"\")*
comm ([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*
comm2  [^\n\r]*[\n\r]
number {digit}+
floatnumber {digit}+"."{digit}*({digit}|"E"[+-]?{digit}+)
ws [ \t]+
/* Rules section */
%%


"("	{ printf("%s \t LB \n", yytext);  }
")"	{ printf("%s \t RB \n", yytext);  }
"{"	{ printf("%s \t LCB \n", yytext);  }
"}"	{ printf("%s \t RCB \n", yytext);  }
\n			{line++;if(comment==1){commentline++;comment=0;}}

">" 	{ printf("%s \t Greater than \n", yytext); }
"<" 	{ printf("%s \t Less than \n", yytext); }
">=" 	{ printf("%s \t Greater equal \n", yytext); }
"<=" 	{ printf("%s \t Less equal \n", yytext); }
"==" 	{ printf("%s \t Equal \n", yytext); }
"!=" 	{ printf("%s \t Not equal \n", yytext); }
"+" 	{ printf("%s \t Add \n", yytext); }
"-"		{ printf("%s \t Sub \n", yytext); }
"*"		{ printf("%s \t Product \n", yytext); }
"/"		{ printf("%s \t Divide \n", yytext); }
"%" 	{ printf("%s \t Mod \n", yytext); }
"++"	{ printf("%s \t Increment \n", yytext);  }
"--"	{ printf("%s \t Decrement \n", yytext);  }
"=" 	{ printf("%s \t Assign \n", yytext); }
"+=" 	{ printf("%s \t Plus Assign \n", yytext); }
"-=" 	{ printf("%s \t Sub Assign \n", yytext); }
"*=" 	{ printf("%s \t Product Assign \n", yytext); }
"/=" 	{ printf("%s \t Divide Assign \n", yytext); }
"%=" 	{ printf("%s \t Mod Assign \n", yytext); }
"&&" 	{ printf("%s \t And \n", yytext); }
"||" 	{ printf("%s \t Or \n", yytext); }
"!" 	{ printf("%s \t Not \n", yytext); }

"print" 	{ printf("%s \t PRINT function\n", yytext); }
"println" 	{ printf("%s \t PRINTLN function \n", yytext); }
"if" 	{ printf("%s \t IF \n", yytext); }
"else" 	{ printf("%s \t ELSE \n", yytext); }
"for" 	{ printf("%s \t FOR function \n", yytext); }


"var"		{flag=1;}
"int"	{ if(flag==1){printf("%s \t int TYPE VAR \n",idvalue); flag=0;typevalue="int";
if(head==NULL){create_symbol();} if(lookup_symbol()==-1){insert_symbol();}else{printf("%s \t Redefined Variable\n",idvalue);} } } 

"float32"	{ if(flag==1){printf("%s \t float32 TYPE VAR \n",idvalue); flag=0;typevalue="float32";
if(head==NULL){create_symbol();} if(lookup_symbol()==-1){insert_symbol();}else{printf("%s \t Redefined Variable\n",idvalue);} } } 

{floatnumber} {printf("%s \t FloatNumber\n",yytext);}
{number}	{ printf("%s \t Number \n", yytext);  }
"\""+{str}+"\"" {printf("%s \t String \n",yytext);}


"/*"{comm}+"*/" {for(int i=0;i<strlen(yytext);++i){if(yytext[i]=='\n'){commentline++;line++;}printf("%c",yytext[i]);}comment=1;printf(" \t C Comment\n");}
"//"+{comm2} {for(int i=0;i<strlen(yytext);++i){if(yytext[i]=='\n'){commentline++;line++;}else{printf("%c",yytext[i]);}}printf(" \t C++ Comment\n");}

{id}	{ idvalue=(char *)malloc(strlen(yytext+1));strcpy(idvalue,yytext); if(flag==0 && lookup_symbol()==1){printf("%s \t ID \n", yytext);}
else if(flag==0 && lookup_symbol()==-1){printf("%s \t Undefined Variable\n",yytext);} }

{ws}			{;}

%%
//	{if(setstr==0){setstr=1;strvalue=(char *)malloc(2000);} else{setstr=0;strfirst=1;printf("\"%s\" \t String \n",strvalue);}}

//{id}	{ if(flag==1){idvalue=(char *)malloc(strlen(yytext+1));strcpy(idvalue,yytext);} else if(flag==0 && lookup_symbol()==i){printf("%s \t ID \n", yytext);} }
//{str} { if(setstr==1){if(strfirst){sprintf(strvalue,"%s",yytext);strfirst=0;}else{sprintf(strvalue,"%s %s",strvalue,yytext);} }}
//else if(setstr==1){if(strfirst){sprintf(strvalue,"%s",yytext);strfirst=0;}else{sprintf(strvalue,"%s %s",strvalue,yytext);} }
//"var "+{id}+" int" { printf("%s \t int TYPE VAR \n",yytext);  }
//\n		{return(T_NEWLINE);}
//"var {id} int" {printf("%s \t int TYPE VAR",yytext);}
/*	C Code section */
int yywrap(void)
{
    return 1;
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
int lookup_symbol() {
	if(head==NULL) return -1;
	struct Table * tmp = (struct Table*)malloc(sizeof(struct Table));
	tmp=head;
	while(tmp->next!=NULL)
	{
		if(strcmp(tmp->id,idvalue)==0)
		{
			return 1;
		}
		tmp=tmp->next;
	}
	if(strcmp(tmp->id,idvalue)==0)
	{
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
	while(head->next!=NULL){
		tmp = head;
		printf("%d \t %s \t %s\n",head->index,head->id,head->type);
		head = head->next;
		free(tmp);
	}
	printf("%d \t %s \t %s\n",head->index,head->id,head->type);
	free(head);
	
}

int main(int argc,char *argv[])
{
	yyin = fopen(argv[1],"r");
	yylex();
	printf("\nParse over, the line number is %d\n",line);
	printf("\ncomment: %d line\n",commentline);
	dump_symbol();
	
	return 0;
}
