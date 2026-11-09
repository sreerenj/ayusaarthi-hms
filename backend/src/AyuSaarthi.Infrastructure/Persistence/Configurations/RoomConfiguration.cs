using AyuSaarthi.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace AyuSaarthi.Infrastructure.Persistence.Configurations;

internal sealed class RoomConfiguration : IEntityTypeConfiguration<Room>
{
    public void Configure(EntityTypeBuilder<Room> builder)
    {
        builder.ToTable("Rooms");

        builder.HasKey(r => r.Id);
        builder.Property(r => r.Id).HasColumnName("RoomId").ValueGeneratedOnAdd();

        builder.Property(r => r.RoomNumber).HasMaxLength(10).IsRequired();
        builder.Property(r => r.RoomType).HasMaxLength(20).IsRequired();
        builder.Property(r => r.Capacity).HasColumnType("tinyint").HasDefaultValue((byte)1);
        builder.Property(r => r.IsAdaAccessible).HasColumnName("IsADAAccessible").HasDefaultValue(false);
        builder.Property(r => r.IsBariatric).HasDefaultValue(false);
        builder.Property(r => r.IsActive).HasDefaultValue(true);

        builder.HasIndex(r => new { r.UnitId, r.RoomNumber }).IsUnique().HasDatabaseName("UQ_Rooms_Number");
        builder.HasOne<NursingUnit>().WithMany().HasForeignKey(r => r.UnitId).OnDelete(DeleteBehavior.Restrict);
    }
}
