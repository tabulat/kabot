.PHONY: check-go install-go setup-path

APP=$(shell basename $(shell git remote get-url origin))
REGISTRY=tabulat
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux #linux darwin windows
TARGETARCH=amd64 #arm64
GO_VERSION=1.24.2
GO_TARGET=go$(GO_VERSION).linux-amd64.tar.gz
GO_URL=https://go.dev/dl/$(GO_TARGET)
GO_INSTALL_DIR=/usr/local/go
GO_BIN_DIR=/usr/local/go/bin
PROFILE_FILE=$(shell if [ -n "$$ZSH_VERSION" ]; then echo ~/.zshrc; elif [ -f ~/.bashrc ]; then echo ~/.bashrc; else echo ~/.profile; fi)

check-go:
	@echo " Checking Go..."
	@if command -v go >/dev/null 2>&1; then \
		echo " Go already installed:"; \
		go version; \
	else \
		echo " Go not install. Running..."; \
		$(MAKE) install-go; \
	fi

install-go:
	@echo " Loading $(GO_URL)..."
	wget -q $(GO_URL)
	@echo " Unpack archiv..."
	sudo rm -rf $(GO_INSTALL_DIR)
	sudo tar -C /usr/local -xzf $(GO_TARGET)
	@echo " Remove archiv..."
	rm -f $(GO_TARGET)
	@echo " Go intall to $(GO_INSTALL_DIR)"
	$(MAKE) setup-path

setup-path:
	@echo " Setup PATH in $(PROFILE_FILE)..."
	@if ! grep -q 'export PATH=.*$(GO_BIN_DIR)' $(PROFILE_FILE); then \
		echo '\n# Go binary path\nexport PATH="$$PATH:$(GO_BIN_DIR)"' >> $(PROFILE_FILE); \
		echo " Go path added to $(PROFILE_FILE)"; \
	else \
		echo " Go path already exists in $(PROFILE_FILE)"; \
	fi
	#@echo " run: source $(PROFILE_FILE)"
	source $(PROFILE_FILE)

format: check-go
	gofmt -s -w ./

lint: check-go
	golint

get: check-go
	go get

test: check-go
	go test -v

build.l: format
	CGO_ENABLED=0 GOOS=linux GOARCH=${shell dpkg --print-architecture} go build -v -o kbot -ldflags "-X="github.com/tabulat/kabot/cmd.appVersion=${VERSION}

build.w: format
	CGO_ENABLED=0 GOOS=windows GOARCH=${shell dpkg --print-architecture} go build -v -o kbot -ldflags "-X="github.com/tabulat/kabot/cmd.appVersion=${VERSION}

build.m: format
	CGO_ENABLED=0 GOOS=darwin GOARCH=${shell dpkg --print-architecture} go build -v -o kbot -ldflags "-X="github.com/tabulat/kabot/cmd.appVersion=${VERSION}

image:
	#docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}
	#@echo "$$GHCR_TOKEN" | docker login ghcr.io -u tabulat --password-stdin
	docker build --platform linux/amd64,linux/arm64,darwin/amd64,darwin/arm64,windows/amd64,windows/arm64 . -t ghcr.io/${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

push:
	#docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}
	#@echo "$$GHCR_TOKEN" | docker login ghcr.io -u tabulat --password-stdin
	docker push ghcr.io/${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

clean:
	docker rmi ghcr.io/${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}