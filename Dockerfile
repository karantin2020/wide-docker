# Dockerfile for https://github.com/b3log/wide

FROM        golang:1.8.3-alpine3.6 as builder

ENV         GOPATH /go

RUN         apk add --update git build-base; \
            go get -u -v -d github.com/b3log/wide; \
            mkdir -p /wide; \
            cd $GOPATH/src/github.com/b3log/wide; \
            go build -ldflags="-s -w" -v -o wide; \
            cp -aH ./wide ./static/ ./views/ ./conf/ ./doc/ ./i18n/ ./README.md ./TERMS.md ./LICENSE ./.header.json ./.header.txt /wide/; \
            chmod +x /wide/wide; \
            rm -rf /wide/conf/*.go; \
            rm -rf /wide/i18n/*.go

FROM        golang:1.8.3-alpine3.6
RUN         apk --no-cache add ca-certificates git; \
            mkdir -p /wide; \
            go get -u -v github.com/visualfc/gotools github.com/nsf/gocode github.com/bradfitz/goimports
WORKDIR     /wide

COPY        --from=builder /wide/ .

EXPOSE      7070

ENTRYPOINT  ["/wide/wide", "-stat", "false"]
CMD         ["-docker=true", "-channel=ws://127.0.0.1:7070"]
