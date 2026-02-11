package main

import (
	"fmt"
	"io"
	"net/http"
	"time"

	"github.com/google/uuid"
)

func main() {
	var handler http.Handler = handler{}
	var mux *http.ServeMux = http.NewServeMux()
	mux.Handle("/api/", handler)

	server := &http.Server{
		Addr:         ":8080",
		Handler:      mux,
		ReadTimeout:  5 * time.Second,
		WriteTimeout: 15 * time.Second,
		IdleTimeout:  120 * time.Second,
	}

	fmt.Println("Go Backend starting on :8080...")
	var err error = server.ListenAndServe()
	if err != nil {
		fmt.Printf("Server error: %v\n", err)
	}
}

type handler struct{}

// implements http.Handler interface
func (h handler) ServeHTTP(rw http.ResponseWriter, r *http.Request) {
	var requestID string = uuid.New().String()
	fmt.Printf("[%s] Received request for /api/\n", requestID)

	var resp *http.Response
	var err error
	resp, err = http.Get("http://engine:5000/run")
	if err != nil {
		http.Error(rw, "Engine communication failed: "+err.Error(), http.StatusInternalServerError)
		return
	}
	defer resp.Body.Close()

	var body []byte
	body, err = io.ReadAll(resp.Body)
	if err != nil {
		http.Error(rw, "Failed to read engine response", http.StatusInternalServerError)
		return
	}

	rw.Header().Set("Content-Type", "application/json")
	rw.Header().Set("Access-Control-Allow-Origin", "*")
	rw.Write(body)
}
