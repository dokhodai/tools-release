PROJECT := tools-release
BINARY_NAME := $(PROJECT)
BUILDER_TAG ?= $(PROJECT)-builder
IMAGE_TAG ?= $(PROJECT)-img
VERSION ?= 1.0.0

all: test

gobuild:
	docker build --target builder -t $(BUILDER_TAG):$(VERSION) .

test: gobuild
	docker run --rm $(BUILDER_TAG):$(VERSION) go test -v ./...

build-image: build-local
	docker build -t $(IMAGE_TAG):$(VERSION) .

build-local: gobuild
	docker create --name gobuild-local $(BUILDER_TAG):$(VERSION)
	docker cp gobuild-local:/go/src/tools-release/target/tools-release .
	docker rm -f gobuild-local

# static analysis
lint: vet fmtcheck

vet: gobuild
	docker run --rm $(BUILDER_TAG):$(VERSION) go vet -v .
	@if [ $$? -eq 1 ]; then \
		echo "Vet found suspicious construsts. check your source code.";\
		exit 1; \
	fi

fmtcheck: gobuild
	docker run --rm $(BUILDER_TAG):$(VERSION) gofmt -l `find . -name '*.go'` > gofmt.txt
	@if [ -s "gofmt.txt" ]; then \
		echo "gofmt needs running on the following files:";\
    	cat gofmt.txt;\
    	exit 1;\
	fi

