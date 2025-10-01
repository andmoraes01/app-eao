using System.Text;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using AppEAO.API.Infrastructure.Data;
using AppEAO.API.Application.Interfaces;
using AppEAO.API.Application.Services;
using AppEAO.API.Domain.Interfaces;
using AppEAO.API.Infrastructure.Repositories;

var builder = WebApplication.CreateBuilder(args);

// Configurar DbContext com SQL Server (Banco de Autenticação)
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("AuthConnection")));

// Configurar autenticação JWT
var jwtSettings = builder.Configuration.GetSection("JwtSettings");
var secretKey = jwtSettings["SecretKey"] ?? throw new InvalidOperationException("JWT SecretKey não configurada");

builder.Services.AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
})
.AddJwtBearer(options =>
{
    options.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuer = true,
        ValidateAudience = true,
        ValidateLifetime = true,
        ValidateIssuerSigningKey = true,
        ValidIssuer = jwtSettings["Issuer"],
        ValidAudience = jwtSettings["Audience"],
        IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(secretKey)),
        ClockSkew = TimeSpan.Zero
    };
});

builder.Services.AddAuthorization();

// Registrar dependências - Repositories (Infrastructure)
builder.Services.AddScoped<IUserRepository, UserRepository>();

// Registrar dependências - Services (Application)
builder.Services.AddScoped<IAuthService, AuthService>();

// Configurar CORS
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
    {
        policy.AllowAnyOrigin()
              .AllowAnyMethod()
              .AllowAnyHeader();
    });
});

// Adicionar controllers
builder.Services.AddControllers();

// Configurar Swagger
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo
    {
        Title = "AppEAO API",
        Version = "v1",
        Description = "API de autenticação para o aplicativo AppEAO"
    });

    // Configurar autenticação JWT no Swagger
    c.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
    {
        Description = "JWT Authorization header usando o esquema Bearer. Exemplo: \"Authorization: Bearer {token}\"",
        Name = "Authorization",
        In = ParameterLocation.Header,
        Type = SecuritySchemeType.ApiKey,
        Scheme = "Bearer"
    });

    c.AddSecurityRequirement(new OpenApiSecurityRequirement
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference
                {
                    Type = ReferenceType.SecurityScheme,
                    Id = "Bearer"
                }
            },
            Array.Empty<string>()
        }
    });
});

var app = builder.Build();

// Configurar pipeline HTTP - ORDEM É IMPORTANTE!

// 1. CORS deve vir primeiro (antes de qualquer redirecionamento)
app.UseCors("AllowAll");

// 2. Swagger (disponível em desenvolvimento)
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI(c =>
    {
        c.SwaggerEndpoint("/swagger/v1/swagger.json", "AppEAO API v1");
        c.RoutePrefix = "swagger";
    });
}

// 3. HTTPS Redirection
app.UseHttpsRedirection();

// 4. Authentication e Authorization
app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

// Endpoint de health check
app.MapGet("/health", () => Results.Ok(new { status = "healthy", timestamp = DateTime.UtcNow }))
    .WithName("HealthCheck")
    .WithOpenApi();

// Abrir navegador automaticamente em desenvolvimento
if (app.Environment.IsDevelopment())
{
    app.Lifetime.ApplicationStarted.Register(() =>
    {
        var urls = app.Urls;
        var httpsUrl = urls.FirstOrDefault(u => u.StartsWith("https")) ?? urls.FirstOrDefault();
        
        if (httpsUrl != null)
        {
            // Abrir Swagger
            var swaggerUrl = $"{httpsUrl}/swagger";
            OpenBrowser(swaggerUrl);
            
            // Abrir Health Check (aguardar 1 segundo para não conflitar)
            Task.Delay(1000).ContinueWith(_ =>
            {
                var healthUrl = $"{httpsUrl}/health";
                OpenBrowser(healthUrl);
            });
        }
    });
}

app.Run();

// Método auxiliar para abrir o navegador
static void OpenBrowser(string url)
{
    try
    {
        System.Diagnostics.Process.Start(new System.Diagnostics.ProcessStartInfo
        {
            FileName = url,
            UseShellExecute = true
        });
    }
    catch (Exception ex)
    {
        Console.WriteLine($"Não foi possível abrir o navegador: {ex.Message}");
        Console.WriteLine($"Acesse manualmente: {url}");
    }
}
