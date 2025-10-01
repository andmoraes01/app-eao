# 🗄️ Como Conectar no Banco de Dados usando DBeaver

## 📋 Pré-requisitos

### **1. Instalar DBeaver**

1. Acesse: https://dbeaver.io/download/
2. Baixe a versão **Community Edition** (gratuita)
3. Execute o instalador
4. Siga o assistente de instalação (clique em "Next" até finalizar)
5. Marque a opção **"Create Desktop Shortcut"** (Criar Atalho na Área de Trabalho)

✅ **DBeaver instalado!**

---

### **2. Verificar se os SQL Servers estão Rodando**

⚠️ **IMPORTANTE:** O AppEAO usa **2 bancos de dados separados**:
- 🔐 **AppEAO_Auth** (porta 1433) - Autenticação e usuários
- 📊 **AppEAO_Data** (porta 1434) - Dados de negócio

#### **Passo 1: Abrir Terminal**
- Pressione `Windows + R`
- Digite: `cmd`
- Pressione Enter

#### **Passo 2: Verificar Docker**
```bash
docker ps
```

**O que você deve ver:**
```
CONTAINER ID   IMAGE                                        NAMES                    PORTS
abc123def456   mcr.microsoft.com/mssql/server:2022-latest   appeao-sqlserver-auth    0.0.0.0:1433->1433/tcp
xyz789ghi012   mcr.microsoft.com/mssql/server:2022-latest   appeao-sqlserver-data    0.0.0.0:1434->1433/tcp
```

✅ **Se aparecerem 2 containers:** Ambos SQL Servers estão rodando!  
❌ **Se estiver vazio:** Execute `docker-compose up -d` no diretório do projeto

---

## 🔌 Conectar no DBeaver - Passo a Passo

📌 **ATENÇÃO:** Você precisará criar **2 conexões separadas** (uma para cada banco)

---

## 🔐 CONEXÃO 1: Banco de Autenticação (AppEAO_Auth)

### **PASSO 1: Abrir DBeaver**

1. Clique no ícone do DBeaver na área de trabalho ou menu iniciar
2. Na primeira vez, pode aparecer uma tela de boas-vindas
3. Clique em **"Close"** ou **"Fechar"**

---

### **PASSO 2: Criar Nova Conexão**

1. Na barra superior, clique em **"Database"** (Banco de Dados)
2. Clique em **"New Database Connection"** (Nova Conexão)
   - Ou use o atalho: `Ctrl + Shift + N`
   - Ou clique no ícone **"+"** na barra de ferramentas

---

### **PASSO 3: Selecionar SQL Server**

1. Na janela "Connect to a database", procure por **"SQL Server"**
   - Use a caixa de busca no topo
   - Digite: `sql server`

2. Clique no ícone **"SQL Server"** (logo azul com "SQL")

3. Clique no botão **"Next"** (Próximo)

---

### **PASSO 4: Configurar Conexão Auth - Aba "Main"**

Agora você verá a tela de configuração. Preencha os campos:

#### **Connection name (Nome da Conexão):**
```
AppEAO - Auth
```

#### **Server Host (Host do Servidor):**
```
localhost
```

#### **Port (Porta):**
```
1433
```

#### **Database/Schema (Banco de Dados):**
```
AppEAO_Auth
```

#### **Authentication (Autenticação):**
- Selecione: **"SQL Server Authentication"**

#### **User name (Nome de Usuário):**
```
sa
```

#### **Password (Senha):**
```
YourStrong@Passw0rd
```

✅ **Marque a caixa:** "Save password locally" (Salvar senha localmente)

---

### **PASSO 5: Testar Conexão**

1. Na parte inferior da janela, clique em **"Test Connection"** (Testar Conexão)

2. Se for a primeira vez:
   - Uma janela pedirá para **baixar os drivers**
   - Clique em **"Download"** ou **"Baixar"**
   - Aguarde o download terminar (pode levar 1-2 minutos)

3. Após o download:
   - Você verá uma mensagem: **"Connected"** ✅
   - Ou em português: **"Conectado"**

❌ **Se der erro:**
- Verifique se o SQL Server está rodando: `docker ps`
- Verifique se digitou a senha corretamente
- Tente novamente

---

### **PASSO 6: Finalizar Conexão Auth**

1. Clique no botão **"Finish"** (Finalizar)
2. A conexão aparecerá no painel esquerdo (**Database Navigator**)

```
📁 AppEAO - Auth
   └── 📁 Databases
       └── 📁 AppEAO_Auth
           └── 📁 Schemas
               └── 📁 dbo
                   └── 📁 Tables
                       └── 📊 Users
```

✅ **Primeira conexão criada com sucesso!**

---

## 📊 CONEXÃO 2: Banco de Dados de Negócio (AppEAO_Data)

### **PASSO 1: Criar Segunda Conexão**

1. Na barra superior, clique em **"Database"** > **"New Database Connection"**
   - Ou use: `Ctrl + Shift + N`

2. Selecione **"SQL Server"** novamente

3. Clique em **"Next"**

---

### **PASSO 2: Configurar Conexão Data - Aba "Main"**

Preencha os campos para o segundo banco:

#### **Connection name (Nome da Conexão):**
```
AppEAO - Data
```

#### **Server Host:**
```
localhost
```

#### **Port (Porta):**
```
1434
```
⚠️ **ATENÇÃO:** Porta diferente! É **1434** para o banco de Data!

#### **Database/Schema:**
```
AppEAO_Data
```

#### **Authentication:**
- Selecione: **"SQL Server Authentication"**

#### **User name:**
```
sa
```

#### **Password:**
```
YourStrong@Passw0rd
```

✅ **Marque:** "Save password locally"

---

### **PASSO 3: Testar Conexão Data**

1. Clique em **"Test Connection"**
2. Deve aparecer: **"Connected"** ✅
3. Clique em **"Finish"**

---

### **PASSO 4: Resultado Final**

Agora você terá **2 conexões** no Database Navigator:

```
📁 AppEAO - Auth (localhost:1433)
   └── 📁 Databases
       └── 📁 AppEAO_Auth
           └── 📁 dbo
               └── 📁 Tables
                   └── 📊 Users

📁 AppEAO - Data (localhost:1434)
   └── 📁 Databases
       └── 📁 AppEAO_Data
           └── 📁 dbo
               └── 📁 Tables
                   └── (vazio por enquanto)
```

✅ **Ambas as conexões criadas!**

---

## 📊 Visualizar Dados da Tabela Users (Banco Auth)

### **Método 1: Usando Interface Gráfica**

1. No painel esquerdo, expanda:
   ```
   AppEAO - Auth
   └── Databases
       └── AppEAO_Auth
           └── Schemas
               └── dbo
                   └── Tables
   ```

2. Localize a tabela **"Users"**

3. **Clique com botão direito** na tabela "Users"

4. Selecione **"View Data"** ou **"Ver Dados"**
   - Ou: **"Data" > "View Data"**

5. Uma aba será aberta mostrando todos os registros

✅ **Você verá as colunas:**
- Id
- Name
- Email
- PasswordHash
- Phone
- CreatedAt
- UpdatedAt
- IsActive

---

### **Método 2: Usando SQL**

1. **Clique com botão direito** na conexão **"AppEAO - Auth"**

2. Selecione **"SQL Editor"** > **"Open SQL Script"**
   - Ou pressione: `Ctrl + ]`

3. Digite a consulta SQL:

```sql
-- Ver todos os usuários
SELECT 
    Id,
    Name,
    Email,
    Phone,
    CreatedAt,
    IsActive
FROM Users;
```

4. **Execute a consulta:**
   - Pressione `Ctrl + Enter`
   - Ou clique no botão **"Execute SQL Statement"** (ícone de "play" laranja)

5. Os resultados aparecerão na parte inferior

---

## 🗄️ Entendendo os Dois Bancos

### **AppEAO_Auth (Porta 1433)**
**Propósito:** Gerenciar autenticação e credenciais de usuários

**Tabelas:**
- `Users` - Usuários do sistema

**Quando usar:**
- Ver usuários cadastrados
- Verificar emails
- Checar status de usuários
- Debugar problemas de login

---

### **AppEAO_Data (Porta 1434)**
**Propósito:** Armazenar dados de negócio da aplicação

**Tabelas:** (Futuras)
- `Profissionais` - Cadastro de profissionais
- `Servicos` - Serviços oferecidos
- `Solicitacoes` - Solicitações de trabalho
- `Avaliacoes` - Avaliações e feedback

**Quando usar:**
- Ver profissionais cadastrados
- Gerenciar serviços
- Acompanhar solicitações

⚠️ **Nota:** Por enquanto, este banco está vazio. Será usado no futuro.

---

## 🔍 Consultas Úteis (Banco Auth)

### **1. Contar Total de Usuários**

```sql
SELECT COUNT(*) AS TotalUsuarios
FROM Users;
```

### **2. Ver Usuários Ativos**

```sql
SELECT 
    Name,
    Email,
    CreatedAt
FROM Users
WHERE IsActive = 1
ORDER BY CreatedAt DESC;
```

### **3. Buscar Usuário por Email**

```sql
SELECT 
    Id,
    Name,
    Email,
    Phone,
    CreatedAt
FROM Users
WHERE Email = 'seu@email.com';
```

### **4. Ver Últimos 10 Usuários Cadastrados**

```sql
SELECT TOP 10
    Name,
    Email,
    CreatedAt
FROM Users
ORDER BY CreatedAt DESC;
```

### **5. Ver Estatísticas (usando a View criada)**

```sql
SELECT * FROM vw_UserStatistics;
```

---

## 🛠️ Operações Comuns

### **Adicionar Novo Usuário Manualmente**

```sql
INSERT INTO Users (Id, Name, Email, PasswordHash, Phone, CreatedAt, IsActive)
VALUES (
    NEWID(),
    'Nome do Usuário',
    'email@exemplo.com',
    '$2a$11$hashdaSenhaAqui',  -- Use a API para criar com hash correto
    '(11) 99999-9999',
    GETUTCDATE(),
    1
);
```

⚠️ **Atenção:** É melhor criar usuários pela API para garantir que a senha seja criptografada corretamente!

---

### **Atualizar Dados de um Usuário**

```sql
UPDATE Users
SET 
    Phone = '(11) 98888-8888',
    UpdatedAt = GETUTCDATE()
WHERE Email = 'email@exemplo.com';
```

---

### **Desativar um Usuário (Soft Delete)**

```sql
UPDATE Users
SET 
    IsActive = 0,
    UpdatedAt = GETUTCDATE()
WHERE Email = 'email@exemplo.com';
```

---

### **Deletar um Usuário (Permanente)**

```sql
DELETE FROM Users
WHERE Email = 'email@exemplo.com';
```

⚠️ **Cuidado:** Esta operação é permanente e não pode ser desfeita!

---

## 🎨 Personalizar DBeaver

### **Mudar Tema para Escuro**

1. Menu **"Window"** > **"Preferences"**
2. Procure por **"Appearance"**
3. Em **"Theme"**, selecione **"Dark"**
4. Clique **"Apply and Close"**

### **Aumentar Tamanho da Fonte**

1. Menu **"Window"** > **"Preferences"**
2. Procure por **"Fonts"**
3. Ajuste o tamanho desejado
4. Clique **"Apply and Close"**

---

## ❓ Troubleshooting (Resolução de Problemas)

### **Problema: "Cannot establish connection"**

**Solução:**

1. Verificar se SQL Server está rodando:
   ```bash
   docker ps
   ```

2. Se não estiver, iniciar:
   ```bash
   docker-compose up -d
   ```

3. Aguardar 30 segundos e tentar conectar novamente

---

### **Problema: "Login failed for user 'sa'"**

**Possíveis causas:**

1. **Senha incorreta**
   - Verifique: `YourStrong@Passw0rd` (com @ e maiúsculas)

2. **SQL Server ainda iniciando**
   - Aguarde mais 30 segundos
   - Tente novamente

---

### **Problema: "Driver not found"**

**Solução:**

1. Na tela de teste de conexão, clique em **"Download"**
2. Aguarde o download dos drivers
3. Tente conectar novamente

---

### **Problema: "Cannot connect to localhost:1433"**

**Solução:**

1. Verificar se Docker Desktop está rodando
2. Verificar se a porta está livre:
   ```bash
   netstat -ano | findstr :1433
   ```
3. Se necessário, reiniciar Docker:
   ```bash
   docker-compose restart sqlserver
   ```

---

## 📸 Resumo Visual

### **Dados de Conexão - Banco de Auth:**

| Campo | Valor |
|-------|-------|
| **Nome** | `AppEAO - Auth` |
| **Host** | `localhost` |
| **Porta** | `1433` |
| **Banco** | `AppEAO_Auth` |
| **Usuário** | `sa` |
| **Senha** | `YourStrong@Passw0rd` |
| **Autenticação** | SQL Server Authentication |

### **Dados de Conexão - Banco de Data:**

| Campo | Valor |
|-------|-------|
| **Nome** | `AppEAO - Data` |
| **Host** | `localhost` |
| **Porta** | `1434` ⚠️ |
| **Banco** | `AppEAO_Data` |
| **Usuário** | `sa` |
| **Senha** | `YourStrong@Passw0rd` |
| **Autenticação** | SQL Server Authentication |

### **Estrutura dos Bancos:**

**AppEAO_Auth (Autenticação):**
```
AppEAO_Auth (Database)
└── dbo (Schema)
    └── Tables
        └── Users
            ├── Id (uniqueidentifier)
            ├── Name (nvarchar)
            ├── Email (nvarchar)
            ├── PasswordHash (nvarchar)
            ├── Phone (nvarchar)
            ├── CreatedAt (datetime2)
            ├── UpdatedAt (datetime2)
            └── IsActive (bit)
```

**AppEAO_Data (Negócio - Futuro):**
```
AppEAO_Data (Database)
└── dbo (Schema)
    └── Tables
        ├── Profissionais (futuro)
        ├── Servicos (futuro)
        ├── Solicitacoes (futuro)
        └── Avaliacoes (futuro)
```

---

## 🎯 Checklist de Sucesso

- [ ] DBeaver instalado
- [ ] SQL Servers rodando no Docker (2 containers)
- [ ] Conexão Auth criada (porta 1433)
- [ ] Conexão Data criada (porta 1434)
- [ ] Teste de ambas conexões bem-sucedido
- [ ] Tabela Users visível no banco Auth
- [ ] Consegue executar consultas SQL

✅ **Tudo OK? Você está pronto para trabalhar com os bancos de dados!**

---

## 🔄 Alternar Entre os Bancos

Para trabalhar com bancos diferentes:

1. No **Database Navigator** (painel esquerdo)
2. Clique na conexão desejada:
   - **AppEAO - Auth** → Para ver usuários
   - **AppEAO - Data** → Para dados de negócio (futuro)
3. Expanda e navegue pelas tabelas

**Dica:** Você pode ter ambas as conexões abertas simultaneamente!

---

## 📚 Recursos Adicionais

### **Documentação Oficial:**
- DBeaver: https://dbeaver.io/docs/
- SQL Server: https://learn.microsoft.com/sql/

### **Tutoriais em Vídeo:**
- YouTube: "DBeaver Tutorial" (busque por vídeos em português)

### **Atalhos Úteis no DBeaver:**
- `Ctrl + Enter` - Executar consulta SQL
- `Ctrl + ]` - Abrir novo script SQL
- `Ctrl + Shift + E` - Executar script completo
- `Ctrl + Space` - Auto-complete SQL
- `F3` - Abrir propriedades do objeto

---

---

## 🏗️ Por Que Dois Bancos?

A separação em dois bancos de dados segue **boas práticas de arquitetura**:

### **Benefícios:**

1. **Segurança** 🔐
   - Dados sensíveis (senhas) isolados no banco Auth
   - Menor exposição de credenciais

2. **Escalabilidade** 📈
   - Bancos podem estar em servidores diferentes no futuro
   - Scaling independente

3. **Organização** 📁
   - Auth separado de dados de negócio
   - Responsabilidades claras

4. **Performance** ⚡
   - Índices e queries otimizados por tipo de dado
   - Menos concorrência

5. **Manutenção** 🛠️
   - Backup independente
   - Migrations separadas
   - Mais fácil gerenciar

---

**Criado para facilitar sua vida! 🎉**

Se tiver dúvidas, consulte:
- 📖 `README.md` - Visão geral do projeto
- 📚 `docs/INDICE.md` - Índice de toda documentação
- 🗄️ `database/README.md` - Detalhes da arquitetura de bancos

