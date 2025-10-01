using Microsoft.EntityFrameworkCore;
using AppEAO.API.Domain.Entities;
using AppEAO.API.Domain.Interfaces;
using AppEAO.API.Infrastructure.Data;

namespace AppEAO.API.Infrastructure.Repositories;

/// <summary>
/// Repositório de usuários - Implementa o acesso a dados
/// </summary>
public class UserRepository : IUserRepository
{
    private readonly AppDbContext _context;
    private readonly ILogger<UserRepository> _logger;

    public UserRepository(AppDbContext context, ILogger<UserRepository> logger)
    {
        _context = context;
        _logger = logger;
    }

    public async Task<User?> GetByIdAsync(Guid id)
    {
        try
        {
            return await _context.Users
                .AsNoTracking()
                .FirstOrDefaultAsync(u => u.Id == id);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Erro ao buscar usuário por ID: {Id}", id);
            throw;
        }
    }

    public async Task<User?> GetByEmailAsync(string email)
    {
        try
        {
            return await _context.Users
                .AsNoTracking()
                .FirstOrDefaultAsync(u => u.Email == email);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Erro ao buscar usuário por email: {Email}", email);
            throw;
        }
    }

    public async Task<IEnumerable<User>> GetAllAsync()
    {
        try
        {
            return await _context.Users
                .AsNoTracking()
                .ToListAsync();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Erro ao buscar todos os usuários");
            throw;
        }
    }

    public async Task<IEnumerable<User>> GetActiveUsersAsync()
    {
        try
        {
            return await _context.Users
                .AsNoTracking()
                .Where(u => u.IsActive)
                .OrderByDescending(u => u.CreatedAt)
                .ToListAsync();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Erro ao buscar usuários ativos");
            throw;
        }
    }

    public async Task<bool> ExistsByEmailAsync(string email)
    {
        try
        {
            return await _context.Users
                .AnyAsync(u => u.Email == email);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Erro ao verificar existência de email: {Email}", email);
            throw;
        }
    }

    public async Task AddAsync(User user)
    {
        try
        {
            await _context.Users.AddAsync(user);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Erro ao adicionar usuário");
            throw;
        }
    }

    public Task UpdateAsync(User user)
    {
        try
        {
            _context.Users.Update(user);
            return Task.CompletedTask;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Erro ao atualizar usuário");
            throw;
        }
    }

    public Task DeleteAsync(User user)
    {
        try
        {
            _context.Users.Remove(user);
            return Task.CompletedTask;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Erro ao deletar usuário");
            throw;
        }
    }

    public async Task<int> SaveChangesAsync()
    {
        try
        {
            return await _context.SaveChangesAsync();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Erro ao salvar mudanças no banco");
            throw;
        }
    }
}


