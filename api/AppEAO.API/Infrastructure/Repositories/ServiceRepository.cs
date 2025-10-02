using Microsoft.EntityFrameworkCore;
using AppEAO.API.Domain.Entities;
using AppEAO.API.Domain.Interfaces;
using AppEAO.API.Infrastructure.Data;

namespace AppEAO.API.Infrastructure.Repositories;

public class ServiceRepository : IServiceRepository
{
    private readonly AppDbContext _context;

    public ServiceRepository(AppDbContext context)
    {
        _context = context;
    }

    public async Task<Service?> GetByIdAsync(int id)
    {
        return await _context.Services
            .Include(s => s.User)
            .Include(s => s.Status)
            .Include(s => s.Materials.Where(m => m.IsActive))
            .Include(s => s.Proposals.Where(p => p.IsActive))
            .FirstOrDefaultAsync(s => s.Id == id && s.IsActive);
    }

    public async Task<IEnumerable<Service>> GetAllAsync()
    {
        return await _context.Services
            .Include(s => s.User)
            .Include(s => s.Status)
            .Include(s => s.Materials.Where(m => m.IsActive))
            .Where(s => s.IsActive)
            .OrderByDescending(s => s.CreatedAt)
            .ToListAsync();
    }

    public async Task<IEnumerable<Service>> GetByUserIdAsync(Guid userId)
    {
        return await _context.Services
            .Include(s => s.User)
            .Include(s => s.Status)
            .Include(s => s.Materials.Where(m => m.IsActive))
            .Include(s => s.Proposals.Where(p => p.IsActive))
            .Where(s => s.UserId == userId && s.IsActive)
            .OrderByDescending(s => s.CreatedAt)
            .ToListAsync();
    }

    public async Task<IEnumerable<Service>> GetActiveServicesAsync()
    {
        return await _context.Services
            .Include(s => s.User)
            .Include(s => s.Status)
            .Include(s => s.Materials.Where(m => m.IsActive))
            .Include(s => s.Proposals.Where(p => p.IsActive))
            .Where(s => s.IsActive && s.StatusId == 1) // Active status
            .OrderByDescending(s => s.CreatedAt)
            .ToListAsync();
    }

    public async Task<IEnumerable<Service>> GetByServiceTypeAsync(string serviceType)
    {
        return await _context.Services
            .Include(s => s.User)
            .Include(s => s.Status)
            .Include(s => s.Materials.Where(m => m.IsActive))
            .Include(s => s.Proposals.Where(p => p.IsActive))
            .Where(s => s.ServiceType == serviceType && s.IsActive && s.StatusId == 1) // Active status
            .OrderByDescending(s => s.CreatedAt)
            .ToListAsync();
    }

    public async Task<IEnumerable<Service>> GetByLocationAsync(string location)
    {
        return await _context.Services
            .Include(s => s.User)
            .Include(s => s.Status)
            .Include(s => s.Materials.Where(m => m.IsActive))
            .Include(s => s.Proposals.Where(p => p.IsActive))
            .Where(s => s.Location.Contains(location) && s.IsActive && s.StatusId == 1) // Active status
            .OrderByDescending(s => s.CreatedAt)
            .ToListAsync();
    }

    public async Task<Service> CreateAsync(Service service)
    {
        _context.Services.Add(service);
        await _context.SaveChangesAsync();
        
        // Recarregar o serviço com as propriedades de navegação
        return await GetByIdAsync(service.Id) ?? service;
    }

    public async Task<Service> UpdateAsync(Service service)
    {
        _context.Services.Update(service);
        await _context.SaveChangesAsync();
        
        // Recarregar o serviço com as propriedades de navegação
        return await GetByIdAsync(service.Id) ?? service;
    }

    public async Task DeleteAsync(int id)
    {
        var service = await _context.Services.FindAsync(id);
        if (service != null)
        {
            service.Deactivate();
            await _context.SaveChangesAsync();
        }
    }

    public async Task<bool> ExistsAsync(int id)
    {
        return await _context.Services.AnyAsync(s => s.Id == id && s.IsActive);
    }
}
