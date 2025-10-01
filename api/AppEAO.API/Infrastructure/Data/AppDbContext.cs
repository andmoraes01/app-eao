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
            
            // Propriedades
            entity.Property(u => u.Name)
                .IsRequired()
                .HasMaxLength(100);
            
            entity.Property(u => u.Email)
                .IsRequired()
                .HasMaxLength(255);
            
            entity.Property(u => u.PasswordHash)
                .IsRequired();
            
            entity.Property(u => u.Phone)
                .HasMaxLength(20);
            
            entity.Property(u => u.CreatedAt)
                .IsRequired();
            
            entity.Property(u => u.UpdatedAt);
            
            entity.Property(u => u.IsActive)
                .IsRequired()
                .HasDefaultValue(true);
            
            // Índices
            entity.HasIndex(u => u.Email)
                .IsUnique()
                .HasDatabaseName("IX_Users_Email");
            
            entity.HasIndex(u => u.CreatedAt)
                .HasDatabaseName("IX_Users_CreatedAt");
        });
    }
}


