# WordPress na AWS com Docker | Projeto PB - Compass Uol

## Etapa 1: Configuração da VPC e Rede

Vamos começar pela infraestrutura base na AWS:

1. **Criar VPC**:
   - Nome: WordPress-VPC
   - CIDR: 10.0.0.0/16
   - Habilitar DNS hostnames e suporte DNS

2. **Criar Subnets**:
   - 2 Subnets públicas (diferentes AZs):
     - Public-Subnet-1: 10.0.1.0/24 (AZ-a)
     - Public-Subnet-2: 10.0.2.0/24 (AZ-b)
   - 2 Subnets privadas (para o RDS):
     - Private-Subnet-1: 10.0.3.0/24 (AZ-a)
     - Private-Subnet-2: 10.0.4.0/24 (AZ-b)

3. **Configurar Internet Gateway**:
   - Criar Internet Gateway
   - Anexar à VPC

4. **Configurar Tabelas de Roteamento**:
   - Criar route table pública
   - Adicionar rota 0.0.0.0/0 apontando para o Internet Gateway
   - Associar às subnets públicas

## Etapa 2: Configuração dos Security Groups

1. **Security Group para EC2/Docker**:
   - Nome: WordPress-EC2-SG
   - Permitir entrada: SSH (22), HTTP (80), HTTP (8080)
   - Permitir saída: All traffic

2. **Security Group para RDS**:
   - Nome: WordPress-RDS-SG
   - Permitir entrada: MySQL (3306) apenas do WordPress-EC2-SG
   - Permitir saída: All traffic

3. **Security Group para EFS**:
   - Nome: WordPress-EFS-SG
   - Permitir entrada: NFS (2049) apenas do WordPress-EC2-SG
   - Permitir saída: All traffic

## Etapa 3: Criação do EFS

1. **Criar o EFS**:
   - Nome: WordPress-EFS
   - VPC: WordPress-VPC
   - Security Group: WordPress-EFS-SG
   - Criar mount targets nas duas subnets públicas

## Etapa 4: Configuração do RDS

1. **Criar Subnet Group para RDS**:
   - Nome: WordPress-DB-Subnet-Group
   - Adicionar as duas subnets privadas

2. **Criar Instância RDS**:
   - Engine: MySQL 8.0
   - Classe: db.t2.micro (free tier)
   - Storage: 20GB GP2
   - Multi-AZ: Desativado (economizar custos)
   - Nome do DB: wordpress
   - User/Password: Configurar
   - VPC: WordPress-VPC
   - Subnet Group: WordPress-DB-Subnet-Group
   - Security Group: WordPress-RDS-SG
   - Publicly accessible: Não

## Etapa 5: Configuração da Instância EC2

1. **Criar Instância EC2**:
   - AMI: Amazon Linux 2 ou Ubuntu Server
   - Tipo: t2.micro
   - VPC: WordPress-VPC
   - Subnet: Public-Subnet-1
   - Auto-assign Public IP: Sim
   - Security Group: WordPress-EC2-SG
   - Storage: 8GB gp2
   - User Data Script:

## Etapa 6: Configuração do Load Balancer

1. **Criar Classic Load Balancer**:
   - Nome: WordPress-LB
   - VPC: WordPress-VPC
   - Subnets: Public-Subnet-1, Public-Subnet-2
   - Security Group: WordPress-EC2-SG
   - Listener: HTTP (80)
   - Health Check: HTTP, porta 80, caminho "/"
   - Adicionar EC2 instance como target

## Etapa 7: Configuração do WordPress com Docker

Depois que a infraestrutura estiver pronta, você precisará conectar à instância EC2 e configurar o Docker Compose adequadamente para apontar para o seu RDS.

1. **Conectar à EC2** (substitua os valores):
   ```bash
   ssh -i "sua-chave.pem" ec2-user@ec2-public-ip
   ```

2. **Atualizar o docker-compose.yml**:

3. **Iniciar o container**:
   ```bash
   cd ~/wordpress
   docker-compose up -d
   ```

## Etapa 8: Teste e Verificação

1. **Testar acesso ao WordPress**:
   - Acesse o DNS do Load Balancer no navegador
   - Complete a configuração inicial do WordPress
   - Verificar se consegue fazer upload de mídia (teste do EFS)

2. **Verificar logs**:
   ```bash
   docker-compose logs -f
   ```

## Etapa 9: Documentação

Crie uma documentação completa da sua solução, incluindo:

1. **Diagrama da arquitetura**
2. **Procedimentos de instalação**
3. **Configurações realizadas**
4. **Comandos utilizados**
5. **Testes realizados**
6. **Problemas enfrentados e soluções**

# Implementação via CloudFormation

Se preferir automatizar todo esse processo, você pode usar o template de CloudFormation que compartilhei anteriormente. Nesse caso, os passos seriam:

1. Acessar o AWS Console > CloudFormation
2. Criar stack > Com novo template
3. Fazer upload do arquivo YAML
4. Preencher os parâmetros (KeyName, InstanceType, etc.)
5. Avançar, revisar e criar stack
6. Esperar a criação de todos os recursos
7. Acessar a URL do WordPress (disponível nos outputs da stack)

