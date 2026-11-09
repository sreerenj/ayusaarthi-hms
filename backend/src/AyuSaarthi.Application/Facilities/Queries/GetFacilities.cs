using AyuSaarthi.Application.Abstractions.Messaging;
using AyuSaarthi.Domain.Repositories;

namespace AyuSaarthi.Application.Facilities.Queries;

public sealed record GetFacilitiesQuery : IQuery<IReadOnlyList<FacilityDto>>;

internal sealed class GetFacilitiesQueryHandler(IFacilityRepository facilities)
    : IQueryHandler<GetFacilitiesQuery, IReadOnlyList<FacilityDto>>
{
    public async Task<IReadOnlyList<FacilityDto>> Handle(GetFacilitiesQuery query, CancellationToken cancellationToken)
    {
        var items = await facilities.ListAsync(cancellationToken);
        return items.Select(FacilityDto.From).ToList();
    }
}
