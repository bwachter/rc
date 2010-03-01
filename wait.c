#include "rc.h"

#include <errno.h>
#include <setjmp.h>
#include <sys/wait.h>

#include "jbwrap.h"

bool forked = FALSE;

static pid_t rc_wait(int *);

typedef struct Pid Pid;

static struct Pid {
	pid_t pid;
	int stat;
	bool alive;
	Pid *n;
} *plist = NULL;

extern pid_t rc_fork() {
	Pid *new;
	pid_t pid = fork();
	switch (pid) {
	case -1:
		uerror("fork");
		rc_error(NULL);
		/* NOTREACHED */
	case 0:
		forked = TRUE;
		sigchk();
		return 0;
	default:
		new = enew(Pid);
		new->pid = pid;
		new->alive = TRUE;
		new->n = plist;
		plist = new;
		return pid;
	}
}

extern pid_t rc_wait4(pid_t pid, int *stat, bool nointr) {
	Pid *r, *prev;
	int ret;
	/* first look for a child which may already have exited */
again:	for (r = plist, prev = NULL; r != NULL; prev = r, r = r->n)
		if (r->pid == pid)
			break;
	if (r == NULL) {
		errno = ECHILD; /* no children */
		uerror("wait");
		*stat = 0x100; /* exit(1) */
		return -1;
	}
	if (r->alive) {
		while (pid != (ret = rc_wait(stat))) {
			Pid *q;
			if (ret < 0) {
				if (nointr)
					goto again;
				return ret;
			}
			for (q = plist; q != NULL; q = q->n)
				if (q->pid == ret) {
					q->alive = FALSE;
					q->stat = *stat;
					break;
				}
		}
	} else
		*stat = r->stat;
	if (prev == NULL)
		plist = r->n; /* remove element from head of list */
	else
		prev->n = r->n;
	efree(r);
	return pid;
}

extern List *sgetapids() {
	List *r;
	Pid *p;
	for (r = NULL, p = plist; p != NULL; p = p->n) {
		List *q;
		if (!p->alive)
			continue;
		q = nnew(List);
		q->w = nprint("%d", p->pid);
		q->m = NULL;
		q->n = r;
		r = q;
	}
	return r;
}

extern void waitforall() {
	int stat;
	while (plist != NULL) {
		int pid = rc_wait4(plist->pid, &stat, FALSE);
		if (pid > 0)
			setstatus(pid, stat);
		else
			set(FALSE);
		sigchk();
	}
}

/*
   rc_wait: a wait() wrapper that interfaces wait() w/rc signals.
   Note that the signal queue is not checked in this fn; someone
   may want to resume the wait() without delivering any signals.
*/

static pid_t rc_wait(int *stat) {
	int r;
	interrupt_happened = FALSE;
	if (!setjmp(slowbuf.j)) {
		slow = TRUE;
		if (!interrupt_happened)
			r = wait(stat);
		else
			r = -1;
	} else
		r = -1;
	slow = FALSE;
	return r;
}
