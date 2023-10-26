FROM alpine:latest

RUN apk --no-cache add gcc musl-dev
RUN apk --no-cache add lua-dev
RUN wget https://github.com/ers35/luastatic/archive/refs/tags/0.0.12.tar.gz \
 && tar -xf 0.0.12.tar.gz \
 && mv luastatic-0.0.12/luastatic.lua .

COPY hello.lua hello.lua

RUN ./luastatic.lua hello.lua /usr/lib/liblua.a -O2 -static
RUN strip hello
RUN ./hello
RUN stat -c '"lua" -> %s' hello > result
