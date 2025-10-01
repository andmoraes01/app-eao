@echo off
echo ====================================
echo   AppEAO - Setup Inicial
echo ====================================
echo.

cd /d "%~dp0"

echo [1/5] Verificando Docker...
docker --version >nul 2>&1
if errorlevel 1 (
    echo.
    echo ERRO: Docker nao encontrado!
    echo Por favor, instale o Docker Desktop: https://www.docker.com/products/docker-desktop/
    pause
    exit /b 1
)
echo    OK: Docker instalado!

echo.
echo [2/6] Iniciando SQL Servers no Docker...
docker-compose up -d
if errorlevel 1 (
    echo ERRO: Falha ao iniciar SQL Servers
    pause
    exit /b 1
)
echo    OK: SQL Servers iniciados!

echo.
echo [3/6] Aguardando SQL Servers estarem prontos (20 segundos)...
timeout /t 20 /nobreak >nul
echo    OK: SQL Servers devem estar prontos!

echo.
echo [4/6] Criando banco AppEAO_Data...
docker exec appeao-sqlserver-data /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "YourStrong@Passw0rd" -C -Q "IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'AppEAO_Data') CREATE DATABASE AppEAO_Data" >nul 2>&1
echo    OK: Banco AppEAO_Data criado!

echo.
echo [5/6] Configurando API .NET...
cd api\AppEAO.API
dotnet restore
if errorlevel 1 (
    echo ERRO: Falha ao restaurar pacotes .NET
    cd ..\..
    pause
    exit /b 1
)
echo    OK: Pacotes restaurados!

echo.
echo [6/6] Aplicando migrations (criando banco Auth)...
dotnet ef database update
if errorlevel 1 (
    echo ERRO: Falha ao criar banco de dados
    echo Verifique se o SQL Server esta rodando: docker ps
    cd ..\..
    pause
    exit /b 1
)
echo    OK: Banco de dados criado!

cd ..\..

echo.
echo ====================================
echo   Setup concluido com sucesso!
echo ====================================
echo.
echo Proximo passo: Execute INICIAR.bat
echo.
pause
