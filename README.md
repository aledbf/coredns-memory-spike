# CoreDNS - dnsperf test

Repository to reproduce issue https://github.com/coredns/coredns/issues/2593

**Requeriments:**

- [Docker](https://docs.docker.com/install/)
- [Docker compose](https://docs.docker.com/compose/install/)

*Usage:*

1. Clone the repo
2. Run `./run.sh`

3. Run `./run-in-kind.sh` to start a local cluster using [kind](https://github.com/kubernetes-sigs/kind)

   Open `http://localhost:3000`

   After the test run `kind delete cluster --name coredns` to destroy kind cluster
