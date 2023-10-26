FROM alpine:latest

RUN apk --no-cache add gcc musl-dev
RUN apk --no-cache add go

COPY hello.go hello.go
RUN go build hello.go
RUN strip hello
RUN ./hello
RUN stat -c '"go" -> %s' hello > result
