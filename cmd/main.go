package main

import (
	"github.com/gorilla/mux"
	"net/http"
)

func main() {
	router := mux.NewRouter()
	router.HandleFunc("/", func(writer http.ResponseWriter, reader *http.Request) {
		writer.Write([]byte("This application demos a web service deployed on Kubernetes."))
	})
	http.ListenAndServe(":8080", router)
}
