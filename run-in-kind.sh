#!/usr/bin/env bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

which helm || $(echo "Please install helm before running the script";exit 1)

export KIND_CLUSTER_NAME="coredns"

which kind || $(echo "Please install kind before running the script";exit 1)

kind create cluster --name ${KIND_CLUSTER_NAME} --config ${DIR}/manifests/kind.yaml

export KUBECONFIG="$(kind get kubeconfig-path --name="${KIND_CLUSTER_NAME}")"

sleep 60

which kubectl || $(echo "Please install kubectl before running the script";exit 1)

kubectl config set-context kubernetes-admin@${KIND_CLUSTER_NAME}

echo "Kubernetes cluster:"
kubectl get nodes -o wide

echo "Installing Prometheus and Grafana"
helm repo update

helm init --upgrade

sleep 60

# https://github.com/fnproject/fn-helm/issues/21
kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'

sleep 60

helm install --name prometheus stable/prometheus \
    --set persistentVolume.enabled=false \
    --set alertmanager.persistentVolume.enabled=false \
    --set pushgateway.persistentVolume.enabled=false \
    --set server.persistentVolume.enabled=false \
    --set deployCoreDNS=true

helm install --name grafana -f manifests/grafana-values.yaml stable/grafana

sleep 60

if [[ $1 = "fix-iptables" ]]; then
    echo "Installing k8s-dns-node-cache"
    kubectl apply -f manifests/local-node-dns.yaml
    sleep 60
    echo "Installing go-dnsperf scaled to 60"
    kubectl apply -f manifests/deployment-ubuntu.localcache.yaml
else
    echo "Installing go-dnsperf scaled to 60"
    kubectl apply -f manifests/deployment-ubuntu.yaml
fi

echo "Open http://localhost:3000 user admin and password coredns"
kubectl --namespace default port-forward svc/grafana 3000:80
