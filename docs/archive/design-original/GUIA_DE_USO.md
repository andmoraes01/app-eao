# 📱 AppEAO - Guia de Uso

## 🎨 Paleta de Cores

```
🟨 Amarelo Principal: #FFD700 (Ouro)
⬛ Preto: #000000
⬜ Branco: #FFFFFF
🔲 Cinza: #757575 (Textos secundários)
```

## 🖼️ Fluxo de Telas

### 1️⃣ Tela de Loading (3 segundos)

**Características:**
- Fundo amarelo (#FFD700)
- Placa preta central com o logo "AppEAO"
- Animação da placa balançando (simulando vento)
- Ícone de martelo rotacionando (simulando trabalho)
- Barra de progresso linear em preto
- Texto "Carregando..."

**Elementos Animados:**
- 🔨 Martelo: Rotação de -17° a +17° (800ms)
- 🪧 Placa: Balança suavemente -3° a +3° (1500ms)
- 📊 Barra de progresso: Animação linear contínua
- 💫 Fade out: Transição suave para home (500ms)

---

### 2️⃣ Tela Home

**Seções:**

**Header (Amarelo)**
- Mini placa com logo AppEAO
- Ícones de construção e handshake
- Texto "Bem-vindo!" em destaque

**Conteúdo Principal (Branco)**
- **Sobre o AppEAO**: Card explicativo com texto introdutório
- **3 Cards de Funcionalidades**:
  1. 🔨 Oferta de Serviços (Amarelo)
  2. 🔍 Busca de Profissionais (Preto)
  3. ✅ Segurança e Confiança (Amarelo)

**Botões de Ação**
- "SOU PROFISSIONAL" (Fundo amarelo, texto preto)
- "BUSCO PROFISSIONAL" (Fundo preto, texto amarelo)

---

## 🚀 Como Executar o Projeto

### Opção 1: Linha de Comando

```bash
# 1. Entre na pasta do projeto
cd C:\Users\Andre\Desktop\appeao

# 2. Instale as dependências
flutter pub get

# 3. Execute o app
flutter run
```

### Opção 2: VS Code

1. Abra o VS Code
2. File → Open Folder → Selecione `C:\Users\Andre\Desktop\appeao`
3. Abra o arquivo `lib/main.dart`
4. Pressione `F5` ou clique em "Run" → "Start Debugging"

### Opção 3: Android Studio

1. Abra o Android Studio
2. Open → Selecione a pasta `C:\Users\Andre\Desktop\appeao`
3. Clique no botão ▶️ (Run) ou pressione `Shift + F10`

---

## 📱 Requisitos

- **Flutter SDK**: 3.0.0 ou superior
- **Emulador**: Android ou iOS (ou dispositivo físico)
- **Espaço**: ~100MB para o projeto

---

## 🎯 Funcionalidades Implementadas

✅ **Loading Screen**
- Animação de placa balançando
- Martelo rotacionando
- Barra de progresso
- Transição suave para home

✅ **Home Screen**
- Header com gradiente amarelo
- Cards informativos
- Botões de ação para profissionais e contratantes
- Design responsivo e moderno

---

## 🔧 Estrutura de Arquivos

```
appeao/
│
├── lib/
│   ├── main.dart                    # 🚀 Ponto de entrada do app
│   └── screens/
│       ├── loading_screen.dart      # 💫 Tela de loading animada
│       └── home_screen.dart         # 🏠 Tela inicial
│
├── pubspec.yaml                     # 📦 Dependências
├── analysis_options.yaml            # 🔍 Configuração de linting
├── README.md                        # 📖 Documentação técnica
└── GUIA_DE_USO.md                  # 📱 Este guia

```

---

## 🎨 Componentes Visuais

### Tela de Loading

```
┌─────────────────────────────────────┐
│         FUNDO AMARELO #FFD700        │
│                                      │
│         ┌──────────────┐            │
│         │              │            │
│         │   AppEAO     │  ← Placa   │
│         │   MÃO DE OBRA│    Preta   │
│         │   ▓▒▓▒▓▒▓▒  │            │
│         └──────────────┘            │
│                                      │
│              🔨                      │
│         (rotacionando)               │
│                                      │
│         ▰▰▰▰▰▰▱▱▱▱                  │
│         Carregando...                │
└─────────────────────────────────────┘
```

### Tela Home

```
┌─────────────────────────────────────┐
│    HEADER AMARELO COM GRADIENTE     │
│                                      │
│         ┌──────┐                    │
│         │AppEAO│  ← Mini logo        │
│         │ 🔨 🤝│                     │
│         └──────┘                    │
│         Bem-vindo!                   │
└─────────────────────────────────────┘
│    CONTEÚDO BRANCO                  │
│                                      │
│   📄 Sobre o AppEAO                 │
│   [Texto introdutório]               │
│                                      │
│   🔨 Oferta de Serviços             │
│   [Descrição]                        │
│                                      │
│   🔍 Busca de Profissionais         │
│   [Descrição]                        │
│                                      │
│   ✅ Segurança e Confiança          │
│   [Descrição]                        │
│                                      │
│   ┌───────────────────────────┐    │
│   │   SOU PROFISSIONAL        │    │
│   └───────────────────────────┘    │
│                                      │
│   ┌───────────────────────────┐    │
│   │   BUSCO PROFISSIONAL      │    │
│   └───────────────────────────┘    │
└─────────────────────────────────────┘
```

---

## 💡 Dicas de Desenvolvimento

1. **Hot Reload**: Pressione `r` no terminal para recarregar o app sem reiniciar
2. **Hot Restart**: Pressione `R` para reiniciar completamente
3. **Inspetor**: Pressione `i` para abrir o Flutter Inspector
4. **Performance**: Pressione `p` para visualizar o performance overlay

---

## 📝 Próximas Implementações

- [ ] Tela de login/registro
- [ ] Formulário de cadastro de profissional
- [ ] Formulário de cadastro de contratante
- [ ] Tela de busca com filtros
- [ ] Perfil do profissional com portfólio
- [ ] Sistema de avaliações e comentários
- [ ] Chat em tempo real
- [ ] Notificações push
- [ ] Integração com mapas
- [ ] Sistema de pagamento

---

## 🆘 Solução de Problemas

**Erro: "Flutter command not found"**
- Instale o Flutter SDK: https://flutter.dev/docs/get-started/install

**Erro: "No devices found"**
- Inicie um emulador Android/iOS ou conecte um dispositivo físico

**Erro: "Package not found"**
- Execute: `flutter pub get`

**Erro de Build**
- Execute: `flutter clean` e depois `flutter pub get`

---

## 📞 Suporte

Para dúvidas ou sugestões sobre o desenvolvimento do AppEAO, consulte:
- [Documentação Flutter](https://flutter.dev/docs)
- [Flutter Community](https://flutter.dev/community)

---

**Desenvolvido com ❤️ usando Flutter**

