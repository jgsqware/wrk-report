FROM debian:jessie-slim

RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    libssl-dev \
    wget \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/wrk2 && \
    git clone https://github.com/giltene/wrk2.git /opt/wrk2 && \
    cd /opt/wrk2 && \
    make && \
    ln -s /opt/wrk2/wrk /bin/wrk

RUN wget -O /bin/wrk-report https://github.com/jgsqware/wrk-report/releases/download/0.1/wrk-report-linux-amd64 && \
  chmod +x /bin/wrk-report