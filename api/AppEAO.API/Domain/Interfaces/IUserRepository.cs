using AppEAO.API.Domain.Entities;

namespace AppEAO.API.Domain.Interfaces;

/// <summary>
/// Interface do repositório de usuários
/// Define o contrato para acesso a dados de usuários
/// </summary>
public interface IUserRepository
{
    Task<User?> GetByIdAsync(Guid id);
    Task<User?> GetByEmailAsync(string email);
    Task<IEnumerable<User>> GetAllAsync();
    Task<IEnumerable<User>> GetActiveUsersAsync();
    Task<bool> ExistsByEmailAsync(string email);
    Task AddAsync(User user);
    Task UpdateAsync(User user);
    Task DeleteAsync(User user);
    Task<int> SaveChangesAsync();
}


