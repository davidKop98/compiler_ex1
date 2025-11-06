/***************************/
/* FILE NAME: LEX_FILE.lex */
/***************************/

/*************/
/* USER CODE */
/*************/

import java_cup.runtime.*;

/******************************/
/* DOLLAR DOLLAR - DON'T TOUCH! */
/******************************/

%%

/************************************/
/* OPTIONS AND DECLARATIONS SECTION */
/************************************/
   
/*****************************************************/ 
/* Lexer is the name of the class JFlex will create. */
/* The code will be written to the file Lexer.java.  */
/*****************************************************/ 
%class Lexer

/********************************************************************/
/* The current line number can be accessed with the variable yyline */
/* and the current column number with the variable yycolumn.        */
/********************************************************************/
%line
%column

/*******************************************************************************/
/* Note that this has to be the EXACT same name of the class the CUP generates */
/*******************************************************************************/
%cupsym TokenNames

/******************************************************************/
/* CUP compatibility mode interfaces with a CUP generated parser. */
/******************************************************************/
%cup

/****************/
/* DECLARATIONS */
/****************/
/*****************************************************************************/   
/* Code between %{ and %}, both of which must be at the beginning of a line, */
/* will be copied verbatim (letter to letter) into the Lexer class code.     */
/* Here you declare member variables and functions that are used inside the  */
/* scanner actions.                                                          */  
/*****************************************************************************/   
%{
	/*********************************************************************************/
	/* Create a new java_cup.runtime.Symbol with information about the current token */
	/*********************************************************************************/
	private Symbol symbol(int type)               {return new Symbol(type, yyline, yycolumn);}
	private Symbol symbol(int type, Object value) {return new Symbol(type, yyline, yycolumn, value);}

	/*******************************************/
	/* Enable line number extraction from main */
	/*******************************************/
	public int getLine() { return yyline + 1; } 

	/**********************************************/
	/* Enable token position extraction from main */
	/**********************************************/
	public int getTokenStartPosition() { return yycolumn + 1; } 
%}

/***********************/
/* MACRO DECLARATIONS */
/***********************/

LineTerminator	= \r|\n|\r\n
WhiteSpace		= {LineTerminator} | [ \t]+
INTEGER			= [0-9][0-9]* // to prevent integer starting from 0
LETTER         	= [A-Za-z]
DIGIT          = [0-9]
ID             = {LETTER}({LETTER}|{DIGIT})*
STRING 			= \"{LETTER}*\"

COMMENT_CHAR   = {LETTER}|{DIGIT}|[ \t]|[\(\)\[\]\{\}\?\!\+\-\*\/\.\;]     //for good // comments
BAD_LINE_CHAR         = [^\r\nA-Za-z0-9 \t\(\)\[\]\{\}\?\!\+\-\*\/\.\;]  //used for bad // comments
COMMENT_CHAR_V2  = {LETTER}|{DIGIT}|[ \t]|{LineTerminator}|[\(\)\[\]\{\}\?\!\+\-\*\/\.\;] //used for /* comments

%state COMMENT


/******************************/
/* DOLLAR DOLLAR - DON'T TOUCH! */
/******************************/

%%

/************************************************************/
/* LEXER matches regular expressions to actions (Java code) */
/************************************************************/

/**************************************************************/
/* YYINITIAL is the state at which the lexer begins scanning. */
/* So these regular expressions will only be matched if the   */
/* scanner is in the start state YYINITIAL.                   */
/**************************************************************/

<YYINITIAL> {
{WhiteSpace}		{ /* just skip what was found, do nothing */ }
"//"[^\r\n]*{BAD_LINE_CHAR}[^\r\n]*{LineTerminator}   { throw new Error("COMMENT ERROR"); }   //comment error
"//"{COMMENT_CHAR}*{LineTerminator}            { /* skip */ }

"/*"                    { yybegin(COMMENT); }


"class"  			{ return symbol(TokenNames.CLASS); } //KEYWORDS:
"nil"     			{ return symbol(TokenNames.NIL); }
"array"  			{ return symbol(TokenNames.ARRAY); }
"while"  			{ return symbol(TokenNames.WHILE); }
"int"     			{ return symbol(TokenNames.TYPE_INT); }
"void"    			{ return symbol(TokenNames.TYPE_VOID); }
"extends" 			{ return symbol(TokenNames.EXTENDS); }
"return"  			{ return symbol(TokenNames.RETURN); }
"new"     			{ return symbol(TokenNames.NEW); }
"if"      			{ return symbol(TokenNames.IF); }
"else"    			{ return symbol(TokenNames.ELSE); }
"string"  			{ return symbol(TokenNames.TYPE_STRING); }

":="   				{ return symbol(TokenNames.ASSIGN); }
"["    				{ return symbol(TokenNames.LBRACK); }
"]"    				{ return symbol(TokenNames.RBRACK); }
"{"   				{ return symbol(TokenNames.LBRACE); }
"}"    				{ return symbol(TokenNames.RBRACE); }
","    				{ return symbol(TokenNames.COMMA); }
"."   			 	{ return symbol(TokenNames.DOT); }
";"   				{ return symbol(TokenNames.SEMICOLON); }
"<"    			{ return symbol(TokenNames.LT); }
">"    			{ return symbol(TokenNames.GT); }
"="    			{ return symbol(TokenNames.EQ); }
"+"					{ return symbol(TokenNames.PLUS);}
"-"					{ return symbol(TokenNames.MINUS);}
"*"					{ return symbol(TokenNames.TIMES);} 
"/"					{ return symbol(TokenNames.DIVIDE);}
"("					{ return symbol(TokenNames.LPAREN);}
")"					{ return symbol(TokenNames.RPAREN);}

{STRING}			{String s = yytext().substring(1, yytext().length()-1);
					return symbol(TokenNames.STRING, s);}

\"[^\r\n\"]*\"   { throw new Error("string with invalid chars"); }  //Bad string handlers:
\"[^\r\n\"]*{LineTerminator}   { throw new Error("string not closed properly via newline"); }
\"[^\r\n\"]*    { throw new Error("string not closed properly via eof"); }

{INTEGER} 			{int v = Integer.parseInt(yytext());
					if (yytext().length() > 1 && yytext().charAt(0) == '0') {
						throw new Error("Lexical error: Integer cannot start with 0");}
					if (v > 32767) {throw new Error("Integer too large"); }
					return symbol(TokenNames.INT, v);}

{ID}				{ return symbol(TokenNames.ID,     yytext());}
<<EOF>>				{ return symbol(TokenNames.EOF);}
.					{ throw new Error("UNKOWN CHAR"); }
}
<COMMENT>{
   "*/" { yybegin(YYINITIAL); }
  {COMMENT_CHAR_V2}   { /* Skip valid comment characters */ }
  [^]              { throw new Error("Invalid character in /* comment"); }
  <<EOF>>          { throw new Error("Unclosed comment"); }
}