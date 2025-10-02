using Microsoft.EntityFrameworkCore;
using AppEAO.API.Domain.Entities;

namespace AppEAO.API.Infrastructure.Data;

/// <summary>
/// Contexto do Entity Framework Core
/// Responsável pela configuração e acesso ao banco de dados
/// </summary>
public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
    {
    }
    
    public DbSet<User> Users { get; set; }
    public DbSet<Status> Statuses { get; set; }
    public DbSet<Service> Services { get; set; }
    public DbSet<ServiceMaterial> ServiceMaterials { get; set; }
    public DbSet<ServiceProposal> ServiceProposals { get; set; }
    public DbSet<ProposalMaterial> ProposalMaterials { get; set; }
    
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);
        
        // Configurações da entidade Status
        modelBuilder.Entity<Status>(entity =>
        {
            entity.ToTable("Statuses");
            entity.HasKey(s => s.Id);
            
            entity.Property(s => s.Name)
                .IsRequired()
                .HasMaxLength(50);
            
            entity.Property(s => s.Description)
                .IsRequired()
                .HasMaxLength(200);
            
            entity.Property(s => s.Color)
                .IsRequired()
                .HasMaxLength(20);
            
            entity.Property(s => s.IsActive)
                .IsRequired()
                .HasDefaultValue(true);
            
            entity.Property(s => s.CreatedAt)
                .IsRequired();
            
            entity.Property(s => s.UpdatedAt)
                .IsRequired();
        });
        
        // Configurações da entidade User
        modelBuilder.Entity<User>(entity =>
        {
            // Nome da tabela
            entity.ToTable("Users");
            
            // Chave primária
            entity.HasKey(u => u.Id);
            
            // Propriedades básicas (não editáveis)
            entity.Property(u => u.Email)
                .IsRequired()
                .HasMaxLength(255);
            
            entity.Property(u => u.CPF)
                .IsRequired()
                .HasMaxLength(14);
            
            entity.Property(u => u.PasswordHash)
                .IsRequired();
            
            entity.Property(u => u.CreatedAt)
                .IsRequired();
            
            entity.Property(u => u.UpdatedAt);
            
            entity.Property(u => u.IsActive)
                .IsRequired()
                .HasDefaultValue(true);
            
            entity.Property(u => u.IsProfileComplete)
                .IsRequired()
                .HasDefaultValue(false);
            
            // Propriedades do perfil (editáveis)
            entity.Property(u => u.Name)
                .IsRequired()
                .HasMaxLength(100);
            
            entity.Property(u => u.Phone)
                .HasMaxLength(20);
            
            entity.Property(u => u.BirthDate);
            
            entity.Property(u => u.Address)
                .HasMaxLength(200);
            
            entity.Property(u => u.City)
                .HasMaxLength(100);
            
            entity.Property(u => u.State)
                .HasMaxLength(2);
            
            entity.Property(u => u.ZipCode)
                .HasMaxLength(10);
            
            entity.Property(u => u.ProfilePhoto)
                .HasMaxLength(500);
            
            entity.Property(u => u.Bio)
                .HasMaxLength(500);
            
            // Índices
            entity.HasIndex(u => u.Email)
                .IsUnique()
                .HasDatabaseName("IX_Users_Email");
            
            entity.HasIndex(u => u.CPF)
                .IsUnique()
                .HasDatabaseName("IX_Users_CPF");
            
            entity.HasIndex(u => u.CreatedAt)
                .HasDatabaseName("IX_Users_CreatedAt");
            
            entity.HasIndex(u => u.IsProfileComplete)
                .HasDatabaseName("IX_Users_IsProfileComplete");
        });

        // Configurações da entidade Service
        modelBuilder.Entity<Service>(entity =>
        {
            entity.ToTable("Services");
            
            entity.HasKey(s => s.Id);
            
            entity.Property(s => s.Title)
                .IsRequired()
                .HasMaxLength(200);
            
            entity.Property(s => s.Description)
                .IsRequired()
                .HasMaxLength(2000);
            
            entity.Property(s => s.ServiceType)
                .IsRequired()
                .HasMaxLength(100);
            
            entity.Property(s => s.Location)
                .IsRequired()
                .HasMaxLength(200);
            
            entity.Property(s => s.LocationType)
                .IsRequired()
                .HasMaxLength(100);
            
            entity.Property(s => s.PreferredTime)
                .IsRequired()
                .HasMaxLength(50);
            
            entity.Property(s => s.MaterialsDescription)
                .HasMaxLength(1000);
            
            entity.Property(s => s.StatusId)
                .IsRequired();
            
            entity.Property(s => s.CreatedAt)
                .IsRequired();
            
            entity.Property(s => s.UpdatedAt);
            
            entity.Property(s => s.IsActive)
                .IsRequired()
                .HasDefaultValue(true);
            
            // Relacionamentos
            entity.HasOne(s => s.User)
                .WithMany()
                .HasForeignKey(s => s.UserId)
                .OnDelete(DeleteBehavior.Cascade);
            
            entity.HasOne(s => s.Status)
                .WithMany()
                .HasForeignKey(s => s.StatusId)
                .OnDelete(DeleteBehavior.Restrict);
            
            entity.HasMany(s => s.Materials)
                .WithOne(m => m.Service)
                .HasForeignKey(m => m.ServiceId)
                .OnDelete(DeleteBehavior.Cascade);
            
            entity.HasMany(s => s.Proposals)
                .WithOne(p => p.Service)
                .HasForeignKey(p => p.ServiceId)
                .OnDelete(DeleteBehavior.Cascade);
            
            // Índices
            entity.HasIndex(s => s.UserId)
                .HasDatabaseName("IX_Services_UserId");
            
            entity.HasIndex(s => s.ServiceType)
                .HasDatabaseName("IX_Services_ServiceType");
            
            entity.HasIndex(s => s.StatusId)
                .HasDatabaseName("IX_Services_StatusId");
            
            entity.HasIndex(s => s.CreatedAt)
                .HasDatabaseName("IX_Services_CreatedAt");
        });

        // Configurações da entidade ServiceMaterial
        modelBuilder.Entity<ServiceMaterial>(entity =>
        {
            entity.ToTable("ServiceMaterials");
            
            entity.HasKey(sm => sm.Id);
            
            entity.Property(sm => sm.Name)
                .IsRequired()
                .HasMaxLength(200);
            
            entity.Property(sm => sm.Brand)
                .HasMaxLength(100);
            
            entity.Property(sm => sm.Unit)
                .IsRequired()
                .HasMaxLength(20);
            
            entity.Property(sm => sm.Notes)
                .HasMaxLength(500);
            
            entity.Property(sm => sm.CreatedAt)
                .IsRequired();
            
            entity.Property(sm => sm.UpdatedAt);
            
            entity.Property(sm => sm.IsActive)
                .IsRequired()
                .HasDefaultValue(true);
            
            // Relacionamentos
            entity.HasOne(sm => sm.Service)
                .WithMany(s => s.Materials)
                .HasForeignKey(sm => sm.ServiceId)
                .OnDelete(DeleteBehavior.Cascade);
            
            // Índices
            entity.HasIndex(sm => sm.ServiceId)
                .HasDatabaseName("IX_ServiceMaterials_ServiceId");
        });

        // Configurações da entidade ServiceProposal
        modelBuilder.Entity<ServiceProposal>(entity =>
        {
            entity.ToTable("ServiceProposals");
            
            entity.HasKey(sp => sp.Id);
            
            entity.Property(sp => sp.Description)
                .IsRequired()
                .HasMaxLength(2000);
            
            entity.Property(sp => sp.StatusId)
                .IsRequired();
            
            entity.Property(sp => sp.Notes)
                .HasMaxLength(1000);
            
            entity.Property(sp => sp.Rating)
                .IsRequired(false);
            
            entity.Property(sp => sp.EvaluationComment)
                .HasMaxLength(1000);
            
            entity.Property(sp => sp.CompletedAt)
                .IsRequired(false);
            
            entity.Property(sp => sp.CreatedAt)
                .IsRequired();
            
            entity.Property(sp => sp.UpdatedAt);
            
            entity.Property(sp => sp.IsActive)
                .IsRequired()
                .HasDefaultValue(true);
            
            // Relacionamentos
            entity.HasOne(sp => sp.Service)
                .WithMany(s => s.Proposals)
                .HasForeignKey(sp => sp.ServiceId)
                .OnDelete(DeleteBehavior.Cascade);
            
            entity.HasOne(sp => sp.Contractor)
                .WithMany()
                .HasForeignKey(sp => sp.ContractorId)
                .OnDelete(DeleteBehavior.Restrict);
            
            entity.HasOne(sp => sp.Status)
                .WithMany()
                .HasForeignKey(sp => sp.StatusId)
                .OnDelete(DeleteBehavior.Restrict);
            
            entity.HasMany(sp => sp.Materials)
                .WithOne(pm => pm.Proposal)
                .HasForeignKey(pm => pm.ProposalId)
                .OnDelete(DeleteBehavior.Cascade);
            
            // Índices
            entity.HasIndex(sp => sp.ServiceId)
                .HasDatabaseName("IX_ServiceProposals_ServiceId");
            
            entity.HasIndex(sp => sp.ContractorId)
                .HasDatabaseName("IX_ServiceProposals_ContractorId");
            
            entity.HasIndex(sp => sp.StatusId)
                .HasDatabaseName("IX_ServiceProposals_StatusId");
        });

        // Configurações da entidade ProposalMaterial
        modelBuilder.Entity<ProposalMaterial>(entity =>
        {
            entity.ToTable("ProposalMaterials");
            
            entity.HasKey(pm => pm.Id);
            
            entity.Property(pm => pm.Name)
                .IsRequired()
                .HasMaxLength(200);
            
            entity.Property(pm => pm.Brand)
                .HasMaxLength(100);
            
            entity.Property(pm => pm.Unit)
                .IsRequired()
                .HasMaxLength(20);
            
            entity.Property(pm => pm.Notes)
                .HasMaxLength(500);
            
            entity.Property(pm => pm.CreatedAt)
                .IsRequired();
            
            entity.Property(pm => pm.UpdatedAt);
            
            entity.Property(pm => pm.IsActive)
                .IsRequired()
                .HasDefaultValue(true);
            
            // Relacionamentos
            entity.HasOne(pm => pm.Proposal)
                .WithMany(sp => sp.Materials)
                .HasForeignKey(pm => pm.ProposalId)
                .OnDelete(DeleteBehavior.Cascade);
            
            // Índices
            entity.HasIndex(pm => pm.ProposalId)
                .HasDatabaseName("IX_ProposalMaterials_ProposalId");
        });
    }
}


