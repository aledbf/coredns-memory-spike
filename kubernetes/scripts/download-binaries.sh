#!/usr/bin/env bash
set -eu

logEnd() {
  local msg='done.'
  [ "$1" -eq 0 ] || msg='Error downloading assets'
  echo "$msg"
}
trap 'logEnd $?' EXIT

# Use BASE_URL=https://my/binaries/url ./scripts/download-binaries to download
# from a different bucket
: "${BASE_URL:="https://storage.googleapis.com/k8s-c10s-test-binaries"}"

os="$(uname -s)"
os_lowercase="$(echo "$os" | tr '[:upper:]' '[:lower:]' )"
arch="$(uname -m)"

dest_dir="/assets/bin"
etcd_dest="${dest_dir}/etcd"
kubectl_dest="${dest_dir}/kubectl"
kube_apiserver_dest="${dest_dir}/kube-apiserver"

echo "About to download a couple of binaries. This might take a while..."

curl -sSL "${BASE_URL}/etcd-${os}-${arch}" --output "$etcd_dest"
curl -sSL "${BASE_URL}/kube-apiserver-${os}-${arch}" --output "$kube_apiserver_dest"

kubectl_version="$(curl -sSL https://storage.googleapis.com/kubernetes-release/release/stable.txt)"
kubectl_url="https://storage.googleapis.com/kubernetes-release/release/${kubectl_version}/bin/${os_lowercase}/amd64/kubectl"
curl -sSL "$kubectl_url" --output "$kubectl_dest"

chmod +x "$etcd_dest" "$kubectl_dest" "$kube_apiserver_dest"

echo    "# destination:"
echo    "#   ${dest_dir}"
echo    "# versions:"
echo -n "#   etcd:            "; "$etcd_dest" --version | head -n 1
echo -n "#   kube-apiserver:  "; "$kube_apiserver_dest" --version
echo -n "#   kubectl:         "; "$kubectl_dest" version --client --short
