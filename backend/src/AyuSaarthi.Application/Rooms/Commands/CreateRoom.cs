using AutoMapper;
using AyuSaarthi.Application.Abstractions.Messaging;
using AyuSaarthi.Application.Common;
using AyuSaarthi.Domain.Entities;
using AyuSaarthi.Domain.Repositories;
using FluentValidation;

namespace AyuSaarthi.Application.Rooms.Commands;

public sealed record CreateRoomCommand(CreateRoomDto Room) : ICommand<int>;

internal sealed class CreateRoomCommandValidator : AbstractValidator<CreateRoomCommand>
{
    public CreateRoomCommandValidator()
    {
        RuleFor(x => x.Room).NotNull().SetValidator(new CreateRoomDtoValidator());
    }
}

internal sealed class CreateRoomCommandHandler(
    IRoomRepository rooms,
    IRepository<NursingUnit> units,
    IUnitOfWork unitOfWork,
    IMapper mapper) : ICommandHandler<CreateRoomCommand, int>
{
    public async Task<int> Handle(CreateRoomCommand command, CancellationToken cancellationToken)
    {
        var dto = command.Room;

        var unit = await units.GetByIdAsync(dto.UnitId, cancellationToken);
        if (unit is not { IsActive: true })
            throw new NotFoundException(nameof(NursingUnit), dto.UnitId);

        if (await rooms.RoomNumberExistsAsync(dto.UnitId, dto.RoomNumber, null, cancellationToken))
            throw new ConflictException($"Room '{dto.RoomNumber}' already exists in unit {dto.UnitId}.");

        var room = mapper.Map<Room>(dto);

        await rooms.AddAsync(room, cancellationToken);
        await unitOfWork.SaveChangesAsync(cancellationToken);

        return room.Id;
    }
}
