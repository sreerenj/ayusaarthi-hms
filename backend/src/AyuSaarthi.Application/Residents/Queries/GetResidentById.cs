using AutoMapper;
using AyuSaarthi.Application.Abstractions.Messaging;
using AyuSaarthi.Application.Common;
using AyuSaarthi.Domain.Entities;
using AyuSaarthi.Domain.Repositories;

namespace AyuSaarthi.Application.Residents.Queries;

public sealed record GetResidentByIdQuery(int Id) : IQuery<ResidentDto>;

internal sealed class GetResidentByIdQueryHandler(IResidentRepository residents, IMapper mapper)
    : IQueryHandler<GetResidentByIdQuery, ResidentDto>
{
    public async Task<ResidentDto> Handle(GetResidentByIdQuery query, CancellationToken cancellationToken)
    {
        var resident = await residents.GetByIdAsync(query.Id, cancellationToken);
        if (resident is not { IsActive: true })
            throw new NotFoundException(nameof(Resident), query.Id);

        return mapper.Map<ResidentDto>(resident);
    }
}
