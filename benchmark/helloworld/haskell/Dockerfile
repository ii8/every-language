FROM alpine:latest

RUN apk --no-cache add gcc musl-dev
RUN apk --no-cache add gmp-static ghc

COPY hello.hs hello.hs
RUN ghc -O2 -optl-static hello.hs
RUN strip hello
RUN ./hello
RUN stat -c '"haskell" -> %s' hello > result
