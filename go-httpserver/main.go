package main

import (
	"fmt"
	"net/http"
	"net/http/httputil"

	"github.com/sirupsen/logrus"
	log "github.com/sirupsen/logrus"
)

func main() {
	hs := http.Server{
		Addr: ":8080",
	}

	mux := http.NewServeMux()
	hs.Handler = mux
	mux.HandleFunc("/", func(w http.ResponseWriter, req *http.Request) {
		bs, err := httputil.DumpRequest(req, false)
		if err != nil {
			logrus.Error(err)
			return
		}
		fmt.Println(string(bs))
		w.WriteHeader(http.StatusOK)
		w.Write([]byte("👋 Hello🏻"))
	})
	log.Error(hs.ListenAndServe())
}
