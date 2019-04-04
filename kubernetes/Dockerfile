FROM golang:1.12.1-alpine

WORKDIR /go/src/github.com/aledbf/coredns-memory-spike

COPY . .

RUN apk add -u curl git \
    && curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh \
    && dep ensure

RUN CGO_ENABLED=0 GOOS=linux go build -o app .

FROM debian:buster-slim

RUN apt update && apt install curl ca-certificates -y --no-install-recommends

COPY --from=0 /go/src/github.com/aledbf/coredns-memory-spike/app app
COPY --from=0 /go/src/github.com/aledbf/coredns-memory-spike/scripts/download-binaries.sh /download-binaries.sh

ENV TEST_ASSET_KUBE_APISERVER=/assets/bin/kube-apiserver
ENV TEST_ASSET_ETCD=/assets/bin/etcd
ENV TEST_ASSET_KUBECTL=/assets/bin/kubectl 

RUN mkdir -p /assets/bin \
    && /download-binaries.sh

ENTRYPOINT ["/app"]
