using AyuSaarthi.Domain.Common;

namespace AyuSaarthi.Domain.Entities;

// Read-only here: rooms only need to verify that their unit exists.
public class NursingUnit : BaseEntity
{
    private NursingUnit() { }

    public int FacilityId { get; private set; }
    public string Name { get; private set; } = string.Empty;
    public string UnitType { get; private set; } = string.Empty;
    public short? FloorNumber { get; private set; }
    public bool IsActive { get; private set; }
}
