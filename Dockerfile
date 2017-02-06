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

RUN mkdir /scripts
COPY scripts/multi-request-json.lua /scripts/multi-request-json.lua

# Install Luarocks dependencies
RUN apt-get update && apt-get install -y curl \
                       unzip \
                       lua5.1 \
                       liblua5.1-dev \
  && rm -rf /var/lib/apt/lists/*

# Install Luarocks - a lua package manager
RUN curl http://luarocks.github.io/luarocks/releases/luarocks-2.4.2.tar.gz -O &&\
    tar -xzvf luarocks-2.4.2.tar.gz &&\
    cd luarocks-2.4.2 &&\
    ./configure &&\
    make build &&\
    make install

# Install the cjson package
RUN luarocks install lua-cjson