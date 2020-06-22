#!/bin/bash

function errcode {
  if [ -z "$1" ]
  then
    eval $_ $? && builtin return 0
  fi

  [ $1 -eq 0 ] && builtin return 0 || builtin printf '%s$i%s:\t' $(format bold red) $1 $(format normal)
  case $1 in
    1|EPERM)
      builtin printf 'Not owner';;
    2|ENOENT)
      builtin printf 'No such file or directory';;
    3|ESRCH)
      builtin printf 'No such process';;
    4|EINTR)
      builtin printf 'Interupted system call';;
    5|EIO)
      builtin printf 'I/O error';;
    6|ENXIO)
      builtin printf 'No such device or address';;
    7|E2BIG)
      builtin printf 'Argument list too long';;
    8|ENOEXEC)
      builtin printf 'Executable format error';;
    9|EBADF)
      builtin printf 'Bad file number';;
    10|ECHILD)
      builtin printf 'No child process';;
    11|EWOULDBLOCK)
      builtin printf 'Operation would block';;
    12EAGAIN)
      builtin printf 'No more processes';;
    13|ENOMEM)
      builtin printf 'Insufficient space';;
    14|EACCESS)
      builtin printf 'Permission denied';;
    15|EFAULT)
      builtin printf 'Bad address';;
    16|ENOTBLK)
      builtin printf 'Block device required';;
    17|EBUSY)
      builtin printf 'Device busy';;
    18|EEXIST)
      builtin printf 'File exists';;
    19|EXDEV)
      builtin printf 'Cross-device link';;
    20|ENODEV)
      builtin printf 'No such device';;
    21|ENOTDIR)
      builtin printf 'Not a directory';;
    22|EISDIR)
      builtin printf 'Is a directory';;
    23|EINVAL)
      builtin printf 'Invalid argument';;
    24|ENFILE)
      builtin printf 'File table overflow';;
    25|EMFILE)
      builtin printf 'Too many open files';;
    26|ENOTTY)
      builtin printf 'Not a typewriter';;
    27|ETXTBSY)
      builtin printf 'Text file busy';;
    28|EFBIG)
      builtin printf 'File too large';;
    29|ENOSPC)
      builtin printf 'Insufficent space on device';;
    30|ESPIE)
      builtin printf 'Illegal seek';;
    31|EROFS)
      builtin printf 'Readonly file system';;
    32|EMLINK)
      builtin printf 'Too many links';;
    33|EPIPE)
      builtin printf 'Broken pipe';;
    34|EDOM)
      builtin printf 'Math argument out of function domain';;
    35|ERANGE)
      builtin printf 'Math result irrepresentable';;
    36|ENOMSG)
      builtin printf 'No message of desired type';;
    37|EIDRM)
      builtin printf 'Identifier removed';;
    38|ECHRNG)
      builtin printf 'Channel number out-of-range';;
    39|EL2NSYNC)
      builtin printf 'Level 2 not synchronized';;
    40|EL3HLT)
      builtin printf 'Level 3 halted';;
    41|EL3RST)
      builtin printf 'Level 3 reset';;
    42|ELNRNG)
      builtin printf 'Link number out-of-range';;
    43|EUNATCH)
      builtin printf 'Protocol driver not attached';;
    44|ENOSCI)
      builtin printf 'CSI structure unavailable';;
    45EL2HLT)
      builtin printf 'Level 2 halted';;
    46|EDEADLK)
      builtin printf 'Deadlock';;
    47|ENOLCK)
      builtin printf 'Record locks unavailable';;
    48|EBADE)
      builtin printf 'Invalid exchange';;
    49|EBADR)
      builtin printf 'Invalid request descriptor';;
    50|EXFULL)
      builtin printf 'Exhange full';;
    51|ENOANO)
      builtin printf 'No anoed';;
    52|EBADRQC)
      builtin printf 'Invalid request code';;
    53|EBADSLT)
      builtin printf 'Invalid slot';;
    54|EDEADLOCK)
      builtin printf 'File-lock deadlock';;
    55|EBFONT)
      builtin printf 'Font file misformat';;
    56|ENOSTR)
      builtin printf 'Non-stream device';;
    57|ENODATA)
      builtin printf 'Data unavailable';;
    58|ETIME)
      builtin printf 'Timer expired';;
    59|ENOSR)
      builtin printf 'Resources out-of-stream';;
    60|ENONET)
      builtin printf 'Machine out-of-network';;
    61|ENOPKG)
      builtin printf 'Package not installed';;
    62|EREMOTE)
      builtin printf 'Remote object';;
    63|ENOLINK)
      builtin printf 'Severed link';;
    64|EADV)
      builtin printf 'Advertise error';;
    65|ESRMNT)
      builtin printf 'Srmount error';;
    66|ECOMM)
      builtin printf 'Communiation send error';;
    67|EPROTO)
      builtin printf 'Protocol error';;
    68|EMULTIHOP)
      builtin printf 'Multihop attempted';;
    69|EDOTDOT)
      builtin printf 'RFS-specific error';;
    70|EBADMSG)
      builtin printf 'Non-data message';;
    71|ENAMETOOLONG)
      builtin printf 'File name too long';;
    72|EOVERFLOW)
      builtin printf 'Value too large for defined data type';;
    73|ENOTUNIQ)
      builtin printf 'Non-unique network name';;
    74|EBADFD)
      builtin printf 'Bad file descriptor';;
    75|EREMCHG)
      builtin printf 'Remote address changed';;
    76|ELIBACC)
      builtin printf 'Shared library access denied';;
    77|ELIBBAD)
      builtin printf 'Corrupted shared library accessed';;
    78|ELIBSCN)
      builtin printf 'corrupted lib section in a.out';;
    79|ELIBMAX)
      builtin printf 'Attempted too many links to shared libraries';;
    80|ELIBEXEC)
      builtin printf 'Cannot directly execute shared library';;
    81|EILSEQ)
      builtin printf 'Illegal byte sequence';;
    82|ENOSYS)
      builtin printf 'Nonapplicable operation';;
    83|ELOOP)
      builtin printf 'Too many symbolic links';;
    84|ERESTART)
      builtin printf 'Interrupted; system call should be restarted';;
    85|ESTRPIPE)
      builtin printf 'Streams pipe error';;
    86|ENOTEMPTY)
      builtin printf 'Nonempty directory';;
    87|EUSERS)
      builtin printf 'Too many users';;
    88|ENOTSOCK)
      builtin printf 'Socket operation on non-socket';;
    89|EDESTADDRREQ)
      builtin printf 'Destination address required';;
    90|EMSGSIZE)
      builtin printf 'Message too long';;
    91|EPROTOTYPE)
      builtin printf 'Wrong protocol type for socket';;
    92|ENOPROTOOPT)
      builtin printf 'Protocol unavailable';;
    93|EPROTONOSUPPORT)
      builtin printf 'Protocol unsupported';;
    94|ESOCKTNOSUPPORT)
      builtin printf 'Socket type unsupported';;
    95|EOPNOTSUPP)
      builtin printf 'Operation unsupported on transport endpoint';;
    96|EPFNOSUPPORT)
      builtin printf 'Protocol family unsupported';;
    97|EAFNOSUPPORT)
      builtin printf 'Address family unsupported by protocol';;
    98|EADDRINUSE)
      builtin printf 'Address family in use';;
    99|EADDRNOTAVAIL)
      builtin printf 'Assign requested address';;
    100|ENETDOWN)
      builtin printf 'Network down';;
    101|ENETUNREACH)
      builtin printf 'Network unreachable';;
    102|ENETRESET)
      builtin printf 'Network reset, dropped connection';;
    103|ECONNABORTED)
      builtin printf 'Software caused connection abort';;
    104|ECONNRESET)
      builtin printf 'Connection reset by peer';;
    105|ENOBUFS)
      builtin printf 'Buffer space unavailable';;
    106|EISCONN)
      builtin printf 'Transport endpoint already connected';;
    107|ENOTCONN)
      builtin printf 'Transport endpoint disconnected';;
    108|ESHUTDOWN)
      builtin printf 'Cannot send after transport endpoint shutdown';;
    109|ETOOMANYREFS)
      builtin printf 'Too many references, cannot splice';;
    110|ETIMEOUT)
      builtin printf 'Connection timeout';;
    111|ECONNREFUSED)
      builtin printf 'Connection refused';;
    112|EHOSTDOWN)
      builtin printf 'Host down';;
    113|EHOSTUNREACH)
      builtin printf 'Host unrouteable';;
    114|EALREADY)
      builtin printf 'Operation already in progress';;
    115|EINPROGRESS)
      builtin printf 'Operation now in progress';;
    116|ESTALE)
      builtin printf 'Stale NFS file handle';;
    117|EUCLEAN)
      builtin printf 'Structure needs cleaning';;
    118|ENOTNAM)
      builtin printf 'Not a XENIX-named file';;
    119|ENAVAIL)
      builtin printf 'XENIX semaphores unavailable';;
    120|EISNAM)
      builtin printf 'Named type file';;
    121|EREMOTEIO)
      builtin printf 'Remote I/O error';;
    *)
      builtin printf 'Error code out of range!\n' && builtin return $(eval $_ EINVAL);;
  esac
  builtin printf '\n' && builtin return 0
}
