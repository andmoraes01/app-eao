namespace AppEAO.API.Application.DTOs;

/// <summary>
/// DTO para retornar erros estruturados
/// </summary>
public class ErrorResponse
{
    public string Message { get; set; } = string.Empty;
    public string? ErrorCode { get; set; }
    public Dictionary<string, string[]>? Errors { get; set; }
    
    public ErrorResponse(string message)
    {
        Message = message;
    }
    
    public ErrorResponse(string message, string errorCode)
    {
        Message = message;
        ErrorCode = errorCode;
    }
    
    public ErrorResponse()
    {
    }
}

