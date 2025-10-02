using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace AppEAO.API.Migrations
{
    /// <inheritdoc />
    public partial class AddStatusTableManual : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            // Inserir os status iniciais
            migrationBuilder.Sql(@"
                INSERT INTO Statuses (Name, Description, Color, IsActive, CreatedAt, UpdatedAt) VALUES
                ('Active', 'Ativo - Aceitando propostas', '#28a745', 1, GETUTCDATE(), GETUTCDATE()),
                ('InProgress', 'Em execução - Proposta aceita', '#ffc107', 1, GETUTCDATE(), GETUTCDATE()),
                ('Completed', 'Concluído - Serviço finalizado', '#6c757d', 1, GETUTCDATE(), GETUTCDATE()),
                ('Cancelled', 'Cancelado - Serviço cancelado', '#dc3545', 1, GETUTCDATE(), GETUTCDATE()),
                ('Pending', 'Pendente - Aguardando aprovação', '#17a2b8', 1, GETUTCDATE(), GETUTCDATE()),
                ('Accepted', 'Aceita - Proposta aceita', '#28a745', 1, GETUTCDATE(), GETUTCDATE()),
                ('Rejected', 'Rejeitada - Proposta rejeitada', '#dc3545', 1, GETUTCDATE(), GETUTCDATE())
            ");

            // Atualizar Services existentes para StatusId = 1 (Active)
            migrationBuilder.Sql("UPDATE Services SET StatusId = 1 WHERE StatusId = 0");

            // Atualizar ServiceProposals existentes para StatusId = 5 (Pending)
            migrationBuilder.Sql("UPDATE ServiceProposals SET StatusId = 5 WHERE StatusId = 0");

            // Agora criar as foreign keys
            migrationBuilder.AddForeignKey(
                name: "FK_Services_Statuses_StatusId",
                table: "Services",
                column: "StatusId",
                principalTable: "Statuses",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_ServiceProposals_Statuses_StatusId",
                table: "ServiceProposals",
                column: "StatusId",
                principalTable: "Statuses",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            // Remover as foreign keys
            migrationBuilder.DropForeignKey(
                name: "FK_ServiceProposals_Statuses_StatusId",
                table: "ServiceProposals");

            migrationBuilder.DropForeignKey(
                name: "FK_Services_Statuses_StatusId",
                table: "Services");

            // Limpar os dados da tabela Statuses
            migrationBuilder.Sql("DELETE FROM Statuses");
        }
    }
}
