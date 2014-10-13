/* config.h.in.  Generated from configure.ac by autoheader.  */

/* The default interpreter */
#define DEFAULTINTERP @DEFAULTINTERP@

/* The default path */
#cmakedefine DEFAULTPATH @DEFAULTPATH@

/* Define to 1 if you are using `editline' or `vrl'. */
#cmakedefine EDITLINE 1

/* Define to the type of elements in the array set by `getgroups'. Usually
   this is either `int' or `gid_t'. */
#define GETGROUPS_T @GETGROUPS_T@

/* Define to 1 if your kernel understands `#!' magic numbers */
#cmakedefine HASH_BANG 1

/* Define to 1 if you have /dev/fd. */
#cmakedefine HAVE_DEV_FD 1

/* Define to 1 if you have the <dirent.h> header file, and it defines `DIR'.
   */
#cmakedefine HAVE_DIRENT_H 1

/* Define to 1 if you have the `mkfifo' function. */
#cmakedefine HAVE_FIFO 1

/* Define to 1 if you have the `getgroups' function. */
#cmakedefine HAVE_GETGROUPS 1

/* Define to 1 if you have the <inttypes.h> header file. */
#cmakedefine HAVE_INTTYPES_H 1

/* Define to 1 if you have the `readline' library (-lreadline). */
#cmakedefine HAVE_LIBREADLINE 1

/* Define to 1 if you have the `lstat' function. */
#cmakedefine HAVE_LSTAT 1

/* Define to 1 if you have the <memory.h> header file. */
#cmakedefine HAVE_MEMORY_H 1

/* Define to 1 if you have the `mkfifo' function. */
#cmakedefine HAVE_MKFIFO 1

/* Define to 1 if you have the <ndir.h> header file, and it defines `DIR'. */
#cmakedefine HAVE_NDIR_H 1

/* Define to 1 if you have the `getgroups' function with POSIX semantics. */
#cmakedefine HAVE_POSIX_GETGROUPS 1

/* Define to 1 if you have /proc/self/fd. */
#cmakedefine HAVE_PROC_SELF_FD 1

/* Define to 1 if you have the `quad_t' type. */
#cmakedefine HAVE_QUAD_T 1

/* Define to 1 if system calls automatically restart after interruption by a
   signal. */
#cmakedefine HAVE_RESTARTABLE_SYSCALLS 1

/* Define to 1 if you have the `rlim_t' type. */
#cmakedefine HAVE_RLIM_T 1

/* Define to 1 if you have the `setpgrp' function. */
#cmakedefine HAVE_SETPGRP 1

/* Define to 1 if you have the `setrlimit' function. */
#cmakedefine HAVE_SETRLIMIT 1

/* Define to 1 if you have the `sigaction' function. */
#cmakedefine HAVE_SIGACTION 1

/* Define to 1 if you have the `sigsetjmp' function or macro. */
#cmakedefine HAVE_SIGSETJMP 1

/* Define to 1 if you have the <stdint.h> header file. */
#cmakedefine HAVE_STDINT_H 1

/* Define to 1 if you have the <stdlib.h> header file. */
#cmakedefine HAVE_STDLIB_H 1

/* Define to 1 if you have the `strerror' function or macro. */
#cmakedefine HAVE_STRERROR 1

/* Define to 1 if you have the <strings.h> header file. */
#cmakedefine HAVE_STRINGS_H 1

/* Define to 1 if you have the <string.h> header file. */
#cmakedefine HAVE_STRING_H 1

/* Has SysV SIGCLD */
#cmakedefine HAVE_SYSV_SIGCLD 1

/* Define to 1 if you have the <sys/dir.h> header file, and it defines `DIR'.
   */
#cmakedefine HAVE_SYS_DIR_H 1

/* Define to 1 if you have the <sys/ndir.h> header file, and it defines `DIR'.
   */
#cmakedefine HAVE_SYS_NDIR_H 1

/* Define to 1 if you have the <sys/resource.h> header file. */
#cmakedefine HAVE_SYS_RESOURCE_H 1

/* Define to 1 if you have the <sys/stat.h> header file. */
#cmakedefine HAVE_SYS_STAT_H 1

/* Define to 1 if you have the <sys/time.h> header file. */
#cmakedefine HAVE_SYS_TIME_H 1

/* Define to 1 if you have the <sys/types.h> header file. */
#cmakedefine HAVE_SYS_TYPES_H 1

/* Define to 1 if you have <sys/wait.h> that is POSIX.1 compatible. */
#cmakedefine HAVE_SYS_WAIT_H 1

/* Define to 1 if you have the <unistd.h> header file. */
#cmakedefine HAVE_UNISTD_H 1

/* Name of package */
#define PACKAGE "@PACKAGE@"

/* Define to the address where bug reports for this package should be sent. */
#define PACKAGE_BUGREPORT "@PACKAGE_BUGREPORT@"

/* Define to the full name of this package. */
#define PACKAGE_NAME "@PACKAGE_NAME@"

/* Define to the full name and version of this package. */
#define PACKAGE_STRING "@PACKAGE_STRING@"

/* Define to the one symbol short name of this package. */
#define PACKAGE_TARNAME "@PACKAGE_TARNAME@"

/* Define to the version of this package. */
#define PACKAGE_VERSION "@PACKAGE_VERSION@"

/* Define to 1 to encode exported environment names. */
#cmakedefine PROTECT_ENV 1

/* Define to 1 to use addon functions. */
#cmakedefine RC_ADDON 1

/* Define to 1 to include `echo' as a builtin. */
#cmakedefine RC_ECHO 1

/* Define to 1 to use job-control-style backgrounding. */
#cmakedefine RC_JOB 1

/* Define to 1 if you are using GNU `readline'. */
#cmakedefine READLINE 1

/* Define to 1 for older versions GNU `readline'. */
#cmakedefine READLINE_OLD 1

/* Release date */
#define RELDATE "@RELDATE@"

/* Define to 1 if `_KERNEL' must be defined for `RLIMIT_*' macros. */
#cmakedefine RLIMIT_NEEDS_KERNEL 1

/* Define to 1 if `rlim_t' is `quad_t'. */
#cmakedefine RLIM_T_IS_QUAD_T 1

/* Define to 1 if the `setpgrp' function takes no argument. */
#cmakedefine SETPGRP_VOID 1

/* Define to 1 if you have the ANSI C header files. */
#cmakedefine STDC_HEADERS 1

/* Version number of package */
#cmakedefine VERSION "@VERSION@"

/* Number of bits in a file offset, on hosts where this is settable. */
#define _FILE_OFFSET_BITS @_FILE_OFFSET_BITS@

/* Define for large files, on AIX-style hosts. */
#cmakedefine _LARGE_FILES

/* Define to `int' if <sys/types.h> doesn't define. */
#cmakedefine gid_t

/* Define to `int' if <sys/types.h> does not define. */
#cmakedefine pid_t

/* Define to 1 if you have the `sig_atomic_t' type. */
#cmakedefine sig_atomic_t 1

/* Define to `unsigned' if <sys/types.h> does not define. */
#cmakedefine size_t

/* Define to `long' if <sys/types.h> does not define. */
#cmakedefine ssize_t

/* Define to `int' if <sys/types.h> doesn't define. */
#cmakedefine uid_t
