using System.ComponentModel.DataAnnotations;

namespace AppEAO.API.Application.DTOs;

public class LoginRequest
{
    [Required(ErrorMessage = "Email é obrigatório")]
    [EmailAddress(ErrorMessage = "Email inválido")]
    public string Email { get; set; } = string.Empty;
    
    [Required(ErrorMessage = "Senha é obrigatória")]
    public string Password { get; set; } = string.Empty;
}

