using AyuSaarthi.Application.Abstractions.Messaging;
using AyuSaarthi.Application.Common;
using AyuSaarthi.Domain.Entities;
using AyuSaarthi.Domain.Repositories;

namespace AyuSaarthi.Application.Facilities.Queries;

public sealed record GetFacilityByIdQuery(int Id) : IQuery<FacilityDto>;

internal sealed class GetFacilityByIdQueryHandler(IFacilityRepository facilities)
    : IQueryHandler<GetFacilityByIdQuery, FacilityDto>
{
    public async Task<FacilityDto> Handle(GetFacilityByIdQuery query, CancellationToken cancellationToken)
    {
        var facility = await facilities.GetByIdAsync(query.Id, cancellationToken)
            ?? throw new NotFoundException(nameof(Facility), query.Id);

        return FacilityDto.From(facility);
    }
}
