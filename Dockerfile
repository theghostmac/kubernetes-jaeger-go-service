# Use the Golang version 1.19 as the parent image
FROM golang:1.19 as builder

# Set the working directory to go/src/kubernetes-jaeger-go-service
WORKDIR /go/src/kubernetes-jaeger-go-service/
# Copy the current directory contents to the container at /go/src/kubernetes-jaeger-go-service
COPY . /go/src/kubernetes-jaeger-go-service

# CGO and Arch seem to be important.. I don see some shege with some 229 exec error.. I wan cry
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o main  .

FROM alpine:latest

# For SSL compatibility
RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*

COPY --from=builder /go/src/kubernetes-jaeger-go-service/main .

# Not a fan of long names but if you so choose you can comment line 17 and do this
# RUN mkdir /go/src/kubernetes-jaeger-go-service
# COPY --from=builder /go/src/kubernetes-jaeger-go-service/main /go/src/kubernetes-jaeger-go-service/

EXPOSE 8080

ENTRYPOINT ["./main"]
