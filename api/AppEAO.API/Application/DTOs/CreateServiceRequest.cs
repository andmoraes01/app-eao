using System.ComponentModel.DataAnnotations;

namespace AppEAO.API.Application.DTOs;

public class CreateServiceRequest
{
    [Required(ErrorMessage = "Título é obrigatório")]
    [StringLength(200, ErrorMessage = "Título deve ter no máximo 200 caracteres")]
    public string Title { get; set; } = string.Empty;

    [Required(ErrorMessage = "Descrição é obrigatória")]
    [StringLength(2000, ErrorMessage = "Descrição deve ter no máximo 2000 caracteres")]
    public string Description { get; set; } = string.Empty;

    [Required(ErrorMessage = "Tipo de serviço é obrigatório")]
    [StringLength(100, ErrorMessage = "Tipo de serviço deve ter no máximo 100 caracteres")]
    public string ServiceType { get; set; } = string.Empty;

    [Required(ErrorMessage = "Localização é obrigatória")]
    [StringLength(200, ErrorMessage = "Localização deve ter no máximo 200 caracteres")]
    public string Location { get; set; } = string.Empty;

    [Required(ErrorMessage = "Tipo de local é obrigatório")]
    [StringLength(100, ErrorMessage = "Tipo de local deve ter no máximo 100 caracteres")]
    public string LocationType { get; set; } = string.Empty;

    [Required(ErrorMessage = "Data de início preferida é obrigatória")]
    public DateTime PreferredStartDate { get; set; }

    [Required(ErrorMessage = "Data de fim preferida é obrigatória")]
    public DateTime PreferredEndDate { get; set; }

    [Required(ErrorMessage = "Horário preferido é obrigatório")]
    [StringLength(50, ErrorMessage = "Horário preferido deve ter no máximo 50 caracteres")]
    public string PreferredTime { get; set; } = string.Empty;

    [Required(ErrorMessage = "Indicação se requer materiais é obrigatória")]
    public bool RequiresMaterials { get; set; }

    [StringLength(1000, ErrorMessage = "Descrição de materiais deve ter no máximo 1000 caracteres")]
    public string? MaterialsDescription { get; set; }

    [Range(0, double.MaxValue, ErrorMessage = "Faixa de orçamento deve ser positiva")]
    public decimal? BudgetRange { get; set; }

    public List<ServiceMaterialRequest>? Materials { get; set; }
}

public class ServiceMaterialRequest
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

    [Range(0, double.MaxValue, ErrorMessage = "Preço estimado deve ser positivo")]
    public decimal? EstimatedPrice { get; set; }

    [StringLength(500, ErrorMessage = "Observações devem ter no máximo 500 caracteres")]
    public string? Notes { get; set; }
}
