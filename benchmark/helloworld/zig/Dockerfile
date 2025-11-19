FROM alpine:latest

RUN apk --no-cache add zig

COPY hello.zig hello.zig
RUN zig build-exe -O ReleaseSmall hello.zig
RUN ./hello
RUN stat -c '"zig" -> %s' hello > result
