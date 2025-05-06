#!/bin/bash

# Atualizando os pacotes
yum upgrade -y
cd /

# Instalando utilitários
yum install -y amazon-efs-utils docker

# Habilitando e iniciando os serviços
chkconfig amazon-efs-mount-watchdog.service on
service amazon-efs-mount-watchdog start
chkconfig docker on
service docker start

# Instalando Docker Compose
curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Criando estrutura de diretórios
mkdir -p /wordpress/compose /wordpress/data
cd /wordpress

# Montando EFS (substituir pelo seu ID real)
mount -t efs -o tls fs-053d3daa02230bc15:/ /wordpress/data

# Entrando na pasta do docker-compose
cd compose

# Criando docker-compose.yml
cat << EOF > docker-compose.yml
version: '3.1'

services:
  wordpress:
    image: wordpress
    restart: always
    ports:
      - "80:80"
    environment:
      WORDPRESS_DB_HOST: \${DB_HOST}
      WORDPRESS_DB_USER: admin
      WORDPRESS_DB_PASSWORD: \${SENHA_DB}
      WORDPRESS_DB_NAME: wordpress
    volumes:
      - /wordpress/data:/var/www/html
EOF

# Criando .env com dados reais
cat << EOF > .env
SENHA_DB=senhaforte123
DB_HOST=wordpress-db.cvywwg4swlx6.sa-east-1.rds.amazonaws.com
EOF

# Subindo o container
docker-compose up -d
