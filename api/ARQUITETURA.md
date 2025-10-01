# 🏗️ Arquitetura da API - AppEAO

## 📐 Clean Architecture / Onion Architecture

A API foi estruturada seguindo os princípios de **Clean Architecture**, com separação clara de responsabilidades em camadas.

---

## 📁 Estrutura de Camadas

```
AppEAO.API/
│
├── 🎯 Controllers/                    ← API Layer (Controllers)
│   └── AuthController.cs
│
├── 📦 Domain/                         ← Domain Layer (Núcleo)
│   ├── Entities/                      ← Entidades de domínio
│   │   └── User.cs
│   └── Interfaces/                    ← Contratos de repositórios
│       └── IUserRepository.cs
│
├── 🔧 Application/                    ← Application Layer (Casos de Uso)
│   ├── DTOs/                          ← Data Transfer Objects
│   │   ├── RegisterRequest.cs
│   │   ├── LoginRequest.cs
│   │   ├── AuthResponse.cs
│   │   └── UserResponse.cs
│   ├── Interfaces/                    ← Contratos de serviços
│   │   └── IAuthService.cs
│   └── Services/                      ← Implementação de serviços
│       └── AuthService.cs
│
├── 🗄️ Infrastructure/                 ← Infrastructure Layer (Externos)
│   ├── Data/                          ← Contexto do banco
│   │   └── AppDbContext.cs
│   └── Repositories/                  ← Implementação de repositórios
│       └── UserRepository.cs
│
├── 🔄 Migrations/                     ← EF Core Migrations
└── ⚙️ Program.cs                      ← Configuração e DI
```

---

## 🎯 Responsabilidades das Camadas

### **1. Domain Layer (Domínio)**

**Responsabilidade:** Núcleo da aplicação, contém a lógica de negócio pura.

**Características:**
- ✅ Não depende de nenhuma outra camada
- ✅ Contém entidades com comportamento
- ✅ Define interfaces (contratos) para repositórios
- ✅ Sem dependências externas (EF Core, ASP.NET, etc)

**Arquivos:**
```
Domain/
├── Entities/
│   └── User.cs              ← Entidade rica com comportamento
└── Interfaces/
    └── IUserRepository.cs   ← Contrato do repositório
```

**Exemplo - User.cs:**
```csharp
public class User
{
    // Propriedades com setters privados (encapsulamento)
    public Guid Id { get; private set; }
    public string Name { get; private set; }
    
    // Construtor para criação
    public User(string name, string email, string passwordHash)
    {
        Id = Guid.NewGuid();
        Name = name;
        // ...
    }
    
    // Métodos de negócio
    public void UpdateProfile(string name, string? phone)
    {
        Name = name;
        Phone = phone;
        UpdatedAt = DateTime.UtcNow;
    }
}
```

---

### **2. Application Layer (Aplicação)**

**Responsabilidade:** Casos de uso, orquestração de lógica de negócio.

**Características:**
- ✅ Depende apenas do Domain
- ✅ Contém services com regras de negócio
- ✅ Usa interfaces do Domain (IUserRepository)
- ✅ Define seus próprios contratos (IAuthService)
- ✅ Trabalha com DTOs para entrada/saída

**Arquivos:**
```
Application/
├── DTOs/                    ← Objetos de transferência
│   ├── RegisterRequest.cs
│   ├── LoginRequest.cs
│   ├── AuthResponse.cs
│   └── UserResponse.cs
├── Interfaces/
│   └── IAuthService.cs      ← Contrato do serviço
└── Services/
    └── AuthService.cs       ← Implementação com lógica de negócio
```

**Exemplo - AuthService.cs:**
```csharp
public class AuthService : IAuthService
{
    private readonly IUserRepository _userRepository; // Usa interface!
    
    public async Task<AuthResponse?> RegisterAsync(RegisterRequest request)
    {
        // 1. Validar regras de negócio
        if (await _userRepository.ExistsByEmailAsync(request.Email))
            return null;
        
        // 2. Criar entidade de domínio
        var user = new User(request.Name, request.Email, passwordHash);
        
        // 3. Persistir usando repositório
        await _userRepository.AddAsync(user);
        await _userRepository.SaveChangesAsync();
        
        // 4. Retornar DTO
        return new AuthResponse { /* ... */ };
    }
}
```

---

### **3. Infrastructure Layer (Infraestrutura)**

**Responsabilidade:** Acesso a recursos externos (banco, APIs, filesystem).

**Características:**
- ✅ Depende do Domain (implementa interfaces)
- ✅ Contém código específico de tecnologia (EF Core, SQL Server)
- ✅ Implementa IUserRepository
- ✅ Configurações de banco (Fluent API)

**Arquivos:**
```
Infrastructure/
├── Data/
│   └── AppDbContext.cs      ← EF Core DbContext
└── Repositories/
    └── UserRepository.cs    ← Implementação do IUserRepository
```

**Exemplo - UserRepository.cs:**
```csharp
public class UserRepository : IUserRepository // Implementa interface do Domain
{
    private readonly AppDbContext _context;
    
    public async Task<User?> GetByEmailAsync(string email)
    {
        return await _context.Users
            .AsNoTracking()
            .FirstOrDefaultAsync(u => u.Email == email);
    }
    
    public async Task AddAsync(User user)
    {
        await _context.Users.AddAsync(user);
    }
}
```

---

### **4. API Layer (Controllers)**

**Responsabilidade:** Expor endpoints HTTP, validação de entrada.

**Características:**
- ✅ Depende da Application (IAuthService)
- ✅ Recebe DTOs via HTTP
- ✅ Retorna DTOs como resposta
- ✅ Validação de ModelState
- ✅ Tratamento de autenticação/autorização

**Exemplo - AuthController.cs:**
```csharp
[ApiController]
[Route("api/[controller]")]
public class AuthController : ControllerBase
{
    private readonly IAuthService _authService; // Usa interface!
    
    [HttpPost("register")]
    public async Task<IActionResult> Register([FromBody] RegisterRequest request)
    {
        if (!ModelState.IsValid)
            return BadRequest(ModelState);
        
        var result = await _authService.RegisterAsync(request);
        
        if (result == null)
            return BadRequest("Email já cadastrado");
        
        return CreatedAtAction(nameof(GetProfile), new { id = result.UserId }, result);
    }
}
```

---

## 🔄 Fluxo de Dependências

```
Controllers (API)
       ↓ depende
   IAuthService (Application Interface)
       ↓ implementa
   AuthService (Application)
       ↓ usa
   IUserRepository (Domain Interface)
       ↓ implementa
   UserRepository (Infrastructure)
       ↓ usa
   AppDbContext (Infrastructure)
       ↓ acessa
   SQL Server (External)
```

**Princípio da Inversão de Dependência:**
- Controllers dependem de `IAuthService` (interface)
- AuthService depende de `IUserRepository` (interface)
- Infraestrutura implementa as interfaces
- Nenhuma camada interna depende de camada externa

---

## 💉 Dependency Injection (Program.cs)

```csharp
// Registrar DbContext
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlServer(connectionString));

// Registrar Repositories (Infrastructure → Domain)
builder.Services.AddScoped<IUserRepository, UserRepository>();

// Registrar Services (Application)
builder.Services.AddScoped<IAuthService, AuthService>();
```

**Benefícios:**
- ✅ Baixo acoplamento
- ✅ Fácil testar (mock de interfaces)
- ✅ Fácil trocar implementações

---

## 🎯 Princípios Aplicados

### **1. Separation of Concerns**
Cada camada tem uma responsabilidade única e bem definida.

### **2. Dependency Inversion**
Camadas internas (Domain) não dependem de camadas externas (Infrastructure).

### **3. Interface Segregation**
Interfaces pequenas e focadas (IUserRepository, IAuthService).

### **4. Single Responsibility**
Cada classe tem uma única razão para mudar.

### **5. Don't Repeat Yourself (DRY)**
Lógica centralizada em services, reutilizável.

---

## ✅ Benefícios da Arquitetura

### **Testabilidade**
```csharp
// Fácil criar mocks
var mockRepository = new Mock<IUserRepository>();
var authService = new AuthService(mockRepository.Object, ...);
```

### **Manutenibilidade**
- Código organizado e fácil de encontrar
- Mudanças isoladas em uma camada
- Regras de negócio centralizadas

### **Escalabilidade**
- Fácil adicionar novos recursos
- Fácil adicionar novas entidades
- Padrão consistente

### **Flexibilidade**
- Trocar banco de dados? Só muda Infrastructure
- Trocar framework? Só muda API Layer
- Adicionar cache? Decorator pattern nos repositories

---

## 📦 Exemplo: Adicionar Nova Funcionalidade

**Tarefa:** Adicionar funcionalidade de "Esqueci minha senha"

### **1. Domain Layer:**
```csharp
// Domain/Entities/PasswordResetToken.cs
public class PasswordResetToken { /* ... */ }

// Domain/Interfaces/IPasswordResetRepository.cs
public interface IPasswordResetRepository { /* ... */ }
```

### **2. Application Layer:**
```csharp
// Application/DTOs/ForgotPasswordRequest.cs
public class ForgotPasswordRequest { /* ... */ }

// Application/Interfaces/IPasswordResetService.cs
public interface IPasswordResetService { /* ... */ }

// Application/Services/PasswordResetService.cs
public class PasswordResetService : IPasswordResetService { /* ... */ }
```

### **3. Infrastructure Layer:**
```csharp
// Infrastructure/Repositories/PasswordResetRepository.cs
public class PasswordResetRepository : IPasswordResetRepository { /* ... */ }
```

### **4. API Layer:**
```csharp
// Controllers/PasswordResetController.cs
[ApiController]
[Route("api/[controller]")]
public class PasswordResetController : ControllerBase { /* ... */ }
```

### **5. Dependency Injection:**
```csharp
builder.Services.AddScoped<IPasswordResetRepository, PasswordResetRepository>();
builder.Services.AddScoped<IPasswordResetService, PasswordResetService>();
```

**Simples, organizado e escalável!** ✨

---

## 🧪 Testando a Arquitetura

### **Unit Tests (Application Layer):**
```csharp
[Fact]
public async Task Register_WithExistingEmail_ReturnsNull()
{
    // Arrange
    var mockRepo = new Mock<IUserRepository>();
    mockRepo.Setup(r => r.ExistsByEmailAsync("test@email.com"))
            .ReturnsAsync(true);
    
    var service = new AuthService(mockRepo.Object, ...);
    var request = new RegisterRequest { Email = "test@email.com" };
    
    // Act
    var result = await service.RegisterAsync(request);
    
    // Assert
    Assert.Null(result);
}
```

### **Integration Tests (Infrastructure Layer):**
```csharp
[Fact]
public async Task UserRepository_CanAddAndRetrieveUser()
{
    // Usar InMemory database
    var options = new DbContextOptionsBuilder<AppDbContext>()
        .UseInMemoryDatabase("TestDb")
        .Options;
    
    var context = new AppDbContext(options);
    var repository = new UserRepository(context, logger);
    
    // Test...
}
```

---

## 📚 Referências

- **Clean Architecture** - Robert C. Martin (Uncle Bob)
- **Domain-Driven Design** - Eric Evans
- **Onion Architecture** - Jeffrey Palermo
- **SOLID Principles**

---

## 🎊 Conclusão

A arquitetura em camadas proporciona:

✅ **Código limpo e organizado**  
✅ **Fácil manutenção**  
✅ **Altamente testável**  
✅ **Baixo acoplamento**  
✅ **Alta coesão**  
✅ **Escalável**  
✅ **Segue boas práticas**  

**Pronto para crescer! 🚀**

---

**Criado em:** Outubro 2025  
**Padrão:** Clean Architecture / Onion Architecture  
**Status:** ✅ Implementado e Documentado


