using AyuSaarthi.Application.Abstractions.Messaging;
using AyuSaarthi.Application.Common;
using AyuSaarthi.Domain.Entities;
using AyuSaarthi.Domain.Repositories;
using FluentValidation;

namespace AyuSaarthi.Application.Rooms.Commands;

public sealed record UpdateRoomCommand(int Id, UpdateRoomDto Room) : ICommand<Unit>;

internal sealed class UpdateRoomCommandValidator : AbstractValidator<UpdateRoomCommand>
{
    public UpdateRoomCommandValidator()
    {
        RuleFor(x => x.Id).GreaterThan(0);
        RuleFor(x => x.Room).NotNull().SetValidator(new UpdateRoomDtoValidator());
    }
}

internal sealed class UpdateRoomCommandHandler(IRoomRepository rooms, IUnitOfWork unitOfWork)
    : ICommandHandler<UpdateRoomCommand, Unit>
{
    public async Task<Unit> Handle(UpdateRoomCommand command, CancellationToken cancellationToken)
    {
        var room = await rooms.GetByIdAsync(command.Id, cancellationToken);
        if (room is not { IsActive: true })
            throw new NotFoundException(nameof(Room), command.Id);

        var dto = command.Room;

        if (await rooms.RoomNumberExistsAsync(room.UnitId, dto.RoomNumber, room.Id, cancellationToken))
            throw new ConflictException($"Room '{dto.RoomNumber}' already exists in unit {room.UnitId}.");

        room.Update(dto.RoomNumber, dto.RoomType, dto.Capacity, dto.IsAdaAccessible, dto.IsBariatric);

        await unitOfWork.SaveChangesAsync(cancellationToken);
        return default;
    }
}
