using AutoMapper;
using AyuSaarthi.Application.Abstractions.Messaging;
using AyuSaarthi.Domain.Repositories;

namespace AyuSaarthi.Application.Residents.Queries;

public sealed record GetResidentsQuery(int? FacilityId) : IQuery<IReadOnlyList<ResidentDto>>;

internal sealed class GetResidentsQueryHandler(IResidentRepository residents, IMapper mapper)
    : IQueryHandler<GetResidentsQuery, IReadOnlyList<ResidentDto>>
{
    public async Task<IReadOnlyList<ResidentDto>> Handle(GetResidentsQuery query, CancellationToken cancellationToken)
    {
        var items = await residents.ListActiveAsync(query.FacilityId, cancellationToken);
        return mapper.Map<List<ResidentDto>>(items);
    }
}
