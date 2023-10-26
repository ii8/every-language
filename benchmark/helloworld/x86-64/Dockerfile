FROM alpine:latest

RUN apk --no-cache add gcc

COPY hello.S hello.S
RUN as -c hello.S -o hello.o
RUN ld hello.o
RUN strip a.out
RUN ./a.out
RUN stat -c '"x86-64" -> %s' a.out > result
