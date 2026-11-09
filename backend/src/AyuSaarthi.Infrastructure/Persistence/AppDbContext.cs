using AyuSaarthi.Domain.Entities;
using AyuSaarthi.Domain.Repositories;
using Microsoft.EntityFrameworkCore;

namespace AyuSaarthi.Infrastructure.Persistence;

public class AppDbContext(DbContextOptions<AppDbContext> options) : DbContext(options), IUnitOfWork
{
    public DbSet<Facility> Facilities => Set<Facility>();
    public DbSet<Resident> Residents => Set<Resident>();
    public DbSet<NursingUnit> Units => Set<NursingUnit>();
    public DbSet<Room> Rooms => Set<Room>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.ApplyConfigurationsFromAssembly(typeof(AppDbContext).Assembly);
    }
}
