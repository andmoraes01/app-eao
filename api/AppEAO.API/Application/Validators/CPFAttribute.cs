using System.ComponentModel.DataAnnotations;

namespace AppEAO.API.Application.Validators;

/// <summary>
/// Validador de CPF brasileiro
/// </summary>
public class CPFAttribute : ValidationAttribute
{
    protected override ValidationResult? IsValid(object? value, ValidationContext validationContext)
    {
        if (value == null || string.IsNullOrWhiteSpace(value.ToString()))
        {
            return new ValidationResult("CPF é obrigatório");
        }

        var cpf = value.ToString()!.Trim();
        
        // Remover caracteres não numéricos
        cpf = new string(cpf.Where(char.IsDigit).ToArray());
        
        // CPF deve ter 11 dígitos
        if (cpf.Length != 11)
        {
            return new ValidationResult("CPF deve ter 11 dígitos");
        }
        
        // Verificar se todos os dígitos são iguais (CPF inválido)
        if (cpf.Distinct().Count() == 1)
        {
            return new ValidationResult("CPF inválido");
        }
        
        // Validar dígitos verificadores
        if (!ValidateVerificationDigits(cpf))
        {
            return new ValidationResult("CPF inválido");
        }
        
        return ValidationResult.Success;
    }
    
    private bool ValidateVerificationDigits(string cpf)
    {
        var digits = cpf.Select(c => int.Parse(c.ToString())).ToArray();
        
        // Validar primeiro dígito verificador
        var sum = 0;
        for (int i = 0; i < 9; i++)
        {
            sum += digits[i] * (10 - i);
        }
        var remainder = sum % 11;
        var digit1 = remainder < 2 ? 0 : 11 - remainder;
        
        if (digits[9] != digit1)
            return false;
        
        // Validar segundo dígito verificador
        sum = 0;
        for (int i = 0; i < 10; i++)
        {
            sum += digits[i] * (11 - i);
        }
        remainder = sum % 11;
        var digit2 = remainder < 2 ? 0 : 11 - remainder;
        
        return digits[10] == digit2;
    }
}

