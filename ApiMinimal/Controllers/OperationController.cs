using ApiMinimal.Services.Contracts;
using Microsoft.AspNetCore.Mvc;

namespace ApiMinimal.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class OperationController : ControllerBase
    {
        private readonly IOperacionService _operacionService;

        public OperationController(IOperacionService operacionService)
        {
            _operacionService = operacionService;
        }

        [HttpGet("OperationAdd")]
        public IActionResult OperationAdd([FromQuery] int a, [FromQuery] int b)
        {
            try
            {
                var resultado = _operacionService.Addtion(a, b);
                return Ok(resultado);
            }
            catch (Exception ex)
            {
                return BadRequest($"Error al realizar la operación: {ex.Message}");
            }
        }
    }
}