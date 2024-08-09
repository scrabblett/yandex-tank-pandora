FROM ubuntu:focal

# Install linux packages
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update -q && \
    apt-get install -yq --no-install-recommends \
        sudo \
        wget \
        less \
        iproute2 \
        software-properties-common \
        git \
        gpg-agent \
        python3-pip \
        make \
        build-essential \
        libssl-dev \
        zlib1g-dev \
        libncurses5-dev \
        libncursesw5-dev \
        libreadline-dev \
        libsqlite3-dev \
        libgdbm-dev \
        libdb5.3-dev \
        libbz2-dev \
        libexpat1-dev \
        liblzma-dev \
        tk-dev \
        libffi-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* /tmp/* /var/tmp/*

# Install python
RUN wget https://www.python.org/ftp/python/3.10.14/Python-3.10.14.tgz && \
    tar -xvf Python-3.10.14.tgz && \
    cd Python-3.10.14 && \
    ./configure --enable-optimizations && \
    make altinstall \
    && rm -rf /Python-3.10.14 /Python-3.10.14.tgz

# Install go
RUN wget https://dl.google.com/go/go1.22.2.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.22.2.linux-amd64.tar.gz \
    && rm -rf /go1.22.2.linux-amd64.tar.gz

ENV PATH=$PATH:/usr/local/go/bin

# Install yandex-tank
RUN pip3.10 install --upgrade setuptools && \
    pip3.10 install --upgrade pip && \
    pip3.10 install https://api.github.com/repos/yandex/yandex-tank/tarball/master \
    && rm -rf /root/.cache/pip/*

# Install pandora
RUN git clone https://github.com/yandex/pandora.git \
    && cd pandora \
    && export CGO_ENABLED=0 \
    && make deps \
    && go install \
    && rm -rf /pandora

ENV PATH=$PATH:/root/go/bin

COPY . /app
WORKDIR /app
