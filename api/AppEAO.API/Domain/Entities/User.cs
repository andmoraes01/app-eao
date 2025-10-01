namespace AppEAO.API.Domain.Entities;

/// <summary>
/// Entidade de domínio representando um usuário do sistema
/// </summary>
public class User
{
    public Guid Id { get; private set; }
    public string Name { get; private set; } = string.Empty;
    public string Email { get; private set; } = string.Empty;
    public string PasswordHash { get; private set; } = string.Empty;
    public string? Phone { get; private set; }
    public DateTime CreatedAt { get; private set; }
    public DateTime? UpdatedAt { get; private set; }
    public bool IsActive { get; private set; }

    // Construtor privado para EF Core
    private User()
    {
        // Valores padrão para quando EF Core criar a instância
        IsActive = true;
        CreatedAt = DateTime.UtcNow;
    }

    // Construtor para criação de novo usuário
    public User(string name, string email, string passwordHash, string? phone = null)
    {
        Id = Guid.NewGuid();
        Name = name;
        Email = email;
        PasswordHash = passwordHash;
        Phone = phone;
        CreatedAt = DateTime.UtcNow;
        IsActive = true;
    }

    // Métodos de negócio
    public void UpdateProfile(string name, string? phone)
    {
        Name = name;
        Phone = phone;
        UpdatedAt = DateTime.UtcNow;
    }

    public void UpdatePassword(string newPasswordHash)
    {
        PasswordHash = newPasswordHash;
        UpdatedAt = DateTime.UtcNow;
    }

    public void Deactivate()
    {
        IsActive = false;
        UpdatedAt = DateTime.UtcNow;
    }

    public void Activate()
    {
        IsActive = true;
        UpdatedAt = DateTime.UtcNow;
    }
}


