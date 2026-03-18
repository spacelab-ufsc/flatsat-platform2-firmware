FROM ubuntu:22.04

ARG INSTALLER=Xilinx_Unified_2023.1_0507_1903_Lin64.bin
ARG XILINX_DIR=/opt/Xilinx
ARG XILINX_AUTH_TOKEN=wi_authentication_key
ARG CONFIG_FILE=install_config.txt
ARG VIVADO_VERSION=2023.1

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /tmp

# install small deps required by installer
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    wget \
    gnupg \
    xz-utils \
    unzip \
    bzip2 \
    python3 \
    python3-pip \
    libxext6 \
    libxrender1 \
    libxtst6 \
    libxi6 \
    libgl1 \
    libncurses5 \
    curl \
    sudo \
    sed \
    openjdk-17-jdk-headless \
    autoconf \
    automake \
    bc \
    bison \
    build-essential \
    chrpath \
    cpio \
    debianutils \
    diffstat \
    flex \
    gawk \
    gcc \
    gcc-multilib \
    git \
    git-core \
    gnupg \
    gzip \
    iproute2 \
    iputils-ping \
    libegl1-mesa \
    libglib2.0-dev \
    libncurses5-dev \
    libselinux1 \
    libssl-dev \
    libtinfo5 \
    libtool \
    libsdl1.2-dev \
    liblz4-tool \
    locales \
    locales-all \
    lsb-release \
    make \
    net-tools \
    pax \
    pylint \
    python3 \
    python3-git \
    python3-jinja2 \
    python3-pip \
    python3-pexpect \
    python3-subunit \
    rsync \
    screen \
    socat \
    sudo \
    tar \
    texinfo \
    tftpd \
    tofrodos \
    unzip \
    vim \
    wget \
    xterm \
    xz-utils \
    zlib1g-dev \
    zstd \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p ${XILINX_DIR}

# copy installer into build context (or change to wget the file)
COPY ./${INSTALLER} /tmp/${INSTALLER}
RUN chmod +x /tmp/${INSTALLER}

# extract web-installer client
RUN mkdir -p /tmp/xinstall && \
    /tmp/${INSTALLER} --keep --noexec --target /tmp/xinstall

WORKDIR /tmp/xinstall

COPY ./${CONFIG_FILE} /tmp/xinstall/${CONFIG_FILE}

RUN sed -i 's|\${X_JAVA_HOME}|/usr|g' xsetup || true

RUN adduser --gecos '' vivado && \
    echo "vivado:fsat" | chpasswd && \
    usermod -aG sudo vivado

RUN chown vivado:vivado /opt/Xilinx

RUN mkdir -p /home/vivado/.Xilinx

COPY ./${XILINX_AUTH_TOKEN} /home/vivado/.Xilinx/${XILINX_AUTH_TOKEN}

RUN chown vivado:vivado /home/vivado/.Xilinx
RUN chmod 666 /home/vivado/.Xilinx/wi_authentication_key

USER vivado

ENV HOME=/home/vivado

ENV XINSTALLER_SCALE=2
RUN ./xsetup --agree XilinxEULA,3rdPartyEULA --batch Install -c /tmp/xinstall/${CONFIG_FILE}

USER root

# Clean up installer payloads to save space
RUN rm -rf /tmp/xinstall /tmp/${INSTALLER}

RUN apt-get update && apt-get install -y -q \
    && rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US.UTF-8 && update-locale

USER vivado

RUN mkdir /home/vivado/workdir/
WORKDIR /home/vivado/workdir/

RUN echo "source /opt/Xilinx/Vivado/${VIVADO_VERSION}/settings64.sh" >> /home/vivado/.bashrc
