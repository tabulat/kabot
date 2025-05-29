FROM --platform=$BUILDPLATFORM quay.io/projectquay/golang:1.21 AS builder
ARG TARGETOS
ARG TARGETARCH

WORKDIR /go/src/app
COPY . .
RUN GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -o /go/bin/kbot .

# --- Final stage ---
FROM --platform=$TARGETARCH ubuntu:22.04

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /
COPY --from=builder /go/bin/kbot .
#COPY --from=debian:latest /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
RUN test -f /etc/ssl/certs/ca-certificates.crt || (echo "❌ TLS not found!" && exit 1)
ENTRYPOINT ["./kbot", "start"]