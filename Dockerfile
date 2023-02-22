# Use the Golang versino 1.19 as the parent image
FROM golang:1.19 as builder
# Set the working directory to go/src/kubernetes-jaeger-go-service
WORKDIR /go/src/kubernetes-jaeger-go-service/
# Copy the current directory contents to the container at /go/src/kubernetes-jaeger-go-service
COPY . /go/src/kubernetes-jaeger-go-service
# Install depenendencies
RUN go mod download
# Build the application
RUN go build -o main
CMD ["go/src/kubernetes-jaeger-go-service"]
EXPOSE 8080