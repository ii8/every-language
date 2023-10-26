FROM alpine:3.18
#FROM alpine:latest

RUN apk --no-cache add clang musl-dev
RUN apk --no-cache add curl binutils-gold git

ENV PATH "/root/.local/share/ponyup/bin:$PATH"
RUN sh -c "$(curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/ponylang/ponyup/latest-release/ponyup-init.sh)" \
 && ponyup update ponyc release

COPY hello.pony hello.pony
RUN ponyc --static
RUN strip 1
RUN ./1
RUN stat -c '"pony" -> %s' 1 > result
