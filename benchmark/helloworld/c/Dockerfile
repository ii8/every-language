FROM alpine:latest

RUN apk --no-cache add gcc musl-dev

COPY hello.c hello.c
RUN gcc -O2 -static hello.c
RUN strip a.out
RUN ./a.out
RUN stat -c '"c" -> %s' a.out > result
