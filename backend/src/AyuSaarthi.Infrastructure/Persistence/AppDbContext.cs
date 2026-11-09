using AyuSaarthi.Domain.Entities;
using AyuSaarthi.Domain.Repositories;
using Microsoft.EntityFrameworkCore;

namespace AyuSaarthi.Infrastructure.Persistence;

public class AppDbContext(DbContextOptions<AppDbContext> options) : DbContext(options), IUnitOfWork
{
    public DbSet<Facility> Facilities => Set<Facility>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.ApplyConfigurationsFromAssembly(typeof(AppDbContext).Assembly);
    }
}
