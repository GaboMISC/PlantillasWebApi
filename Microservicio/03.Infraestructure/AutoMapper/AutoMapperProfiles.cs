using AutoMapper;
using Microservicio._01.Domain.Models.Dtos;
using Microservicio._01.Domain.Models.Entities;

namespace Microservicio._03.Infraestructure.AutoMapper
{
    /*
     * Nugget
         * AutoMapper
         * AutoMapper.Extensions.Microsoft.DependencyInjection
     */
    public class AutoMapperProfiles : Profile
    {
        public AutoMapperProfiles()
        {
            // Request
            CreateMap<ValidationRequestEntity, RequestDto>() // Entity, Dto
                .ForMember(dest => dest.Id, opt => opt.MapFrom(scr => scr.Identifier))
                .ForMember(dest => dest.Version, opt => opt.MapFrom(scr => scr.Version))

                // Se usa para ignorar atributos del origen para que aparezcan vacios en el destino
                .ForMember(dest => dest.HierarchyIdentifier, opt => opt.Ignore())
            .ReverseMap();

            // Response
            CreateMap<ValidationResponseEntity, ResultDto>() // Entity, Dto
                .ForMember(dest => dest.Success, opt => opt.MapFrom(scr => scr.Success))
                .ForMember(dest => dest.Message, opt => opt.MapFrom(scr => scr.Message))
            .ReverseMap();
        }
    }
}