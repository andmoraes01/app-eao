namespace AppEAO.API.Application.DTOs;

public class ServiceResponse
{
    public int Id { get; set; }
    public Guid UserId { get; set; }
    public string UserName { get; set; } = string.Empty;
    public string Title { get; set; } = string.Empty;
    public string Description { get; set; } = string.Empty;
    public string ServiceType { get; set; } = string.Empty;
    public string Location { get; set; } = string.Empty;
    public string LocationType { get; set; } = string.Empty;
    public DateTime PreferredStartDate { get; set; }
    public DateTime PreferredEndDate { get; set; }
    public string PreferredTime { get; set; } = string.Empty;
    public bool RequiresMaterials { get; set; }
    public string? MaterialsDescription { get; set; }
    public decimal? BudgetRange { get; set; }
    public string Status { get; set; } = string.Empty;
    public int StatusId { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime UpdatedAt { get; set; }
    public List<ServiceMaterialResponse> Materials { get; set; } = new();
    public int ProposalCount { get; set; }
}

public class ServiceMaterialResponse
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string? Brand { get; set; }
    public int Quantity { get; set; }
    public string Unit { get; set; } = string.Empty;
    public decimal? EstimatedPrice { get; set; }
    public string? Notes { get; set; }
}
