using AutoMapper;
using AyuSaarthi.Domain.Entities;

namespace AyuSaarthi.Application.Rooms;

public sealed class RoomMappingProfile : Profile
{
    public RoomMappingProfile()
    {
        CreateMap<Room, RoomDto>();

        // Room is built through its constructor; parameter names match the DTO property names.
        CreateMap<CreateRoomDto, Room>();
    }
}
