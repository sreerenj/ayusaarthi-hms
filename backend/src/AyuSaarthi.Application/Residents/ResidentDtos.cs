namespace AyuSaarthi.Application.Residents;

public sealed record ResidentDto(
    int Id,
    int FacilityId,
    string FirstName,
    string? MiddleName,
    string LastName,
    string? PreferredName,
    DateOnly DateOfBirth,
    string Gender,
    string? MaritalStatus,
    string PrimaryLanguage,
    string? Religion,
    string? NationalOrigin,
    bool IsActive,
    DateTime CreatedAt);

public abstract record ResidentWriteDto
{
    public string FirstName { get; init; } = string.Empty;
    public string? MiddleName { get; init; }
    public string LastName { get; init; } = string.Empty;
    public string? PreferredName { get; init; }
    public DateOnly DateOfBirth { get; init; }
    public string Gender { get; init; } = string.Empty;
    public string? MaritalStatus { get; init; }
    public string PrimaryLanguage { get; init; } = "English";
    public string? Religion { get; init; }
    public string? NationalOrigin { get; init; }
}

public sealed record CreateResidentDto : ResidentWriteDto
{
    public int FacilityId { get; init; }
    public int CreatedByStaffId { get; init; }
}

public sealed record UpdateResidentDto : ResidentWriteDto;
