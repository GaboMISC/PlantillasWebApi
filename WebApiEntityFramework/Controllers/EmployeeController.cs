using Microsoft.AspNetCore.Mvc;
using WebApiEntityFramework.Models;
using WebApiEntityFramework.Repositories;

namespace WebApiEntityFramework.Controllers
{
    /// <summary>
    /// Controlador que maneja operaciones CRUD para entidades Employee.
    /// </summary>
    [Route("api/[controller]")]
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        private readonly EmployeeRepository _repository;

        /// <summary>
        /// Constructor que inicializa una nueva instancia del controlador con un repositorio de empleados.
        /// </summary>
        /// <param name="repository">Repositorio de empleados.</param>
        public EmployeeController(EmployeeRepository repository)
        {
            _repository = repository;
        }

        /// <summary>
        /// Obtiene todos los empleados disponibles.
        /// </summary>
        /// <returns>Una acción HTTP que devuelve una colección de empleados.</returns>
        [HttpGet("GetAllEmployees")]
        public IActionResult GetAllEmployees()
        {
            IEnumerable<Employee> employees = _repository.GetAllEmployees();
            return Ok(employees);
        }

        /// <summary>
        /// Obtiene un empleado por su identificador.
        /// </summary>
        /// <param name="id">Identificador del empleado.</param>
        /// <returns>Una acción HTTP que devuelve un empleado.</returns>
        [HttpGet("{id}")]
        public IActionResult GetEmployeeById(int id)
        {
            Employee employee = _repository.GetEmployeeById(id);
            return Ok(employee);
        }

        /// <summary>
        /// Agrega un nuevo empleado.
        /// </summary>
        /// <param name="employee">Datos del empleado a agregar.</param>
        /// <returns>Una acción HTTP indicando que el empleado fue agregado exitosamente.</returns>
        [HttpPost("AddEmployee")]
        public IActionResult AddEmployee([FromBody] Employee employee)
        {
            BaseResponse result = _repository.AddEmployee(employee);
            return Ok(result);
        }

        /// <summary>
        /// Actualiza un empleado existente por su identificador.
        /// </summary>
        /// <param name="id">Identificador del empleado a actualizar.</param>
        /// <param name="employee">Datos actualizados del empleado.</param>
        /// <returns>Una acción HTTP indicando que el empleado fue actualizado exitosamente.</returns>
        [HttpPut("UpdateEmployee/{id}")]
        public IActionResult UpdateEmployee(int id, [FromBody] Employee employee)
        {
            BaseResponse result = _repository.UpdateEmployee(id, employee);
            return Ok(result);
        }

        /// <summary>
        /// Elimina un empleado por su identificador.
        /// </summary>
        /// <param name="id">Identificador del empleado a eliminar.</param>
        /// <returns>Una acción HTTP indicando que el empleado fue eliminado exitosamente.</returns>
        [HttpDelete("DeleteEmployee/{id}")]
        public IActionResult DeleteEmployee(int id)
        {
            BaseResponse result = _repository.DeleteEmployee(id);
            return Ok(result);
        }
    }
}