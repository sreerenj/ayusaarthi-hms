using AyuSaarthi.Domain.Entities;
using AyuSaarthi.Domain.Repositories;
using Microsoft.EntityFrameworkCore;

namespace AyuSaarthi.Infrastructure.Persistence.Repositories;

internal sealed class RoomRepository(AppDbContext context) : Repository<Room>(context), IRoomRepository
{
    public async Task<IReadOnlyList<Room>> ListActiveAsync(int? unitId, CancellationToken cancellationToken = default)
    {
        var query = Context.Rooms.AsNoTracking().Where(r => r.IsActive);

        if (unitId is not null)
            query = query.Where(r => r.UnitId == unitId);

        return await query.OrderBy(r => r.UnitId).ThenBy(r => r.RoomNumber).ToListAsync(cancellationToken);
    }

    public Task<bool> RoomNumberExistsAsync(int unitId, string roomNumber, int? excludeRoomId, CancellationToken cancellationToken = default)
        => Context.Rooms.AnyAsync(
            r => r.UnitId == unitId && r.RoomNumber == roomNumber && r.Id != excludeRoomId,
            cancellationToken);
}
