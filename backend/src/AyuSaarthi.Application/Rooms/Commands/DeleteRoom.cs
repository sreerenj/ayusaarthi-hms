using AyuSaarthi.Application.Abstractions.Messaging;
using AyuSaarthi.Application.Common;
using AyuSaarthi.Domain.Entities;
using AyuSaarthi.Domain.Repositories;

namespace AyuSaarthi.Application.Rooms.Commands;

public sealed record DeleteRoomCommand(int Id) : ICommand<Unit>;

internal sealed class DeleteRoomCommandHandler(IRoomRepository rooms, IUnitOfWork unitOfWork)
    : ICommandHandler<DeleteRoomCommand, Unit>
{
    public async Task<Unit> Handle(DeleteRoomCommand command, CancellationToken cancellationToken)
    {
        var room = await rooms.GetByIdAsync(command.Id, cancellationToken);
        if (room is not { IsActive: true })
            throw new NotFoundException(nameof(Room), command.Id);

        room.Deactivate();
        await unitOfWork.SaveChangesAsync(cancellationToken);
        return default;
    }
}
