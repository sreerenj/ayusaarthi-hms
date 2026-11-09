using AyuSaarthi.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace AyuSaarthi.Infrastructure.Persistence.Configurations;

internal sealed class UnitConfiguration : IEntityTypeConfiguration<NursingUnit>
{
    public void Configure(EntityTypeBuilder<NursingUnit> builder)
    {
        builder.ToTable("Units");

        builder.HasKey(u => u.Id);
        builder.Property(u => u.Id).HasColumnName("UnitId").ValueGeneratedOnAdd();

        builder.Property(u => u.Name).HasColumnName("UnitName").HasMaxLength(100).IsRequired();
        builder.Property(u => u.UnitType).HasMaxLength(30).IsRequired();
        builder.Property(u => u.IsActive).HasDefaultValue(true);

        builder.HasOne<Facility>().WithMany().HasForeignKey(u => u.FacilityId).OnDelete(DeleteBehavior.Restrict);
    }
}
