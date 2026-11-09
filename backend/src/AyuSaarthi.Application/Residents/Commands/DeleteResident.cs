using AyuSaarthi.Application.Abstractions.Messaging;
using AyuSaarthi.Application.Common;
using AyuSaarthi.Domain.Entities;
using AyuSaarthi.Domain.Repositories;

namespace AyuSaarthi.Application.Residents.Commands;

public sealed record DeleteResidentCommand(int Id) : ICommand<Unit>;

internal sealed class DeleteResidentCommandHandler(IResidentRepository residents, IUnitOfWork unitOfWork)
    : ICommandHandler<DeleteResidentCommand, Unit>
{
    public async Task<Unit> Handle(DeleteResidentCommand command, CancellationToken cancellationToken)
    {
        var resident = await residents.GetByIdAsync(command.Id, cancellationToken);
        if (resident is not { IsActive: true })
            throw new NotFoundException(nameof(Resident), command.Id);

        resident.Deactivate();
        await unitOfWork.SaveChangesAsync(cancellationToken);
        return default;
    }
}
