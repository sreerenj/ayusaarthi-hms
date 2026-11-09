using AyuSaarthi.Domain.Common;

namespace AyuSaarthi.Domain.Entities;

public class Resident : BaseEntity
{
    private Resident() { }

    public Resident(
        int facilityId,
        int createdByStaffId,
        string firstName,
        string? middleName,
        string lastName,
        string? preferredName,
        DateOnly dateOfBirth,
        string gender,
        string? maritalStatus,
        string primaryLanguage,
        string? religion,
        string? nationalOrigin)
    {
        FacilityId = facilityId;
        CreatedByStaffId = createdByStaffId;
        IsActive = true;
        CreatedAt = DateTime.UtcNow;
        Update(firstName, middleName, lastName, preferredName, dateOfBirth, gender,
            maritalStatus, primaryLanguage, religion, nationalOrigin);
    }

    public int FacilityId { get; private set; }
    public string FirstName { get; private set; } = string.Empty;
    public string? MiddleName { get; private set; }
    public string LastName { get; private set; } = string.Empty;
    public string? PreferredName { get; private set; }
    public DateOnly DateOfBirth { get; private set; }
    public string Gender { get; private set; } = string.Empty;
    public string? MaritalStatus { get; private set; }
    public string PrimaryLanguage { get; private set; } = string.Empty;
    public string? Religion { get; private set; }
    public string? NationalOrigin { get; private set; }
    public bool IsActive { get; private set; }
    public DateTime CreatedAt { get; private set; }
    public int CreatedByStaffId { get; private set; }

    public void Update(
        string firstName,
        string? middleName,
        string lastName,
        string? preferredName,
        DateOnly dateOfBirth,
        string gender,
        string? maritalStatus,
        string primaryLanguage,
        string? religion,
        string? nationalOrigin)
    {
        FirstName = firstName;
        MiddleName = middleName;
        LastName = lastName;
        PreferredName = preferredName;
        DateOfBirth = dateOfBirth;
        Gender = gender;
        MaritalStatus = maritalStatus;
        PrimaryLanguage = primaryLanguage;
        Religion = religion;
        NationalOrigin = nationalOrigin;
    }

    // Residents hold PHI, so they are deactivated rather than physically deleted.
    public void Deactivate() => IsActive = false;
}
