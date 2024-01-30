using Microservicio._01.Domain.Models.Constants;
using Microservicio._01.Domain.Models.Dtos;
using Microsoft.AspNetCore.Mvc;

namespace Microservicio._02.Application.Business.Handlers
{
    public static class DataNotationsErrorHandler
    {
        public static BadRequestObjectResult CustomErrorResponse(ActionContext actionContext)
        {
            var errorRecordList = actionContext.ModelState.Where(modelError => modelError.Value?.Errors.Count > 0).ToList();

            // Obtiene las descripciones de los errores
            var errorList = errorRecordList
                .SelectMany(errors => errors.Value!.Errors)
                .Select(error => error.ErrorMessage)
                .ToList();

            // Obtiene el Action Name
            string actionMethod = string.Empty;
            if (actionContext.ActionDescriptor.RouteValues.TryGetValue(ActionMethodsResponse.Action, out string? actionValue))
                actionMethod = actionValue ?? string.Empty;

            // Le asigna el formato a cada error
            List<ResultDto> errors = new List<ResultDto>();
            errorList.ForEach(error => errors.Add(new ResultDto()
            {
                Success = false,
                Message = string.Empty
            }));

            // Genera el response de salida
            switch (actionMethod)
            {
                case ActionMethodsResponse.Action:
                    return new BadRequestObjectResult(new RequestDto()
                    {
                        Version = 1,
                        HierarchyIdentifier = 1,
                        Id = "123"
                    });

                case ActionMethodsResponse.ValidateModel:
                    List<RequestDto> lista = new List<RequestDto>();
                    errorList.ForEach(error => lista.Add(new RequestDto()
                    {
                        Version = 0,
                        HierarchyIdentifier = 2,
                        Id = error
                    }));
                    return new BadRequestObjectResult(lista);

                default:
                    return new BadRequestObjectResult(errors);
            }
        }
    }
}