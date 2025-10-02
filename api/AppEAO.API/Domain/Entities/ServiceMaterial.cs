namespace AppEAO.API.Domain.Entities;

public class ServiceMaterial
{
    public int Id { get; private set; }
    public int ServiceId { get; private set; }
    public string Name { get; private set; } = string.Empty;
    public string? Brand { get; private set; }
    public int Quantity { get; private set; }
    public string Unit { get; private set; } = string.Empty; // unidade, kg, m², etc
    public decimal? EstimatedPrice { get; private set; }
    public string? Notes { get; private set; }
    public DateTime CreatedAt { get; private set; }
    public DateTime UpdatedAt { get; private set; }
    public bool IsActive { get; private set; }

    // Navigation properties
    public Service Service { get; private set; } = null!;

    // Constructor for EF Core
    private ServiceMaterial() { }

    public ServiceMaterial(
        int serviceId,
        string name,
        int quantity,
        string unit,
        string? brand = null,
        decimal? estimatedPrice = null,
        string? notes = null)
    {
        ServiceId = serviceId;
        Name = name;
        Brand = brand;
        Quantity = quantity;
        Unit = unit;
        EstimatedPrice = estimatedPrice;
        Notes = notes;
        CreatedAt = DateTime.UtcNow;
        UpdatedAt = DateTime.UtcNow;
        IsActive = true;
    }

    public void Update(
        string name,
        int quantity,
        string unit,
        string? brand = null,
        decimal? estimatedPrice = null,
        string? notes = null)
    {
        Name = name;
        Brand = brand;
        Quantity = quantity;
        Unit = unit;
        EstimatedPrice = estimatedPrice;
        Notes = notes;
        UpdatedAt = DateTime.UtcNow;
    }

    public void Deactivate()
    {
        IsActive = false;
        UpdatedAt = DateTime.UtcNow;
    }
}
