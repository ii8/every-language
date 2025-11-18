FROM alpine:latest

RUN apk --no-cache add gcc musl-dev
RUN apk --no-cache add gmp-dev gmp-static
RUN wget https://github.com/ii8/mlton-builds/releases/download/20241230/mlton-20241230.x86_64-linux-musl.tar.gz \
 && tar -xf mlton-20241230.x86_64-linux-musl.tar.gz \
 && cp -r mlton-on-20241230-release.x86_64-linux-musl/* /usr/local/

COPY hello.sml hello.sml

RUN mlton -link-opt -static hello.sml
RUN strip hello
RUN ./hello
RUN stat -c '"sml" -> %s' hello > result
