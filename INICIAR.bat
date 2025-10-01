@echo off
echo ====================================
echo      AppEAO - Inicializar
echo ====================================
echo.

cd /d "%~dp0"

echo Escolha o que deseja iniciar:
echo.
echo 1 - API (Backend)
echo 2 - Mobile (Flutter no Chrome)
echo 3 - Ambos (API + Mobile)
echo 4 - Ver status do SQL Server
echo 5 - Parar todos os servicos
echo.

set /p opcao="Digite sua opcao (1-5): "

if "%opcao%"=="1" goto api
if "%opcao%"=="2" goto mobile
if "%opcao%"=="3" goto both
if "%opcao%"=="4" goto status
if "%opcao%"=="5" goto stop

echo Opcao invalida!
pause
exit /b 1

:api
echo.
echo Iniciando API...
cd api\AppEAO.API
start "AppEAO API" dotnet run
echo.
echo API iniciando... Acesse: https://localhost:7001/swagger
echo.
pause
exit /b 0

:mobile
echo.
echo Iniciando Mobile (Flutter)...
cd mobile
start "AppEAO Mobile" flutter run -d chrome
echo.
echo Mobile iniciando...
echo.
pause
exit /b 0

:both
echo.
echo Iniciando API...
cd api\AppEAO.API
start "AppEAO API" dotnet run
cd ..\..

timeout /t 5 /nobreak >nul

echo Iniciando Mobile...
cd mobile
start "AppEAO Mobile" flutter run -d chrome
cd ..

echo.
echo API e Mobile iniciando...
echo API: https://localhost:7001/swagger
echo.
pause
exit /b 0

:status
echo.
echo Status dos servicos:
echo.
docker ps --filter "name=appeao-sqlserver"
echo.
echo Logs recentes do SQL Server:
docker logs appeao-sqlserver --tail 20
echo.
pause
exit /b 0

:stop
echo.
echo Parando servicos...
docker-compose down
echo.
echo Servicos parados!
echo.
pause
exit /b 0
