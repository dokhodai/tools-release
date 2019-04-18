PROJECT := tools-release
BINARY_NAME := $(PROJECT)

all: test build

test: 
	go test -v ./...

build:
	go build -o target/tools-release .

clean:
	rm -rf target
