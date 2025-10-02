using AppEAO.API.Application.DTOs;
using AppEAO.API.Application.Interfaces;
using AppEAO.API.Domain.Entities;
using AppEAO.API.Domain.Interfaces;

namespace AppEAO.API.Application.Services;

public class ServiceProposalService : IServiceProposalService
{
    private readonly IServiceProposalRepository _proposalRepository;
    private readonly IServiceRepository _serviceRepository;
    private readonly IUserRepository _userRepository;

    public ServiceProposalService(
        IServiceProposalRepository proposalRepository,
        IServiceRepository serviceRepository,
        IUserRepository userRepository)
    {
        _proposalRepository = proposalRepository;
        _serviceRepository = serviceRepository;
        _userRepository = userRepository;
    }

    public async Task<ProposalResponse?> GetByIdAsync(int id)
    {
        var proposal = await _proposalRepository.GetByIdAsync(id);
        return proposal != null ? MapToResponse(proposal) : null;
    }

    public async Task<IEnumerable<ProposalResponse>> GetByServiceIdAsync(int serviceId)
    {
        var proposals = await _proposalRepository.GetByServiceIdAsync(serviceId);
        return proposals.Select(MapToResponse);
    }

    public async Task<IEnumerable<ProposalResponse>> GetByContractorIdAsync(Guid contractorId)
    {
        var proposals = await _proposalRepository.GetByContractorIdAsync(contractorId);
        return proposals.Select(MapToResponse);
    }

    public async Task<IEnumerable<ProposalResponse>> GetByStatusAsync(int statusId)
    {
        var proposals = await _proposalRepository.GetByStatusAsync(statusId);
        return proposals.Select(MapToResponse);
    }

    public async Task<ProposalResponse> CreateAsync(CreateProposalRequest request, int serviceId, Guid contractorId)
    {
        // Verificar se o serviço existe
        var service = await _serviceRepository.GetByIdAsync(serviceId);
        if (service == null)
            throw new ArgumentException("Serviço não encontrado");

        // Verificar se o usuário existe
        var contractor = await _userRepository.GetByIdAsync(contractorId);
        if (contractor == null)
            throw new ArgumentException("Usuário não encontrado");

        // Verificar se o usuário não é o dono do serviço
        if (service.UserId == contractorId)
            throw new ArgumentException("Você não pode fazer uma proposta para seu próprio serviço");

        // Verificar se o serviço está disponível para propostas
        if (service.StatusId != 1) // Active status
            throw new ArgumentException("Este serviço não está mais aceitando propostas");

        // Criar a proposta
        var proposal = new ServiceProposal(
            serviceId,
            contractorId,
            request.Description,
            request.LaborCost,
            request.EstimatedStartDate,
            request.EstimatedEndDate,
            request.MaterialCost,
            request.Notes
        );

        var createdProposal = await _proposalRepository.CreateAsync(proposal);

        // Adicionar materiais se fornecidos
        if (request.Materials != null && request.Materials.Any())
        {
            foreach (var materialRequest in request.Materials)
            {
                var material = new ProposalMaterial(
                    createdProposal.Id,
                    materialRequest.Name,
                    materialRequest.Quantity,
                    materialRequest.Unit,
                    materialRequest.UnitPrice,
                    materialRequest.Brand,
                    materialRequest.Notes
                );
                createdProposal.Materials.Add(material);
            }
            
            // Salvar os materiais no banco
            await _proposalRepository.UpdateAsync(createdProposal);
        }

        return MapToResponse(createdProposal);
    }

    public async Task<ProposalResponse> UpdateAsync(int id, CreateProposalRequest request, Guid contractorId)
    {
        var proposal = await _proposalRepository.GetByIdAsync(id);
        if (proposal == null)
            throw new ArgumentException("Proposta não encontrada");

        if (proposal.ContractorId != contractorId)
            throw new UnauthorizedAccessException("Você não tem permissão para editar esta proposta");

        if (proposal.StatusId != 5) // Pending status
            throw new InvalidOperationException("Apenas propostas pendentes podem ser editadas");

        proposal.Update(
            request.Description,
            request.LaborCost,
            request.EstimatedStartDate,
            request.EstimatedEndDate,
            request.MaterialCost,
            request.Notes
        );

        var updatedProposal = await _proposalRepository.UpdateAsync(proposal);
        return MapToResponse(updatedProposal);
    }

    public async Task DeleteAsync(int id, Guid contractorId)
    {
        var proposal = await _proposalRepository.GetByIdAsync(id);
        if (proposal == null)
            throw new ArgumentException("Proposta não encontrada");

        if (proposal.ContractorId != contractorId)
            throw new UnauthorizedAccessException("Você não tem permissão para excluir esta proposta");

        await _proposalRepository.DeleteAsync(id);
    }

    public async Task<ProposalResponse> AcceptAsync(int id, Guid serviceOwnerId)
    {
        var proposal = await _proposalRepository.GetByIdAsync(id);
        if (proposal == null)
            throw new ArgumentException("Proposta não encontrada");

        var service = await _serviceRepository.GetByIdAsync(proposal.ServiceId);
        if (service == null)
            throw new ArgumentException("Serviço não encontrado");

        if (service.UserId != serviceOwnerId)
            throw new UnauthorizedAccessException("Você não tem permissão para aceitar esta proposta");

        if (proposal.StatusId != 5) // Pending status
            throw new InvalidOperationException("Apenas propostas pendentes podem ser aceitas");

        proposal.Accept();
        var updatedProposal = await _proposalRepository.UpdateAsync(proposal);
        
        // Atualizar status do serviço para "Em execução"
        service.SetInProgress();
        await _serviceRepository.UpdateAsync(service);
        
        return MapToResponse(updatedProposal);
    }

    public async Task<ProposalResponse> RejectAsync(int id, Guid serviceOwnerId)
    {
        var proposal = await _proposalRepository.GetByIdAsync(id);
        if (proposal == null)
            throw new ArgumentException("Proposta não encontrada");

        var service = await _serviceRepository.GetByIdAsync(proposal.ServiceId);
        if (service == null)
            throw new ArgumentException("Serviço não encontrado");

        if (service.UserId != serviceOwnerId)
            throw new UnauthorizedAccessException("Você não tem permissão para rejeitar esta proposta");

        if (proposal.StatusId != 5) // Pending status
            throw new InvalidOperationException("Apenas propostas pendentes podem ser rejeitadas");

        proposal.Reject();
        var updatedProposal = await _proposalRepository.UpdateAsync(proposal);
        return MapToResponse(updatedProposal);
    }

    public async Task<ProposalResponse> CompleteAsync(int id, Guid serviceOwnerId)
    {
        var proposal = await _proposalRepository.GetByIdAsync(id);
        if (proposal == null)
            throw new ArgumentException("Proposta não encontrada");

        var service = await _serviceRepository.GetByIdAsync(proposal.ServiceId);
        if (service == null)
            throw new ArgumentException("Serviço não encontrado");

        if (service.UserId != serviceOwnerId)
            throw new UnauthorizedAccessException("Você não tem permissão para concluir esta proposta");

        if (proposal.StatusId != 6) // Accepted status
            throw new InvalidOperationException("Apenas propostas aceitas podem ser concluídas");

        proposal.Complete();
        var updatedProposal = await _proposalRepository.UpdateAsync(proposal);
        
        // Atualizar status do serviço para "Concluído"
        service.Complete(); // Isso já define StatusId = 3 (Completed)
        await _serviceRepository.UpdateAsync(service);
        
        return MapToResponse(updatedProposal);
    }

    public async Task<ProposalResponse> EvaluateAsync(int id, EvaluateProposalRequest request, Guid serviceOwnerId)
    {
        var proposal = await _proposalRepository.GetByIdAsync(id);
        if (proposal == null)
            throw new ArgumentException("Proposta não encontrada");

        var service = await _serviceRepository.GetByIdAsync(proposal.ServiceId);
        if (service == null)
            throw new ArgumentException("Serviço não encontrado");

        if (service.UserId != serviceOwnerId)
            throw new UnauthorizedAccessException("Você não tem permissão para avaliar esta proposta");

        if (proposal.StatusId != 3) // Completed status (usando o mesmo ID dos serviços)
            throw new InvalidOperationException("Apenas propostas concluídas podem ser avaliadas");

        proposal.Evaluate(request.Rating, request.EvaluationComment);
        var updatedProposal = await _proposalRepository.UpdateAsync(proposal);
        return MapToResponse(updatedProposal);
    }

    public async Task<bool> ExistsAsync(int id)
    {
        return await _proposalRepository.ExistsAsync(id);
    }

    private static ProposalResponse MapToResponse(ServiceProposal proposal)
    {
        return new ProposalResponse
        {
            Id = proposal.Id,
            ServiceId = proposal.ServiceId,
            ContractorId = proposal.ContractorId,
            ContractorName = proposal.Contractor?.Name ?? "Prestador",
            Description = proposal.Description,
            LaborCost = proposal.LaborCost,
            MaterialCost = proposal.MaterialCost,
            TotalCost = proposal.TotalCost,
            EstimatedStartDate = proposal.EstimatedStartDate,
            EstimatedEndDate = proposal.EstimatedEndDate,
            Status = proposal.Status.Name,
            StatusId = proposal.StatusId,
            Notes = proposal.Notes,
            Rating = proposal.Rating,
            EvaluationComment = proposal.EvaluationComment,
            CompletedAt = proposal.CompletedAt,
            CreatedAt = proposal.CreatedAt,
            UpdatedAt = proposal.UpdatedAt,
            Materials = proposal.Materials.Select(m => new ProposalMaterialResponse
            {
                Id = m.Id,
                Name = m.Name,
                Brand = m.Brand,
                Quantity = m.Quantity,
                Unit = m.Unit,
                UnitPrice = m.UnitPrice,
                TotalPrice = m.TotalPrice,
                Notes = m.Notes
            }).ToList()
        };
    }
}
