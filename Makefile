.PHONY: default server client deps fmt clean all release-all assets client-assets server-assets contributors
export GOPATH:=$(shell pwd)

BUILDTAGS=debug
default: all

deps: assets
	go get -tags '$(BUILDTAGS)' -d -v ngrok/...

server: deps
	go install -tags '$(BUILDTAGS)' cmd/ngrokd

fmt:
	go fmt ngrok/...

client: deps
	go install -tags '$(BUILDTAGS)' cmd/ngrok

assets: client-assets server-assets

bin/go-bindata:
	GOOS="" GOARCH="" go get github.com/jteeuwen/go-bindata/go-bindata

client-assets: bin/go-bindata
	bin/go-bindata -nomemcopy -pkg=assets -tags=$(BUILDTAGS) \
		-debug=$(if $(findstring debug,$(BUILDTAGS)),true,false) \
		-o=src/github.com/hgsgtk/ngrok/internal/client/assets/assets_$(BUILDTAGS).go \
		assets/client/...

server-assets: bin/go-bindata
	bin/go-bindata -nomemcopy -pkg=assets -tags=$(BUILDTAGS) \
		-debug=$(if $(findstring debug,$(BUILDTAGS)),true,false) \
		-o=src/github.com/hgsgtk/ngrok/assets/server/assets_$(BUILDTAGS).go \
		assets/server/...

release-client: BUILDTAGS=release
release-client: client

release-server: BUILDTAGS=release
release-server: server

release-all: fmt release-client release-server

all: fmt client server

clean:
	go clean -i -r ngrok/...
	rm -rf src/github.com/hgsgtk/ngrok/internal/client/assets/ src/github.com/hgsgtk/ngrok/assets/server/

contributors:
	echo "Contributors to ngrok, both large and small:\n" > CONTRIBUTORS
	git log --raw | grep "^Author: " | sort | uniq | cut -d ' ' -f2- | sed 's/^/- /' | cut -d '<' -f1 >> CONTRIBUTORS
