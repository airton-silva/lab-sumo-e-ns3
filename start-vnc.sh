#!/bin/bash

# Iniciar Xvfb (servidor X virtual)
Xvfb :0 -screen 0 1280x1024x24 -ac +extension GLX +render -noreset &

# Configurar display
export DISPLAY=:0

# Esperar Xvfb iniciar
sleep 2

# Iniciar desktop
startxfce4 &

# Verificar instalações
echo "Verificando instalações..."
which sumo && sumo --version
which ns3 && echo "NS-3 instalado"

# Criar atalho para Jupyter no desktop
echo "[Desktop Entry]
Version=1.0
Type=Application
Name=Jupyter Lab
Comment=Jupyter Laboratory
Exec=xfce4-terminal -e 'bash -c \"jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token=; bash\"'
Icon=applications-science
Categories=Development;
" > /root/Desktop/jupyter.desktop

chmod +x /root/Desktop/jupyter.desktop

# Iniciar Jupyter em background
jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root \
    --NotebookApp.token='' --NotebookApp.password='' \
    --notebook-dir=/workspace &

# Iniciar VNC server
x11vnc -forever -noxdamage -shared -display :0 -passwd 123456 &

# Iniciar noVNC
/opt/novnc/utils/novnc_proxy --vnc localhost:5900 --listen 0.0.0.0:6080 &

echo "=========================================="
echo "  SUMO-NS3 Lab Environment Started!"
echo "=========================================="
echo " VNC Access: http://localhost:6080/vnc.html"
echo " Jupyter Lab: http://localhost:8888"
echo " VNC Password: 123456"
echo "=========================================="
echo " Desktop apps available:"
echo " - Terminal"
echo " - Firefox" 
echo " - Jupyter Lab"
echo "=========================================="

# Manter container rodando
wait