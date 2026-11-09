using AutoMapper;
using AyuSaarthi.Application.Abstractions.Messaging;
using AyuSaarthi.Application.Common;
using AyuSaarthi.Domain.Entities;
using AyuSaarthi.Domain.Repositories;

namespace AyuSaarthi.Application.Rooms.Queries;

public sealed record GetRoomByIdQuery(int Id) : IQuery<RoomDto>;

internal sealed class GetRoomByIdQueryHandler(IRoomRepository rooms, IMapper mapper)
    : IQueryHandler<GetRoomByIdQuery, RoomDto>
{
    public async Task<RoomDto> Handle(GetRoomByIdQuery query, CancellationToken cancellationToken)
    {
        var room = await rooms.GetByIdAsync(query.Id, cancellationToken);
        if (room is not { IsActive: true })
            throw new NotFoundException(nameof(Room), query.Id);

        return mapper.Map<RoomDto>(room);
    }
}
