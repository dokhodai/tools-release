PROJECT := tools-release
BINARY_NAME := $(PROJECT)
BUILDER_TAG ?= $(PROJECT)-builder
IMAGE_TAG ?= $(PROJECT)-img

all: test

gobuild:
	docker build --target builder -t $(BUILDER_TAG) .

test: gobuild
	docker run --rm $(BUILDER_TAG) go test -v ./...

build-image:
	docker build -t $(IMAGE_TAG) .

# static analysis
lint: vet fmtcheck

vet: gobuild
	docker run --rm $(BUILDER_TAG) go vet -v .
	@if [ $$? -eq 1 ]; then \
		echo "Vet found suspicious construsts. check your source code.";\
		exit 1; \
	fi

fmtcheck: gobuild
	docker run --rm $(BUILDER_TAG) gofmt -l `find . -name '*.go'` > gofmt.txt
	@if [ -s "gofmt.txt" ]; then \
		echo "gofmt needs running on the following files:";\
    	cat gofmt.txt;\
    	exit 1;\
	fi

