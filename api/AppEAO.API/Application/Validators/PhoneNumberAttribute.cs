using System.ComponentModel.DataAnnotations;
using System.Text.RegularExpressions;

namespace AppEAO.API.Application.Validators;

/// <summary>
/// Validador customizado para telefone brasileiro
/// </summary>
public class BrazilianPhoneAttribute : ValidationAttribute
{
    protected override ValidationResult? IsValid(object? value, ValidationContext validationContext)
    {
        if (value == null || string.IsNullOrWhiteSpace(value.ToString()))
        {
            // Telefone é opcional, então null ou vazio é válido
            return ValidationResult.Success;
        }

        var phone = value.ToString()!.Trim();
        
        // Remover caracteres não numéricos para validação
        var phoneNumbers = Regex.Replace(phone, @"[^\d]", "");
        
        // Formato brasileiro: +55 (DDD) NÚMERO
        // DDD: 2 dígitos (11-99)
        // Número: 8 ou 9 dígitos
        // Total: 10 ou 11 dígitos (sem o +55)
        
        if (phoneNumbers.Length < 10 || phoneNumbers.Length > 13)
        {
            return new ValidationResult("Telefone inválido. Use o formato: +55 (DDD) XXXXX-XXXX");
        }
        
        // Se começar com 55 (código do Brasil), validar DDD e número
        if (phoneNumbers.StartsWith("55"))
        {
            // Remove o 55
            phoneNumbers = phoneNumbers.Substring(2);
            
            if (phoneNumbers.Length < 10 || phoneNumbers.Length > 11)
            {
                return new ValidationResult("Telefone brasileiro deve ter DDD (2 dígitos) + 8 ou 9 dígitos");
            }
            
            // Validar DDD (11-99)
            var ddd = int.Parse(phoneNumbers.Substring(0, 2));
            if (ddd < 11 || ddd > 99)
            {
                return new ValidationResult("DDD inválido. Deve estar entre 11 e 99");
            }
        }
        else
        {
            // Telefone brasileiro sem código de país
            if (phoneNumbers.Length != 10 && phoneNumbers.Length != 11)
            {
                return new ValidationResult("Telefone deve ter DDD (2 dígitos) + 8 ou 9 dígitos");
            }
            
            // Validar DDD
            var ddd = int.Parse(phoneNumbers.Substring(0, 2));
            if (ddd < 11 || ddd > 99)
            {
                return new ValidationResult("DDD inválido. Deve estar entre 11 e 99");
            }
        }
        
        return ValidationResult.Success;
    }
}

