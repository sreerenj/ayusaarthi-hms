using AyuSaarthi.Domain.Common;

namespace AyuSaarthi.Domain.Entities;

public class Room : BaseEntity
{
    private Room() { }

    public Room(
        int unitId,
        string roomNumber,
        string roomType,
        byte capacity,
        bool isAdaAccessible,
        bool isBariatric)
    {
        UnitId = unitId;
        IsActive = true;
        Update(roomNumber, roomType, capacity, isAdaAccessible, isBariatric);
    }

    public int UnitId { get; private set; }
    public string RoomNumber { get; private set; } = string.Empty;
    public string RoomType { get; private set; } = string.Empty;
    public byte Capacity { get; private set; }
    public bool IsAdaAccessible { get; private set; }
    public bool IsBariatric { get; private set; }
    public bool IsActive { get; private set; }

    public void Update(string roomNumber, string roomType, byte capacity, bool isAdaAccessible, bool isBariatric)
    {
        RoomNumber = roomNumber;
        RoomType = roomType;
        Capacity = capacity;
        IsAdaAccessible = isAdaAccessible;
        IsBariatric = isBariatric;
    }

    // Beds reference rooms, so rooms are deactivated rather than physically deleted.
    public void Deactivate() => IsActive = false;
}
