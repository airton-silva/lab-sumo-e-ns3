#!/bin/bash

# Iniciar Jupyter Lab
echo "Iniciando Jupyter Lab..."
jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root \
    --NotebookApp.token='' --NotebookApp.password='' \
    --notebook-dir=/workspace &
    
# Manter container rodando
echo "Serviços iniciados. Acesse via http://localhost:8888"
wait