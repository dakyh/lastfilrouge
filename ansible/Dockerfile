FROM python:3.9-slim

# Installer les dépendances
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

# Ajouter le dépôt Docker
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

# Installer Docker CLI
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    docker-ce-cli \
    && rm -rf /var/lib/apt/lists/*

# Installer Ansible et dépendances Python requises
RUN pip install --no-cache-dir ansible docker requests

# Installer la collection Docker pour Ansible
RUN ansible-galaxy collection install community.docker

WORKDIR /ansible