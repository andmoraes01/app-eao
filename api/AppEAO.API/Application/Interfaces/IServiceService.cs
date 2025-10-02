using AppEAO.API.Application.DTOs;
using AppEAO.API.Domain.Entities;

namespace AppEAO.API.Application.Interfaces;

public interface IServiceService
{
    Task<ServiceResponse?> GetByIdAsync(int id);
    Task<IEnumerable<ServiceResponse>> GetAllAsync();
    Task<IEnumerable<ServiceResponse>> GetByUserIdAsync(Guid userId);
    Task<IEnumerable<ServiceResponse>> GetActiveServicesAsync();
    Task<IEnumerable<ServiceResponse>> GetByServiceTypeAsync(string serviceType);
    Task<IEnumerable<ServiceResponse>> GetByLocationAsync(string location);
    Task<ServiceResponse> CreateAsync(CreateServiceRequest request, Guid userId);
    Task<ServiceResponse> UpdateAsync(int id, CreateServiceRequest request, Guid userId);
    Task DeleteAsync(int id, Guid userId);
    Task<bool> ExistsAsync(int id);
}
