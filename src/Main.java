import java.io.*;
import java.io.PrintWriter;

import java_cup.runtime.Symbol;
   

public class Main
{
	
	static public void main(String argv[])
	{
		lexer(argv[0],argv[1]);
	}
	static public int lexer(String inputFile,String outputFile) //returns -1 on fail (=lexer error). 1 on success
	{
		Lexer l = null	;
		Symbol s;
		FileReader fileReader = null;
		PrintWriter fileWriter = null;
		String inputFileName = inputFile;
		String outputFileName = outputFile;
		
		try
		{
			/********************************/
			/* [1] Initialize a file reader */
			/********************************/
			fileReader = new FileReader(inputFileName);

			/********************************/
			/* [2] Initialize a file writer */
			/********************************/
			fileWriter = new PrintWriter(outputFileName);
			
			/******************************/
			/* [3] Initialize a new lexer */
			/******************************/
			l = new Lexer(fileReader);

			/***********************/
			/* [4] Read next token */
			/***********************/
			s = l.next_token();

			/********************************/
			/* [5] Main reading tokens loop */
			/********************************/
			int line_numb=0;
			while (s.sym != TokenNames.EOF)
			{
				line_numb++;
				/************************/
				/* [6] Print to console */
				/************************/
				System.out.print(line_numb+") "+getTokenName(s.sym));
				if(s.value != null){System.out.print("("+s.value+")");}
				System.out.print("[");
				System.out.print(l.getLine());
				System.out.print(",");
				System.out.print(l.getTokenStartPosition());
				System.out.print("]");
				System.out.print("\n");
				
				/*********************/
				/* [7] Print to file */
				/*********************/
				fileWriter.print(getTokenName(s.sym));
				if(s.value != null){fileWriter.print("("+s.value+")");}
				fileWriter.print("[");
				fileWriter.print(l.getLine());
				fileWriter.print(",");
				fileWriter.print(l.getTokenStartPosition());
				fileWriter.print("]");
				
				/***********************/
				/* [8] Read next token */
				/***********************/
				Symbol next = l.next_token();
				if (next.sym != TokenNames.EOF) {
					fileWriter.print("\n");
				}
				s = next;
			}
			
			/******************************/
			/* [9] Close lexer input file */
			/******************************/
			l.yyclose();

			/**************************/
			/* [10] Close output file */
			/**************************/
			fileWriter.close();
        }	     
		catch (Throwable e) //encountered a lexical error
		{
			try {
				l.yyclose(); 
				fileReader.close();
				if (fileWriter != null) {
					try { fileWriter.close(); } catch (Throwable ignore) {}
				}
				PrintWriter pw = new PrintWriter(outputFileName); 
				pw.print("ERROR"); // no newline
				pw.close();
			} catch (Throwable ignore) {
				return -1;
			}
			return -1;
		}
		return 1;
	}
	private static String getTokenName(int sym) {  //lexer func helper
		switch(sym) {
			case TokenNames.EOF: return "EOF";
			case TokenNames.PLUS: return "PLUS";
			case TokenNames.MINUS: return "MINUS";
			case TokenNames.TIMES: return "TIMES";
			case TokenNames.DIVIDE: return "DIVIDE";
			case TokenNames.LPAREN: return "LPAREN";
			case TokenNames.RPAREN: return "RPAREN";
			case TokenNames.NUMBER: return "NUMBER";
			case TokenNames.ID: return "ID";
			case TokenNames.CLASS: return "CLASS";
			case TokenNames.NIL: return "NIL";
			case TokenNames.ARRAY: return "ARRAY";
			case TokenNames.WHILE: return "WHILE";
			case TokenNames.TYPE_INT: return "TYPE_INT";
			case TokenNames.TYPE_VOID: return "TYPE_VOID";
			case TokenNames.EXTENDS: return "EXTENDS";
			case TokenNames.RETURN: return "RETURN";
			case TokenNames.NEW: return "NEW";
			case TokenNames.IF: return "IF";
			case TokenNames.ELSE: return "ELSE";
			case TokenNames.TYPE_STRING: return "TYPE_STRING";
			case TokenNames.ASSIGN: return "ASSIGN";
			case TokenNames.EQ: return "EQ";
			case TokenNames.LBRACK: return "LBRACK";
			case TokenNames.RBRACK: return "RBRACK";
			case TokenNames.LBRACE: return "LBRACE";
			case TokenNames.RBRACE: return "RBRACE";
			case TokenNames.COMMA: return "COMMA";
			case TokenNames.DOT: return "DOT";
			case TokenNames.SEMICOLON: return "SEMICOLON";
			case TokenNames.LT: return "LT";
			case TokenNames.GT: return "GT";
			case TokenNames.STRING: return "STRING";
			case TokenNames.INT: return "INT";
			default: return "UNKNOWN";
		}
	}
	
}


