using AyuSaarthi.Domain.Entities;

namespace AyuSaarthi.Domain.Repositories;

public interface IResidentRepository : IRepository<Resident>
{
    Task<IReadOnlyList<Resident>> ListActiveAsync(int? facilityId, CancellationToken cancellationToken = default);
}
