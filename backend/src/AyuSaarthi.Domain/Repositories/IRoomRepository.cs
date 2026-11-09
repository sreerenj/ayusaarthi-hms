using AyuSaarthi.Domain.Entities;

namespace AyuSaarthi.Domain.Repositories;

public interface IRoomRepository : IRepository<Room>
{
    Task<IReadOnlyList<Room>> ListActiveAsync(int? unitId, CancellationToken cancellationToken = default);

    // Includes inactive rooms because the (UnitId, RoomNumber) unique constraint does too.
    Task<bool> RoomNumberExistsAsync(int unitId, string roomNumber, int? excludeRoomId, CancellationToken cancellationToken = default);
}
