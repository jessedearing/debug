package main

import (
	"flag"
	"fmt"
	"net/http"
	"net/http/httputil"

	"github.com/sirupsen/logrus"
	log "github.com/sirupsen/logrus"
)

func main() {
	var (
		tlsCertificate string
		tlsKey         string
		port           string
	)

	flag.StringVar(&tlsCertificate, "cert-file", "", "Specify the certificate file")
	flag.StringVar(&tlsKey, "cert-key", "", "Specify the certificate key")
	flag.StringVar(&port, "port", ":8080", "The port to run the server on")

	flag.Parse()
	hs := http.Server{
		Addr: port,
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
	if tlsCertificate != "" {
		log.Info("Serving TLS")
		log.Error(hs.ListenAndServeTLS(tlsCertificate, tlsKey))
	} else {
		log.Info("Serving plain HTTP")
		log.Error(hs.ListenAndServe())
	}
}
