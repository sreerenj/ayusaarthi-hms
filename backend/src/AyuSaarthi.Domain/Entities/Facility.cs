using AyuSaarthi.Domain.Common;

namespace AyuSaarthi.Domain.Entities;

public class Facility : BaseEntity
{
    private Facility() { }

    public Facility(
        string name,
        string addressLine1,
        string? addressLine2,
        string city,
        string stateCode,
        string zipCode,
        string? phoneNumber,
        string? licenseNumber,
        string? npi)
    {
        Name = name;
        AddressLine1 = addressLine1;
        AddressLine2 = addressLine2;
        City = city;
        StateCode = stateCode;
        ZipCode = zipCode;
        PhoneNumber = phoneNumber;
        LicenseNumber = licenseNumber;
        Npi = npi;
        IsActive = true;
        CreatedAt = DateTime.UtcNow;
    }

    public string Name { get; private set; } = string.Empty;
    public string AddressLine1 { get; private set; } = string.Empty;
    public string? AddressLine2 { get; private set; }
    public string City { get; private set; } = string.Empty;
    public string StateCode { get; private set; } = string.Empty;
    public string ZipCode { get; private set; } = string.Empty;
    public string? PhoneNumber { get; private set; }
    public string? LicenseNumber { get; private set; }
    public string? MedicareProvNum { get; private set; }
    public string? MedicaidProvNum { get; private set; }
    public string? Npi { get; private set; }
    public bool IsActive { get; private set; }
    public DateTime CreatedAt { get; private set; }
}
