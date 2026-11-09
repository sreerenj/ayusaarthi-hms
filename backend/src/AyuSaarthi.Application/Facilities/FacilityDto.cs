using AyuSaarthi.Domain.Entities;

namespace AyuSaarthi.Application.Facilities;

public sealed record FacilityDto(
    int Id,
    string Name,
    string AddressLine1,
    string? AddressLine2,
    string City,
    string StateCode,
    string ZipCode,
    string? PhoneNumber,
    string? LicenseNumber,
    string? Npi,
    bool IsActive)
{
    public static FacilityDto From(Facility f) => new(
        f.Id, f.Name, f.AddressLine1, f.AddressLine2, f.City, f.StateCode, f.ZipCode,
        f.PhoneNumber, f.LicenseNumber, f.Npi, f.IsActive);
}
