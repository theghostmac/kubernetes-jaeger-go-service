package main

import (
	"github.com/jaegertracing/jaeger-client-go"
	"github.com/opentracing/opentracing-go"
	"net/http"

	"github.com/gorilla/mux"
	"github.com/jaegertracing/jaeger-client-go/config"
)

func main() {
	// Create Jaeger tracer
	cfg := config.Configuration{
		Sampler: &config.SamplerConfig{
			Type:  "const",
			Param: 1,
		},
		Reporter: &config.ReporterConfig{
			LogSpans: true,
		},
	}
	tracer, _, err := cfg.New("kubernetes-jaeger-go-service", config.Logger(jaeger.StdLogger))
	if err != nil {
		panic(err)
	}
	opentracing.SetGlobalTracer(tracer)

	router := mux.NewRouter()
	router.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		// Start a new span
		span := opentracing.StartSpan("/")
		defer span.Finish()

		w.Write([]byte("This application demos a web service deployed on Kubernetes."))
	})
	http.ListenAndServe(":8080", router)
}
