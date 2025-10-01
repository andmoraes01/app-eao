using AppEAO.API.Application.DTOs;

namespace AppEAO.API.Application.Interfaces;

/// <summary>
/// Interface do serviço de autenticação
/// Define os contratos para operações de autenticação e gerenciamento de usuários
/// </summary>
public interface IAuthService
{
    /// <summary>
    /// Registra um novo usuário no sistema
    /// </summary>
    Task<AuthResponse?> RegisterAsync(RegisterRequest request);
    
    /// <summary>
    /// Realiza login do usuário
    /// </summary>
    Task<AuthResponse?> LoginAsync(LoginRequest request);
    
    /// <summary>
    /// Obtém informações de um usuário por ID
    /// </summary>
    Task<UserResponse?> GetUserByIdAsync(Guid userId);
    
    /// <summary>
    /// Verifica se um email já está cadastrado
    /// </summary>
    Task<bool> EmailExistsAsync(string email);
}


