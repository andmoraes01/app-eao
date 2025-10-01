# 📱 AppEAO - Preview Visual

## 🎬 Experiência do Usuário

### Fluxo Completo

```
┌─────────────┐
│   INÍCIO    │
│  (App Open) │
└──────┬──────┘
       │
       ▼
┌─────────────────────────────────────┐
│      LOADING SCREEN (3s)            │
│  ╔═══════════════════════════════╗  │
│  ║       FUNDO AMARELO           ║  │
│  ║                               ║  │
│  ║      ┌──────────────┐        ║  │
│  ║      │              │        ║  │
│  ║      │   AppEAO     │ ⟲      ║  │
│  ║      │ MÃO DE OBRA  │        ║  │
│  ║      │ ▓▒▓▒▓▒▓▒▓▒  │        ║  │
│  ║      └──────────────┘        ║  │
│  ║                               ║  │
│  ║           🔨 ⟲                ║  │
│  ║                               ║  │
│  ║      ▰▰▰▰▰▰▰▱▱▱▱▱           ║  │
│  ║      Carregando...            ║  │
│  ╚═══════════════════════════════╝  │
└────────────┬────────────────────────┘
             │
             │ (Fade out 500ms)
             │
             ▼
┌─────────────────────────────────────┐
│         HOME SCREEN                 │
│  ╔═══════════════════════════════╗  │
│  ║   HEADER AMARELO             ║  │
│  ║                              ║  │
│  ║      [Mini Logo]             ║  │
│  ║      Bem-vindo!              ║  │
│  ╠═══════════════════════════════╣  │
│  ║   CONTEÚDO BRANCO            ║  │
│  ║                              ║  │
│  ║   📋 Sobre o AppEAO          ║  │
│  ║   [Texto introdutório]       ║  │
│  ║                              ║  │
│  ║   ┌─────────────────────┐   ║  │
│  ║   │ 🔨 Oferta Serviços  │   ║  │
│  ║   └─────────────────────┘   ║  │
│  ║                              ║  │
│  ║   ┌─────────────────────┐   ║  │
│  ║   │ 🔍 Busca Prof.      │   ║  │
│  ║   └─────────────────────┘   ║  │
│  ║                              ║  │
│  ║   ┌─────────────────────┐   ║  │
│  ║   │ ✅ Segurança        │   ║  │
│  ║   └─────────────────────┘   ║  │
│  ║                              ║  │
│  ║   ┌─────────────────────┐   ║  │
│  ║   │ SOU PROFISSIONAL    │   ║  │
│  ║   └─────────────────────┘   ║  │
│  ║                              ║  │
│  ║   ┌─────────────────────┐   ║  │
│  ║   │ BUSCO PROFISSIONAL  │   ║  │
│  ║   └─────────────────────┘   ║  │
│  ║                              ║  │
│  ╚═══════════════════════════════╝  │
└─────────────────────────────────────┘
```

---

## 🎨 Paleta de Cores Aplicada

### Tela de Loading
```
╔══════════════════════════════════════╗
║  #FFD700 (Amarelo Ouro) - 100%       ║
║  ┌────────────────────────┐          ║
║  │ #000000 (Preto)        │          ║
║  │ ┌──────────────────┐   │          ║
║  │ │ #FFD700 (Texto)  │   │          ║
║  │ └──────────────────┘   │          ║
║  └────────────────────────┘          ║
║                                      ║
║       #000000 (Ícone Martelo)        ║
║                                      ║
║  ──────────────── #000000            ║
║  Carregando... #000000               ║
╚══════════════════════════════════════╝
```

### Tela Home
```
╔══════════════════════════════════════╗
║  Gradient (#FFD700 → #FFC700)        ║
║  ┌────────────────┐                  ║
║  │ #000000 bg     │                  ║
║  │ #FFD700 texto  │                  ║
║  └────────────────┘                  ║
║  Bem-vindo! (#000000)                ║
╠══════════════════════════════════════╣
║  #FFFFFF Background                  ║
║                                      ║
║  Sobre o AppEAO (#000000)            ║
║  ┌────────────────────────┐          ║
║  │ #F5F5F5 + Border       │          ║
║  │ #FFD700 (30% opacity)  │          ║
║  │ Texto #000000          │          ║
║  └────────────────────────┘          ║
║                                      ║
║  Cards com cores alternadas:         ║
║  - Amarelo (#FFD700)                 ║
║  - Preto (#000000)                   ║
║  - Amarelo (#FFD700)                 ║
║                                      ║
║  ┌────────────────────────┐          ║
║  │ #FFD700 bg + #000 text │          ║
║  └────────────────────────┘          ║
║  ┌────────────────────────┐          ║
║  │ #000000 bg + #FFD700 text│        ║
║  └────────────────────────┘          ║
╚══════════════════════════════════════╝
```

---

## 🎭 Animações em Detalhes

### 1. Placa da Loading Screen
```
Movimento: Balanço suave
Simulando: Vento na placa de obra

    \  |  /
     \ | /    ← Posição central
      \|/
     ──●──
      /|\
     / | \    ← -3° a +3°
    /  |  \

Duração: 1.5 segundos
Loop: Infinito
```

### 2. Martelo
```
Movimento: Rotação
Simulando: Martelada

    ╱         ← Rotação +17°
   ╱
  ●
   ╲
    ╲         ← Rotação -17°

Duração: 0.8 segundos
Loop: Infinito
```

### 3. Transição
```
Opacidade: 100% → 0%

████████  100%
███████░   87%
██████░░   75%
████░░░░   50%
██░░░░░░   25%
░░░░░░░░    0%

Duração: 500ms
Após: 3 segundos
```

---

## 📐 Dimensões e Proporções

### Loading Screen

```
Tela Total: 100% x 100%
├─ Fundo Amarelo: 100%
│
├─ Placa Central:
│  ├─ Largura: 200px
│  ├─ Altura: 140px
│  ├─ Posição: Centro vertical
│  └─ Margem superior: ~30% da tela
│
├─ Martelo:
│  ├─ Tamanho: 60px
│  ├─ Gap acima: 50px
│  └─ Gap abaixo: 30px
│
└─ Barra de progresso:
   ├─ Largura: 150px
   ├─ Altura: 4px
   └─ Gap abaixo texto: 15px
```

### Home Screen Header

```
Header:
├─ Altura: ~180px (dinâmica)
├─ Padding top: 30px
├─ Logo: 100px x 70px
├─ Gap: 20px
├─ Título: 32px
└─ Padding bottom: 30px
```

### Home Screen Conteúdo

```
Conteúdo:
├─ Padding lateral: 24px
├─ Gap entre elementos: 16-30px
│
├─ Cards Feature:
│  ├─ Padding interno: 20px
│  ├─ Border radius: 12px
│  ├─ Icon container: 32px
│  └─ Gap icon-texto: 16px
│
└─ Botões:
   ├─ Altura: 56px
   ├─ Largura: 100%
   ├─ Border radius: 12px
   └─ Gap entre botões: 16px
```

---

## 🔄 Estados e Interações

### Botões

```
ESTADO NORMAL:
┌─────────────────────────┐
│  SOU PROFISSIONAL       │  ← Elevation 3px
└─────────────────────────┘
        │
        │ (ao pressionar)
        ▼
┌─────────────────────────┐
│  SOU PROFISSIONAL       │  ← Elevation 1px
└─────────────────────────┘  (cor +10% escura)
        │
        │ (ao soltar)
        ▼
┌─────────────────────────┐
│  SOU PROFISSIONAL       │  ← Volta ao normal
└─────────────────────────┘
```

---

## 📱 Responsividade

### Layout Adaptativo

```
MOBILE PORTRAIT (360px):
┌────────────┐
│   Header   │ ← Compacto
├────────────┤
│            │
│  Conteúdo  │ ← Scroll vertical
│            │
│            │
└────────────┘

MOBILE LANDSCAPE:
┌──────────────────────┐
│ Header   │ Conteúdo  │ ← Adaptado
└──────────────────────┘

TABLET (600px+):
┌────────────────────┐
│      Header        │ ← Espaçado
├────────────────────┤
│                    │
│     Conteúdo       │ ← Mais espaço
│    (cards maiores) │
│                    │
└────────────────────┘
```

---

## 🎯 Elementos Interativos (Futuro)

### Áreas Clicáveis

```
┌─────────────────────────┐
│  ┌───────────────────┐  │
│  │ SOU PROFISSIONAL  │  │ ← 56px altura
│  │  (Touch area)     │  │   (mínimo 48px)
│  └───────────────────┘  │
└─────────────────────────┘
    ◄──────────────────►
    Largura total da tela
    (padding 24px)
```

---

## 💡 Feedback Visual

### Loading Indicators

```
Barra de Progresso:
▰▰▰▰▰▰▰▱▱▱▱▱▱▱
│       │        │
Carregado  Atual  Restante

Animação: Contínua
Velocidade: Indeterminada
Cor: Preto sobre fundo transparente
```

### Texto de Status

```
"Carregando..."
│
├─ Cor: #000000
├─ Tamanho: 16px
├─ Peso: Semi-bold (600)
├─ Espaçamento: 1px
└─ Posição: Centro, abaixo da barra
```

---

## 🎨 Mockups ASCII

### Tela Completa - Loading

```
╔════════════════════════════════════════╗
║                                        ║
║        🟨🟨🟨🟨🟨🟨🟨🟨🟨🟨             ║
║        🟨                🟨             ║
║        🟨    ┌─────┐    🟨             ║
║        🟨    │⬛⬛⬛│    🟨             ║
║        🟨    │⬛🟨⬛│    🟨             ║
║        🟨    │⬛⬛⬛│    🟨             ║
║        🟨    └─────┘    🟨             ║
║        🟨                🟨             ║
║        🟨      🔨        🟨             ║
║        🟨                🟨             ║
║        🟨   ▰▰▰▰▱▱▱▱    🟨             ║
║        🟨  Carregando    🟨             ║
║        🟨🟨🟨🟨🟨🟨🟨🟨🟨🟨             ║
║                                        ║
╚════════════════════════════════════════╝
```

### Tela Completa - Home

```
╔════════════════════════════════════════╗
║  🟨🟨🟨🟨🟨🟨🟨🟨🟨🟨🟨🟨🟨🟨            ║
║  🟨         [Logo]         🟨            ║
║  🟨      Bem-vindo!        🟨            ║
║  🟨🟨🟨🟨🟨🟨🟨🟨🟨🟨🟨🟨🟨🟨            ║
║  ⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜            ║
║  ⬜  Sobre o AppEAO       ⬜            ║
║  ⬜  [Texto intro...]     ⬜            ║
║  ⬜                       ⬜            ║
║  ⬜  ┌─────────────────┐ ⬜            ║
║  ⬜  │🔨 Oferta Serv.  │ ⬜            ║
║  ⬜  └─────────────────┘ ⬜            ║
║  ⬜  ┌─────────────────┐ ⬜            ║
║  ⬜  │🔍 Busca Prof.   │ ⬜            ║
║  ⬜  └─────────────────┘ ⬜            ║
║  ⬜  ┌─────────────────┐ ⬜            ║
║  ⬜  │✅ Segurança     │ ⬜            ║
║  ⬜  └─────────────────┘ ⬜            ║
║  ⬜                       ⬜            ║
║  ⬜  🟨 SOU PROFISSIONAL  ⬜            ║
║  ⬜  ⬛ BUSCO PROFISSIONAL⬜            ║
║  ⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜            ║
╚════════════════════════════════════════╝
```

---

## ⚡ Performance

### Tempo de Carregamento
- Loading Screen: 3 segundos fixos
- Transição: 500ms suave
- Total inicial: ~3.5 segundos

### Animações
- FPS alvo: 60fps
- Animações otimizadas com `AnimationController`
- Uso de `const` constructors

### Recursos
- Sem imagens externas (apenas ícones Material)
- Código leve e otimizado
- Builds rápidos

---

**Preview criado para demonstrar a experiência visual completa do AppEAO** 🚀

