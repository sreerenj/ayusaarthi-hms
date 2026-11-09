using AyuSaarthi.Application.Abstractions.Messaging;
using AyuSaarthi.Application.Common;
using AyuSaarthi.Domain.Entities;
using AyuSaarthi.Domain.Repositories;

namespace AyuSaarthi.Application.Facilities.Commands;

public sealed record CreateFacilityCommand(
    string Name,
    string AddressLine1,
    string? AddressLine2,
    string City,
    string StateCode,
    string ZipCode,
    string? PhoneNumber,
    string? LicenseNumber,
    string? Npi) : ICommand<int>;

internal sealed class CreateFacilityCommandHandler(IFacilityRepository facilities, IUnitOfWork unitOfWork)
    : ICommandHandler<CreateFacilityCommand, int>
{
    public async Task<int> Handle(CreateFacilityCommand command, CancellationToken cancellationToken)
    {
        if (command.Npi is not null && await facilities.NpiExistsAsync(command.Npi, cancellationToken))
            throw new ConflictException($"A facility with NPI '{command.Npi}' already exists.");

        var facility = new Facility(
            command.Name, command.AddressLine1, command.AddressLine2, command.City,
            command.StateCode, command.ZipCode, command.PhoneNumber, command.LicenseNumber, command.Npi);

        await facilities.AddAsync(facility, cancellationToken);
        await unitOfWork.SaveChangesAsync(cancellationToken);

        return facility.Id;
    }
}
