using Microservicio._01.Domain.Models.Dtos;

namespace Microservicio.Application.Business.Contracts
{
    public interface IValidationBusiness
    {
        public Task<ResultDto> ValidateProcess(RequestDto request);
    }
}