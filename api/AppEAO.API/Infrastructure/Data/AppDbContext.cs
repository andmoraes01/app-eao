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
    
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);
        
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
    }
}


