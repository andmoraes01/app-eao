# 🏗️ AppEAO - Monorepo

Aplicativo de gerenciamento de mão de obra com Flutter (mobile) e .NET (backend API).

## ⚡ Início Rápido

**Quer começar agora?** Execute:
```bash
SETUP.bat    # Setup inicial (primeira vez)
INICIAR.bat  # Iniciar serviços
```

**Quer guias detalhados?** Consulte:
- 📊 [Como conectar no banco (DBeaver)](docs/COMO_CONECTAR_DBEAVER.md)
- 🚀 [Como executar a API (Visual Studio)](docs/COMO_EXECUTAR_API_VISUAL_STUDIO.md)
- 📱 [Como executar o Mobile (Flutter)](docs/COMO_EXECUTAR_MOBILE_FLUTTER.md)
- 📚 [Ver toda documentação](docs/INDICE.md)

---

## 📁 Estrutura do Projeto

```
appeao/
├── mobile/              # Aplicativo Flutter
├── api/                 # API .NET 8.0
│   └── AppEAO.API/     # Projeto da API
├── database/            # Scripts SQL
├── docs/                # Documentação
├── docker-compose.yml   # Configuração Docker
└── README.md           # Este arquivo
```

## 🚀 Pré-requisitos

### **Obrigatórios:**
- [.NET SDK 8.0+](https://dotnet.microsoft.com/download)
- [Flutter SDK 3.0+](https://flutter.dev)
- [Docker Desktop](https://www.docker.com/products/docker-desktop/)

### **Opcional:**
- [Visual Studio Code](https://code.visualstudio.com/)
- [Postman](https://www.postman.com/) (para testar a API)

---

## 📋 Guia de Instalação - Passo a Passo

### **PASSO 1: Clonar/Baixar o Projeto**

```bash
cd C:\Users\Andre\Desktop\appeao
```

---

### **PASSO 2: Iniciar o Banco de Dados (SQL Server no Docker)**

```bash
# Iniciar o SQL Server
docker-compose up -d

# Verificar se está rodando
docker ps

# Ver logs (opcional)
docker logs appeao-sqlserver
```

⏳ **Aguarde ~30 segundos** para o SQL Server inicializar completamente.

✅ **Verificar se o banco está pronto:**
```bash
docker exec -it appeao-sqlserver /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "YourStrong@Passw0rd" -C -Q "SELECT @@VERSION"
```

---

### **PASSO 3: Configurar e Executar a API**

```bash
# Navegar para a pasta da API
cd api\AppEAO.API

# Restaurar pacotes
dotnet restore

# Aplicar migrations (criar banco de dados e tabelas)
dotnet ef database update

# Executar a API
dotnet run
```

✅ **API rodando em:** `https://localhost:7001` e `http://localhost:5001`

📖 **Swagger (documentação da API):** `https://localhost:7001/swagger`

---

### **PASSO 4: Executar o Aplicativo Mobile**

#### **Opção A: Executar no Chrome (mais fácil)**

```bash
# Navegar para a pasta mobile
cd ..\..\mobile

# Instalar dependências
flutter pub get

# Executar no navegador
flutter run -d chrome
```

#### **Opção B: Executar no Windows Desktop**

Primeiro, instale os componentes do Visual Studio:
1. Abra **Visual Studio Installer**
2. Modifique **Visual Studio Community 2022**
3. Marque: **"Desenvolvimento para desktop com C++"**
4. Inclua:
   - MSVC v142 - VS 2019 C++ x64/x86 build tools
   - C++ CMake tools for Windows
   - Windows 10 SDK

Depois execute:
```bash
flutter run -d windows
```

#### **Opção C: Executar em Emulador Android**

```bash
# Ver emuladores disponíveis
flutter emulators

# Iniciar emulador
flutter emulators --launch <nome-do-emulador>

# Executar app
flutter run
```

---

## 🔧 Comandos Úteis

### **Docker**

```bash
# Iniciar serviços
docker-compose up -d

# Parar serviços
docker-compose down

# Ver logs do SQL Server
docker logs -f appeao-sqlserver

# Reiniciar SQL Server
docker-compose restart sqlserver

# Remover tudo (cuidado: apaga os dados!)
docker-compose down -v
```

### **API .NET**

```bash
cd api\AppEAO.API

# Executar em modo desenvolvimento
dotnet run

# Executar com hot reload
dotnet watch run

# Criar nova migration
dotnet ef migrations add NomeDaMigration

# Aplicar migrations
dotnet ef database update

# Reverter última migration
dotnet ef migrations remove

# Build para produção
dotnet build -c Release

# Executar testes (se houver)
dotnet test
```

### **Mobile Flutter**

```bash
cd mobile

# Instalar dependências
flutter pub get

# Limpar cache
flutter clean

# Ver dispositivos disponíveis
flutter devices

# Executar no Chrome
flutter run -d chrome

# Executar no Windows
flutter run -d windows

# Build para produção (Windows)
flutter build windows

# Build para Android APK
flutter build apk

# Analisar código
flutter analyze
```

---

## 📡 Endpoints da API

### **Base URL:** `https://localhost:7001/api`

### **Autenticação**

#### **1. Registrar Novo Usuário**
```http
POST /api/auth/register
Content-Type: application/json

{
  "name": "João Silva",
  "email": "joao@email.com",
  "password": "senha123",
  "phone": "(11) 99999-9999"
}
```

**Resposta (201 Created):**
```json
{
  "userId": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  "name": "João Silva",
  "email": "joao@email.com",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "expiresAt": "2025-10-02T22:00:00Z"
}
```

#### **2. Login**
```http
POST /api/auth/login
Content-Type: application/json

{
  "email": "joao@email.com",
  "password": "senha123"
}
```

#### **3. Obter Perfil (requer autenticação)**
```http
GET /api/auth/profile
Authorization: Bearer {seu-token-jwt}
```

#### **4. Verificar Token**
```http
GET /api/auth/verify
Authorization: Bearer {seu-token-jwt}
```

### **Health Check**

```http
GET /health
```

---

## 🗄️ Estrutura do Banco de Dados

### **Tabela: Users**

| Coluna        | Tipo         | Descrição                    |
|---------------|--------------|------------------------------|
| Id            | uniqueidentifier | PK, gerado automaticamente   |
| Name          | nvarchar(100)| Nome completo                |
| Email         | nvarchar(255)| Email único                  |
| PasswordHash  | nvarchar(max)| Senha criptografada (BCrypt) |
| Phone         | nvarchar(20) | Telefone (opcional)          |
| CreatedAt     | datetime2    | Data de criação              |
| UpdatedAt     | datetime2    | Data de atualização          |
| IsActive      | bit          | Status do usuário            |

**Índices:**
- `IX_Users_Email` (único)
- `IX_Users_CreatedAt`

---

## 🔐 Segurança

- **Senhas:** Criptografadas com BCrypt
- **Tokens:** JWT com expiração de 24 horas
- **HTTPS:** Obrigatório em produção
- **CORS:** Configurado para aceitar qualquer origem (ajuste em produção)

---

## 🧪 Testando a API

### **Com Postman:**

1. Importe a collection (criar arquivo `AppEAO.postman_collection.json`)
2. Configure a variável `{{baseUrl}}`: `https://localhost:7001`
3. Teste os endpoints

### **Com cURL:**

```bash
# Registrar usuário
curl -X POST https://localhost:7001/api/auth/register \
  -H "Content-Type: application/json" \
  -d "{\"name\":\"Teste\",\"email\":\"teste@email.com\",\"password\":\"123456\"}"

# Login
curl -X POST https://localhost:7001/api/auth/login \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"teste@email.com\",\"password\":\"123456\"}"
```

### **Com Swagger:**

Acesse: `https://localhost:7001/swagger`

---

## 🐛 Troubleshooting

### **Problema: SQL Server não inicia**
```bash
# Verificar logs
docker logs appeao-sqlserver

# Reiniciar
docker-compose restart sqlserver
```

### **Problema: API não conecta ao banco**
- Verifique se o SQL Server está rodando: `docker ps`
- Teste a conexão manualmente
- Verifique a connection string em `appsettings.json`

### **Problema: Flutter não encontra dispositivos**
```bash
flutter doctor
flutter devices
```

### **Problema: Porta já em uso**
```bash
# Verificar processos na porta 1433 (SQL Server)
netstat -ano | findstr :1433

# Verificar processos na porta 5001 (API)
netstat -ano | findstr :5001
```

---

## 📚 Documentação Adicional

- [Documentação do Flutter](https://flutter.dev/docs)
- [Documentação do .NET](https://docs.microsoft.com/dotnet)
- [Entity Framework Core](https://docs.microsoft.com/ef/core)
- [SQL Server no Docker](https://hub.docker.com/_/microsoft-mssql-server)

---

## 👨‍💻 Desenvolvimento

### **Fluxo de Trabalho:**

1. **Iniciar serviços:**
   ```bash
   docker-compose up -d
   ```

2. **Desenvolvimento da API:**
   ```bash
   cd api\AppEAO.API
   dotnet watch run
   ```

3. **Desenvolvimento do Mobile:**
   ```bash
   cd mobile
   flutter run -d chrome
   ```

---

## 📝 Próximos Passos

- [ ] Implementar tela de cadastro no mobile
- [ ] Implementar tela de login no mobile
- [ ] Integrar mobile com API
- [ ] Adicionar testes unitários
- [ ] Adicionar validações avançadas
- [ ] Implementar refresh token
- [ ] Adicionar recuperação de senha
- [ ] Deploy em produção

---

## 📄 Licença

Este projeto é privado e destinado apenas para uso interno.

---

## 🆘 Suporte

Para dúvidas ou problemas, consulte a documentação em `docs/` ou abra uma issue.
