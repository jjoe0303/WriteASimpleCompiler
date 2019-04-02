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
    INC = 258,
    DEC = 259,
    MTE = 260,
    LTE = 261,
    EQ = 262,
    NE = 263,
    ADDASGN = 264,
    SUBASGN = 265,
    MULASGN = 266,
    DIVASGN = 267,
    MODASGN = 268,
    AND = 269,
    OR = 270,
    NOT = 271,
    PRINT = 272,
    PRINTLN = 273,
    IF = 274,
    ELSE = 275,
    FOR = 276,
    VAR = 277,
    QUOTA = 278,
    NEWLINE = 279,
    I_CONST = 280,
    F_CONST = 281,
    VOID = 282,
    INT = 283,
    FLOAT = 284,
    STRING = 285,
    ID = 286
  };
#endif
/* Tokens.  */
#define INC 258
#define DEC 259
#define MTE 260
#define LTE 261
#define EQ 262
#define NE 263
#define ADDASGN 264
#define SUBASGN 265
#define MULASGN 266
#define DIVASGN 267
#define MODASGN 268
#define AND 269
#define OR 270
#define NOT 271
#define PRINT 272
#define PRINTLN 273
#define IF 274
#define ELSE 275
#define FOR 276
#define VAR 277
#define QUOTA 278
#define NEWLINE 279
#define I_CONST 280
#define F_CONST 281
#define VOID 282
#define INT 283
#define FLOAT 284
#define STRING 285
#define ID 286

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 22 "compiler_hw3.y" /* yacc.c:1909  */

    RULE_TYPE rule_type;
    int intVal;

#line 121 "y.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
