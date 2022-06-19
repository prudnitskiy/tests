FROM golang:alpine AS builder

ENV CGO_ENABLED=0 GOOS=linux GOARCH=amd64
ARG VERSION
RUN apk update && apk add --no-cache git
WORKDIR app

COPY . .
RUN go get -d -v .
RUN go build -ldflags "-X main.version=$VERSION" -o /go/bin/simplews

FROM scratch
COPY --from=builder /go/bin/simplews /go/bin/simplews
EXPOSE 8081/tcp
ENTRYPOINT ["/go/bin/simplews"]
