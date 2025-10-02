using AppEAO.API.Application.DTOs;

namespace AppEAO.API.Application.Interfaces;

public interface IServiceProposalService
{
    Task<ProposalResponse?> GetByIdAsync(int id);
    Task<IEnumerable<ProposalResponse>> GetByServiceIdAsync(int serviceId);
    Task<IEnumerable<ProposalResponse>> GetByContractorIdAsync(Guid contractorId);
    Task<IEnumerable<ProposalResponse>> GetByStatusAsync(int statusId);
    Task<ProposalResponse> CreateAsync(CreateProposalRequest request, int serviceId, Guid contractorId);
    Task<ProposalResponse> UpdateAsync(int id, CreateProposalRequest request, Guid contractorId);
    Task DeleteAsync(int id, Guid contractorId);
    Task<ProposalResponse> AcceptAsync(int id, Guid serviceOwnerId);
    Task<ProposalResponse> RejectAsync(int id, Guid serviceOwnerId);
    Task<ProposalResponse> CompleteAsync(int id, Guid serviceOwnerId);
    Task<ProposalResponse> EvaluateAsync(int id, EvaluateProposalRequest request, Guid serviceOwnerId);
    Task<bool> ExistsAsync(int id);
}
