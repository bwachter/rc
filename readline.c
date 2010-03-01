#include "rc.h"

#include <signal.h>

#include "jbwrap.h"

/* This is hairy.  GNU readline is broken.  It tries to behave like a
restartable system call.  However, we need SIGINT to abort input.  This
is basically the same problem that system-bsd.c tries to solve, and so
we borrow some of the HAVE_RESTARTABLE_SYSCALLS code.  If a signal is
caught, then we call rcRaise, which longjmp()s back to the
top level. */

struct Jbwrap rl_buf;
volatile sig_atomic_t rl_active;

extern char *rc_readline(char *prompt) {
	char *r = 0;
	int s;

	if ((s = sigsetjmp(rl_buf.j, 1)) == 0) {
		rl_active = TRUE;
		r = readline(prompt);
	} else {
		/* Readline interrupted.  Clear up the terminal settings. */
		switch (s) {
		default:
#if READLINE_OLD
			rl_clean_up_for_exit();
			rl_deprep_terminal();
#else
			_rl_clean_up_for_exit();
			(*rl_deprep_term_function)();
#endif
			rl_clear_signals();
			rl_pending_input = 0;
			break;

/* These signals are already cleaned up by readline. */

		case SIGINT:
		case SIGALRM:
#ifdef SIGTSTP
		case SIGTSTP:
		case SIGTTOU:
		case SIGTTIN:
#endif
			break;
		}
		rl_active = FALSE;
		sigchk();
		rc_raise(eError);
		/* rc_raise doesn't return, but gcc doesn't know that.  This silences a warning. */
		r = 0;
	}

	rl_active = FALSE;
	return r;
}
