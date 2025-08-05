FROM ubuntu:jammy-20220815
ENV DEBIAN_FRONTEND=noninteractive

RUN dpkg --add-architecture i386

RUN apt-get update && apt-get install -y -q \
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
    zlib1g:i386 \
    zstd \
    && rm -rf /var/lib/apt/lists/*

ARG PETA_RUN_FILE

RUN locale-gen en_US.UTF-8 && update-locale

# make /bin/sh symlink to bash instead of dash:
RUN echo "dash dash/sh boolean false" | debconf-set-selections
RUN DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash

#make a Vivado user
RUN adduser --gecos '' petalinux && \
    echo "petalinux:fsat" | chpasswd && \
    usermod -aG sudo petalinux

COPY ${PETA_RUN_FILE} /

# run the install
RUN chmod 755 /${PETA_RUN_FILE} && \
    mkdir -p /opt/Xilinx && \
    chmod 777 /tmp /opt/Xilinx

USER petalinux

RUN cd /tmp && \
    SKIP_LICENSE=y /${PETA_RUN_FILE} -d /opt/Xilinx/petalinux

ENV HOME=/home/petalinux
ENV LANG=en_US.UTF-8
RUN mkdir /home/petalinux/project/
WORKDIR /home/petalinux/project/

RUN echo "source /opt/Xilinx/petalinux/settings.sh" >> /home/petalinux/.bashrc
