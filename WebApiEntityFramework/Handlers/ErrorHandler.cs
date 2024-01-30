using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.AspNetCore.Mvc;
using System.Net;
using WebApiEntityFramework.Models;

namespace WebApiEntityFramework.Handlers
{
    public class ErrorHandler : IActionFilter, IOrderedFilter
    {
        public int Order => int.MaxValue - 10;

        public void OnActionExecuted(ActionExecutedContext context)
        {
            if (context.Exception is CustomException customException)
            {
                // Personaliza el reponse del error
                BaseResponse result = MakeErrorResponse(customException.Message);

                // Modificar el resultado de la acción
                context.Result = new ObjectResult(result)
                {
                    StatusCode = (int)HttpStatusCode.Conflict
                };
            }
            else if (context.Exception is IOException || context.Exception is not null)
            {
                // Personaliza el reponse del error
                BaseResponse result = MakeErrorResponse(context.Exception.Message);

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

        public BaseResponse MakeErrorResponse(string message)
        {
            return new BaseResponse()
            {
                Success = false,
                Message = message
            };
        }
    }
}