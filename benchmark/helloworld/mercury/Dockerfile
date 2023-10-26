FROM alpine:latest

RUN apk --no-cache add gcc musl-dev
RUN apk --no-cache add mercury

COPY hello.m hello.m
RUN mmc -O6 hello.m
RUN ./hello
RUN echo '/hello' > files
RUN ldd hello | awk 'NF == 4 {print $3}; NF == 2 {print $1}' | sort | uniq >> files
RUN ls -l $(cat files) | awk '{ total += $5 }; END { printf("\"mercury\" -> %s\n", total) }' > result
