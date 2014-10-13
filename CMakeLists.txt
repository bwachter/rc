cmake_minimum_required(VERSION 2.6)
cmake_policy(VERSION 2.6)

set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/CMake/Modules)

project(rc)

set (PACKAGE "rc")

if (NOT VERSION)
  set(VERSION 1.8.0)
endif()

# use /bin/foo as default interpreter (/bin/sh)
if (NOT DEFAULTINTERP)
  set (DEFAULTINTERP "\"/bin/sh\"")
endif()

# set default path
if (NOT DEFAULTPATH)
  set (DEFAULTPATH "\"/usr/local/bin\",\"/usr/bin\",\"/bin\",\".\"")
endif()

# add some sane defaults
# to enable e.g. readline, do cmake -Dwith-readline=ON .
option(with-history "Build history subprograms" ON)
option(with-readline "Use readline" OFF)
option(with-editline "Simmule Turner's line editing" OFF)
option(with-vrl "Gert-Jan Vons's line editing" OFF)
option(RC_ECHO "Have 'echo' as builtin" ON)
option(RC_JOB "Have job-control-style backgrounding" ON)
option(PROTECT_ENV "Protect environment names" ON)

#  --with-addon=foo.c    Extra builtins, from addon.c by default
#  --disable-largefile     omit support for large files

if(${with-readline} STREQUAL "ON")
  find_package(Readline REQUIRED)
  set(READLINE 1)
  set(EXTRA_LIBRARIES ${EXTRA_LIBRARIES} ${READLINE_LIBRARY})
endif()

if(${with-editline} STREQUAL "ON")
  find_package(Editline REQUIRED)
  set(EDITLINE 1)
  set(EXTRA_LIBRARIES ${EXTRA_LIBRARIES} ${EDITLINE_LIBRARY})
endif()

if(${with-vrl} STREQUAL "ON")
  set(EDITLINE 1)
endif()

include (CheckIncludeFiles)
include (CheckFunctionExists)
include (CheckTypeSize)
include (CheckSymbolExists)

check_include_files (dirent.h HAVE_DIRENT_H)
check_include_files (inttypes.h HAVE_INTTYPES_H)
check_include_files (memory.h HAVE_MEMORY_H)
check_include_files (ndir.h HAVE_NDIR_H)
check_include_files (stdint.h HAVE_STDINT_H)
check_include_files (stdlib.h HAVE_STDLIB_H)
check_include_files (strings.h HAVE_STRINGS_H)
check_include_files (string.h HAVE_STRING_H)
# add checks for SYS_DIR and SYS_NDIR
check_include_files (sys/resource.h HAVE_SYS_RESOURCE_H)
check_include_files (sys/stat.h HAVE_SYS_STAT_H)
check_include_files (sys/time.h HAVE_SYS_TIME_H)
check_include_files (sys/types.h HAVE_SYS_TYPES_H)
check_include_files (sys/wait.h HAVE_SYS_WAIT_H)
check_include_files (unistd.h HAVE_UNISTD_H)

check_function_exists(getgroups HAVE_GETGROUPS)
check_function_exists(strerror HAVE_STRERROR)
check_function_exists(lstat HAVE_LSTAT)
check_function_exists(setpgrp HAVE_SETPGRP)
# TODO: check if this macro fails with BSD-stylp SETPGRP
check_function_exists(setpgrp SETPGRP_VOID)
check_function_exists(setrlimit HAVE_SETRLIMIT)
check_function_exists(sigaction HAVE_SIGACTION)

check_symbol_exists(sigsetjmp "setjmp.h" HAVE_SIGSETJMP)

if(NOT HAVE_SIGSETJMP)
  if(HAVE_SETJMP_H)
    check_symbol_exists(sigsetjmp "setjmp.h" HAVE_MACRO_SIGSETJMP)
    if(HAVE_MACRO_SIGSETJMP)
      set(HAVE_SIGSETJMP 1)
    endif()
  endif()
endif()

if(${HAVE_SYS_RESOURCE_H})
  set (CMAKE_EXTRA_INCLUDE_FILES sys/resource.h)
  check_type_size(rlim_t HAVE_RLIM_T)
  set (CMAKE_EXTRA_INCLUDE_FILES)
endif()

# FIXME add the remaining checks from STDC_HEADERS
# http://www.delorie.com/gnu/docs/autoconf/autoconf_50.html
check_include_files ("stdlib.h;stdarg.h;string.h;float.h" STDC_HEADERS)

# Try to figure out if the system has /dev/fd, /proc/self/fd
if(EXISTS "/dev/fd" AND IS_DIRECTORY "/dev/fd" AND EXISTS "/dev/fd/0" AND NOT IS_DIRECTORY "/dev/fd/0")
  set(HAVE_DEV_FD 1)
elseif(EXISTS "/proc/self/fd" AND IS_DIRECTORY "/proc/self/fd" AND EXISTS "/proc/self/fd/0" AND NOT IS_DIRECTORY "/proc/self/fd/0")
  set(HAVE_PROC_FD 1)
else()
  # TODO: HAVE_FIFO should be set if either mkfifo or mknod exist
  #       since that's fallback code for fallback code it's pretty low priority for now
  check_function_exists(mkfifo HAVE_FIFO)
  check_function_exists(mkfifo HAVE_MKFIFO)
endif()

### Hacks
set(GETGROUPS_T "gid_t")
set(HASH_BANG 1)
set(HAVE_POSIX_GETGROUPS 1)
set(HAVE_SYSV_SIGCLD 1)
set(_FILE_OFFSET_BITS 64)
###

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/config.h.cmake ${CMAKE_CURRENT_BINARY_DIR}/config.h)

include_directories(${CMAKE_CURRENT_BINARY_DIR})

#conditionally built files
#addon.o addon.h
#system-bsd.o

set (SRCS
  edit.h
  getgroups.h
  input.h
  jbwrap.h
  parse.h
  proto.h
  rc.h
  rlimit.h
  stat.h
  wait.h
  builtins.c
  except.c
  exec.c
  fn.c
  footobar.c
  getopt.c
  glob.c
  glom.c
  hash.c
  heredoc.c
  input.c
  lex.c
  list.c
  main.c
  match.c
  nalloc.c
  open.c
  parse.c
  print.c
  redir.c
  signal.c
  status.c
  system.c
  tree.c
  utils.c
  var.c
  wait.c
  walk.c
  which.c
)

# add conditionally built files

if (${READLINE})
  set(SRCS ${SRCS} edit-gnu.c)
elseif(${EDITLINE})
  set(SRCS ${SRCS} edit-bsd.c)
else()
    set(SRCS ${SRCS} edit-null.c)
endif()

if(NOT ${HASH_BANG})
  set (SRCS ${SRCS} execve.c)
endif()


add_executable(mkstatval mkstatval.c)
add_custom_command(
  OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/statval.h
  COMMAND ${CMAKE_CURRENT_BINARY_DIR}/mkstatval > ${CMAKE_CURRENT_BINARY_DIR}/statval.h
  COMMENT "Generating statval.h"
  DEPENDS mkstatval
  )
set (SRCS ${SRCS} statval.h)

add_executable(mksignal mksignal.c)
add_custom_command(
  OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/sigmsgs.h ${CMAKE_CURRENT_BINARY_DIR}/sigmsgs.c
  COMMAND ${CMAKE_CURRENT_BINARY_DIR}/mksignal
  DEPENDS mksignal
  COMMENT "Generating sigmsgs.c and sigmsgs.h"
  )
set (SRCS ${SRCS} sigmsgs.h sigmsgs.c)

add_executable(rc ${SRCS})
add_dependencies(rc mksignal mkstatval)
target_link_libraries(rc ${EXTRA_LIBRARIES})

if(${with-history} STREQUAL "ON")
  add_executable(history rc.h history.c)
endif()

add_executable(tripping tripping.c)
