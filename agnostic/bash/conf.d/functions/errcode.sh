#!/bin/bash

function errcode {
  if [ -z "$1" ]
  then
    for errno in (seq 1 121)
    do
      eval $_ $errno
    done
    return 0
  fi

  case $1 in
    0)
      return 0
      ;;
    1|EPERM)
      echo 'Not owner'
      ;;
    2|ENOENT)
      echo 'No such file or directory'
      ;;
    3|ESRCH)
      echo 'No such process'
      ;;
    4|EINTR)
      echo 'Interrupted system call'
      ;;
    5|EIO)
      echo 'I/O error'
      ;;
    6|ENXIO)
      echo 'No such device or address'
      ;;
    7|E2BIG)
      echo 'Arg list too long'
      ;;
    8|ENOEXEC)
      echo 'Exec format error'
      ;;
    9|EBADF)
      echo 'Bad file number'
      ;;
    10|ECHILD)
      echo 'No child processes'
      ;;
    11|EWOULDBLOCK)
      echo 'Operation would block'
      ;;
    12|EAGAIN)
      echo 'No more processes'
      ;;
    13|ENOMEM)
      echo 'Not enough space'
      ;;
    14|EACCES)
      echo 'Permission denied'
      ;;
    15|EFAULT)
      echo 'Bad address'
      ;;
    16|ENOTBLK)
      echo 'Block device required'
      ;;
    17|EBUSY)
      echo 'Device busy'
      ;;
    18|EEXIST)
      echo 'File exists'
      ;;
    19|EXDEV)
      echo 'Cross-device link'
      ;;
    20|ENODEV)
      echo 'No such device'
      ;;
    21|ENOTDIR)
      echo 'Not a directory'
      ;;
    22|EISDIR)
      echo 'Is a directory'
      ;;
    23|EINVAL)
      echo 'Invalid argument'
      ;;
    24|ENFILE)
      echo 'File table overflow'
      ;;
    25|EMFILE)
      echo 'Too many open files'
      ;;
    26|ENOTTY)
      echo 'Not a typewriter'
      ;;
    27|ETXTBSY)
      echo 'Text file busy'
      ;;
    28|EFBIG)
      echo 'File too large'
      ;;
    29|ENOSPC)
      echo 'No space left on device'
      ;;
    30|ESPIPE)
      echo 'Illegal seek'
      ;;
    31|EROFS)
      echo 'Read-only file system'
      ;;
    32|EMLINK)
      echo 'Too many links'
      ;;
    33|EPIPE)
      echo 'Broken pipe'
      ;;
    34|EDOM)
      echo 'Math argument out of domain of func'
      ;;
    35|ERANGE)
      echo 'Math result not representable'
      ;;
    36|ENOMSG)
      echo 'No message of desired type'
      ;;
    37|EIDRM)
      echo 'Identifier removed'
      ;;
    38|ECHRNG)
      echo 'Channel number out of range'
      ;;
    39|EL2NSYNC)
      echo 'Level 2 not synchronized'
      ;;
    40|EL3HLT)
      echo 'Level 3 halted'
      ;;
    41|EL3RST)
      echo 'Level 3 reset'
      ;;
    42|ELNRNG)
      echo 'Link number out of range'
      ;;
    43|EUNATCH)
      echo 'Protocol driver not attached'
      ;;
    44|ENOCSI)
      echo 'No CSI structure available'
      ;;
    45|EL2HLT)
      echo 'Level 2 halted'
      ;;
    46|EDEADLK)
      echo 'Deadlock condition'
      ;;
    47|ENOLCK)
      echo 'No record locks available'
      ;;
    48|EBADE)
      echo 'Invalid exchange'
      ;;
    49|EBADR)
      echo 'Invalid request descriptor'
      ;;
    50|EXFULL)
      echo 'Exchange full'
      ;;
    51|ENOANO)
      echo 'No anode'
      ;;
    52|EBADRQC)
      echo 'Invalid request code'
      ;;
    53|EBADSLT)
      echo 'Invalid slot'
      ;;
    54|EDEADLOCK)
      echo 'File locking deadlock error'
      ;;
    55|EBFONT)
      echo 'Bad font file format'
      ;;
    56|ENOSTR)
      echo 'Device not a stream'
      ;;
    57|ENODATA)
      echo 'No data available'
      ;;
    58|ETIME)
      echo 'Timer expired'
      ;;
    59|ENOSR)
      echo 'Out of streams resources'
      ;;
    60|ENONET)
      echo 'Machine is not on the network'
      ;;
    61|ENOPKG)
      echo 'Package not installed'
      ;;
    62|EREMOTE)
      echo 'Object is remote'
      ;;
    63|ENOLINK)
      echo 'Link has been severed'
      ;;
    64|EADV)
      echo 'Advertise error'
      ;;
    65|ESRMNT)
      echo 'Srmount error'
      ;;
    66|ECOMM)
      echo 'Communication error on send'
      ;;
    67|EPROTO)
      echo 'Protocol error'
      ;;
    68|EMULTIHOP)
      echo 'Multihop attempted'
      ;;
    69|EDOTDOT)
      echo 'RFS specific error'
      ;;
    70|EBADMSG)
      echo 'Not a data message'
      ;;
    71|ENAMETOOLONG)
      echo 'File name too long'
      ;;
    72|EOVERFLOW)
      echo 'Value too large for defined data type'
      ;;
    73|ENOTUNIQ)
      echo 'Name not unique on network'
      ;;
    74|EBADFD)
      echo 'File descriptor in bad state'
      ;;
    75|EREMCHG)
      echo 'Remote address changed'
      ;;
    76|ELIBACC)
      echo 'Can not access a needed shared library'
      ;;
    77|ELIBBAD)
      echo 'Accessing a corrupted shared library'
      ;;
    78|ELIBSCN)
      echo 'lib section in a.out corrupted'
      ;;
    79|ELIBMAX)
      echo 'Attempting to link in too many shared libraries'
      ;;
    80|ELIBEXEC)
      echo 'Cannot exec a shared library directly'
      ;;
    81|EILSEQ)
      echo 'Illegal byte sequence'
      ;;
    82|ENOSYS)
      echo 'Operation not applicable'
      ;;
    83|ELOOP)
      echo 'Too many symbolic links encountered'
      ;;
    84|ERESTART)
      echo 'Interrupted system call should be restarted'
      ;;
    85|ESTRPIPE)
      echo 'Streams pipe error'
      ;;
    86|ENOTEMPTY)
      echo 'Directory not empty'
      ;;
    87|EUSERS)
      echo 'Too many users'
      ;;
    88|ENOTSOCK)
      echo 'Socket operation on non-socket'
      ;;
    89|EDESTADDRREQ)
      echo 'Destination address required'
      ;;
    90|EMSGSIZE)
      echo 'Message too long'
      ;;
    91|EPROTOTYPE)
      echo 'Protocol wrong type for socket'
      ;;
    92|ENOPROTOOPT)
      echo 'Protocol not available'
      ;;
    93|EPROTONOSUPPORT)
      echo 'Protocol not supported'
      ;;
    94|ESOCKTNOSUPPORT)
      echo 'Socket type not supported'
      ;;
    95|EOPNOTSUPP)
      echo 'Operation not supported on transport endpoint'
      ;;
    96|EPFNOSUPPORT)
      echo 'Protocol family not supported'
      ;;
    97|EAFNOSUPPORT)
      echo 'Address family not supported by protocol'
      ;;
    98|EADDRINUSE)
      echo 'Address already in use'
      ;;
    99|EADDRNOTAVAIL)
      echo 'assign requested address'
      ;;
    100|ENETDOWN)
      echo 'Network is down'
      ;;
    101|ENETUNREACH)
      echo 'Network is unreachable'
      ;;
    102|ENETRESET)
      echo 'Network dropped connection because of reset'
      ;;
    103|ECONNABORTED)
      echo 'Software caused connection abort'
      ;;
    104|ECONNRESET)
      echo 'Connection reset by peer'
      ;;
    105|ENOBUFS)
      echo 'No buffer space available'
      ;;
    106|EISCONN)
      echo 'Transport endpoint is already connected'
      ;;
    107|ENOTCONN)
      echo 'Transport endpoint is not connected'
      ;;
    108|ESHUTDOWN)
      echo 'Cannot send after transport endpoint shutdown'
      ;;
    109|ETOOMANYREFS)
      echo 'Too many references: cannot splice'
      ;;
    110|ETIMEDOUT)
      echo 'Connection timed out'
      ;;
    111|ECONNREFUSED)
      echo 'Connection refused'
      ;;
    112|EHOSTDOWN)
      echo 'Host is down'
      ;;
    113|EHOSTUNREACH)
      echo 'No route to host'
      ;;
    114|EALREADY)
      echo 'Operation already in progress'
      ;;
    115|EINPROGRESS)
      echo 'Operation now in progress'
      ;;
    116|ESTALE)
      echo 'Stale NFS file handle'
      ;;
    117|EUCLEAN)
      echo 'Structure needs cleaning'
      ;;
    118|ENOTNAM)
      echo 'Not a XENIX named type file'
      ;;
    119|ENAVAIL)
      echo 'No XENIX semaphores available'
      ;;
    120|EISNAM)
      echo 'Is a named type file'
      ;;
    121|EREMOTEIO)
      echo 'Remote I/O error'
      ;;
    *)
      echo 'Error code out of range!'
      return (errno EINVAL)
      ;;
  esac
  return 0
}

