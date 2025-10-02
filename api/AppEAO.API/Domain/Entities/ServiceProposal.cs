namespace AppEAO.API.Domain.Entities;

public class ServiceProposal
{
    public int Id { get; private set; }
    public int ServiceId { get; private set; }
    public Guid ContractorId { get; private set; } // ID do prestador de serviço
    public string Description { get; private set; } = string.Empty;
    public decimal LaborCost { get; private set; }
    public decimal? MaterialCost { get; private set; }
    public decimal TotalCost { get; private set; }
    public DateTime EstimatedStartDate { get; private set; }
    public DateTime EstimatedEndDate { get; private set; }
    public int StatusId { get; private set; }
    public string? Notes { get; private set; }
    public int? Rating { get; private set; } // 0-5 estrelas
    public string? EvaluationComment { get; private set; } // Comentário da avaliação
    public DateTime? CompletedAt { get; private set; } // Data de conclusão
    public DateTime CreatedAt { get; private set; }
    public DateTime UpdatedAt { get; private set; }
    public bool IsActive { get; private set; }

    // Navigation properties
    public Service Service { get; private set; } = null!;
    public User Contractor { get; private set; } = null!;
    public Status Status { get; private set; } = null!;
    public ICollection<ProposalMaterial> Materials { get; private set; } = new List<ProposalMaterial>();

    // Constructor for EF Core
    private ServiceProposal() { }

    public ServiceProposal(
        int serviceId,
        Guid contractorId,
        string description,
        decimal laborCost,
        DateTime estimatedStartDate,
        DateTime estimatedEndDate,
        decimal? materialCost = null,
        string? notes = null)
    {
        ServiceId = serviceId;
        ContractorId = contractorId;
        Description = description;
        LaborCost = laborCost;
        MaterialCost = materialCost;
        EstimatedStartDate = estimatedStartDate;
        EstimatedEndDate = estimatedEndDate;
        Notes = notes;
        TotalCost = laborCost + (materialCost ?? 0);
        StatusId = 5; // Pending status
        CreatedAt = DateTime.UtcNow;
        UpdatedAt = DateTime.UtcNow;
        IsActive = true;
    }

    public void Update(
        string description,
        decimal laborCost,
        DateTime estimatedStartDate,
        DateTime estimatedEndDate,
        decimal? materialCost = null,
        string? notes = null)
    {
        Description = description;
        LaborCost = laborCost;
        MaterialCost = materialCost;
        EstimatedStartDate = estimatedStartDate;
        EstimatedEndDate = estimatedEndDate;
        Notes = notes;
        TotalCost = laborCost + (materialCost ?? 0);
        UpdatedAt = DateTime.UtcNow;
    }

    public void Accept()
    {
        StatusId = 6; // Accepted status
        UpdatedAt = DateTime.UtcNow;
    }

    public void Reject()
    {
        StatusId = 7; // Rejected status
        UpdatedAt = DateTime.UtcNow;
    }

    public void Complete()
    {
        StatusId = 3; // Completed status (usando o mesmo ID dos serviços)
        CompletedAt = DateTime.UtcNow;
        UpdatedAt = DateTime.UtcNow;
    }

    public void Evaluate(int rating, string? evaluationComment = null)
    {
        if (rating < 0 || rating > 5)
            throw new ArgumentException("Rating must be between 0 and 5");
            
        Rating = rating;
        EvaluationComment = evaluationComment;
        UpdatedAt = DateTime.UtcNow;
    }

    public void Deactivate()
    {
        IsActive = false;
        UpdatedAt = DateTime.UtcNow;
    }
}
