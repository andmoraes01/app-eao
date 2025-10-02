using AppEAO.API.Application.DTOs;
using AppEAO.API.Application.Interfaces;
using AppEAO.API.Domain.Entities;
using AppEAO.API.Domain.Interfaces;

namespace AppEAO.API.Application.Services;

public class ServiceService : IServiceService
{
    private readonly IServiceRepository _serviceRepository;
    private readonly IUserRepository _userRepository;

    public ServiceService(IServiceRepository serviceRepository, IUserRepository userRepository)
    {
        _serviceRepository = serviceRepository;
        _userRepository = userRepository;
    }

    public async Task<ServiceResponse?> GetByIdAsync(int id)
    {
        var service = await _serviceRepository.GetByIdAsync(id);
        return service != null ? MapToResponse(service) : null;
    }

    public async Task<IEnumerable<ServiceResponse>> GetAllAsync()
    {
        var services = await _serviceRepository.GetAllAsync();
        return services.Select(MapToResponse);
    }

    public async Task<IEnumerable<ServiceResponse>> GetByUserIdAsync(Guid userId)
    {
        var services = await _serviceRepository.GetByUserIdAsync(userId);
        return services.Select(MapToResponse);
    }

    public async Task<IEnumerable<ServiceResponse>> GetActiveServicesAsync()
    {
        var services = await _serviceRepository.GetActiveServicesAsync();
        return services.Select(MapToResponse);
    }

    public async Task<IEnumerable<ServiceResponse>> GetByServiceTypeAsync(string serviceType)
    {
        var services = await _serviceRepository.GetByServiceTypeAsync(serviceType);
        return services.Select(MapToResponse);
    }

    public async Task<IEnumerable<ServiceResponse>> GetByLocationAsync(string location)
    {
        var services = await _serviceRepository.GetByLocationAsync(location);
        return services.Select(MapToResponse);
    }

    public async Task<ServiceResponse> CreateAsync(CreateServiceRequest request, Guid userId)
    {
        // Verificar se o usuário existe
        var user = await _userRepository.GetByIdAsync(userId);
        if (user == null)
            throw new ArgumentException("Usuário não encontrado");

        // Criar o serviço
        var service = new Service(
            userId,
            request.Title,
            request.Description,
            request.ServiceType,
            request.Location,
            request.LocationType,
            request.PreferredStartDate,
            request.PreferredEndDate,
            request.PreferredTime,
            request.RequiresMaterials,
            request.MaterialsDescription,
            request.BudgetRange
        );

        var createdService = await _serviceRepository.CreateAsync(service);

        // Adicionar materiais se fornecidos
        if (request.Materials != null && request.Materials.Any())
        {
            foreach (var materialRequest in request.Materials)
            {
                var material = new ServiceMaterial(
                    createdService.Id,
                    materialRequest.Name,
                    materialRequest.Quantity,
                    materialRequest.Unit,
                    materialRequest.Brand,
                    materialRequest.EstimatedPrice,
                    materialRequest.Notes
                );
                createdService.Materials.Add(material);
            }
            
            // Salvar os materiais no banco
            await _serviceRepository.UpdateAsync(createdService);
        }

        return MapToResponse(createdService);
    }

    public async Task<ServiceResponse> UpdateAsync(int id, CreateServiceRequest request, Guid userId)
    {
        var service = await _serviceRepository.GetByIdAsync(id);
        if (service == null)
            throw new ArgumentException("Serviço não encontrado");

        if (service.UserId != userId)
            throw new UnauthorizedAccessException("Você não tem permissão para editar este serviço");

        service.Update(
            request.Title,
            request.Description,
            request.ServiceType,
            request.Location,
            request.LocationType,
            request.PreferredStartDate,
            request.PreferredEndDate,
            request.PreferredTime,
            request.RequiresMaterials,
            request.MaterialsDescription,
            request.BudgetRange
        );

        var updatedService = await _serviceRepository.UpdateAsync(service);
        return MapToResponse(updatedService);
    }

    public async Task DeleteAsync(int id, Guid userId)
    {
        var service = await _serviceRepository.GetByIdAsync(id);
        if (service == null)
            throw new ArgumentException("Serviço não encontrado");

        if (service.UserId != userId)
            throw new UnauthorizedAccessException("Você não tem permissão para excluir este serviço");

        await _serviceRepository.DeleteAsync(id);
    }

    public async Task<bool> ExistsAsync(int id)
    {
        return await _serviceRepository.ExistsAsync(id);
    }

    private static ServiceResponse MapToResponse(Service service)
    {
        return new ServiceResponse
        {
            Id = service.Id,
            UserId = service.UserId,
            UserName = service.User?.Name ?? "Usuário",
            Title = service.Title,
            Description = service.Description,
            ServiceType = service.ServiceType,
            Location = service.Location,
            LocationType = service.LocationType,
            PreferredStartDate = service.PreferredStartDate,
            PreferredEndDate = service.PreferredEndDate,
            PreferredTime = service.PreferredTime,
            RequiresMaterials = service.RequiresMaterials,
            MaterialsDescription = service.MaterialsDescription,
            BudgetRange = service.BudgetRange,
            Status = service.Status.Name,
            StatusId = service.StatusId,
            CreatedAt = service.CreatedAt,
            UpdatedAt = service.UpdatedAt,
            Materials = service.Materials.Select(m => new ServiceMaterialResponse
            {
                Id = m.Id,
                Name = m.Name,
                Brand = m.Brand,
                Quantity = m.Quantity,
                Unit = m.Unit,
                EstimatedPrice = m.EstimatedPrice,
                Notes = m.Notes
            }).ToList(),
            ProposalCount = service.Proposals.Count
        };
    }
}
