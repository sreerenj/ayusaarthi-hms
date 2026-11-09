using AyuSaarthi.Domain.Entities;
using AyuSaarthi.Domain.Repositories;
using Microsoft.EntityFrameworkCore;

namespace AyuSaarthi.Infrastructure.Persistence.Repositories;

internal sealed class FacilityRepository(AppDbContext context) : Repository<Facility>(context), IFacilityRepository
{
    public Task<bool> NpiExistsAsync(string npi, CancellationToken cancellationToken = default)
        => Context.Facilities.AnyAsync(f => f.Npi == npi, cancellationToken);
}
