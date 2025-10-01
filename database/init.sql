-- Script de inicialização do banco de dados AppEAO
-- Este script será executado após a criação do banco via EF Core Migrations

USE AppEAO;
GO

-- Verificar se o banco foi criado corretamente
PRINT 'Banco de dados AppEAO inicializado com sucesso!';
GO

-- Criar índices adicionais para performance
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Users_CreatedAt')
BEGIN
    CREATE INDEX IX_Users_CreatedAt ON Users(CreatedAt DESC);
    PRINT 'Índice IX_Users_CreatedAt criado com sucesso!';
END
GO

-- View para estatísticas de usuários
IF OBJECT_ID('vw_UserStatistics', 'V') IS NOT NULL
    DROP VIEW vw_UserStatistics;
GO

CREATE VIEW vw_UserStatistics AS
SELECT 
    COUNT(*) as TotalUsers,
    SUM(CASE WHEN IsActive = 1 THEN 1 ELSE 0 END) as ActiveUsers,
    SUM(CASE WHEN IsActive = 0 THEN 1 ELSE 0 END) as InactiveUsers,
    COUNT(CASE WHEN CreatedAt >= DATEADD(day, -7, GETUTCDATE()) THEN 1 END) as NewUsersLastWeek,
    COUNT(CASE WHEN CreatedAt >= DATEADD(day, -30, GETUTCDATE()) THEN 1 END) as NewUsersLastMonth
FROM Users;
GO

PRINT 'View vw_UserStatistics criada com sucesso!';
GO

