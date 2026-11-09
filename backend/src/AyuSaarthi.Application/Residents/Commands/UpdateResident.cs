using AyuSaarthi.Application.Abstractions.Messaging;
using AyuSaarthi.Application.Common;
using AyuSaarthi.Domain.Entities;
using AyuSaarthi.Domain.Repositories;
using FluentValidation;

namespace AyuSaarthi.Application.Residents.Commands;

public sealed record UpdateResidentCommand(int Id, UpdateResidentDto Resident) : ICommand<Unit>;

internal sealed class UpdateResidentCommandValidator : AbstractValidator<UpdateResidentCommand>
{
    public UpdateResidentCommandValidator()
    {
        RuleFor(x => x.Id).GreaterThan(0);
        RuleFor(x => x.Resident).NotNull().SetValidator(new UpdateResidentDtoValidator());
    }
}

internal sealed class UpdateResidentCommandHandler(IResidentRepository residents, IUnitOfWork unitOfWork)
    : ICommandHandler<UpdateResidentCommand, Unit>
{
    public async Task<Unit> Handle(UpdateResidentCommand command, CancellationToken cancellationToken)
    {
        var resident = await residents.GetByIdAsync(command.Id, cancellationToken);
        if (resident is not { IsActive: true })
            throw new NotFoundException(nameof(Resident), command.Id);

        var dto = command.Resident;
        resident.Update(
            dto.FirstName, dto.MiddleName, dto.LastName, dto.PreferredName, dto.DateOfBirth,
            dto.Gender, dto.MaritalStatus, dto.PrimaryLanguage, dto.Religion, dto.NationalOrigin);

        await unitOfWork.SaveChangesAsync(cancellationToken);
        return default;
    }
}
