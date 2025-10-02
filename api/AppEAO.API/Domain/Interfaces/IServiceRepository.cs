using AppEAO.API.Domain.Entities;

namespace AppEAO.API.Domain.Interfaces;

public interface IServiceRepository
{
    Task<Service?> GetByIdAsync(int id);
    Task<IEnumerable<Service>> GetAllAsync();
    Task<IEnumerable<Service>> GetByUserIdAsync(Guid userId);
    Task<IEnumerable<Service>> GetActiveServicesAsync();
    Task<IEnumerable<Service>> GetByServiceTypeAsync(string serviceType);
    Task<IEnumerable<Service>> GetByLocationAsync(string location);
    Task<Service> CreateAsync(Service service);
    Task<Service> UpdateAsync(Service service);
    Task DeleteAsync(int id);
    Task<bool> ExistsAsync(int id);
}
