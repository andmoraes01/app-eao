# 🗄️ Arquitetura de Bancos de Dados - AppEAO

## 📊 Separação de Bancos

O AppEAO utiliza **dois bancos de dados separados** para segregar responsabilidades:

### **1. AppEAO_Auth (Porta 1433)**
- **Propósito:** Autenticação e gerenciamento de usuários
- **Container:** `appeao-sqlserver-auth`
- **Porta:** 1433
- **Tabelas:**
  - `Users` - Credenciais e dados de autenticação

### **2. AppEAO_Data (Porta 1434)**
- **Propósito:** Dados de negócio da aplicação
- **Container:** `appeao-sqlserver-data`
- **Porta:** 1434
- **Tabelas:** (futuras)
  - `Profissionais` - Cadastro de profissionais
  - `Servicos` - Serviços oferecidos
  - `Solicitacoes` - Solicitações de serviços
  - `Avaliacoes` - Avaliações e feedback

---

## 🎯 Por Que Separar?

### **Benefícios:**

1. **Segurança** 🔐
   - Dados sensíveis (senhas) isolados
   - Acesso restrito ao banco de Auth
   - Menor superfície de ataque

2. **Escalabilidade** 📈
   - Bancos podem estar em servidores diferentes
   - Scaling independente
   - Performance otimizada

3. **Manutenção** 🛠️
   - Backup independente
   - Migrations separadas
   - Mais fácil gerenciar

4. **Organização** 📁
   - Responsabilidades claras
   - Auth separado de business
   - Código mais limpo

---

## 🔌 Conexões

### **appsettings.json:**
```json
{
  "ConnectionStrings": {
    "AuthConnection": "Server=localhost,1433;Database=AppEAO_Auth;...",
    "DataConnection": "Server=localhost,1434;Database=AppEAO_Data;..."
  }
}
```

### **Program.cs:**
```csharp
// Banco de Auth
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("AuthConnection")));

// Banco de Data (futuro)
// builder.Services.AddDbContext<DataDbContext>(options =>
//     options.UseSqlServer(builder.Configuration.GetConnectionString("DataConnection")));
```

---

## 📦 Docker Compose

### **Estrutura:**
```yaml
services:
  sqlserver-auth:    # Banco de Autenticação
    ports: "1433:1433"
    
  sqlserver-data:    # Banco de Negócio
    ports: "1434:1433"
```

### **Comandos:**

```bash
# Iniciar ambos os bancos
docker-compose up -d

# Ver status
docker ps

# Logs do banco de Auth
docker logs appeao-sqlserver-auth

# Logs do banco de Data
docker logs appeao-sqlserver-data

# Parar tudo
docker-compose down
```

---

## 🔍 Acessar os Bancos

### **Banco de Auth (porta 1433):**
```bash
docker exec -it appeao-sqlserver-auth /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "YourStrong@Passw0rd" -C
```

Depois:
```sql
USE AppEAO_Auth;
GO

SELECT * FROM Users;
GO
```

---

### **Banco de Data (porta 1434):**
```bash
docker exec -it appeao-sqlserver-data /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "YourStrong@Passw0rd" -C
```

Depois:
```sql
USE AppEAO_Data;
GO

-- Futuras tabelas aqui
```

---

## 📋 Schema Atual

### **AppEAO_Auth:**
```sql
Tables:
├── Users
│   ├── Id (PK, uniqueidentifier)
│   ├── Name (nvarchar(100))
│   ├── Email (nvarchar(255), UNIQUE)
│   ├── PasswordHash (nvarchar(max))
│   ├── Phone (nvarchar(20))
│   ├── CreatedAt (datetime2)
│   ├── UpdatedAt (datetime2)
│   └── IsActive (bit, DEFAULT 1)
│
└── __EFMigrationsHistory
```

### **AppEAO_Data:**
```sql
(Vazio - será populado no futuro)

Tabelas Planejadas:
├── Profissionais
├── Servicos
├── Categorias
├── Solicitacoes
├── Avaliacoes
└── Mensagens
```

---

## 🚀 Migrations

### **Banco de Auth:**
```bash
cd api\AppEAO.API

# Criar migration
dotnet ef migrations add NomeDaMigration

# Aplicar ao banco
dotnet ef database update
```

### **Banco de Data (futuro):**
```bash
# Quando criar o segundo DbContext:
dotnet ef migrations add NomeDaMigration --context DataDbContext
dotnet ef database update --context DataDbContext
```

---

## 📊 Comparação

### **Arquitetura Anterior (1 banco):**
```
AppEAO (único banco)
├── Users           ← Auth
├── Profissionais   ← Business
├── Servicos        ← Business
└── Avaliacoes      ← Business

❌ Tudo misturado
```

### **Arquitetura Atual (2 bancos):**
```
AppEAO_Auth              AppEAO_Data
├── Users                ├── Profissionais
└── (só auth)            ├── Servicos
                         └── Avaliacoes

✅ Separado e organizado
```

---

## 🎯 Próximos Passos

Quando precisar adicionar funcionalidades de negócio:

1. Criar `DataDbContext` 
2. Adicionar entidades de negócio
3. Configurar connection para `DataConnection`
4. Criar migrations separadas
5. Aplicar ao banco `AppEAO_Data`

**Exemplo futuro:**
```csharp
// Infrastructure/Data/DataDbContext.cs
public class DataDbContext : DbContext
{
    public DataDbContext(DbContextOptions<DataDbContext> options) : base(options) { }
    
    public DbSet<Profissional> Profissionais { get; set; }
    public DbSet<Servico> Servicos { get; set; }
}

// Program.cs
builder.Services.AddDbContext<DataDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DataConnection")));
```

---

## 📚 DBeaver - Conectar nos Dois Bancos

### **Conexão 1: Banco de Auth**
```
Nome: AppEAO Auth
Host: localhost
Porta: 1433
Database: AppEAO_Auth
User: sa
Password: YourStrong@Passw0rd
```

### **Conexão 2: Banco de Data**
```
Nome: AppEAO Data
Host: localhost
Porta: 1434
Database: AppEAO_Data
User: sa
Password: YourStrong@Passw0rd
```

---

**Arquitetura de bancos implementada! 🎉**

**Status:** ✅ Auth rodando | ⏳ Data aguardando implementação

