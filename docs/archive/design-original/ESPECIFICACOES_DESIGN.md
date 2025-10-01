# 🎨 AppEAO - Especificações de Design

## Identidade Visual

### Cores Principais

| Cor | Hex Code | RGB | Uso |
|-----|----------|-----|-----|
| 🟨 Amarelo Ouro | `#FFD700` | rgb(255, 215, 0) | Cor primária, backgrounds, destaques |
| ⬛ Preto | `#000000` | rgb(0, 0, 0) | Cor secundária, textos, contrastes |
| ⬜ Branco | `#FFFFFF` | rgb(255, 255, 255) | Backgrounds, textos em preto |
| 🔲 Cinza Claro | `#F5F5F5` | rgb(245, 245, 245) | Cards, áreas de destaque |

---

## Tipografia

### Família de Fontes
- **Padrão**: Roboto (default do Material Design)

### Tamanhos e Pesos

| Elemento | Tamanho | Peso | Uso |
|----------|---------|------|-----|
| Logo Principal | 36px | Bold (700) | Placa de loading |
| Título H1 | 32px | Bold (700) | "Bem-vindo!" |
| Título H2 | 24px | Bold (700) | Seções |
| Título H3 | 18px | Bold (700) | Cards de features |
| Corpo | 16px | Regular (400) | Textos gerais |
| Subtítulo | 14px | Medium (500) | Descrições |
| Botão | 16px | Bold (700) | CTAs |
| Label | 14px | Medium (500) | Labels de placa |

### Espaçamento de Letras (Letter Spacing)
- Logo: 2px
- Subtítulos de placa: 3px
- Botões: 1px
- Outros: 0px (padrão)

---

## Componentes

### 1. Placa do Logo

#### Versão Grande (Loading Screen)
```
Dimensões: 200px × 140px
Background: #000000
Border Radius: 8px
Padding: 20px
Shadow: 0px 8px 15px rgba(0,0,0,0.3)

Conteúdo:
- Título "AppEAO": 36px, #FFD700, Bold
- Subtítulo "MÃO DE OBRA": 14px, #FFD700, Medium
- Listras decorativas: 8 barras (20px × 4px)
  Alternando entre #FFD700 e #000000
```

#### Versão Pequena (Home Screen)
```
Dimensões: 100px × 70px
Background: #000000
Border Radius: 6px
Shadow: 0px 5px 10px rgba(0,0,0,0.2)

Conteúdo:
- Título "AppEAO": 20px, #FFD700, Bold
- Ícones: construction (16px) + handshake (16px)
```

### 2. Animações

#### Placa (Loading)
```
Tipo: Rotação
Duração: 1500ms
Range: -0.05 rad a +0.05 rad (-3° a +3°)
Curve: easeInOut
Repeat: Infinito (reverse: true)
```

#### Martelo (Loading)
```
Tipo: Rotação
Duração: 800ms
Range: -0.3 rad a +0.3 rad (-17° a +17°)
Curve: easeInOut
Repeat: Infinito (reverse: true)
Ícone: Icons.construction (60px, #000000)
```

#### Fade Out (Transição)
```
Duração: 500ms
Opacity: 1.0 → 0.0
Curve: easeOut
Delay: 3000ms (após iniciar loading)
```

### 3. Botões

#### Botão Primário (Amarelo)
```
Background: #FFD700
Foreground: #000000
Height: 56px
Width: 100%
Border Radius: 12px
Elevation: 3px
Font Size: 16px
Font Weight: Bold
Letter Spacing: 1px
Texto: MAIÚSCULO
```

#### Botão Secundário (Preto)
```
Background: #000000
Foreground: #FFD700
Height: 56px
Width: 100%
Border Radius: 12px
Elevation: 3px
Font Size: 16px
Font Weight: Bold
Letter Spacing: 1px
Texto: MAIÚSCULO
```

### 4. Cards de Feature

```
Background: #FFFFFF
Padding: 20px
Border Radius: 12px
Border: 2px solid (cor variável com opacity 0.3)
Shadow: 0px 4px 8px (cor variável com opacity 0.1)

Ícone Container:
- Padding: 12px
- Border Radius: 10px
- Background: cor com opacity 0.1
- Icon Size: 32px

Layout:
- Row com ícone à esquerda
- Spacing: 16px entre ícone e texto
- Column expandida com título + descrição
```

### 5. Barra de Progresso (Loading)

```
Width: 150px
Height: 4px (minHeight)
Background: rgba(0,0,0,0.2)
Value Color: #000000
Tipo: LinearProgressIndicator indeterminado
```

---

## Layout e Espaçamento

### Grid System
- **Padding horizontal padrão**: 24px
- **Espaçamento entre seções**: 30-40px
- **Espaçamento entre elementos**: 16-20px
- **Espaçamento pequeno**: 8px
- **Espaçamento mínimo**: 4px

### Breakpoints (para futuro)
```
Mobile Small: < 360px
Mobile: 360px - 600px
Tablet: 600px - 900px
Desktop: > 900px
```

---

## Ícones

### Ícones Utilizados (Material Icons)

| Ícone | Nome | Contexto | Tamanho |
|-------|------|----------|---------|
| 🔨 | `construction` | Martelo, construção | 16px - 60px |
| 🤝 | `handshake` | Parceria, acordo | 16px |
| 💼 | `work` | Oferta de serviços | 32px |
| 🔍 | `search` | Busca de profissionais | 32px |
| ✅ | `verified_user` | Segurança | 32px |

---

## Telas Detalhadas

### Loading Screen

```
┌──────────────────────────────────────────┐
│                                          │
│             Background: #FFD700          │
│                                          │
│              (30px top)                  │
│                                          │
│         ┌────────────────────┐          │
│         │  PLACA PRETA       │          │
│         │                    │          │
│         │     AppEAO         │ 36px     │
│         │   MÃO DE OBRA      │ 14px     │
│         │   ▓▒▓▒▓▒▓▒▓▒      │          │
│         │                    │          │
│         └────────────────────┘          │
│            (balançando)                  │
│                                          │
│              (50px gap)                  │
│                                          │
│                 🔨                       │
│            (rotacionando)                │
│              60px icon                   │
│                                          │
│              (30px gap)                  │
│                                          │
│         ▰▰▰▰▰▰▰▰▱▱▱▱▱▱                 │
│            (150px width)                 │
│                                          │
│              (15px gap)                  │
│                                          │
│           Carregando...                  │
│              16px text                   │
│                                          │
└──────────────────────────────────────────┘
```

### Home Screen - Header

```
┌──────────────────────────────────────────┐
│     GRADIENT (#FFD700 → #FFC700)        │
│                                          │
│              (30px top)                  │
│                                          │
│           ┌──────────┐                  │
│           │ AppEAO   │ 100×70px         │
│           │  🔨 🤝   │                  │
│           └──────────┘                  │
│                                          │
│              (20px gap)                  │
│                                          │
│           Bem-vindo!                     │
│              32px Bold                   │
│                                          │
│              (30px bottom)               │
└──────────────────────────────────────────┘
```

### Home Screen - Conteúdo

```
┌──────────────────────────────────────────┐
│         Background: #FFFFFF              │
│         Padding: 24px                    │
│                                          │
│         (20px top)                       │
│                                          │
│    Sobre o AppEAO                        │
│    24px Bold                             │
│                                          │
│         (20px gap)                       │
│                                          │
│    ┌─────────────────────────────┐     │
│    │ Card com texto introdutório │     │
│    │ Background: #F5F5F5         │     │
│    │ Border: 2px #FFD700 (30%)   │     │
│    │ Padding: 20px               │     │
│    │ Border Radius: 12px         │     │
│    │                             │     │
│    │ Texto justificado           │     │
│    │ 16px, line-height: 1.6      │     │
│    └─────────────────────────────┘     │
│                                          │
│         (30px gap)                       │
│                                          │
│    ┌─────────────────────────────┐     │
│    │ 🔨  Oferta de Serviços      │     │
│    │     [Descrição]             │     │
│    └─────────────────────────────┘     │
│                                          │
│         (16px gap)                       │
│                                          │
│    ┌─────────────────────────────┐     │
│    │ 🔍  Busca de Profissionais  │     │
│    │     [Descrição]             │     │
│    └─────────────────────────────┘     │
│                                          │
│         (16px gap)                       │
│                                          │
│    ┌─────────────────────────────┐     │
│    │ ✅  Segurança e Confiança   │     │
│    │     [Descrição]             │     │
│    └─────────────────────────────┘     │
│                                          │
│         (40px gap)                       │
│                                          │
│    ┌─────────────────────────────┐     │
│    │   SOU PROFISSIONAL          │     │
│    │   #FFD700 bg, #000 text     │     │
│    │   56px height               │     │
│    └─────────────────────────────┘     │
│                                          │
│         (16px gap)                       │
│                                          │
│    ┌─────────────────────────────┐     │
│    │   BUSCO PROFISSIONAL        │     │
│    │   #000 bg, #FFD700 text     │     │
│    │   56px height               │     │
│    └─────────────────────────────┘     │
│                                          │
│         (30px bottom)                    │
└──────────────────────────────────────────┘
```

---

## Estados dos Componentes

### Botões

**Normal**
- Background: Cor definida
- Elevation: 3px

**Pressed**
- Background: 10% mais escuro
- Elevation: 1px

**Disabled** (futuro)
- Background: Cinza (#CCCCCC)
- Foreground: #999999
- Elevation: 0px

### Cards

**Normal**
- Border: 2px solid (cor com 30% opacity)
- Shadow: suave

**Hover** (futuro - web)
- Border: 2px solid (cor com 50% opacity)
- Shadow: mais pronunciada
- Transform: translateY(-2px)

---

## Acessibilidade

### Contraste de Cores
- Amarelo (#FFD700) sobre Preto: ✅ WCAG AA
- Preto sobre Amarelo: ✅ WCAG AAA
- Preto sobre Branco: ✅ WCAG AAA

### Tamanhos Mínimos
- Textos: Mínimo 14px
- Botões: Mínimo 48px de altura (target touch)
- Ícones: Mínimo 24px para interação

### Animações
- Duração máxima: 1500ms
- Sem animações que possam causar convulsões
- Suporte futuro para `prefers-reduced-motion`

---

## Exportação de Assets (Futuro)

### Logo
- `logo_large.png`: 512×512px
- `logo_medium.png`: 256×256px
- `logo_small.png`: 128×128px

### Ícone do App
- Android: `ic_launcher.png` (múltiplas densidades)
- iOS: `Icon.png` (múltiplos tamanhos)

### Splash Screen
- Fundo amarelo com placa preta centralizada
- Dimensões responsivas

---

## Design System (Resumo Rápido)

```dart
// Cores
const Color primaryYellow = Color(0xFFFFD700);
const Color secondaryBlack = Color(0xFF000000);
const Color backgroundWhite = Color(0xFFFFFFFF);
const Color lightGray = Color(0xFFF5F5F5);

// Espaçamentos
const double spacingSmall = 8.0;
const double spacingMedium = 16.0;
const double spacingLarge = 24.0;
const double spacingXLarge = 30.0;

// Border Radius
const double radiusSmall = 6.0;
const double radiusLarge = 12.0;

// Elevations
const double elevationLow = 3.0;
const double elevationMedium = 8.0;
const double elevationHigh = 15.0;
```

---

**Design criado para representar confiança, profissionalismo e modernidade no setor de construção civil.**

