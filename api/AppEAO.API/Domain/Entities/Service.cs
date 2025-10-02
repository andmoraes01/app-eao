using System.ComponentModel.DataAnnotations;

namespace AppEAO.API.Domain.Entities;

public class Service
{
    public int Id { get; private set; }
    public Guid UserId { get; private set; }
    public string Title { get; private set; } = string.Empty;
    public string Description { get; private set; } = string.Empty;
    public string ServiceType { get; private set; } = string.Empty;
    public string Location { get; private set; } = string.Empty;
    public string LocationType { get; private set; } = string.Empty;
    public DateTime PreferredStartDate { get; private set; }
    public DateTime PreferredEndDate { get; private set; }
    public string PreferredTime { get; private set; } = string.Empty;
    public bool RequiresMaterials { get; private set; }
    public string? MaterialsDescription { get; private set; }
    public decimal? BudgetRange { get; private set; }
    public int StatusId { get; private set; }
    public DateTime CreatedAt { get; private set; }
    public DateTime UpdatedAt { get; private set; }
    public bool IsActive { get; private set; }

    // Navigation properties
    public User User { get; private set; } = null!;
    public Status Status { get; private set; } = null!;
    public ICollection<ServiceMaterial> Materials { get; private set; } = new List<ServiceMaterial>();
    public ICollection<ServiceProposal> Proposals { get; private set; } = new List<ServiceProposal>();

    // Constructor for EF Core
    private Service() { }

    public Service(
        Guid userId,
        string title,
        string description,
        string serviceType,
        string location,
        string locationType,
        DateTime preferredStartDate,
        DateTime preferredEndDate,
        string preferredTime,
        bool requiresMaterials,
        string? materialsDescription = null,
        decimal? budgetRange = null)
    {
        UserId = userId;
        Title = title;
        Description = description;
        ServiceType = serviceType;
        Location = location;
        LocationType = locationType;
        PreferredStartDate = preferredStartDate;
        PreferredEndDate = preferredEndDate;
        PreferredTime = preferredTime;
        RequiresMaterials = requiresMaterials;
        MaterialsDescription = materialsDescription;
        BudgetRange = budgetRange;
        StatusId = 1; // Active status
        CreatedAt = DateTime.UtcNow;
        UpdatedAt = DateTime.UtcNow;
        IsActive = true;
    }

    public void Update(
        string title,
        string description,
        string serviceType,
        string location,
        string locationType,
        DateTime preferredStartDate,
        DateTime preferredEndDate,
        string preferredTime,
        bool requiresMaterials,
        string? materialsDescription = null,
        decimal? budgetRange = null)
    {
        Title = title;
        Description = description;
        ServiceType = serviceType;
        Location = location;
        LocationType = locationType;
        PreferredStartDate = preferredStartDate;
        PreferredEndDate = preferredEndDate;
        PreferredTime = preferredTime;
        RequiresMaterials = requiresMaterials;
        MaterialsDescription = materialsDescription;
        BudgetRange = budgetRange;
        UpdatedAt = DateTime.UtcNow;
    }

    public void Cancel()
    {
        StatusId = 4; // Cancelled status
        UpdatedAt = DateTime.UtcNow;
    }

    public void Complete()
    {
        StatusId = 3; // Completed status
        UpdatedAt = DateTime.UtcNow;
    }

    public void UpdateStatus(int newStatusId)
    {
        StatusId = newStatusId;
        UpdatedAt = DateTime.UtcNow;
    }

    public void SetInProgress()
    {
        StatusId = 2; // InProgress status
        UpdatedAt = DateTime.UtcNow;
    }

    public void Deactivate()
    {
        IsActive = false;
        UpdatedAt = DateTime.UtcNow;
    }
}
