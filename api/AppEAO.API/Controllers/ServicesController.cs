using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using System.Security.Claims;
using AppEAO.API.Application.DTOs;
using AppEAO.API.Application.Interfaces;

namespace AppEAO.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class ServicesController : ControllerBase
{
    private readonly IServiceService _serviceService;

    public ServicesController(IServiceService serviceService)
    {
        _serviceService = serviceService;
    }

    /// <summary>
    /// Lista todos os serviços ativos
    /// </summary>
    [HttpGet]
    public async Task<ActionResult<IEnumerable<ServiceResponse>>> GetActiveServices()
    {
        try
        {
            var services = await _serviceService.GetActiveServicesAsync();
            return Ok(services);
        }
        catch (Exception ex)
        {
            return StatusCode(500, new ErrorResponse
            {
                Message = "Erro interno do servidor",
                ErrorCode = "INTERNAL_ERROR",
                Errors = new Dictionary<string, string[]> { { "Server", new[] { ex.Message } } }
            });
        }
    }

    /// <summary>
    /// Lista serviços por tipo
    /// </summary>
    [HttpGet("type/{serviceType}")]
    public async Task<ActionResult<IEnumerable<ServiceResponse>>> GetByServiceType(string serviceType)
    {
        try
        {
            var services = await _serviceService.GetByServiceTypeAsync(serviceType);
            return Ok(services);
        }
        catch (Exception ex)
        {
            return StatusCode(500, new ErrorResponse
            {
                Message = "Erro interno do servidor",
                ErrorCode = "INTERNAL_ERROR",
                Errors = new Dictionary<string, string[]> { { "Server", new[] { ex.Message } } }
            });
        }
    }

    /// <summary>
    /// Lista serviços por localização
    /// </summary>
    [HttpGet("location/{location}")]
    public async Task<ActionResult<IEnumerable<ServiceResponse>>> GetByLocation(string location)
    {
        try
        {
            var services = await _serviceService.GetByLocationAsync(location);
            return Ok(services);
        }
        catch (Exception ex)
        {
            return StatusCode(500, new ErrorResponse
            {
                Message = "Erro interno do servidor",
                ErrorCode = "INTERNAL_ERROR",
                Errors = new Dictionary<string, string[]> { { "Server", new[] { ex.Message } } }
            });
        }
    }

    /// <summary>
    /// Obtém um serviço por ID
    /// </summary>
    [HttpGet("{id}")]
    public async Task<ActionResult<ServiceResponse>> GetById(int id)
    {
        try
        {
            var service = await _serviceService.GetByIdAsync(id);
            if (service == null)
                return NotFound(new ErrorResponse
                {
                    Message = "Serviço não encontrado",
                    ErrorCode = "SERVICE_NOT_FOUND"
                });

            return Ok(service);
        }
        catch (Exception ex)
        {
            return StatusCode(500, new ErrorResponse
            {
                Message = "Erro interno do servidor",
                ErrorCode = "INTERNAL_ERROR",
                Errors = new Dictionary<string, string[]> { { "Server", new[] { ex.Message } } }
            });
        }
    }

    /// <summary>
    /// Lista serviços do usuário logado
    /// </summary>
    [HttpGet("my-services")]
    public async Task<ActionResult<IEnumerable<ServiceResponse>>> GetMyServices()
    {
        try
        {
            var userId = GetCurrentUserId();
            var services = await _serviceService.GetByUserIdAsync(userId);
            return Ok(services);
        }
        catch (Exception ex)
        {
            return StatusCode(500, new ErrorResponse
            {
                Message = "Erro interno do servidor",
                ErrorCode = "INTERNAL_ERROR",
                Errors = new Dictionary<string, string[]> { { "Server", new[] { ex.Message } } }
            });
        }
    }

    /// <summary>
    /// Cria um novo serviço
    /// </summary>
    [HttpPost]
    public async Task<ActionResult<ServiceResponse>> CreateService([FromBody] CreateServiceRequest request)
    {
        try
        {
            if (!ModelState.IsValid)
            {
                var errors = ModelState
                    .Where(x => x.Value?.Errors.Count > 0)
                    .ToDictionary(
                        kvp => kvp.Key,
                        kvp => kvp.Value?.Errors.Select(e => e.ErrorMessage).ToArray() ?? new string[0]
                    );

                return BadRequest(new ErrorResponse
                {
                    Message = "Dados inválidos",
                    ErrorCode = "VALIDATION_ERROR",
                    Errors = errors
                });
            }

            var userId = GetCurrentUserId();
            var service = await _serviceService.CreateAsync(request, userId);
            return CreatedAtAction(nameof(GetById), new { id = service.Id }, service);
        }
        catch (ArgumentException ex)
        {
            return BadRequest(new ErrorResponse
            {
                Message = ex.Message,
                ErrorCode = "INVALID_REQUEST"
            });
        }
        catch (Exception ex)
        {
            return StatusCode(500, new ErrorResponse
            {
                Message = "Erro interno do servidor",
                ErrorCode = "INTERNAL_ERROR",
                Errors = new Dictionary<string, string[]> { { "Server", new[] { ex.Message } } }
            });
        }
    }

    /// <summary>
    /// Atualiza um serviço
    /// </summary>
    [HttpPut("{id}")]
    public async Task<ActionResult<ServiceResponse>> UpdateService(int id, [FromBody] CreateServiceRequest request)
    {
        try
        {
            if (!ModelState.IsValid)
            {
                var errors = ModelState
                    .Where(x => x.Value?.Errors.Count > 0)
                    .ToDictionary(
                        kvp => kvp.Key,
                        kvp => kvp.Value?.Errors.Select(e => e.ErrorMessage).ToArray() ?? new string[0]
                    );

                return BadRequest(new ErrorResponse
                {
                    Message = "Dados inválidos",
                    ErrorCode = "VALIDATION_ERROR",
                    Errors = errors
                });
            }

            var userId = GetCurrentUserId();
            var service = await _serviceService.UpdateAsync(id, request, userId);
            return Ok(service);
        }
        catch (ArgumentException ex)
        {
            return BadRequest(new ErrorResponse
            {
                Message = ex.Message,
                ErrorCode = "INVALID_REQUEST"
            });
        }
        catch (UnauthorizedAccessException ex)
        {
            return Forbid();
        }
        catch (Exception ex)
        {
            return StatusCode(500, new ErrorResponse
            {
                Message = "Erro interno do servidor",
                ErrorCode = "INTERNAL_ERROR",
                Errors = new Dictionary<string, string[]> { { "Server", new[] { ex.Message } } }
            });
        }
    }

    /// <summary>
    /// Exclui um serviço
    /// </summary>
    [HttpDelete("{id}")]
    public async Task<ActionResult> DeleteService(int id)
    {
        try
        {
            var userId = GetCurrentUserId();
            await _serviceService.DeleteAsync(id, userId);
            return NoContent();
        }
        catch (ArgumentException ex)
        {
            return NotFound(new ErrorResponse
            {
                Message = ex.Message,
                ErrorCode = "SERVICE_NOT_FOUND"
            });
        }
        catch (UnauthorizedAccessException ex)
        {
            return Forbid();
        }
        catch (Exception ex)
        {
            return StatusCode(500, new ErrorResponse
            {
                Message = "Erro interno do servidor",
                ErrorCode = "INTERNAL_ERROR",
                Errors = new Dictionary<string, string[]> { { "Server", new[] { ex.Message } } }
            });
        }
    }

    private Guid GetCurrentUserId()
    {
        var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
        if (string.IsNullOrEmpty(userIdClaim) || !Guid.TryParse(userIdClaim, out var userId))
        {
            throw new UnauthorizedAccessException("Usuário não autenticado");
        }
        return userId;
    }
}
