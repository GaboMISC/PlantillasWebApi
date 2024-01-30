using Microservicio._01.Domain.Models.Exceptions;
using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.AspNetCore.Mvc;
using System.Net;
using Microservicio._01.Domain.Models.Dtos;

namespace Microservicio._02.Application.Business.Handlers
{
    public class ErrorHandler : IActionFilter, IOrderedFilter
    {
        /*
		 * En este caso, Order está configurado para ser int.MaxValue - 10, lo que significa que este filtro tiene un valor muy alto y, por lo tanto, se ejecutará casi al final del ciclo de vida de la acción del controlador. El propósito de esta configuración es que el filtro ErrorHandler maneje las excepciones después de que otros filtros hayan tenido la oportunidad de realizar sus tareas. 
		 */
        public int Order => int.MaxValue - 10;

        public void OnActionExecuted(ActionExecutedContext context)
        {
            if (context.Exception is CustomException customException)
            {
                // Personaliza el reponse del error
                ResultDto result = MakeErrorResponse(customException.Message);

                // Modificar el resultado de la acción
                context.Result = new ObjectResult(result)
                {
                    StatusCode = (int)HttpStatusCode.Conflict
                };
            }
            else if (context.Exception is IOException || context.Exception is not null)
            {
                // Personaliza el reponse del error
                ResultDto result = MakeErrorResponse(context.Exception.Message);

                // Modificar el resultado de la acción
                context.Result = new ObjectResult(result)
                {
                    StatusCode = (int)HttpStatusCode.InternalServerError
                };
            }
            // Marcar la excepción como manejada
            context.ExceptionHandled = true;
        }

        public void OnActionExecuting(ActionExecutingContext context)
        {
            //Implementation no necesary
        }

        public ResultDto MakeErrorResponse(string message)
        {
            return new ResultDto()
            {
                Success = false,
                Message = message
            };
        }
    }
}
