FROM rockylinux:8

# 安装 EPEL 源
RUN dnf install -y epel-release

# 1. 安装核心编译工具与系统管理工具
# 2. 安装 EDA 必备图形依赖库 (LSB, X11, GL 等)
# 3. 安装 Java 运行环境 (Socrates 强依赖)
# 4. 安装轻量级桌面 (Fluxbox) 与 VNC 服务
RUN dnf install -y \
    wget tar gzip make perl gcc gcc-c++ sudo \
    redhat-lsb-core \
    libX11 libXext libXrender libXtst libXft \
    xorg-x11-fonts-Type1 xorg-x11-fonts-75dpi \
    mesa-libGL mesa-libGLU \
    java-11-openjdk-devel \
    tigervnc-server fluxbox xterm \
    && dnf clean all

# Codespace 默认规范：创建非 root 用户
RUN useradd -m -s /bin/bash vscode && \
    echo "vscode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd

# 初始化 VNC 的启动脚本，默认启动 fluxbox 桌面
RUN mkdir -p /home/vscode/.vnc && \
    echo -e "#!/bin/sh\nfluxbox &" > /home/vscode/.vnc/xstartup && \
    chmod +x /home/vscode/.vnc/xstartup && \
    chown -R vscode:vscode /home/vscode/.vnc

USER vscode
ENV USER=vscodeFROM rockylinux:8

# 安装 EPEL 源
RUN dnf install -y epel-release

# 1. 安装核心编译工具与系统管理工具
# 2. 安装 EDA 必备图形依赖库 (LSB, X11, GL 等)
# 3. 安装 Java 运行环境 (Socrates 强依赖)
# 4. 安装轻量级桌面 (Fluxbox) 与 VNC 服务
RUN dnf install -y \
    wget tar gzip make perl gcc gcc-c++ sudo \
    redhat-lsb-core \
    libX11 libXext libXrender libXtst libXft \
    xorg-x11-fonts-Type1 xorg-x11-fonts-75dpi \
    mesa-libGL mesa-libGLU \
    java-11-openjdk-devel \
    tigervnc-server fluxbox xterm \
    && dnf clean all

# Codespace 默认规范：创建非 root 用户
RUN useradd -m -s /bin/bash vscode && \
    echo "vscode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd

# 初始化 VNC 的启动脚本，默认启动 fluxbox 桌面
RUN mkdir -p /home/vscode/.vnc && \
    echo -e "#!/bin/sh\nfluxbox &" > /home/vscode/.vnc/xstartup && \
    chmod +x /home/vscode/.vnc/xstartup && \
    chown -R vscode:vscode /home/vscode/.vnc

USER vscode
ENV USER=vscode
