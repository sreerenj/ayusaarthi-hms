using AyuSaarthi.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace AyuSaarthi.Infrastructure.Persistence.Configurations;

internal sealed class ResidentConfiguration : IEntityTypeConfiguration<Resident>
{
    public void Configure(EntityTypeBuilder<Resident> builder)
    {
        builder.ToTable("Residents");

        builder.HasKey(r => r.Id);
        builder.Property(r => r.Id).HasColumnName("ResidentId").ValueGeneratedOnAdd();

        builder.Property(r => r.FirstName).HasMaxLength(100).IsRequired();
        builder.Property(r => r.MiddleName).HasMaxLength(100);
        builder.Property(r => r.LastName).HasMaxLength(100).IsRequired();
        builder.Property(r => r.PreferredName).HasMaxLength(100);
        builder.Property(r => r.DateOfBirth).HasColumnType("date");
        builder.Property(r => r.Gender).HasMaxLength(20).IsRequired();
        builder.Property(r => r.MaritalStatus).HasMaxLength(20);
        builder.Property(r => r.PrimaryLanguage).HasMaxLength(50).IsRequired();
        builder.Property(r => r.Religion).HasMaxLength(50);
        builder.Property(r => r.NationalOrigin).HasMaxLength(50);
        builder.Property(r => r.IsActive).HasDefaultValue(true);
        builder.Property(r => r.CreatedAt).HasColumnType("datetime2").HasDefaultValueSql("SYSUTCDATETIME()");

        builder.HasOne<Facility>().WithMany().HasForeignKey(r => r.FacilityId).OnDelete(DeleteBehavior.Restrict);
    }
}
