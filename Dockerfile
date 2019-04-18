FROM golang:1.12.4 as builder
RUN mkdir -p /go/src/tools-release
WORKDIR /go/src/tools-release
ADD . /go/src/tools-release
RUN go get -d -v ./...
RUN GOOS=linux go build -o target/tools-release .

FROM alpine:latest  
RUN apk --no-cache add ca-certificates
RUN mkdir -p /go/bin
COPY --from=builder /go/src/tools-release/target/tools-release /go/bin

EXPOSE 8080

CMD ["/go/bin/tools-release"]
