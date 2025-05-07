# 🚀 WordPress com Docker na AWS | Projeto 02 - Compass Uol

Repositório do projeto da Sprint 2 do Programa Compass UOL, com foco em deploy de uma aplicação WordPress utilizando a infraestrutura da AWS. O ambiente foi construído com boas práticas de segurança, alta disponibilidade e escalabilidade em mente, aplicando serviços como EC2, Load Balancer, RDS, EFS e Security Groups.

---

## 🛠️ Tecnologias e Ferramentas

- **Docker & Docker Compose**
- **Amazon EC2**
- **Amazon RDS (MySQL)**
- **Amazon EFS**
- **Elastic Load Balancer**
- **Security Groups**
- **WordPress**
- **Linux (Ubuntu 22.04)**
- **Shell Script**

---

## 📌 Estrutura da Solução

A arquitetura do projeto foi construída conforme o diagrama abaixo (resumidamente):

- 1 instância EC2 com Docker rodando WordPress + PHP + Apache
- Banco de dados gerenciado com Amazon RDS (MySQL)
- Sistema de arquivos persistente com Amazon EFS
- Balanceador de carga (ELB) distribuindo requisições
- Grupos de segurança configurados para acesso seguro (SSH e HTTP)

---

## ⚙️ Pré-requisitos

Antes de rodar o projeto, você precisa ter:

- Conta AWS ativa
- Chave de acesso EC2 (`.pem`)
- Docker e Docker Compose instalados
- Permissões adequadas em Security Groups
- Acesso liberado no Load Balancer (porta 80)

---

## 📦 Instalação e Deploy

1. Clone o repositório:

```bash
git clone https://github.com/ThiagoResende88/Sprint02_CompassUOL.git
cd seu-repo
```

2. Acesse a instância EC2 via SSH:

```bash
ssh -i WP-Key.pem ec2-user@<IP_PÚBLICO_EC2>
```

3. Suba o ambiente com Docker Compose:

```bash
docker-compose up -d
```

4. Acesse via navegador:

```bash
http://<DNS_DO_LOAD_BALANCER>
```

---

## 💾 Banco de Dados (RDS)

* **Endpoint**: `wordpress-db.*"SUA_KEY"*.sa-east-1.rds.amazonaws.com`
* **Usuário**: admin (ou outro, definido no `.env`)
* **Porta**: 3306

O banco foi configurado para aceitar conexões da instância EC2 com a porta 3306 liberada no SG.

---

## 📁 Armazenamento (EFS)

* O EFS foi montado via:

```bash
sudo mount -t efs -o tls *fs-"SEU_ID"*:/ efs
```

* Utilizado para armazenar arquivos persistentes do WordPress (plugins, uploads, etc).

---

## 🔐 Segurança

* Acesso SSH restrito ao IP Local: `179.109.93.91/32`
* Porta 80 aberta para a internet (`0.0.0.0/0`)
* Acesso ao RDS restrito ao security group da EC2
* Senhas e variáveis sensíveis armazenadas em arquivos `.env` (não versionados)

---

## ✅ Status do Projeto

✔️ Infraestrutura provisionada

✔️ Docker funcionando corretamente

✔️ WordPress acessível via Load Balancer

✔️ Conexão com RDS testada

✔️ EFS montado e funcional

---

## 📚 Aprendizados

Durante o desenvolvimento desse projeto, foram colocados em prática diversos conceitos de cloud computing, segurança em infraestrutura, deploy com containers e boas práticas com Docker e AWS. A atividade reforçou a importância de automação, controle de acesso e persistência de dados em ambientes escaláveis.

---

## 📷 Imagens

[Prints](https://github.com/ThiagoResende88/Sprint02_CompassUOL/tree/main/prints)

---

## 👤 Autor

**Thiago Dias Resende**

📧 [thiago.resende.pb@compasso.com.br](mailto:thiago.resende.pb@compasso.com.br)

💼 [LinkedIn](https://www.linkedin.com/in/seu-perfil)

---

## 📝 Licença

Este projeto é parte do programa de treinamento da [Compass UOL](https://compass.uol). Uso restrito a fins educacionais.

---
