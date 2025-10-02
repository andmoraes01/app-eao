using System.ComponentModel.DataAnnotations;

namespace AppEAO.API.Application.DTOs;

public class CreateProposalRequest
{
    [Required(ErrorMessage = "Descrição é obrigatória")]
    [StringLength(2000, ErrorMessage = "Descrição deve ter no máximo 2000 caracteres")]
    public string Description { get; set; } = string.Empty;

    [Required(ErrorMessage = "Custo da mão de obra é obrigatório")]
    [Range(0, double.MaxValue, ErrorMessage = "Custo da mão de obra deve ser positivo")]
    public decimal LaborCost { get; set; }

    [Range(0, double.MaxValue, ErrorMessage = "Custo de materiais deve ser positivo")]
    public decimal? MaterialCost { get; set; }

    [Required(ErrorMessage = "Data de início estimada é obrigatória")]
    public DateTime EstimatedStartDate { get; set; }

    [Required(ErrorMessage = "Data de fim estimada é obrigatória")]
    public DateTime EstimatedEndDate { get; set; }

    [StringLength(1000, ErrorMessage = "Observações devem ter no máximo 1000 caracteres")]
    public string? Notes { get; set; }

    public List<ProposalMaterialRequest>? Materials { get; set; }
}

public class ProposalMaterialRequest
{
    [Required(ErrorMessage = "Nome do material é obrigatório")]
    [StringLength(200, ErrorMessage = "Nome do material deve ter no máximo 200 caracteres")]
    public string Name { get; set; } = string.Empty;

    [StringLength(100, ErrorMessage = "Marca deve ter no máximo 100 caracteres")]
    public string? Brand { get; set; }

    [Required(ErrorMessage = "Quantidade é obrigatória")]
    [Range(1, int.MaxValue, ErrorMessage = "Quantidade deve ser maior que zero")]
    public int Quantity { get; set; }

    [Required(ErrorMessage = "Unidade é obrigatória")]
    [StringLength(20, ErrorMessage = "Unidade deve ter no máximo 20 caracteres")]
    public string Unit { get; set; } = string.Empty;

    [Required(ErrorMessage = "Preço unitário é obrigatório")]
    [Range(0, double.MaxValue, ErrorMessage = "Preço unitário deve ser positivo")]
    public decimal UnitPrice { get; set; }

    [StringLength(500, ErrorMessage = "Observações devem ter no máximo 500 caracteres")]
    public string? Notes { get; set; }
}
