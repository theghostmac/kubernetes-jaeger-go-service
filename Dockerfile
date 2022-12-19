FROM golang:1.19 as builder
WORKDIR /app
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o my-service ./cmd/

FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /app/kubernetes-jaeger-go-service .
CMD ["./my-service"]