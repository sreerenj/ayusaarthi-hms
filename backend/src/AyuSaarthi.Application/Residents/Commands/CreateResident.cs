using AutoMapper;
using AyuSaarthi.Application.Abstractions.Messaging;
using AyuSaarthi.Application.Common;
using AyuSaarthi.Domain.Entities;
using AyuSaarthi.Domain.Repositories;
using FluentValidation;

namespace AyuSaarthi.Application.Residents.Commands;

public sealed record CreateResidentCommand(CreateResidentDto Resident) : ICommand<int>;

internal sealed class CreateResidentCommandValidator : AbstractValidator<CreateResidentCommand>
{
    public CreateResidentCommandValidator()
    {
        RuleFor(x => x.Resident).NotNull().SetValidator(new CreateResidentDtoValidator());
    }
}

internal sealed class CreateResidentCommandHandler(
    IResidentRepository residents,
    IFacilityRepository facilities,
    IUnitOfWork unitOfWork,
    IMapper mapper) : ICommandHandler<CreateResidentCommand, int>
{
    public async Task<int> Handle(CreateResidentCommand command, CancellationToken cancellationToken)
    {
        var dto = command.Resident;

        if (await facilities.GetByIdAsync(dto.FacilityId, cancellationToken) is null)
            throw new NotFoundException(nameof(Facility), dto.FacilityId);

        var resident = mapper.Map<Resident>(dto);

        await residents.AddAsync(resident, cancellationToken);
        await unitOfWork.SaveChangesAsync(cancellationToken);

        return resident.Id;
    }
}
