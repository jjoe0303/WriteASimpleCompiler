/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    PRINT = 258,
    PRINTLN = 259,
    IF = 260,
    ELSE = 261,
    FOR = 262,
    VAR = 263,
    NEWLINE = 264,
    PLUS = 265,
    MINUS = 266,
    PRODUCT = 267,
    DIVIDE = 268,
    MOD = 269,
    INCREMENT = 270,
    DECREMENT = 271,
    GREATER_THAN = 272,
    LESS_THAN = 273,
    GREATER_EQUAL = 274,
    LESS_EQUAL = 275,
    EQUAL = 276,
    NOT_EQUAL = 277,
    ASSIGN = 278,
    PLUS_ASSIGN = 279,
    MINUS_ASSIGN = 280,
    PRODUCT_ASSIGN = 281,
    DIVIDE_ASSIGN = 282,
    MOD_ASSIGN = 283,
    AND = 284,
    OR = 285,
    NOT = 286,
    LB = 287,
    RB = 288,
    LCB = 289,
    RCB = 290,
    LDQ = 291,
    RDQ = 292,
    VOID = 293,
    INT = 294,
    FLOAT = 295,
    ID = 296,
    I_CONST = 297,
    F_CONST = 298,
    STRING = 299
  };
#endif
/* Tokens.  */
#define PRINT 258
#define PRINTLN 259
#define IF 260
#define ELSE 261
#define FOR 262
#define VAR 263
#define NEWLINE 264
#define PLUS 265
#define MINUS 266
#define PRODUCT 267
#define DIVIDE 268
#define MOD 269
#define INCREMENT 270
#define DECREMENT 271
#define GREATER_THAN 272
#define LESS_THAN 273
#define GREATER_EQUAL 274
#define LESS_EQUAL 275
#define EQUAL 276
#define NOT_EQUAL 277
#define ASSIGN 278
#define PLUS_ASSIGN 279
#define MINUS_ASSIGN 280
#define PRODUCT_ASSIGN 281
#define DIVIDE_ASSIGN 282
#define MOD_ASSIGN 283
#define AND 284
#define OR 285
#define NOT 286
#define LB 287
#define RB 288
#define LCB 289
#define RCB 290
#define LDQ 291
#define RDQ 292
#define VOID 293
#define INT 294
#define FLOAT 295
#define ID 296
#define I_CONST 297
#define F_CONST 298
#define STRING 299

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 53 "compiler_hw2.y" /* yacc.c:1909  */

    int i_val;
    double f_val;
    char* string;

#line 148 "y.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
