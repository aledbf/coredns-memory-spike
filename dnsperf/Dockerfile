FROM debian:buster-slim

RUN apt update && \
    apt install -y --no-install-recommends \
    bind9 \
    g++ \
    libbind-dev \
    libcap-dev \
    libgeoip-dev \
    libjson-c-dev \
    libkrb5-dev \
    libssl-dev \
    libxml2-dev \
    binutils csh sed gawk autoconf automake autotools-dev \
    libprotobuf-c-dev libfstrm-dev liblmdb-dev \
    netcat \
    unzip \
    make

ENV DNSPERF_VERSION 2.2.1
ADD https://www.dns-oarc.net/files/dnsperf/dnsperf-${DNSPERF_VERSION}.tar.gz /opt/
RUN tar -zxf /opt/dnsperf-${DNSPERF_VERSION}.tar.gz -C /opt/

RUN cd /opt/dnsperf-${DNSPERF_VERSION} \
    && ./configure \
    && make install distclean

ADD http://s3.amazonaws.com/alexa-static/top-1m.csv.zip /opt
RUN unzip /opt/top-1m.csv.zip
RUN cat /top-1m.csv | cut -f 2 -d ',' | head -n 100000 | sed 's/$/ A/' > top-100k.dnsperf

ADD wait-for.sh /

CMD ["dnsperf"]
