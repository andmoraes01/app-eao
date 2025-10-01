# 📱 Como Executar o Mobile (Flutter) - Guia Completo

## 📋 Pré-requisitos

### **1. Instalar Flutter SDK**

#### **Passo 1: Download**
1. Acesse: https://flutter.dev/docs/get-started/install/windows
2. Clique em **"Download Flutter SDK"**
3. Baixe o arquivo ZIP (aproximadamente 1GB)

#### **Passo 2: Extrair**
1. Extraia o arquivo ZIP
2. **Recomendado:** Coloque em `C:\flutter`
   - ⚠️ **Importante:** NÃO coloque em pastas com espaços ou caracteres especiais
   - ✅ Bom: `C:\flutter`
   - ❌ Ruim: `C:\Program Files\flutter`

#### **Passo 3: Adicionar ao PATH**

1. Pressione `Windows + R`
2. Digite: `sysdm.cpl` e pressione Enter
3. Clique na aba **"Avançado"**
4. Clique em **"Variáveis de Ambiente"**
5. Na seção **"Variáveis do sistema"**, encontre **"Path"**
6. Clique em **"Editar"**
7. Clique em **"Novo"**
8. Digite: `C:\flutter\bin` (ou o caminho onde você extraiu)
9. Clique **"OK"** em todas as janelas

#### **Passo 4: Verificar Instalação**

1. Abra um **novo terminal** (PowerShell ou CMD)
2. Execute:
   ```bash
   flutter --version
   ```

**Deve mostrar:**
```
Flutter 3.35.5 • channel stable
Dart 3.9.2
```

✅ **Flutter instalado com sucesso!**

---

### **2. Executar Flutter Doctor**

O Flutter tem uma ferramenta que verifica se está tudo configurado corretamente.

```bash
flutter doctor
```

**Você verá algo assim:**
```
Doctor summary (to see all details, run flutter doctor -v):
[√] Flutter (Channel stable, 3.35.5)
[√] Windows Version (10 Home 64 bits)
[√] Chrome - develop for the web
[!] Visual Studio - develop Windows apps
[√] VS Code (version 1.95.0)
[√] Connected device (2 available)
[√] Network resources

! Doctor found issues in 1 category.
```

**Símbolos:**
- `[√]` = Tudo OK ✅
- `[!]` = Aviso (pode funcionar, mas não está 100%)
- `[X]` = Erro (precisa corrigir)

---

### **3. Instalar Extensão do Flutter (Opcional mas Recomendado)**

#### **Para VS Code:**

1. Abra o **Visual Studio Code**
2. Pressione `Ctrl + Shift + X` (Extensões)
3. Procure por: **"Flutter"**
4. Clique em **"Install"** na extensão oficial do Flutter (Dart Code)
5. Isso instalará também a extensão **Dart** automaticamente

✅ **Extensões instaladas!**

---

## 🌐 Opções de Execução

O Flutter pode rodar em várias plataformas. Vamos ver cada uma:

### **Resumo das Opções:**

| Plataforma | Dificuldade | Requisitos | Recomendado |
|------------|-------------|------------|-------------|
| **Chrome** | ⭐ Fácil | Navegador Chrome | ✅ SIM (Mais rápido) |
| **Edge** | ⭐ Fácil | Navegador Edge | ✅ SIM |
| **Windows** | ⭐⭐ Médio | Visual Studio C++ tools | ⚠️ Opcional |
| **Android** | ⭐⭐⭐ Difícil | Android Studio + Emulador | ❌ Não necessário |

**Recomendação:** Use **Chrome** ou **Edge** para desenvolvimento!

---

## 🚀 EXECUTAR NO CHROME (Mais Fácil)

### **Passo 1: Verificar se Chrome está Disponível**

```bash
flutter devices
```

**Você verá:**
```
Chrome (web) • chrome • web-javascript • Google Chrome 140.0.7339.208
```

✅ **Chrome detectado!**

---

### **Passo 2: Navegar até o Projeto**

```bash
cd C:\Users\Andre\Desktop\appeao\mobile
```

---

### **Passo 3: Instalar Dependências (Primeira Vez)**

```bash
flutter pub get
```

**O que acontece:**
- Flutter baixa todas as dependências do projeto
- Você verá: `Got dependencies!`

⏱️ **Tempo:** 10-30 segundos (depende da internet)

✅ **Dependências instaladas!**

---

### **Passo 4: Executar no Chrome**

```bash
flutter run -d chrome
```

**O que acontece:**

1. **Flutter compila o projeto**
   ```
   Launching lib\main.dart on Chrome in debug mode...
   ```

2. **Chrome abre automaticamente**
   - Uma nova janela do Chrome será aberta
   - Mostrará seu aplicativo

3. **Console mostra comandos:**
   ```
   Flutter run key commands.
   r Hot reload. 🔥
   R Hot restart.
   h List all available interactive commands.
   d Detach (terminate "flutter run" but leave application running).
   c Clear the screen
   q Quit (terminate the application on the device).
   ```

✅ **App rodando no Chrome!**

---

### **Passo 5: Ver o Aplicativo**

O Chrome abrirá e você verá:

1. **Tela de Loading (5 segundos)**
   - Logo "AppEAO" com martelo animado
   - Placa balançando

2. **Tela de Login**
   - Campos para email e senha
   - Botão "CRIAR CONTA"

3. **Pronto!** Você pode interagir com o app! 🎉

---

## 🔥 Hot Reload - Mudanças Instantâneas

Uma das melhores features do Flutter!

### **Como Usar:**

1. **Com o app rodando**, abra um arquivo Dart (ex: `login_screen.dart`)

2. **Faça uma mudança** (ex: mude o texto de um botão)

3. **Salve o arquivo** (`Ctrl + S`)

4. No terminal, pressione **`r`** (letra r minúscula)

5. **O app atualiza INSTANTANEAMENTE** sem perder o estado!

**Comandos no Terminal:**

| Tecla | Ação | Quando usar |
|-------|------|-------------|
| `r` | Hot Reload | Para mudanças em UI/lógica |
| `R` | Hot Restart | Para mudanças grandes ou erros |
| `q` | Quit | Para parar o app |
| `c` | Clear | Limpar console |
| `h` | Help | Ver todos os comandos |

---

## 🌐 EXECUTAR NO EDGE

Se preferir o Edge ao invés do Chrome:

```bash
flutter run -d edge
```

Funciona exatamente igual ao Chrome! ✅

---

## 💻 EXECUTAR NO WINDOWS DESKTOP

Para rodar como aplicativo nativo do Windows:

### **Pré-requisito: Visual Studio C++ Tools**

1. Abra **Visual Studio Installer**
2. Modifique **Visual Studio Community 2022**
3. Marque: **"Desenvolvimento para desktop com C++"**
4. Inclua:
   - ✅ MSVC v142 - VS 2019 C++ x64/x86 build tools
   - ✅ C++ CMake tools for Windows
   - ✅ Windows 10 SDK
5. Instalar (pode levar 10-20 minutos)

### **Executar:**

```bash
flutter run -d windows
```

**Vantagens:**
- ✅ App nativo do Windows
- ✅ Performance melhor
- ✅ Parece um app desktop real

**Desvantagens:**
- ❌ Primeira compilação é lenta (2-5 minutos)
- ❌ Requer Visual Studio instalado

---

## 📂 Estrutura do Projeto Mobile

Entenda a organização do código:

```
mobile/
├── lib/                          ← Todo o código Dart aqui
│   ├── main.dart                ← Ponto de entrada
│   ├── screens/                 ← Telas do app
│   │   ├── loading_screen.dart  ← Splash screen (5s)
│   │   ├── login_screen.dart    ← Tela de login
│   │   ├── register_screen.dart ← Tela de cadastro
│   │   └── home_screen.dart     ← Tela principal
│   └── services/
│       └── auth_service.dart    ← Comunicação com API
├── pubspec.yaml                 ← Dependências do projeto
├── analysis_options.yaml        ← Regras de lint
└── build/                       ← Arquivos compilados (ignorar)
```

---

## 🎨 Desenvolvimento - Workflow

### **Método 1: Via Terminal (Recomendado)**

#### **Setup Inicial:**
```bash
# 1. Navegar para o projeto
cd C:\Users\Andre\Desktop\appeao\mobile

# 2. Instalar dependências
flutter pub get

# 3. Executar
flutter run -d chrome
```

#### **Desenvolvimento:**
```bash
# App rodando, você faz mudanças no código...

# No terminal do Flutter:
r    # Hot reload (aplicar mudanças)
R    # Hot restart (reiniciar app)
c    # Limpar console
q    # Sair
```

---

### **Método 2: Via VS Code**

#### **Passo 1: Abrir Projeto**
1. Abrir VS Code
2. **File** > **Open Folder**
3. Selecionar: `C:\Users\Andre\Desktop\appeao\mobile`

#### **Passo 2: Selecionar Dispositivo**
1. Na parte inferior direita, clique onde mostra o dispositivo
2. Selecione **"Chrome (web)"** ou **"Windows (desktop)"**

#### **Passo 3: Executar**
- Pressione **F5** ou
- Menu **"Run"** > **"Start Debugging"** ou
- Clique no ícone de "Play" no canto superior direito

#### **Hot Reload no VS Code:**
- Salvar arquivo: `Ctrl + S`
- Hot reload automático ativado! ⚡
- Ou: `Ctrl + F5` para reiniciar

---

### **Método 3: Via Script INICIAR.bat**

```bash
# Na raiz do projeto
INICIAR.bat

# Escolher opção 2 (Mobile)
```

O script executará automaticamente! ✅

---

## 🧪 Testando o App

### **Fluxo Completo de Teste:**

#### **1. Loading Screen (5 segundos)**
- ⏱️ Aguarde 5 segundos
- 🎨 Veja a animação do martelo
- 📋 Placa "AppEAO" balançando

#### **2. Tela de Login**
- 👀 Você verá campos de email e senha
- 🔘 Botão "ENTRAR"
- 🔘 Botão "CRIAR CONTA"

#### **3. Criar Nova Conta**
1. Clique em **"CRIAR CONTA"**
2. Preencha:
   ```
   Nome:     João Silva
   Email:    joao@teste.com
   Senha:    123456
   Telefone: (11) 99999-9999 (opcional)
   ```
3. Clique em **"CADASTRAR"**
4. ✅ Se a API estiver rodando: "Cadastro realizado com sucesso!"
5. ❌ Se a API NÃO estiver rodando: Erro de conexão

#### **4. Fazer Login**
1. Digite email e senha
2. Clique em **"ENTRAR"**
3. ✅ Sucesso: "Bem-vindo, João Silva!"
4. Redireciona para tela principal

---

## 🔗 Integração com API

Para o app funcionar completamente, a **API precisa estar rodando!**

### **Setup Completo:**

#### **Terminal 1: API**
```bash
cd C:\Users\Andre\Desktop\appeao\api\AppEAO.API
dotnet run
```
✅ API rodando em `https://localhost:7001`

#### **Terminal 2: Mobile**
```bash
cd C:\Users\Andre\Desktop\appeao\mobile
flutter run -d chrome
```
✅ Mobile rodando e conectando na API

### **Verificar Integração:**

1. No mobile, cadastre um usuário
2. Verifique nos logs da API:
   ```
   info: Novo usuário registrado: joao@teste.com
   ```
3. Conecte no banco e veja o registro:
   ```sql
   SELECT * FROM Users;
   ```

✅ **Integração funcionando!**

---

## 📦 Gerenciar Dependências

### **Ver Dependências Instaladas:**

Abra `pubspec.yaml`:
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2
  http: ^1.1.0  # Para fazer requisições HTTP
```

### **Adicionar Nova Dependência:**

1. Abra `pubspec.yaml`
2. Adicione na seção `dependencies`:
   ```yaml
   shared_preferences: ^2.2.2
   ```
3. Salve o arquivo
4. Execute:
   ```bash
   flutter pub get
   ```

### **Atualizar Dependências:**

```bash
# Ver atualizações disponíveis
flutter pub outdated

# Atualizar todas
flutter pub upgrade
```

---

## 🐛 Debug (Depuração)

### **Via VS Code:**

#### **Adicionar Breakpoint:**
1. Abra um arquivo Dart (ex: `login_screen.dart`)
2. Clique na **margem esquerda** ao lado do número da linha
3. Um **círculo vermelho** aparecerá

#### **Executar com Debug:**
1. Pressione **F5**
2. Quando a execução chegar no breakpoint, pausará
3. Você pode:
   - Ver valores de variáveis
   - Usar **Debug Console** na parte inferior
   - Pressionar **F10** para próxima linha
   - Pressionar **F5** para continuar

### **Ver Logs:**

No terminal onde o Flutter está rodando, você verá todos os logs:
```
flutter: Erro ao registrar: Connection refused
flutter: Login bem-sucedido!
```

### **Adicionar Logs no Código:**

```dart
import 'package:flutter/foundation.dart';

// Simples
print('Meu log aqui');

// Debug (só aparece em modo debug)
debugPrint('Debug info');

// Condicional
if (kDebugMode) {
  print('Só em debug');
}
```

---

## 🎨 Modificar o App

### **Exemplo 1: Mudar Cor de Fundo**

1. Abra `lib/screens/login_screen.dart`
2. Procure por:
   ```dart
   backgroundColor: const Color(0xFFFFD700), // Amarelo
   ```
3. Mude para:
   ```dart
   backgroundColor: Colors.blue, // Azul
   ```
4. Salve (`Ctrl + S`)
5. No terminal, pressione **`r`**
6. ✅ Cor mudou instantaneamente!

---

### **Exemplo 2: Mudar Texto**

1. Abra `lib/screens/login_screen.dart`
2. Procure por:
   ```dart
   'ENTRAR'
   ```
3. Mude para:
   ```dart
   'FAZER LOGIN'
   ```
4. Salve e hot reload (**`r`**)
5. ✅ Texto atualizado!

---

### **Exemplo 3: Mudar Tempo do Loading**

1. Abra `lib/screens/loading_screen.dart`
2. Procure por:
   ```dart
   Future.delayed(const Duration(seconds: 5), () {
   ```
3. Mude para:
   ```dart
   Future.delayed(const Duration(seconds: 3), () {
   ```
4. Salve e pressione **`R`** (restart completo)
5. ✅ Loading agora dura 3 segundos!

---

## 🔧 Comandos Úteis

### **Limpeza e Build:**

```bash
# Limpar cache (se tiver problemas)
flutter clean

# Reinstalar dependências
flutter pub get

# Analisar código (verificar erros)
flutter analyze

# Formatar código
flutter format .

# Ver dispositivos disponíveis
flutter devices
```

### **Build para Produção:**

```bash
# Build para Web
flutter build web

# Build para Windows
flutter build windows

# Build para Android APK
flutter build apk

# Build para Android App Bundle
flutter build appbundle
```

---

## ⚙️ Configurações do Projeto

### **Nome do App:**

Edite `pubspec.yaml`:
```yaml
name: appeao
description: Sistema para oferta e demanda de mão de obra
```

### **Ícone do App:**

1. Adicione seu ícone em `assets/icon.png`
2. Use o pacote `flutter_launcher_icons`
3. Configure e gere os ícones

### **Splash Screen:**

O projeto já tem uma splash screen customizada (LoadingScreen)!

---

## 📊 Performance

### **Ver Informações de Performance:**

Com o app rodando, pressione:
```
P  # Toggle performance overlay
```

Isso mostra FPS e outras métricas.

### **DevTools:**

```bash
# Abrir DevTools
flutter pub global activate devtools
flutter pub global run devtools
```

Isso abre uma interface web com ferramentas de debug avançadas!

---

## 🐛 Troubleshooting

### **Problema: "flutter: command not found"**

**Solução:**
1. Verificar se Flutter está no PATH
2. Abrir novo terminal
3. Reiniciar computador se necessário

---

### **Problema: "No devices found"**

**Solução:**
```bash
# Ver o que está disponível
flutter devices

# Se Chrome não aparece
# Instale o Chrome: https://www.google.com/chrome/

# Se Windows não aparece
# Instale Visual Studio C++ tools
```

---

### **Problema: "Waiting for another flutter command to release the startup lock"**

**Solução:**
```bash
# Deletar arquivo de lock
rm C:\flutter\bin\cache\lockfile
```

---

### **Problema: "Error: Unable to find git in your PATH"**

**Solução:**
1. Instalar Git: https://git-scm.com/download/win
2. Adicionar ao PATH
3. Reiniciar terminal

---

### **Problema: "Gradle build failed" (Android)**

**Solução:**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

---

### **Problema: "Error connecting to API"**

**Verificar:**
1. ✅ API está rodando? (`netstat -ano | findstr :7001`)
2. ✅ SQL Server está rodando? (`docker ps`)
3. ✅ URL correta em `auth_service.dart`?

```dart
// Verificar em lib/services/auth_service.dart
static const String baseUrl = 'https://localhost:7001/api';
```

---

## ⌨️ Atalhos Úteis

### **VS Code:**

| Atalho | Ação |
|--------|------|
| **F5** | Iniciar com debug |
| **Ctrl + F5** | Iniciar sem debug |
| **Shift + F5** | Parar debug |
| **Ctrl + .** | Quick fix |
| **Ctrl + Space** | Autocomplete |
| **Ctrl + K, Ctrl + D** | Formatar documento |
| **Shift + Alt + F** | Formatar arquivo |
| **Ctrl + Shift + P** | Command palette |

### **Terminal do Flutter:**

| Tecla | Ação |
|-------|------|
| **r** | Hot reload |
| **R** | Hot restart |
| **h** | Help |
| **c** | Clear console |
| **q** | Quit |
| **d** | Detach |
| **P** | Performance overlay |
| **w** | Dump widget hierarchy |

---

## 🎯 Checklist de Execução

### **Setup Inicial (uma vez):**
- [ ] Flutter instalado
- [ ] Flutter no PATH
- [ ] `flutter doctor` executado
- [ ] VS Code com extensão Flutter (opcional)
- [ ] Projeto mobile no diretório correto

### **Execução Diária:**
- [ ] SQL Server rodando (`docker ps`)
- [ ] API rodando (`dotnet run` em api/AppEAO.API)
- [ ] Terminal no diretório mobile
- [ ] `flutter pub get` executado (primeira vez)
- [ ] `flutter run -d chrome` executado
- [ ] App abrindo no Chrome
- [ ] Consegue cadastrar usuário

✅ **Tudo OK? App funcionando perfeitamente!**

---

## 📚 Workflow Diário Completo

### **Manhã - Iniciar Desenvolvimento:**

```bash
# Terminal 1: SQL Server
cd C:\Users\Andre\Desktop\appeao
docker-compose up -d

# Terminal 2: API
cd api\AppEAO.API
dotnet run
# → Swagger abre automaticamente

# Terminal 3: Mobile
cd mobile
flutter run -d chrome
# → App abre no Chrome
```

### **Durante o Dia:**

1. Fazer mudanças no código Dart
2. Salvar (`Ctrl + S`)
3. Hot reload (`r`) no terminal
4. Testar no navegador
5. Repetir

### **Final do Dia:**

```bash
# Mobile: Pressione 'q' no terminal
# API: Ctrl+C
# SQL Server (opcional):
docker-compose down
```

---

## 🎓 Recursos de Aprendizado

### **Documentação Oficial:**
- Flutter: https://flutter.dev/docs
- Dart: https://dart.dev/guides

### **Tutoriais:**
- Flutter Codelabs (gratuito): https://docs.flutter.dev/codelabs
- Widget of the Week (YouTube)
- Flutter Community (Medium)

### **Widgets Úteis:**
- Material Design: https://flutter.dev/docs/development/ui/widgets/material
- Cupertino (iOS): https://flutter.dev/docs/development/ui/widgets/cupertino

---

## 📱 Estrutura do AppEAO

### **Fluxo de Navegação:**

```
LoadingScreen (5s)
       ↓
LoginScreen
   ↙      ↘
Login    RegisterScreen
   ↘      ↙
  HomeScreen
```

### **Comunicação com API:**

```
Mobile (Flutter)
       ↓
   HTTP Request
       ↓
   API (.NET)
       ↓
   SQL Server
```

---

## ✨ Dicas Profissionais

### **Produtividade:**
1. Use hot reload (`r`) constantemente
2. Mantenha o VS Code aberto com arquivo atual
3. Use snippets (digite `stless` + Tab para StatelessWidget)
4. Formate código regularmente (`Shift + Alt + F`)

### **Debug:**
1. Use `print()` para logs rápidos
2. Use DevTools para debug avançado
3. Adicione breakpoints liberalmente
4. Teste em diferentes tamanhos de tela

### **Performance:**
1. Evite rebuilds desnecessários
2. Use `const` sempre que possível
3. Implemente `ListView.builder` para listas grandes
4. Profile com DevTools regularmente

---

## 🎊 Conclusão

Agora você sabe:

✅ **Instalar** Flutter do zero  
✅ **Executar** o app mobile no Chrome  
✅ **Usar** hot reload para desenvolvimento rápido  
✅ **Debugar** problemas  
✅ **Modificar** o código  
✅ **Integrar** com a API  

**Próximo passo:**
```bash
cd mobile
flutter run -d chrome
```

E comece a desenvolver! 🚀📱

---

**Criado para facilitar seu desenvolvimento Flutter! 🎉**

Consulte também:
- `COMO_EXECUTAR_API_VISUAL_STUDIO.md` - Para rodar a API
- `COMO_CONECTAR_DBEAVER.md` - Para conectar no banco

