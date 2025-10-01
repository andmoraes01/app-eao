namespace AppEAO.API.Domain.Entities;

/// <summary>
/// Entidade de domínio representando um usuário do sistema
/// </summary>
public class User
{
    // Dados básicos (não editáveis após criação)
    public Guid Id { get; private set; }
    public string Email { get; private set; } = string.Empty;
    public string CPF { get; private set; } = string.Empty; // Não editável
    public string PasswordHash { get; private set; } = string.Empty;
    public DateTime CreatedAt { get; private set; }
    public DateTime? UpdatedAt { get; private set; }
    public bool IsActive { get; private set; }
    
    // Dados do perfil (editáveis)
    public string Name { get; private set; } = string.Empty;
    public string? Phone { get; private set; }
    public DateTime? BirthDate { get; private set; }
    public string? Address { get; private set; }
    public string? City { get; private set; }
    public string? State { get; private set; }
    public string? ZipCode { get; private set; }
    public string? ProfilePhoto { get; private set; }
    public string? Bio { get; private set; }
    
    // Controle de completude do perfil
    public bool IsProfileComplete { get; private set; }

    // Construtor privado para EF Core
    private User()
    {
        IsActive = true;
        CreatedAt = DateTime.UtcNow;
        IsProfileComplete = false;
    }

    // Construtor para criação de novo usuário (registro simplificado)
    public User(string name, string email, string cpf, string passwordHash, string? phone = null)
    {
        Id = Guid.NewGuid();
        Name = name;
        Email = email;
        CPF = cpf;
        PasswordHash = passwordHash;
        Phone = phone;
        CreatedAt = DateTime.UtcNow;
        IsActive = true;
        IsProfileComplete = false; // Perfil inicial incompleto
    }

    // Métodos de negócio
    public void UpdateBasicInfo(string name, string? phone)
    {
        Name = name;
        Phone = phone;
        UpdatedAt = DateTime.UtcNow;
        CheckProfileCompletion();
    }
    
    public void UpdateFullProfile(
        string name,
        string? phone,
        DateTime? birthDate,
        string? address,
        string? city,
        string? state,
        string? zipCode,
        string? bio)
    {
        Name = name;
        Phone = phone;
        BirthDate = birthDate;
        Address = address;
        City = city;
        State = state;
        ZipCode = zipCode;
        Bio = bio;
        UpdatedAt = DateTime.UtcNow;
        CheckProfileCompletion();
    }
    
    public void UpdateProfilePhoto(string photoUrl)
    {
        ProfilePhoto = photoUrl;
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
    
    /// <summary>
    /// Calcula a completude do perfil
    /// Perfil completo requer: Nome, Email, CPF, Telefone, Data de Nascimento, Endereço, Cidade, Estado
    /// </summary>
    public int GetProfileCompletionPercentage()
    {
        var fields = 0;
        var filledFields = 0;
        
        // Campos obrigatórios para perfil completo
        fields++; if (!string.IsNullOrWhiteSpace(Name)) filledFields++;
        fields++; if (!string.IsNullOrWhiteSpace(Email)) filledFields++;
        fields++; if (!string.IsNullOrWhiteSpace(CPF)) filledFields++;
        fields++; if (!string.IsNullOrWhiteSpace(Phone)) filledFields++;
        fields++; if (BirthDate.HasValue) filledFields++;
        fields++; if (!string.IsNullOrWhiteSpace(Address)) filledFields++;
        fields++; if (!string.IsNullOrWhiteSpace(City)) filledFields++;
        fields++; if (!string.IsNullOrWhiteSpace(State)) filledFields++;
        
        return (int)((filledFields / (double)fields) * 100);
    }
    
    private void CheckProfileCompletion()
    {
        IsProfileComplete = GetProfileCompletionPercentage() == 100;
    }
}


