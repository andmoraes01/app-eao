using AppEAO.API.Domain.Entities;

namespace AppEAO.API.Domain.Interfaces;

public interface IServiceProposalRepository
{
    Task<ServiceProposal?> GetByIdAsync(int id);
    Task<IEnumerable<ServiceProposal>> GetByServiceIdAsync(int serviceId);
    Task<IEnumerable<ServiceProposal>> GetByContractorIdAsync(Guid contractorId);
    Task<IEnumerable<ServiceProposal>> GetByStatusAsync(int statusId);
    Task<ServiceProposal> CreateAsync(ServiceProposal proposal);
    Task<ServiceProposal> UpdateAsync(ServiceProposal proposal);
    Task DeleteAsync(int id);
    Task<bool> ExistsAsync(int id);
}
