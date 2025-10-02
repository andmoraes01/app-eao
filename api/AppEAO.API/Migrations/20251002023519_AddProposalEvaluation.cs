using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace AppEAO.API.Migrations
{
    /// <inheritdoc />
    public partial class AddProposalEvaluation : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<DateTime>(
                name: "CompletedAt",
                table: "ServiceProposals",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "EvaluationComment",
                table: "ServiceProposals",
                type: "nvarchar(1000)",
                maxLength: 1000,
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "Rating",
                table: "ServiceProposals",
                type: "int",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "CompletedAt",
                table: "ServiceProposals");

            migrationBuilder.DropColumn(
                name: "EvaluationComment",
                table: "ServiceProposals");

            migrationBuilder.DropColumn(
                name: "Rating",
                table: "ServiceProposals");
        }
    }
}
