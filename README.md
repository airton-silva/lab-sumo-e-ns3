# 🛣️ Laboratório de Simulação de Tráfego e Redes (SUMO & NS-3)

Este repositório contém o ambiente completo, baseado em Docker, necessário para executar simulações com **SUMO (Simulation of Urban MObility)** e **NS-3 (Network Simulator 3)**.

O ambiente fornece uma interface gráfica completa (XFCE4) acessível via **noVNC (Web Browser)** e uma interface interativa via **Jupyter Lab** para notebooks Python, garantindo um ambiente de treinamento padronizado e acessível.

## 🚀 Como Rodar o Ambiente

O ambiente é inicializado via `docker-compose`.

### 1. Pré-requisitos

* **Docker Engine e Docker Compose** instalados (ou Docker Desktop).
* **Conexão com a Internet** para o download inicial da imagem/construção.

### 2. Inicialização Rápida (Usando Imagem Publicada)

Se a imagem já estiver publicada no Docker Hub (ex: `seu_usuario/lab-sumo-e-ns3:latest`), use o `docker-compose.yml` que referencia essa imagem.

```bash
# 1. Certifique-se de que os arquivos de configuração (docker-compose.yml, etc.) estão na pasta.
# 2. Inicie o container. O Docker fará o pull da imagem automaticamente.
docker-compose up -d

# 1. Construir a imagem (pode demorar bastante na primeira vez devido ao NS-3 e SUMO)
docker-compose build

# 2. Iniciar o container
docker-compose up -d

# 3. Parar o conteiner
docker-compose stop

# 4. Parar e remover o conteiner
docker-compose down

```
### 3. Acesso ao Ambiente

Serviço,Porta,URL de Acesso,Credencial
noVNC (Desktop Gráfico),6080,http://localhost:6080/vnc.html,Senha: 123456
Jupyter Lab,8888,http://localhost:8888,Sem Token/Senha
VNC Direto (Cliente),5900,Cliente VNC (ex: RealVNC) para localhost:5900,Senha: 123456

### Teste Rápido do ambiente

Os seguintes arquivos de exemplo estão incluídos para verificar a funcionalidade de cada ferramenta. Todos os comandos devem ser executados dentro do Terminal no Desktop VNC.

### 1. Testar SUMO (GUI)

```bash
sumo-gui -n /workspace/examples/sumo/hello-word.net.xml -r /workspace/examples/sumo/hello-word.rou.xml

```

### 2. Testar NS-3

```bash
cd /opt/ns-allinone-3.37/ns-3.37
./waf --run scratch/hello-simulator

```    

### Testar Jupyter Lab (TraCI/SUMO Python)

1. Acesse http://localhost:8888 no seu navegador host.

2. Navegue até notebook/01-sumo-basico.ipynb.

3. Execute as células em ordem para verificar a integração entre Python e a API TraCI do SUMO.
