using AutoMapper;
using AyuSaarthi.Domain.Entities;

namespace AyuSaarthi.Application.Residents;

public sealed class ResidentMappingProfile : Profile
{
    public ResidentMappingProfile()
    {
        CreateMap<Resident, ResidentDto>();

        // Resident is built through its constructor; parameter names match the DTO property names.
        CreateMap<CreateResidentDto, Resident>();
    }
}
