FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Adicionar repositório do SUMO
RUN apt-get update && apt-get install -y \
    gnupg2 software-properties-common && \
    add-apt-repository -y ppa:sumo/stable && \
    apt-get update

# Instalar dependências principais e SUMO (REMOVIDO FIREFOX E NS3 DAQUI)
RUN apt-get update && apt-get install -y \
    xfce4 xfce4-goodies x11vnc xvfb \
    python3-pip wget curl git \
    build-essential cmake \
    sumo sumo-tools sumo-doc \
    libxerces-c-dev libfox-1.6-dev libgdal-dev \
    libproj-dev proj-data proj-bin \
    libgl2ps-dev swig \
    qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools \
    libqt5opengl5-dev libqt5svg5-dev \
    && rm -rf /var/lib/apt/lists/*

# -----------------------------------------------------------
# **CORREÇÃO FIREFOX (Instalação via repositório Mozilla, não-snap)**
# Esta seção garante que o Firefox seja um pacote .deb tradicional,
# necessário para funcionar corretamente no ambiente VNC/Xvfb.
# -----------------------------------------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
    gnupg \
    && rm -rf /var/lib/apt/lists/*
    
RUN install -d -m 0755 /etc/apt/keyrings && \
    wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null && \
    echo 'Package: *' | tee /etc/apt/preferences.d/mozilla && \
    echo 'Pin: origin packages.mozilla.org' | tee -a /etc/apt/preferences.d/mozilla && \
    echo 'Pin-Priority: 1000' | tee -a /etc/apt/preferences.d/mozilla && \
    echo 'deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main' | tee /etc/apt/sources.list.d/mozilla.list > /dev/null && \
    apt-get update && \
    apt-get install -y firefox \
    && rm -rf /var/lib/apt/lists/*
# -----------------------------------------------------------
# FIM CORREÇÃO FIREFOX
# -----------------------------------------------------------

# Instalar noVNC
RUN git clone https://github.com/novnc/noVNC.git /opt/novnc \
    && git clone https://github.com/novnc/websockify /opt/novnc/utils/websockify

# Configurar password do VNC sem interação
RUN mkdir -p /root/.vnc && \
    x11vnc -storepasswd 123456 /root/.vnc/passwd && \
    chmod 600 /root/.vnc/passwd

# Instalar NS-3 de release estável (mantida apenas a instalação manual)
RUN cd /opt && \
    wget https://www.nsnam.org/releases/ns-allinone-3.37.tar.bz2 && \
    tar xjf ns-allinone-3.37.tar.bz2 && \
    cd ns-allinone-3.37 && \
    ./build.py

# Instalar Python packages
RUN pip3 install jupyter notebook matplotlib numpy scipy pandas sumolib traci

# Configurar variáveis de ambiente (apontando para a instalação manual)
ENV SUMO_HOME=/usr/share/sumo
ENV PATH="/opt/ns-allinone-3.37/ns-3.37:$PATH"
ENV PYTHONPATH="/opt/ns-allinone-3.37/ns-3.37/build/bindings/python:$PYTHONPATH"

# Criar diretório de trabalho e atalhos
RUN mkdir /workspace && \
    mkdir -p /root/Desktop && \
    echo "[Desktop Entry]\nVersion=1.0\nType=Application\nName=Terminal\nComment=System Terminal\nExec=xfce4-terminal\nIcon=utilities-terminal\nCategories=System;\n" > /root/Desktop/terminal.desktop && \
    echo "[Desktop Entry]\nVersion=1.0\nType=Application\nName=Firefox\nComment=Web Browser\nExec=firefox\nIcon=firefox\nCategories=Network;\n" > /root/Desktop/firefox.desktop && \
    chmod +x /root/Desktop/*.desktop

WORKDIR /workspace

# Script de inicialização VNC
COPY start-vnc.sh /start-vnc.sh
RUN chmod +x /start-vnc.sh

EXPOSE 6080 5900 8888

CMD ["/start-vnc.sh"]