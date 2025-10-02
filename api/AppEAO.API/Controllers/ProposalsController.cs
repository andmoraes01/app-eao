using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using System.Security.Claims;
using AppEAO.API.Application.DTOs;
using AppEAO.API.Application.Interfaces;

namespace AppEAO.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class ProposalsController : ControllerBase
{
    private readonly IServiceProposalService _proposalService;

    public ProposalsController(IServiceProposalService proposalService)
    {
        _proposalService = proposalService;
    }

    /// <summary>
    /// Lista propostas por serviço
    /// </summary>
    [HttpGet("service/{serviceId}")]
    public async Task<ActionResult<IEnumerable<ProposalResponse>>> GetByServiceId(int serviceId)
    {
        try
        {
            var proposals = await _proposalService.GetByServiceIdAsync(serviceId);
            return Ok(proposals);
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
    /// Lista propostas do usuário logado (como prestador)
    /// </summary>
    [HttpGet("my-proposals")]
    public async Task<ActionResult<IEnumerable<ProposalResponse>>> GetMyProposals()
    {
        try
        {
            var contractorId = GetCurrentUserId();
            var proposals = await _proposalService.GetByContractorIdAsync(contractorId);
            return Ok(proposals);
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
    /// Lista propostas por status
    /// </summary>
    [HttpGet("status/{statusId}")]
    public async Task<ActionResult<IEnumerable<ProposalResponse>>> GetByStatus(int statusId)
    {
        try
        {
            var proposals = await _proposalService.GetByStatusAsync(statusId);
            return Ok(proposals);
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
    /// Obtém uma proposta por ID
    /// </summary>
    [HttpGet("{id}")]
    public async Task<ActionResult<ProposalResponse>> GetById(int id)
    {
        try
        {
            var proposal = await _proposalService.GetByIdAsync(id);
            if (proposal == null)
                return NotFound(new ErrorResponse
                {
                    Message = "Proposta não encontrada",
                    ErrorCode = "PROPOSAL_NOT_FOUND"
                });

            return Ok(proposal);
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
    /// Cria uma nova proposta
    /// </summary>
    [HttpPost("service/{serviceId}")]
    public async Task<ActionResult<ProposalResponse>> CreateProposal(int serviceId, [FromBody] CreateProposalRequest request)
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

            var contractorId = GetCurrentUserId();
            var proposal = await _proposalService.CreateAsync(request, serviceId, contractorId);
            return CreatedAtAction(nameof(GetById), new { id = proposal.Id }, proposal);
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
    /// Atualiza uma proposta
    /// </summary>
    [HttpPut("{id}")]
    public async Task<ActionResult<ProposalResponse>> UpdateProposal(int id, [FromBody] CreateProposalRequest request)
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

            var contractorId = GetCurrentUserId();
            var proposal = await _proposalService.UpdateAsync(id, request, contractorId);
            return Ok(proposal);
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
        catch (InvalidOperationException ex)
        {
            return BadRequest(new ErrorResponse
            {
                Message = ex.Message,
                ErrorCode = "INVALID_OPERATION"
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
    /// Exclui uma proposta
    /// </summary>
    [HttpDelete("{id}")]
    public async Task<ActionResult> DeleteProposal(int id)
    {
        try
        {
            var contractorId = GetCurrentUserId();
            await _proposalService.DeleteAsync(id, contractorId);
            return NoContent();
        }
        catch (ArgumentException ex)
        {
            return NotFound(new ErrorResponse
            {
                Message = ex.Message,
                ErrorCode = "PROPOSAL_NOT_FOUND"
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
    /// Aceita uma proposta
    /// </summary>
    [HttpPost("{id}/accept")]
    public async Task<ActionResult<ProposalResponse>> AcceptProposal(int id)
    {
        try
        {
            var serviceOwnerId = GetCurrentUserId();
            var proposal = await _proposalService.AcceptAsync(id, serviceOwnerId);
            return Ok(proposal);
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
        catch (InvalidOperationException ex)
        {
            return BadRequest(new ErrorResponse
            {
                Message = ex.Message,
                ErrorCode = "INVALID_OPERATION"
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
    /// Rejeita uma proposta
    /// </summary>
    [HttpPost("{id}/reject")]
    public async Task<ActionResult<ProposalResponse>> RejectProposal(int id)
    {
        try
        {
            var serviceOwnerId = GetCurrentUserId();
            var proposal = await _proposalService.RejectAsync(id, serviceOwnerId);
            return Ok(proposal);
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
        catch (InvalidOperationException ex)
        {
            return BadRequest(new ErrorResponse
            {
                Message = ex.Message,
                ErrorCode = "INVALID_OPERATION"
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
    /// Conclui uma proposta aceita
    /// </summary>
    [HttpPost("{id}/complete")]
    public async Task<ActionResult<ProposalResponse>> CompleteProposal(int id)
    {
        try
        {
            var serviceOwnerId = GetCurrentUserId();
            var proposal = await _proposalService.CompleteAsync(id, serviceOwnerId);
            return Ok(proposal);
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
        catch (InvalidOperationException ex)
        {
            return BadRequest(new ErrorResponse
            {
                Message = ex.Message,
                ErrorCode = "INVALID_OPERATION"
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
    /// Avalia uma proposta concluída
    /// </summary>
    [HttpPost("{id}/evaluate")]
    public async Task<ActionResult<ProposalResponse>> EvaluateProposal(int id, [FromBody] EvaluateProposalRequest request)
    {
        try
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(new ErrorResponse
                {
                    Message = "Dados inválidos",
                    ErrorCode = "VALIDATION_ERROR",
                    Errors = ModelState.ToDictionary(
                        kvp => kvp.Key,
                        kvp => kvp.Value?.Errors.Select(e => e.ErrorMessage).ToArray() ?? new string[0]
                    )
                });
            }

            var serviceOwnerId = GetCurrentUserId();
            var proposal = await _proposalService.EvaluateAsync(id, request, serviceOwnerId);
            return Ok(proposal);
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
        catch (InvalidOperationException ex)
        {
            return BadRequest(new ErrorResponse
            {
                Message = ex.Message,
                ErrorCode = "INVALID_OPERATION"
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
