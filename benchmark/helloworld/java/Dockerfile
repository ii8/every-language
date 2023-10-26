FROM alpine:latest

RUN apk --no-cache add gcc musl-dev
RUN apk --no-cache add openjdk17

COPY hello.java hello.java
RUN javac hello.java
RUN jar cfe hello.jar HelloWorld HelloWorld.class
RUN jlink --output runtime --add-modules java.base
RUN cp /lib/ld-musl-x86_64.so.1 runtime/lib/
RUN cp /lib/libz.so.1 runtime/lib/
RUN mv hello.jar runtime
RUN tar -cf hello runtime
RUN stat -c '"java" -> %s' hello > result
