using AyuSaarthi.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace AyuSaarthi.Infrastructure.Persistence.Configurations;

internal sealed class FacilityConfiguration : IEntityTypeConfiguration<Facility>
{
    public void Configure(EntityTypeBuilder<Facility> builder)
    {
        builder.ToTable("Facilities");

        builder.HasKey(f => f.Id);
        builder.Property(f => f.Id).HasColumnName("FacilityId").ValueGeneratedOnAdd();

        builder.Property(f => f.Name).HasColumnName("FacilityName").HasMaxLength(150).IsRequired();
        builder.Property(f => f.AddressLine1).HasMaxLength(200).IsRequired();
        builder.Property(f => f.AddressLine2).HasMaxLength(200);
        builder.Property(f => f.City).HasMaxLength(100).IsRequired();
        builder.Property(f => f.StateCode).HasColumnType("char(2)").IsRequired();
        builder.Property(f => f.ZipCode).HasMaxLength(10).IsRequired();
        builder.Property(f => f.PhoneNumber).HasMaxLength(20);
        builder.Property(f => f.LicenseNumber).HasMaxLength(50);
        builder.Property(f => f.MedicareProvNum).HasMaxLength(20);
        builder.Property(f => f.MedicaidProvNum).HasMaxLength(20);
        builder.Property(f => f.Npi).HasColumnName("NPI").HasMaxLength(10);
        builder.Property(f => f.IsActive).HasDefaultValue(true);
        builder.Property(f => f.CreatedAt).HasColumnType("datetime2").HasDefaultValueSql("SYSUTCDATETIME()");

        builder.HasIndex(f => f.Npi).IsUnique().HasDatabaseName("UQ_Facilities_NPI");
    }
}
