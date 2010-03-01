# Makefile for rc.

# Please check the configuration parameters in config.h (and if you want
# to make sure, the definitions in proto.h) to make sure they are correct
# for your system.

SHELL=/bin/sh

# Uncomment this line if you have defined the NOEXECVE macro in config.h
#EXECVE=execve.o

# Define this macro if you wish to extend rc via locally-defined builtins.
# An interface is provided in addon.[ch]. Note that the author does not
# endorse any such extensions, rather hopes that this way rc will become
# useful to more people.
#ADDON=addon.o

# Use an ANSI compiler (or at least one that groks prototypes and void *):
CC=gcc -g -O
CFLAGS=
LDFLAGS=

# You may substitute "bison -y" for yacc. (You want to choose the one that
# makes a smaller y.tab.c.)
YACC=yacc

OBJS=$(ADDON) builtins.o except.o exec.o $(EXECVE) fn.o footobar.o getopt.o \
	glob.o glom.o hash.o heredoc.o input.o lex.o list.o main.o match.o \
	nalloc.o open.o print.o redir.o sigmsgs.o signal.o status.o tree.o \
	utils.o var.o version.o wait.o walk.o which.o y.tab.o

# If rc is compiled with READLINE defined, you must supply the correct
# arguments to ld on this line. Typically this would be something like:
#
#	$(CC) -o $@ $(OBJS) -lreadline -ltermcap

rc: $(OBJS)
	$(CC) -o $@ $(OBJS) $(LDFLAGS)

sigmsgs.c: mksignal
	sh mksignal /usr/include/sys/signal.h

y.tab.c: parse.y
	$(YACC) -d parse.y

config.h: config.h-dist
	cp config.h-dist config.h

trip: rc
	./rc -p < trip.rc

clean: force
	rm -f *.o *.tab.* sigmsgs.*

history: force
	cd history; make CC="$(CC)" $(HISTORYMAKEFLAGS)

force:

# dependencies:

$(OBJS): config.h
sigmsgs.h: sigmsgs.c
lex.o y.tab.o: y.tab.c
builtins.c fn.c status.c hash.c: sigmsgs.h
