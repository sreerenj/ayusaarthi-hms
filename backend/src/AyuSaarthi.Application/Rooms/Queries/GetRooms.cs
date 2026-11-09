using AutoMapper;
using AyuSaarthi.Application.Abstractions.Messaging;
using AyuSaarthi.Domain.Repositories;

namespace AyuSaarthi.Application.Rooms.Queries;

public sealed record GetRoomsQuery(int? UnitId) : IQuery<IReadOnlyList<RoomDto>>;

internal sealed class GetRoomsQueryHandler(IRoomRepository rooms, IMapper mapper)
    : IQueryHandler<GetRoomsQuery, IReadOnlyList<RoomDto>>
{
    public async Task<IReadOnlyList<RoomDto>> Handle(GetRoomsQuery query, CancellationToken cancellationToken)
    {
        var items = await rooms.ListActiveAsync(query.UnitId, cancellationToken);
        return mapper.Map<List<RoomDto>>(items);
    }
}
