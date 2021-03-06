FROM rawmind/alpine-tools:3.5-1
MAINTAINER Raul Sanchez <rawmind@gmail.com>

ENV SERVICE_ARCHIVE=/opt/rancher-tools.tgz \
    GOMAXPROCS=2 \
    GOROOT=/usr/lib/go \
    GOPATH=/opt/src \
    GOBIN=/gopath/bin 

# Add files
ADD root /
RUN apk add --no-cache go git && \
    mkdir -p ${SERVICE_VOLUME}/scripts; cd /opt/src && \
    go get && \
    CGO_ENABLED=0 go build -v -installsuffix cgo -ldflags '-extld ld -extldflags -static' -a -x get_rancher_certificates.go && \
    mv ./get_rancher_certificates ${SERVICE_VOLUME}/scripts/ && \
    chmod 755 ${SERVICE_VOLUME}/scripts/get_rancher_certificates && \
    cd ${SERVICE_VOLUME} && \
    tar czvf ${SERVICE_ARCHIVE} * && \
    apk del go git && \
    rm -rf /var/cache/apk/* /opt/src ${SERVICE_VOLUME}/* 