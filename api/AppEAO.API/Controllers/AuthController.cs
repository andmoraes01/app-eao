using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using AppEAO.API.Application.DTOs;
using AppEAO.API.Application.Interfaces;
using System.Security.Claims;

namespace AppEAO.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class AuthController : ControllerBase
{
    private readonly IAuthService _authService;
    private readonly ILogger<AuthController> _logger;

    public AuthController(IAuthService authService, ILogger<AuthController> logger)
    {
        _authService = authService;
        _logger = logger;
    }

    /// <summary>
    /// Registra um novo usuário
    /// </summary>
    [HttpPost("register")]
    [ProducesResponseType(typeof(AuthResponse), StatusCodes.Status201Created)]
    [ProducesResponseType(typeof(ErrorResponse), StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> Register([FromBody] RegisterRequest request)
    {
        if (!ModelState.IsValid)
        {
            var errors = ModelState
                .Where(x => x.Value?.Errors.Count > 0)
                .ToDictionary(
                    x => x.Key,
                    x => x.Value!.Errors.Select(e => e.ErrorMessage).ToArray()
                );
            
            return BadRequest(new ErrorResponse("Dados inválidos") { Errors = errors });
        }

        var result = await _authService.RegisterAsync(request);

        if (result == null)
        {
            // Verificar se email já existe
            if (await _authService.EmailExistsAsync(request.Email))
            {
                return BadRequest(new ErrorResponse("Email já cadastrado", "EMAIL_EXISTS"));
            }
            
            return BadRequest(new ErrorResponse("Erro ao processar registro", "REGISTRATION_ERROR"));
        }

        return CreatedAtAction(nameof(GetProfile), new { id = result.UserId }, result);
    }

    /// <summary>
    /// Realiza login do usuário
    /// </summary>
    [HttpPost("login")]
    [ProducesResponseType(typeof(AuthResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<IActionResult> Login([FromBody] LoginRequest request)
    {
        if (!ModelState.IsValid)
            return BadRequest(ModelState);

        var result = await _authService.LoginAsync(request);

        if (result == null)
            return Unauthorized(new { message = "Email ou senha inválidos" });

        return Ok(result);
    }

    /// <summary>
    /// Obtém o perfil do usuário autenticado
    /// </summary>
    [HttpGet("profile")]
    [Authorize]
    [ProducesResponseType(typeof(UserResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GetProfile()
    {
        var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
        
        if (string.IsNullOrEmpty(userIdClaim) || !Guid.TryParse(userIdClaim, out var userId))
            return Unauthorized();

        var user = await _authService.GetUserByIdAsync(userId);

        if (user == null)
            return NotFound(new { message = "Usuário não encontrado" });

        return Ok(user);
    }

    /// <summary>
    /// Verifica se o token é válido
    /// </summary>
    [HttpGet("verify")]
    [Authorize]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public IActionResult VerifyToken()
    {
        return Ok(new { message = "Token válido", isValid = true });
    }
}

