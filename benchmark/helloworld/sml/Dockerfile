FROM alpine:latest

RUN apk --no-cache add gcc musl-dev
RUN apk --no-cache add gmp-dev
RUN wget https://github.com/ii8/mlton-builds/releases/download/git04d76908f/mlton-git04d76908f.x86_64-linux-musl.tar.gz \
 && tar -xf mlton-git04d76908f.x86_64-linux-musl.tar.gz \
 && cp -r mlton-git04d76908f.x86_64-linux-musl/* /usr/local/

COPY hello.sml hello.sml

RUN mlton -link-opt -static hello.sml
RUN strip hello
RUN ./hello
RUN stat -c '"sml" -> %s' hello > result
