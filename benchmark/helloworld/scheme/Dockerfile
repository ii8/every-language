FROM alpine:latest

RUN apk --no-cache add gcc musl-dev
RUN apk --no-cache add chicken chicken-dev

COPY hello.scm hello.scm
RUN chicken hello.scm -explicit-use
RUN gcc -static -I/usr/include/chicken hello.c -O2 -fomit-frame-pointer -fno-strict-aliasing -o hello -lchicken
RUN strip hello
RUN ./hello
RUN stat -c '"scheme" -> %s' hello > result
