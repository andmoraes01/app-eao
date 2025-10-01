using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Microsoft.IdentityModel.Tokens;
using AppEAO.API.Application.DTOs;
using AppEAO.API.Application.Interfaces;
using AppEAO.API.Domain.Entities;
using AppEAO.API.Domain.Interfaces;
using BCrypt.Net;

namespace AppEAO.API.Application.Services;

/// <summary>
/// Serviço de autenticação - Implementa a lógica de negócio de autenticação
/// </summary>
public class AuthService : IAuthService
{
    private readonly IUserRepository _userRepository;
    private readonly IConfiguration _configuration;
    private readonly ILogger<AuthService> _logger;

    public AuthService(
        IUserRepository userRepository,
        IConfiguration configuration,
        ILogger<AuthService> logger)
    {
        _userRepository = userRepository;
        _configuration = configuration;
        _logger = logger;
    }

    public async Task<AuthResponse?> RegisterAsync(RegisterRequest request)
    {
        try
        {
            // Verificar se o email já existe
            if (await _userRepository.ExistsByEmailAsync(request.Email))
            {
                _logger.LogWarning("Tentativa de registro com email já existente: {Email}", request.Email);
                return null;
            }

            // Criptografar senha
            var passwordHash = BCrypt.Net.BCrypt.HashPassword(request.Password);

            // Criar novo usuário (usando construtor do domínio)
            var user = new User(
                name: request.Name,
                email: request.Email,
                cpf: request.CPF,
                passwordHash: passwordHash,
                phone: request.Phone
            );

            // Adicionar ao repositório
            await _userRepository.AddAsync(user);
            await _userRepository.SaveChangesAsync();

            _logger.LogInformation("Novo usuário registrado: {Email}", user.Email);

            // Gerar token JWT
            var token = GenerateJwtToken(user);
            var expiresAt = DateTime.UtcNow.AddHours(24);

            return new AuthResponse
            {
                UserId = user.Id,
                Name = user.Name,
                Email = user.Email,
                Token = token,
                ExpiresAt = expiresAt
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Erro ao registrar usuário");
            return null;
        }
    }

    public async Task<AuthResponse?> LoginAsync(LoginRequest request)
    {
        try
        {
            // Buscar usuário por email
            var user = await _userRepository.GetByEmailAsync(request.Email);

            if (user == null || !user.IsActive)
            {
                _logger.LogWarning("Tentativa de login com email não encontrado ou inativo: {Email}", request.Email);
                return null;
            }

            // Verificar senha
            if (!BCrypt.Net.BCrypt.Verify(request.Password, user.PasswordHash))
            {
                _logger.LogWarning("Tentativa de login com senha incorreta: {Email}", request.Email);
                return null;
            }

            // Gerar token JWT
            var token = GenerateJwtToken(user);
            var expiresAt = DateTime.UtcNow.AddHours(24);

            _logger.LogInformation("Login bem-sucedido: {Email}", user.Email);

            return new AuthResponse
            {
                UserId = user.Id,
                Name = user.Name,
                Email = user.Email,
                Token = token,
                ExpiresAt = expiresAt
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Erro ao fazer login");
            return null;
        }
    }

    public async Task<UserResponse?> GetUserByIdAsync(Guid userId)
    {
        try
        {
            var user = await _userRepository.GetByIdAsync(userId);

            if (user == null || !user.IsActive)
                return null;

            return new UserResponse
            {
                Id = user.Id,
                Name = user.Name,
                Email = user.Email,
                CPF = user.CPF,
                Phone = user.Phone,
                BirthDate = user.BirthDate,
                Address = user.Address,
                City = user.City,
                State = user.State,
                ZipCode = user.ZipCode,
                ProfilePhoto = user.ProfilePhoto,
                Bio = user.Bio,
                CreatedAt = user.CreatedAt,
                IsActive = user.IsActive,
                IsProfileComplete = user.IsProfileComplete,
                ProfileCompletionPercentage = user.GetProfileCompletionPercentage()
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Erro ao buscar usuário");
            return null;
        }
    }

    public async Task<bool> EmailExistsAsync(string email)
    {
        return await _userRepository.ExistsByEmailAsync(email);
    }

    public async Task<UserResponse?> UpdateProfileAsync(Guid userId, UpdateProfileRequest request)
    {
        try
        {
            var user = await _userRepository.GetByIdAsync(userId);

            if (user == null || !user.IsActive)
            {
                _logger.LogWarning("Tentativa de atualizar perfil de usuário inexistente ou inativo: {UserId}", userId);
                return null;
            }

            // Atualizar perfil usando método do domínio
            user.UpdateFullProfile(
                name: request.Name,
                phone: request.Phone,
                birthDate: request.BirthDate,
                address: request.Address,
                city: request.City,
                state: request.State,
                zipCode: request.ZipCode,
                bio: request.Bio
            );

            await _userRepository.UpdateAsync(user);
            await _userRepository.SaveChangesAsync();

            _logger.LogInformation("Perfil atualizado: {Email}", user.Email);

            return new UserResponse
            {
                Id = user.Id,
                Name = user.Name,
                Email = user.Email,
                CPF = user.CPF,
                Phone = user.Phone,
                BirthDate = user.BirthDate,
                Address = user.Address,
                City = user.City,
                State = user.State,
                ZipCode = user.ZipCode,
                ProfilePhoto = user.ProfilePhoto,
                Bio = user.Bio,
                CreatedAt = user.CreatedAt,
                IsActive = user.IsActive,
                IsProfileComplete = user.IsProfileComplete,
                ProfileCompletionPercentage = user.GetProfileCompletionPercentage()
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Erro ao atualizar perfil do usuário");
            return null;
        }
    }

    private string GenerateJwtToken(User user)
    {
        var jwtSettings = _configuration.GetSection("JwtSettings");
        var secretKey = jwtSettings["SecretKey"] ?? throw new InvalidOperationException("JWT SecretKey não configurada");
        
        var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(secretKey));
        var credentials = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

        var claims = new[]
        {
            new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
            new Claim(ClaimTypes.Name, user.Name),
            new Claim(ClaimTypes.Email, user.Email),
            new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString())
        };

        var token = new JwtSecurityToken(
            issuer: jwtSettings["Issuer"],
            audience: jwtSettings["Audience"],
            claims: claims,
            expires: DateTime.UtcNow.AddHours(24),
            signingCredentials: credentials
        );

        return new JwtSecurityTokenHandler().WriteToken(token);
    }
}


