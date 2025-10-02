using Microsoft.EntityFrameworkCore;
using AppEAO.API.Domain.Entities;
using AppEAO.API.Domain.Interfaces;
using AppEAO.API.Infrastructure.Data;

namespace AppEAO.API.Infrastructure.Repositories;

public class ServiceProposalRepository : IServiceProposalRepository
{
    private readonly AppDbContext _context;

    public ServiceProposalRepository(AppDbContext context)
    {
        _context = context;
    }

    public async Task<ServiceProposal?> GetByIdAsync(int id)
    {
        return await _context.ServiceProposals
            .Include(p => p.Service)
            .Include(p => p.Contractor)
            .Include(p => p.Status)
            .Include(p => p.Materials.Where(m => m.IsActive))
            .FirstOrDefaultAsync(p => p.Id == id && p.IsActive);
    }

    public async Task<IEnumerable<ServiceProposal>> GetByServiceIdAsync(int serviceId)
    {
        return await _context.ServiceProposals
            .Include(p => p.Service)
            .Include(p => p.Contractor)
            .Include(p => p.Status)
            .Include(p => p.Materials.Where(m => m.IsActive))
            .Where(p => p.ServiceId == serviceId && p.IsActive)
            .OrderByDescending(p => p.CreatedAt)
            .ToListAsync();
    }

    public async Task<IEnumerable<ServiceProposal>> GetByContractorIdAsync(Guid contractorId)
    {
        return await _context.ServiceProposals
            .Include(p => p.Service)
            .Include(p => p.Contractor)
            .Include(p => p.Status)
            .Include(p => p.Materials.Where(m => m.IsActive))
            .Where(p => p.ContractorId == contractorId && p.IsActive)
            .OrderByDescending(p => p.CreatedAt)
            .ToListAsync();
    }

    public async Task<IEnumerable<ServiceProposal>> GetByStatusAsync(int statusId)
    {
        return await _context.ServiceProposals
            .Include(p => p.Service)
            .Include(p => p.Contractor)
            .Include(p => p.Status)
            .Include(p => p.Materials.Where(m => m.IsActive))
            .Where(p => p.StatusId == statusId && p.IsActive)
            .OrderByDescending(p => p.CreatedAt)
            .ToListAsync();
    }

    public async Task<ServiceProposal> CreateAsync(ServiceProposal proposal)
    {
        _context.ServiceProposals.Add(proposal);
        await _context.SaveChangesAsync();
        
        // Recarregar a proposta com as propriedades de navegação
        return await GetByIdAsync(proposal.Id) ?? proposal;
    }

    public async Task<ServiceProposal> UpdateAsync(ServiceProposal proposal)
    {
        _context.ServiceProposals.Update(proposal);
        await _context.SaveChangesAsync();
        
        // Recarregar a proposta com as propriedades de navegação
        return await GetByIdAsync(proposal.Id) ?? proposal;
    }

    public async Task DeleteAsync(int id)
    {
        var proposal = await _context.ServiceProposals.FindAsync(id);
        if (proposal != null)
        {
            proposal.Deactivate();
            await _context.SaveChangesAsync();
        }
    }

    public async Task<bool> ExistsAsync(int id)
    {
        return await _context.ServiceProposals.AnyAsync(p => p.Id == id && p.IsActive);
    }
}
