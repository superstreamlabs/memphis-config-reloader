FROM golang:1.17 AS build
COPY . /go/src/reloader
WORKDIR /go/src/reloader
ARG VERSION
RUN CGO_ENABLED=0 GOOS=linux go build -o /go/src/reloader/ -ldflags "-s -w" -a 

FROM alpine:latest as osdeps
RUN apk add --no-cache ca-certificates

FROM alpine:3.15
COPY --from=build /go/src/reloader/* /usr/local/bin/memphis-config-reloader
COPY --from=osdeps /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

CMD ["memphis-config-reloader"]
