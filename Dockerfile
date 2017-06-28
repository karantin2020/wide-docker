# Dockerfile for https://github.com/b3log/wide

FROM        golang:1.8.3-alpine3.6 as builder

ENV         GOPATH /go

RUN         apk add --update git build-base; \
            go get -u -v -d github.com/b3log/wide; \
            mkdir -p /wide; \
            cd $GOPATH/src/github.com/b3log/wide; \
            go build -ldflags="-s -w" -v -o wide; \
            ./wide -v; \
            ./wide -h

FROM        alpine:3.6
RUN         apk --no-cache add ca-certificates; \
            mkdir -p /wide
WORKDIR     /wide
COPY        --from=builder /go/src/github.com/b3log/wide .

EXPOSE      7070

ENTRYPOINT  ["/wide"]
CMD         ["-docker=true", "-channel=ws://127.0.0.1:7070"]
