using FluentValidation;

namespace AyuSaarthi.Application.Residents;

internal static class ResidentGenders
{
    public static readonly string[] Allowed = ["Male", "Female", "Non-Binary", "Other", "Unknown"];
}

internal abstract class ResidentWriteDtoValidator<T> : AbstractValidator<T> where T : ResidentWriteDto
{
    protected ResidentWriteDtoValidator()
    {
        RuleFor(x => x.FirstName).NotEmpty().MaximumLength(100);
        RuleFor(x => x.MiddleName).MaximumLength(100);
        RuleFor(x => x.LastName).NotEmpty().MaximumLength(100);
        RuleFor(x => x.PreferredName).MaximumLength(100);
        RuleFor(x => x.DateOfBirth)
            .Must(d => d != default && d <= DateOnly.FromDateTime(DateTime.UtcNow))
            .WithMessage("'Date Of Birth' must be a valid date that is not in the future.");
        RuleFor(x => x.Gender).NotEmpty().Must(g => ResidentGenders.Allowed.Contains(g))
            .WithMessage($"'Gender' must be one of: {string.Join(", ", ResidentGenders.Allowed)}.");
        RuleFor(x => x.MaritalStatus).MaximumLength(20);
        RuleFor(x => x.PrimaryLanguage).NotEmpty().MaximumLength(50);
        RuleFor(x => x.Religion).MaximumLength(50);
        RuleFor(x => x.NationalOrigin).MaximumLength(50);
    }
}

internal sealed class CreateResidentDtoValidator : ResidentWriteDtoValidator<CreateResidentDto>
{
    public CreateResidentDtoValidator()
    {
        RuleFor(x => x.FacilityId).GreaterThan(0);
        RuleFor(x => x.CreatedByStaffId).GreaterThan(0);
    }
}

internal sealed class UpdateResidentDtoValidator : ResidentWriteDtoValidator<UpdateResidentDto>;
