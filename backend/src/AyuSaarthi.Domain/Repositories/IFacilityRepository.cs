using AyuSaarthi.Domain.Entities;

namespace AyuSaarthi.Domain.Repositories;

public interface IFacilityRepository : IRepository<Facility>
{
    Task<bool> NpiExistsAsync(string npi, CancellationToken cancellationToken = default);
}
