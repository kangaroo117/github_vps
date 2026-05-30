FROM rockylinux:8

RUN dnf install -y epel-release

RUN dnf install -y \
    wget tar gzip make perl gcc gcc-c++ sudo \
    redhat-lsb-core \
    libX11 libXext libXrender libXtst libXft \
    xorg-x11-fonts-Type1 xorg-x11-fonts-75dpi \
    mesa-libGL mesa-libGLU \
    java-11-openjdk-devel \
    tigervnc-server fluxbox xterm \
    && dnf clean all

RUN useradd -m -s /bin/bash vscode && \
    echo "vscode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd

RUN mkdir -p /home/vscode/.vnc && \
    echo -e "#!/bin/sh\nfluxbox &" > /home/vscode/.vnc/xstartup && \
    chmod +x /home/vscode/.vnc/xstartup && \
    chown -R vscode:vscode /home/vscode/.vnc

USER vscode
ENV USER=vscode
