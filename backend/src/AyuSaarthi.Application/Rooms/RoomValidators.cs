using FluentValidation;

namespace AyuSaarthi.Application.Rooms;

internal static class RoomTypes
{
    public static readonly string[] Allowed = ["Private", "Semi-Private", "Ward"];
}

internal abstract class RoomWriteDtoValidator<T> : AbstractValidator<T> where T : RoomWriteDto
{
    protected RoomWriteDtoValidator()
    {
        RuleFor(x => x.RoomNumber).NotEmpty().MaximumLength(10);
        RuleFor(x => x.RoomType).NotEmpty().Must(t => RoomTypes.Allowed.Contains(t))
            .WithMessage($"'Room Type' must be one of: {string.Join(", ", RoomTypes.Allowed)}.");
        RuleFor(x => x.Capacity).InclusiveBetween((byte)1, (byte)4);
    }
}

internal sealed class CreateRoomDtoValidator : RoomWriteDtoValidator<CreateRoomDto>
{
    public CreateRoomDtoValidator()
    {
        RuleFor(x => x.UnitId).GreaterThan(0);
    }
}

internal sealed class UpdateRoomDtoValidator : RoomWriteDtoValidator<UpdateRoomDto>;
