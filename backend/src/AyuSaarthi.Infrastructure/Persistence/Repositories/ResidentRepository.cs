using AyuSaarthi.Domain.Entities;
using AyuSaarthi.Domain.Repositories;
using Microsoft.EntityFrameworkCore;

namespace AyuSaarthi.Infrastructure.Persistence.Repositories;

internal sealed class ResidentRepository(AppDbContext context) : Repository<Resident>(context), IResidentRepository
{
    public async Task<IReadOnlyList<Resident>> ListActiveAsync(int? facilityId, CancellationToken cancellationToken = default)
    {
        var query = Context.Residents.AsNoTracking().Where(r => r.IsActive);

        if (facilityId is not null)
            query = query.Where(r => r.FacilityId == facilityId);

        return await query.OrderBy(r => r.LastName).ThenBy(r => r.FirstName).ToListAsync(cancellationToken);
    }
}
