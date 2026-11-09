using AyuSaarthi.Application.Abstractions.Messaging;
using AyuSaarthi.Application.Rooms;
using AyuSaarthi.Application.Rooms.Commands;
using AyuSaarthi.Application.Rooms.Queries;
using Microsoft.AspNetCore.Mvc;

namespace AyuSaarthi.Api.Controllers;

[ApiController]
[Route("api/v1/rooms")]
public class RoomsController(IDispatcher dispatcher) : ControllerBase
{
    [HttpGet]
    [ProducesResponseType<IReadOnlyList<RoomDto>>(StatusCodes.Status200OK)]
    public async Task<IActionResult> GetAll([FromQuery] int? unitId, CancellationToken ct)
        => Ok(await dispatcher.Query(new GetRoomsQuery(unitId), ct));

    [HttpGet("{id:int}")]
    [ProducesResponseType<RoomDto>(StatusCodes.Status200OK)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GetById(int id, CancellationToken ct)
        => Ok(await dispatcher.Query(new GetRoomByIdQuery(id), ct));

    [HttpPost]
    [ProducesResponseType<RoomDto>(StatusCodes.Status201Created)]
    [ProducesResponseType<ValidationProblemDetails>(StatusCodes.Status400BadRequest)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status404NotFound)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status409Conflict)]
    public async Task<IActionResult> Create(CreateRoomDto request, CancellationToken ct)
    {
        var id = await dispatcher.Send(new CreateRoomCommand(request), ct);
        var created = await dispatcher.Query(new GetRoomByIdQuery(id), ct);
        return CreatedAtAction(nameof(GetById), new { id }, created);
    }

    [HttpPut("{id:int}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType<ValidationProblemDetails>(StatusCodes.Status400BadRequest)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status404NotFound)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status409Conflict)]
    public async Task<IActionResult> Update(int id, UpdateRoomDto request, CancellationToken ct)
    {
        await dispatcher.Send(new UpdateRoomCommand(id, request), ct);
        return NoContent();
    }

    [HttpDelete("{id:int}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Delete(int id, CancellationToken ct)
    {
        await dispatcher.Send(new DeleteRoomCommand(id), ct);
        return NoContent();
    }
}
