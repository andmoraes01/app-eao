namespace AppEAO.API.Application.DTOs;

public class ProposalResponse
{
    public int Id { get; set; }
    public int ServiceId { get; set; }
    public Guid ContractorId { get; set; }
    public string ContractorName { get; set; } = string.Empty;
    public string Description { get; set; } = string.Empty;
    public decimal LaborCost { get; set; }
    public decimal? MaterialCost { get; set; }
    public decimal TotalCost { get; set; }
    public DateTime EstimatedStartDate { get; set; }
    public DateTime EstimatedEndDate { get; set; }
    public string Status { get; set; } = string.Empty;
    public int StatusId { get; set; }
    public string? Notes { get; set; }
    public int? Rating { get; set; }
    public string? EvaluationComment { get; set; }
    public DateTime? CompletedAt { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime UpdatedAt { get; set; }
    public List<ProposalMaterialResponse> Materials { get; set; } = new();
}

public class ProposalMaterialResponse
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string? Brand { get; set; }
    public int Quantity { get; set; }
    public string Unit { get; set; } = string.Empty;
    public decimal UnitPrice { get; set; }
    public decimal TotalPrice { get; set; }
    public string? Notes { get; set; }
}
