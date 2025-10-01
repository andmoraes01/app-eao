# 🚀 Como Executar a API no Visual Studio

## 📋 Pré-requisitos

### **1. Instalar Visual Studio 2022**

1. Acesse: https://visualstudio.microsoft.com/downloads/
2. Baixe **Visual Studio Community 2022** (gratuito)
3. Execute o instalador **"vs_community.exe"**

---

### **2. Selecionar Componentes na Instalação**

Durante a instalação, você verá várias opções de "Workloads" (Cargas de Trabalho).

#### **Obrigatório:**
✅ Marque: **"ASP.NET and web development"** (Desenvolvimento Web e ASP.NET)

#### **Componentes Individuais (Aba "Individual components"):**

Na aba "Individual components", procure e marque:
- ✅ **.NET 8.0 Runtime**
- ✅ **.NET SDK**
- ✅ **Entity Framework 6 tools**

#### **Resumo:**
```
Workloads:
✅ ASP.NET and web development

Components:
✅ .NET 8.0 Runtime
✅ .NET SDK
✅ Entity Framework tools
```

---

### **3. Finalizar Instalação**

1. Clique em **"Install"** (Instalar)
2. Aguarde o download e instalação (pode levar 20-40 minutos dependendo da internet)
3. Após instalação, reinicie o computador se solicitado

✅ **Visual Studio instalado!**

---

## 🐳 Verificar SQL Server

Antes de executar a API, o banco de dados precisa estar rodando.

### **Passo 1: Abrir PowerShell ou CMD**

- Pressione `Windows + R`
- Digite: `cmd` ou `powershell`
- Pressione Enter

### **Passo 2: Navegar até o Projeto**

```bash
cd C:\Users\Andre\Desktop\appeao
```

### **Passo 3: Verificar se Docker está Rodando**

```bash
docker ps
```

**Deve mostrar:**
```
CONTAINER ID   IMAGE                                        STATUS
abc123         mcr.microsoft.com/mssql/server:2022-latest   Up X minutes
```

### **Passo 4: Se Não Estiver Rodando**

```bash
docker-compose up -d
```

Aguarde 30 segundos para o SQL Server inicializar.

✅ **SQL Server rodando!**

---

## 📂 Abrir Projeto no Visual Studio

### **MÉTODO 1: Pelo Explorador de Arquivos (Mais Fácil)**

1. Abra o **Explorador de Arquivos** do Windows

2. Navegue até:
   ```
   C:\Users\Andre\Desktop\appeao\api\AppEAO.API
   ```

3. Procure o arquivo: **`AppEAO.API.csproj`**

4. **Clique duas vezes** no arquivo `.csproj`

5. O Visual Studio abrirá automaticamente

---

### **MÉTODO 2: Pelo Visual Studio**

1. Abra o **Visual Studio 2022**

2. Na tela inicial, clique em **"Open a project or solution"**
   - Ou: **"Abrir um projeto ou solução"**

3. Navegue até:
   ```
   C:\Users\Andre\Desktop\appeao\api\AppEAO.API
   ```

4. Selecione o arquivo **`AppEAO.API.csproj`**

5. Clique em **"Open"** (Abrir)

---

### **MÉTODO 3: Pela Pasta da Solução**

1. Abra o Visual Studio 2022

2. Na tela inicial, clique em **"Open a local folder"**

3. Navegue e selecione a pasta:
   ```
   C:\Users\Andre\Desktop\appeao\api\AppEAO.API
   ```

4. Clique em **"Select Folder"**

---

## ⏳ Primeira Vez - Restaurar Pacotes

Quando você abrir o projeto pela primeira vez, o Visual Studio vai:

1. **Carregar o projeto** (pode levar alguns segundos)

2. **Restaurar pacotes NuGet automaticamente**
   - Você verá uma barra de progresso na parte inferior
   - Mensagem: "Restoring NuGet packages..."

3. **Aguarde até ver:**
   ```
   Restore completed in X ms
   ```

✅ **Pacotes restaurados!**

---

## 🔧 Configurar Projeto para Execução

### **PASSO 1: Verificar Configuração de Inicialização**

1. Na barra superior do Visual Studio, procure por um **dropdown** que mostra:
   ```
   https ▼
   ```
   ou
   ```
   AppEAO.API ▼
   ```

2. Clique na **setinha ▼**

3. Selecione: **"https"**

✅ **Configuração correta!**

---

### **PASSO 2: Verificar Configuração do Projeto**

1. No **Solution Explorer** (Gerenciador de Soluções) à direita:
   - Se não estiver visível, pressione `Ctrl + Alt + L`

2. **Clique com botão direito** no projeto **"AppEAO.API"**

3. Selecione **"Properties"** (Propriedades) no final do menu

4. No menu lateral esquerdo, clique em **"Debug"**

5. Clique em **"Open debug launch profiles UI"**

6. Verifique:
   - ✅ **Launch browser:** MARCADO
   - ✅ **App URL:** `https://localhost:7001;http://localhost:5001`

7. Feche a janela (será salvo automaticamente)

---

## ▶️ EXECUTAR A API

### **MÉTODO 1: Botão Play (Mais Fácil)**

1. Na barra superior, localize o **botão verde de "Play"** ▶️
   - Está escrito: **"https"** ou **"AppEAO.API"**

2. **Clique no botão ▶️**

3. Aguarde a compilação:
   - Você verá mensagens na parte inferior (**Output**)
   - "Build started..."
   - "Build succeeded"

4. Uma janela de terminal (console) abrirá mostrando:
   ```
   info: Microsoft.Hosting.Lifetime[14]
         Now listening on: https://localhost:7001
   info: Microsoft.Hosting.Lifetime[14]
         Now listening on: http://localhost:5001
   ```

5. **O navegador abrirá automaticamente** mostrando o Swagger

✅ **API rodando!**

---

### **MÉTODO 2: Menu Debug**

1. No menu superior, clique em **"Debug"**

2. Selecione **"Start Debugging"**
   - Ou pressione: **F5**

3. Aguarde compilação e execução

---

### **MÉTODO 3: Sem Debug (Mais Rápido)**

1. No menu superior, clique em **"Debug"**

2. Selecione **"Start Without Debugging"**
   - Ou pressione: **Ctrl + F5**

3. Executa sem anexar o debugger (inicia mais rápido)

---

## 🌐 O que Abre Automaticamente

Quando você executa a API, **automaticamente** abrirá:

### **1. Console/Terminal**
Mostra os logs em tempo real:
```
info: Microsoft.Hosting.Lifetime[14]
      Now listening on: https://localhost:7001
info: Microsoft.Hosting.Lifetime[14]
      Now listening on: http://localhost:5001
```

### **2. Navegador com Swagger**
- URL: `https://localhost:7001/swagger`
- Interface para testar os endpoints

### **3. Navegador com Health Check** (após configuração)
- URL: `https://localhost:7001/health`
- Status da API

---

## 📖 Usando o Swagger

O Swagger abrirá automaticamente. Você verá:

### **Endpoints Disponíveis:**

```
▼ Auth
  POST   /api/auth/register
  POST   /api/auth/login
  GET    /api/auth/profile
  GET    /api/auth/verify

▼ Health
  GET    /health
```

---

### **Testar Endpoint de Registro:**

1. **Clique em:** `POST /api/auth/register`

2. A seção expandirá

3. **Clique em:** "Try it out" (Experimentar)

4. **Edite o JSON de exemplo:**

```json
{
  "name": "João Silva",
  "email": "joao@teste.com",
  "password": "123456",
  "phone": "(11) 99999-9999"
}
```

5. **Clique em:** "Execute"

6. **Veja a resposta:**
   - Se sucesso: **Status 201 Created**
   - Você verá o token JWT gerado

---

### **Testar Endpoint de Login:**

1. **Clique em:** `POST /api/auth/login`

2. **Clique em:** "Try it out"

3. **Preencha:**

```json
{
  "email": "joao@teste.com",
  "password": "123456"
}
```

4. **Clique em:** "Execute"

5. **Resposta:**
   - Status: **200 OK**
   - Token JWT retornado

---

## 🛑 Parar a API

### **MÉTODO 1: Botão Stop**

1. Na barra superior, clique no **botão vermelho ⏹️** (Stop)

2. A API parará e o console fechará

---

### **MÉTODO 2: Menu Debug**

1. Menu **"Debug"**
2. **"Stop Debugging"**
3. Ou pressione: **Shift + F5**

---

### **MÉTODO 3: Fechar Console**

1. Clique no **X** da janela do console

2. A API parará automaticamente

---

## 🔄 Hot Reload (Recarregar Sem Reiniciar)

O Visual Studio 2022 tem **Hot Reload** ativado por padrão!

### **Como Funciona:**

1. Com a API rodando, faça uma alteração no código

2. **Salve o arquivo** (Ctrl + S)

3. O Visual Studio detectará e recarregará automaticamente

4. Você verá na parte inferior:
   ```
   Hot Reload succeeded
   ```

✅ **Mudanças aplicadas sem reiniciar!**

### **Quando Não Funciona:**

Hot Reload funciona para:
- ✅ Mudanças em métodos
- ✅ Mudanças em lógica
- ✅ Adicionar novos endpoints

NÃO funciona para:
- ❌ Mudanças em `Program.cs`
- ❌ Adicionar novos pacotes NuGet
- ❌ Mudanças em configuração

**Nestes casos, pare e inicie novamente (F5).**

---

## 📊 Ver Logs em Tempo Real

### **Output Window:**

1. Menu **"View"** > **"Output"**
   - Ou: `Ctrl + Alt + O`

2. No dropdown **"Show output from:"**, selecione:
   - **"Debug"** - Para logs de debug
   - **"AppEAO.API"** - Para logs da aplicação

3. Você verá todos os logs:
   ```
   info: API iniciada
   info: Requisição recebida: POST /api/auth/register
   info: Novo usuário registrado
   ```

---

## 🐛 Debug (Depuração)

### **Adicionar Breakpoint:**

1. Abra um arquivo de código (ex: `AuthController.cs`)

2. Clique na **margem esquerda cinza** ao lado do número da linha
   - Um **círculo vermelho** aparecerá

3. Execute a API com **F5** (Debug)

4. Faça uma requisição que chegue naquele código

5. **A execução pausará** no breakpoint

6. Você pode:
   - Ver valores de variáveis (passe o mouse sobre elas)
   - Usar a janela **"Locals"** para ver todas as variáveis
   - Pressionar **F10** para executar linha por linha
   - Pressionar **F5** para continuar

---

## ⚙️ Configurações Úteis

### **Abrir `appsettings.json`:**

1. No **Solution Explorer**

2. Clique duas vezes em **`appsettings.json`**

3. Você verá:
   ```json
   {
     "ConnectionStrings": {
       "DefaultConnection": "Server=localhost,1433;..."
     },
     "JwtSettings": {
       "SecretKey": "...",
       ...
     }
   }
   ```

### **Alterar Porta da API:**

1. Abra **`Properties/launchSettings.json`**

2. Procure por:
   ```json
   "applicationUrl": "https://localhost:7001;http://localhost:5001"
   ```

3. Mude para a porta desejada

4. Salve e reinicie a API

---

## 📦 Gerenciar Pacotes NuGet

### **Via Interface Gráfica:**

1. No **Solution Explorer**

2. **Clique com botão direito** no projeto **"AppEAO.API"**

3. Selecione **"Manage NuGet Packages..."**

4. Você verá abas:
   - **Browse** - Pesquisar e instalar novos pacotes
   - **Installed** - Ver pacotes instalados
   - **Updates** - Ver atualizações disponíveis

### **Via Package Manager Console:**

1. Menu **"Tools"** > **"NuGet Package Manager"** > **"Package Manager Console"**

2. Execute comandos:
   ```powershell
   Install-Package NomeDoPackage
   Update-Package NomeDoPackage
   Uninstall-Package NomeDoPackage
   ```

---

## 🔍 Troubleshooting

### **Problema: "The project doesn't know how to run the profile 'https'"**

**Solução:**
1. Clique com botão direito no projeto
2. **Properties** > **Debug**
3. Crie novo profile "https"
4. Configure a URL: `https://localhost:7001`

---

### **Problema: "Unable to connect to SQL Server"**

**Solução:**
1. Verificar se Docker está rodando: `docker ps`
2. Iniciar SQL Server: `docker-compose up -d`
3. Aguardar 30 segundos
4. Reiniciar a API (F5)

---

### **Problema: "Port 7001 is already in use"**

**Solução:**
1. Parar a API se estiver rodando
2. Verificar processos na porta:
   ```bash
   netstat -ano | findstr :7001
   ```
3. Matar o processo:
   ```bash
   taskkill /PID <número> /F
   ```

---

### **Problema: Pacotes NuGet não restauram**

**Solução:**
1. Menu **"Tools"** > **"NuGet Package Manager"** > **"Package Manager Console"**
2. Execute:
   ```powershell
   dotnet restore
   ```
3. Se persistir:
   ```powershell
   dotnet clean
   dotnet build
   ```

---

### **Problema: "Build failed"**

**Solução:**
1. Ver erros na janela **"Error List"**:
   - Menu **"View"** > **"Error List"**
2. Clique duas vezes no erro para ir ao código
3. Corrija o erro
4. Salve e tente novamente

---

## 🎨 Personalizar Visual Studio

### **Tema Escuro:**

1. Menu **"Tools"** > **"Options"**
2. **"Environment"** > **"General"**
3. **"Color theme:"** > Selecione **"Dark"**
4. **OK**

### **Aumentar Fonte:**

1. Menu **"Tools"** > **"Options"**
2. **"Environment"** > **"Fonts and Colors"**
3. Ajuste **"Size"** (Tamanho)
4. **OK**

---

## ⌨️ Atalhos Úteis

| Atalho | Ação |
|--------|------|
| **F5** | Iniciar com Debug |
| **Ctrl + F5** | Iniciar sem Debug |
| **Shift + F5** | Parar Debug |
| **F9** | Adicionar/Remover Breakpoint |
| **F10** | Debug - Próxima linha |
| **F11** | Debug - Entrar no método |
| **Ctrl + .** | Quick Actions (correções rápidas) |
| **Ctrl + K, Ctrl + D** | Formatar documento |
| **Ctrl + Shift + B** | Build projeto |
| **Ctrl + Alt + L** | Solution Explorer |
| **Ctrl + Alt + O** | Output Window |

---

## 📊 Checklist de Execução

- [ ] Visual Studio 2022 instalado
- [ ] Projeto aberto (AppEAO.API.csproj)
- [ ] Docker rodando
- [ ] SQL Server ativo (docker ps)
- [ ] Pacotes NuGet restaurados
- [ ] Configuração "https" selecionada
- [ ] Pressionar F5
- [ ] Swagger abre automaticamente
- [ ] API rodando nas portas 7001/5001

✅ **Tudo OK? API funcionando perfeitamente!**

---

## 🎯 Workflow Diário

### **Iniciar o Dia:**

```bash
# 1. Iniciar SQL Server
docker-compose up -d

# 2. Aguardar 20 segundos
# (enquanto isso, abra o Visual Studio)

# 3. Abrir Visual Studio
# - Abrir projeto AppEAO.API.csproj

# 4. Pressionar F5
# - API iniciará automaticamente
```

### **Durante o Desenvolvimento:**

1. Fazer alterações no código
2. Salvar (Ctrl + S)
3. Hot Reload aplica automaticamente
4. Testar no Swagger
5. Repetir

### **Fim do Dia:**

1. Parar API (Shift + F5)
2. Fechar Visual Studio
3. Parar SQL Server (opcional):
   ```bash
   docker-compose down
   ```

---

## 📚 Recursos Adicionais

### **Documentação Oficial:**
- Visual Studio: https://learn.microsoft.com/visualstudio/
- ASP.NET Core: https://learn.microsoft.com/aspnet/core/

### **Tutoriais:**
- Microsoft Learn (gratuito)
- YouTube: "Visual Studio 2022 Tutorial"

---

**Criado para facilitar seu desenvolvimento! 🚀**

Agora você está pronto para desenvolver com o Visual Studio profissionalmente!

