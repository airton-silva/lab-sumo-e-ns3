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
which ns3 && echo "NS-3 instalado (Via Source/Build)"

# -----------------------------------------------------------
# AJUSTE JUPYTER LAB: 
# Inicialização apenas em background para acesso via porta 8888.
# Removida a criação redundante de atalho que inicia o serviço.
# -----------------------------------------------------------
echo "Iniciando Jupyter Lab (Porta 8888)..."
jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root \
    --NotebookApp.token='' --NotebookApp.password='' \
    --notebook-dir=/workspace &
# -----------------------------------------------------------
# FIM AJUSTE JUPYTER LAB
# -----------------------------------------------------------


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
echo " - Firefox (Para abrir o OSM Web Wizard)" 
echo "=========================================="

# Manter container rodando
wait