%{
int linecounter = 1;
%}
%option nounput
%%
"\""[a-zA-Z]"\""                        { return(WQUOTED); }
-?[0-9]+                                { return(INTEGER); }
set                                     { return(SET); }
spawn                                   { return(SPAWN); }
Charactor                               { return(CHARACTOR); }
move                                    { return(MOVE); }
Up                                      { return(UP); }
Down                                    { return(DOWN); }
Left                                    { return(LEFT); }
Right                                   { return(RIGHT); }
key                                     { return(KEY); }
go                                      { return(GO); }
"+"                                     { return(ADD); }
"-"                                     { return(SUBSTRACTION); }
"*"                                     { return(MULTIPLY); }
"/"                                     { return(DIVIDE); }
"#"                                     { return(SHARP); }
"("                                     { return(LPAR); }
")"                                     { return(RPAR); }
"\n"                                    { linecounter++; }
"\r\n"                                  { linecounter++; }
"\r"                                    { linecounter++; }
" "|"\t"                                { }
"/*"                                    { comment(); }
.                                       { return(UNKNOWN); }
%%
int yywrap(void) {
	return(1);
}
void comment(void) {
	int boolean, first, second;

	boolean = TRUE;
	first = input();
	while (first != EOF && boolean) {
		second = input();
		if (first == '*' && second == '/') {
			boolean = FALSE;
		} else if (first == '\r' && second == '\n') {
			linecounter++;
			first = input();
		} else {
			if (first == '\r' || first == '\n') {
				linecounter++;
			}
			first = second;
		}
	}
	if (first == EOF) {
		fprintf(stderr, "eof in comment\n");
	}
}
