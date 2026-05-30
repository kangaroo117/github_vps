FROM rockylinux:8

RUN dnf install -y epel-release

# 增加了 git 和 python3 作为 noVNC 的运行依赖
RUN dnf install -y \
    wget tar gzip make perl gcc gcc-c++ sudo \
    redhat-lsb-core \
    libX11 libXext libXrender libXtst libXft \
    xorg-x11-fonts-Type1 xorg-x11-fonts-75dpi \
    mesa-libGL mesa-libGLU \
    java-11-openjdk-devel \
    tigervnc-server fluxbox xterm \
    git python3 procps-ng \
    && dnf clean all

# 下载 noVNC 和 websockify 代理工具
RUN git clone https://github.com/novnc/noVNC.git /opt/novnc && \
    git clone https://github.com/novnc/websockify /opt/novnc/utils/websockify

RUN useradd -m -s /bin/bash vscode && \
    echo "vscode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd && \
    chown -R vscode:vscode /opt/novnc

RUN mkdir -p /home/vscode/.vnc && \
    echo -e "#!/bin/sh\nfluxbox &" > /home/vscode/.vnc/xstartup && \
    chmod +x /home/vscode/.vnc/xstartup && \
    chown -R vscode:vscode /home/vscode/.vnc

USER vscode
ENV USER=vscode
