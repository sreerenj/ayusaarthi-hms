namespace AyuSaarthi.Application.Rooms;

public sealed record RoomDto(
    int Id,
    int UnitId,
    string RoomNumber,
    string RoomType,
    byte Capacity,
    bool IsAdaAccessible,
    bool IsBariatric,
    bool IsActive);

public abstract record RoomWriteDto
{
    public string RoomNumber { get; init; } = string.Empty;
    public string RoomType { get; init; } = string.Empty;
    public byte Capacity { get; init; } = 1;
    public bool IsAdaAccessible { get; init; }
    public bool IsBariatric { get; init; }
}

public sealed record CreateRoomDto : RoomWriteDto
{
    public int UnitId { get; init; }
}

public sealed record UpdateRoomDto : RoomWriteDto;
