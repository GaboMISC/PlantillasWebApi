using AutoMapper;
using Microservicio._01.Domain.Models.Dtos;
using Microservicio._01.Domain.Models.Entities;
using Microservicio._01.Domain.Models.Exceptions;
using Microservicio.Application.Business.Contracts;

namespace Microservicio.Application.Business
{
    public class ValidationBusiness : IValidationBusiness
    {
        private readonly IMapper _mapper;

        public ValidationBusiness(IMapper mapper) => _mapper = mapper; 

        public async Task<ResultDto> ValidateProcess(RequestDto request)
        {
            ResultDto result;
            ValidationResponseEntity response;

            ValidationRequestEntity contentRequest = _mapper.Map<ValidationRequestEntity>(request);

            if (contentRequest.Version == 4)
                throw new NotImplementedException();
            else if (contentRequest.Version == 3)
                throw new CustomException("Incorrecto");
            else
                response = new ValidationResponseEntity()
                {
                    Success = true,
                    Message = $"Exito"
                };

            // Auto Mapper
            result = _mapper.Map<ResultDto>(response);

            return await Task.FromResult(result);
        }
    }
}