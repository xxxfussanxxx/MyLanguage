TARGET	= MyLanguage

# LINK (*.o)
LD	= clang
LDFLAGS	= -Weverything -Werror

# COMPILE (*.c)
CC	= clang
CCFLAGS	= $(shell \
	XcodeMajorVersion=`xcodebuild -version | head -n 1 | cut -d " " -f 2 | cut -d "." -f 1`; \
	if [ $${XcodeMajorVersion} -lt "12" ] ; \
	then \
		echo '-Weverything -Werror -Wno-reserved-id-macro -Wno-unused-macros -Wno-implicit-int-conversion -Wno-sign-conversion -Wno-comma -Wno-unreachable-code -Wno-padded -Wno-missing-noreturn -Wno-missing-variable-declarations -Wno-cast-align -save-temps -O2' ; \
	else \
		if [ $${XcodeMajorVersion} -lt "15" ] ; \
		then \
			echo '-Weverything -Werror -Wno-poison-system-directories -Wno-reserved-id-macro -Wno-unused-macros -Wno-implicit-int-conversion -Wno-sign-conversion -Wno-padded -Wno-missing-noreturn -Wno-unreachable-code-break -Wno-unneeded-internal-declaration -Wno-unreachable-code -Wno-unreachable-code-return -Wno-sign-compare -save-temps -O2' ; \
		else \
			echo '-Weverything -Werror -Wno-poison-system-directories -Wno-reserved-id-macro -Wno-unused-macros -Wno-implicit-int-conversion -Wno-sign-conversion -Wno-padded -Wno-missing-noreturn -Wno-unreachable-code-break -Wno-unneeded-internal-declaration -Wno-unreachable-code -Wno-unreachable-code-return -Wno-sign-compare -Wno-gnu-line-marker -Wno-comma -Wno-missing-variable-declarations -Wno-cast-align -save-temps -O2' ; \
		fi \
	fi)
CCTEMPS	= *.o *.s *.i *.bc

# GENERATOR (*.lex and *.yac)
LEX	= flex
YAC	= bison --yacc

OBJS	= y.tab.o main.o
DEFS	= defs.h
REXP	= rexp.lex
LEXC	= lex.yy.c
SYNS	= syns.yac
YACC	= y.tab.c
SRC	= src.txt
TMP	= tmp.txt
ARC	= MyLanguage

all: $(TARGET)

$(TARGET): $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $(OBJS)

$(OBJS): $(DEFS)

$(LEXC): $(REXP) $(DEFS)
	$(LEX) $(REXP)

$(YACC): $(SYNS) $(LEXC) $(DEFS)
	$(YAC) $(SYNS)

%.o: %.c
	$(CC) $(CCFLAGS) -c $< -o $@

clean:
	-rm -f $(TARGET)* $(OBJS) $(LEXC) $(YACC) $(TMP) $(CCTEMPS) $(ARC).zip *\~

src: all
	./$(TARGET) < $(SRC) > $(TMP) ; if [ ! $$? == 0 ] ; then rm -f $(TMP); touch $(TMP) ; fi
	cat $(TMP)
	@echo

srcLF: all
	./$(TARGET) < srcLF.txt > $(TMP) ; if [ ! $$? == 0 ] ; then rm -f $(TMP); touch $(TMP) ; fi
	cat $(TMP)
	@echo

srcCR: all
	./$(TARGET) < srcCR.txt > $(TMP) ; if [ ! $$? == 0 ] ; then rm -f $(TMP); touch $(TMP) ; fi
	cat $(TMP)
	@echo

srcCRLF: all
	./$(TARGET) < srcCRLF.txt > $(TMP) ; if [ ! $$? == 0 ] ; then rm -f $(TMP); touch $(TMP) ; fi
	cat $(TMP)
	@echo

zip: clean
	mkdir $(ARC)
	cp -p -r ./*.* Makefile $(ARC)/
	zip -r $(ARC).zip $(ARC)/
	rm -rf $(ARC)

test: src
	@:
