using System.ComponentModel.DataAnnotations;
using AppEAO.API.Application.Validators;

namespace AppEAO.API.Application.DTOs;

public class UpdateProfileRequest
{
    [Required(ErrorMessage = "Nome é obrigatório")]
    [StringLength(100, ErrorMessage = "Nome não pode ter mais de 100 caracteres")]
    public string Name { get; set; } = string.Empty;
    
    [BrazilianPhone]
    public string? Phone { get; set; }
    
    public DateTime? BirthDate { get; set; }
    
    [StringLength(200)]
    public string? Address { get; set; }
    
    [StringLength(100)]
    public string? City { get; set; }
    
    [StringLength(2, MinimumLength = 2, ErrorMessage = "Estado deve ter 2 caracteres (UF)")]
    public string? State { get; set; }
    
    [StringLength(10)]
    [RegularExpression(@"^\d{5}-?\d{3}$", ErrorMessage = "CEP inválido. Use formato: 12345-678")]
    public string? ZipCode { get; set; }
    
    [StringLength(500)]
    public string? Bio { get; set; }
}

