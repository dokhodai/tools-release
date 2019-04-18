PROJECT := tools-release
BINARY_NAME := $(PROJECT)

all: test build

test: 
	go test -v ./...

build:
	go build -o target/tools-release .

# static analysis
lint: vet fmtcheck

vet:
	go vet -v .
	@if [ $$? -eq 1 ]; then \
		echo "Vet found suspicious construsts. check your source code.";\
		exit 1; \
	fi

fmtcheck:
	gofmt -l `find . -name '*.go'` > gofmt.txt
	@if [ -s "gofmt.txt" ]; then \
		echo "gofmt needs running on the following files:";\
		cat gofmt.txt; \
		exit 1;\
	fi

clean:
	rm -rf target gofmt.txt
