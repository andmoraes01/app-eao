using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace AppEAO.API.Migrations
{
    /// <inheritdoc />
    public partial class AddStatusTable : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_Services_Status",
                table: "Services");

            migrationBuilder.DropIndex(
                name: "IX_ServiceProposals_Status",
                table: "ServiceProposals");

            migrationBuilder.DropColumn(
                name: "Status",
                table: "Services");

            migrationBuilder.DropColumn(
                name: "Status",
                table: "ServiceProposals");

            migrationBuilder.AddColumn<int>(
                name: "StatusId",
                table: "Services",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "StatusId",
                table: "ServiceProposals",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.CreateTable(
                name: "Statuses",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Description = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false),
                    Color = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: false),
                    IsActive = table.Column<bool>(type: "bit", nullable: false, defaultValue: true),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    UpdatedAt = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Statuses", x => x.Id);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Services_StatusId",
                table: "Services",
                column: "StatusId");

            migrationBuilder.CreateIndex(
                name: "IX_ServiceProposals_StatusId",
                table: "ServiceProposals",
                column: "StatusId");

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

            migrationBuilder.AddForeignKey(
                name: "FK_ServiceProposals_Statuses_StatusId",
                table: "ServiceProposals",
                column: "StatusId",
                principalTable: "Statuses",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_Services_Statuses_StatusId",
                table: "Services",
                column: "StatusId",
                principalTable: "Statuses",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_ServiceProposals_Statuses_StatusId",
                table: "ServiceProposals");

            migrationBuilder.DropForeignKey(
                name: "FK_Services_Statuses_StatusId",
                table: "Services");

            migrationBuilder.DropTable(
                name: "Statuses");

            migrationBuilder.DropIndex(
                name: "IX_Services_StatusId",
                table: "Services");

            migrationBuilder.DropIndex(
                name: "IX_ServiceProposals_StatusId",
                table: "ServiceProposals");

            migrationBuilder.DropColumn(
                name: "StatusId",
                table: "Services");

            migrationBuilder.DropColumn(
                name: "StatusId",
                table: "ServiceProposals");

            migrationBuilder.AddColumn<string>(
                name: "Status",
                table: "Services",
                type: "nvarchar(20)",
                maxLength: 20,
                nullable: false,
                defaultValue: "Active");

            migrationBuilder.AddColumn<string>(
                name: "Status",
                table: "ServiceProposals",
                type: "nvarchar(20)",
                maxLength: 20,
                nullable: false,
                defaultValue: "Pending");

            migrationBuilder.CreateIndex(
                name: "IX_Services_Status",
                table: "Services",
                column: "Status");

            migrationBuilder.CreateIndex(
                name: "IX_ServiceProposals_Status",
                table: "ServiceProposals",
                column: "Status");
        }
    }
}
