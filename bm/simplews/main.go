package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
)

var version string

func rootHandler(w http.ResponseWriter, r *http.Request) {
	var Body string

	switch r.URL.Path {
	case "/":
		Body = "Welcome to ReaQta!"
	case "/api":
		Body = "Welcome to ReaQta API"
	default:
		http.Error(w, "404 not found.", http.StatusNotFound)
		return
	}

	if version != "" {
		Body = Body + " version " + version
	}
	fmt.Fprint(w, Body)
	log.Printf("[%s] %s", r.RemoteAddr, r.URL.Path)
}

func hcHandler(w http.ResponseWriter, r *http.Request) {
	if r.URL.Path == "/health" {
		fmt.Fprint(w, "ok")
	} else {
		http.Error(w, "404 not found.", http.StatusNotFound)
		return
	}
}
func main() {
	PORT := ":8081"
	arguments := os.Args
	if len(arguments) == 1 {
		log.Println("Using default port number", PORT)
	} else if len(arguments) == 2 {
		PORT = ":" + arguments[1]
	} else {
		log.Fatal("Usage: ./simplews [port{:int}]")
		log.Fatalf("Too many args to run:%d", len(arguments))
	}

	http.HandleFunc("/health", hcHandler)
	http.HandleFunc("/", rootHandler)

	err := http.ListenAndServe(PORT, nil)
	if err != nil {
		log.Fatal(err)
	}
}
