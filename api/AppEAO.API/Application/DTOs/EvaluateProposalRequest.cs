using System.ComponentModel.DataAnnotations;

namespace AppEAO.API.Application.DTOs;

public class EvaluateProposalRequest
{
    [Required]
    [Range(0, 5, ErrorMessage = "A nota deve estar entre 0 e 5 estrelas")]
    public int Rating { get; set; }

    [MaxLength(1000, ErrorMessage = "O comentário não pode ter mais de 1000 caracteres")]
    public string? EvaluationComment { get; set; }
}
