FROM golang:1.12.4
RUN mkdir -p /go/src/tools-release
WORKDIR /go/src/tools-release
ADD . /go/src/tools-release
RUN go get -d -v ./...
RUN GOOS=linux go build -o target/tools-release .

