FROM ubuntu:22.04

RUN dpkg --add-architecture i386
RUN apt-get update

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y -q \
    iproute2 \
    gawk \
    python3 \
    build-essential \
    gcc \
    git \
    make \
    net-tools \
    libncurses5-dev \
    tftpd \
    zlib1g-dev \
    libssl-dev \
    flex \
    bison \
    libselinux1 \
    gnupg \
    wget \
    git-core \
    diffstat \
    chrpath \
    socat \
    xterm \
    autoconf \
    libtool \
    tar \
    unzip \
    texinfo \
    zlib1g-dev \
    gcc-multilib \
    automake \
    zlib1g:i386 \
    screen \
    pax \
    gzip \
    cpio \
    python3-pip \
    python3-pexpect \
    xz-utils \
    debianutils \
    iputils-ping \
    python3-git \
    python3-jinja2 \
    libegl1-mesa \
    libsdl1.2-dev \
    libtinfo5 \
    locales \
    rsync \
    vim \
    expect \
    sudo \
    bc \
    pylint \
    locales-all

ARG PETA_RUN_FILE

RUN locale-gen en_US.UTF-8 && update-locale

# make /bin/sh symlink to bash instead of dash:
RUN echo "dash dash/sh boolean false" | debconf-set-selections
RUN DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash

#make a Vivado user
RUN adduser --gecos '' petalinux && \
    echo "petalinux:fsat" | chpasswd && \
    usermod -aG sudo petalinux

# Sudo usage without password
#usermod -aG sudo petalinux && \
#echo "petalinux ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Copy installer and eula-accept script
COPY ./scripts/accept-eula.sh ${PETA_RUN_FILE} /

# run the install
RUN chmod a+rx /${PETA_RUN_FILE} && \
    chmod a+rx /accept-eula.sh && \
    mkdir -p /opt/Xilinx && \
    chmod 777 /tmp /opt/Xilinx

USER petalinux

RUN cd /tmp && \
    /accept-eula.sh /${PETA_RUN_FILE} /opt/Xilinx/petalinux

ENV HOME=/home/petalinux
ENV LANG=en_US.UTF-8
RUN mkdir /home/petalinux/project/
WORKDIR /home/petalinux/project/

RUN echo "source /opt/Xilinx/petalinux/settings.sh" >> /home/petalinux/.bashrc
