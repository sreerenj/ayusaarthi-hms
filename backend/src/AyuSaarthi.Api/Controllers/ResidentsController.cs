using AyuSaarthi.Application.Abstractions.Messaging;
using AyuSaarthi.Application.Residents;
using AyuSaarthi.Application.Residents.Commands;
using AyuSaarthi.Application.Residents.Queries;
using Microsoft.AspNetCore.Mvc;

namespace AyuSaarthi.Api.Controllers;

[ApiController]
[Route("api/v1/residents")]
public class ResidentsController(IDispatcher dispatcher) : ControllerBase
{
    [HttpGet]
    [ProducesResponseType<IReadOnlyList<ResidentDto>>(StatusCodes.Status200OK)]
    public async Task<IActionResult> GetAll([FromQuery] int? facilityId, CancellationToken ct)
        => Ok(await dispatcher.Query(new GetResidentsQuery(facilityId), ct));

    [HttpGet("{id:int}")]
    [ProducesResponseType<ResidentDto>(StatusCodes.Status200OK)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GetById(int id, CancellationToken ct)
        => Ok(await dispatcher.Query(new GetResidentByIdQuery(id), ct));

    [HttpPost]
    [ProducesResponseType<ResidentDto>(StatusCodes.Status201Created)]
    [ProducesResponseType<ValidationProblemDetails>(StatusCodes.Status400BadRequest)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Create(CreateResidentDto request, CancellationToken ct)
    {
        var id = await dispatcher.Send(new CreateResidentCommand(request), ct);
        var created = await dispatcher.Query(new GetResidentByIdQuery(id), ct);
        return CreatedAtAction(nameof(GetById), new { id }, created);
    }

    [HttpPut("{id:int}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType<ValidationProblemDetails>(StatusCodes.Status400BadRequest)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Update(int id, UpdateResidentDto request, CancellationToken ct)
    {
        await dispatcher.Send(new UpdateResidentCommand(id, request), ct);
        return NoContent();
    }

    [HttpDelete("{id:int}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Delete(int id, CancellationToken ct)
    {
        await dispatcher.Send(new DeleteResidentCommand(id), ct);
        return NoContent();
    }
}
