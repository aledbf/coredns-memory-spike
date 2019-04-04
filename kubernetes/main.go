package main

import (
	"net/url"
	"os"
	"os/signal"
	"syscall"
	"time"

	"k8s.io/klog"
	"sigs.k8s.io/testing_frameworks/integration"
)

func main() {
	u, err := url.Parse("http://0.0.0.0:8081")
	if err != nil {
		klog.Fatal(err)
	}

	cp := &integration.ControlPlane{
		APIServer: &integration.APIServer{
			URL: u,
			Out: os.Stdout,
			Err: os.Stderr,
		},
	}

	err = cp.Start()
	if err != nil {
		klog.Fatal(err)
	}

	klog.Infof("Kubernetes API server URL: %v", cp.APIURL())

	handleSigterm(cp)
}

func handleSigterm(cp *integration.ControlPlane) {
	signalChan := make(chan os.Signal, 1)
	signal.Notify(signalChan, syscall.SIGTERM)
	<-signalChan
	klog.Info("Received SIGTERM, shutting down")
	time.Sleep(5 * time.Second)

	klog.Infof("Exiting")
	cp.Stop()
	os.Exit(0)
}
