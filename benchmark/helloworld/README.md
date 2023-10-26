# Hello, World!

The purpose of this benchmark is to estimate executable size overhead incurred
by language runtimes by measuring the size of simple executables.

The rules are:

- The program must print "Hello, World!" to stdout
- The program should be built inside an alpine:latest docker container.
- The source code of the hello world program should be idiomatic.
- The program must be statically linked. If external runtime components are
  required and the language does not support bundling them their size must be
  added to the final result as well.
- The program may be stripped of debug symbols.
- If a libc is linked it should be musl if possible.
- The final result should be stored in the root directory of the container in
  a file called `result`, the format is `"coolang" -> 35352` where `coolang`
  is the language being benchmarked and `35352` is the size in bytes of the
  hello world binary.

