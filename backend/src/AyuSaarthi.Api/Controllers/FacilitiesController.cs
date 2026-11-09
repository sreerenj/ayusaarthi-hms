using AyuSaarthi.Application.Abstractions.Messaging;
using AyuSaarthi.Application.Facilities;
using AyuSaarthi.Application.Facilities.Commands;
using AyuSaarthi.Application.Facilities.Queries;
using Microsoft.AspNetCore.Mvc;

namespace AyuSaarthi.Api.Controllers;

[ApiController]
[Route("api/v1/facilities")]
public class FacilitiesController(IDispatcher dispatcher) : ControllerBase
{
    [HttpGet]
    public async Task<ActionResult<IReadOnlyList<FacilityDto>>> GetAll(CancellationToken ct)
        => Ok(await dispatcher.Query(new GetFacilitiesQuery(), ct));

    [HttpGet("{id:int}")]
    public async Task<ActionResult<FacilityDto>> GetById(int id, CancellationToken ct)
        => Ok(await dispatcher.Query(new GetFacilityByIdQuery(id), ct));

    [HttpPost]
    public async Task<IActionResult> Create(CreateFacilityCommand command, CancellationToken ct)
    {
        var id = await dispatcher.Send(command, ct);
        return CreatedAtAction(nameof(GetById), new { id }, new { id });
    }
}
