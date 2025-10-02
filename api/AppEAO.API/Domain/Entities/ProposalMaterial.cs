namespace AppEAO.API.Domain.Entities;

public class ProposalMaterial
{
    public int Id { get; private set; }
    public int ProposalId { get; private set; }
    public string Name { get; private set; } = string.Empty;
    public string? Brand { get; private set; }
    public int Quantity { get; private set; }
    public string Unit { get; private set; } = string.Empty;
    public decimal UnitPrice { get; private set; }
    public decimal TotalPrice { get; private set; }
    public string? Notes { get; private set; }
    public DateTime CreatedAt { get; private set; }
    public DateTime UpdatedAt { get; private set; }
    public bool IsActive { get; private set; }

    // Navigation properties
    public ServiceProposal Proposal { get; private set; } = null!;

    // Constructor for EF Core
    private ProposalMaterial() { }

    public ProposalMaterial(
        int proposalId,
        string name,
        int quantity,
        string unit,
        decimal unitPrice,
        string? brand = null,
        string? notes = null)
    {
        ProposalId = proposalId;
        Name = name;
        Brand = brand;
        Quantity = quantity;
        Unit = unit;
        UnitPrice = unitPrice;
        TotalPrice = quantity * unitPrice;
        Notes = notes;
        CreatedAt = DateTime.UtcNow;
        UpdatedAt = DateTime.UtcNow;
        IsActive = true;
    }

    public void Update(
        string name,
        int quantity,
        string unit,
        decimal unitPrice,
        string? brand = null,
        string? notes = null)
    {
        Name = name;
        Brand = brand;
        Quantity = quantity;
        Unit = unit;
        UnitPrice = unitPrice;
        TotalPrice = quantity * unitPrice;
        Notes = notes;
        UpdatedAt = DateTime.UtcNow;
    }

    public void Deactivate()
    {
        IsActive = false;
        UpdatedAt = DateTime.UtcNow;
    }
}
