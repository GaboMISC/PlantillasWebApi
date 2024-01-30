using WebApiEntityFramework.Data;
using WebApiEntityFramework.Handlers;
using WebApiEntityFramework.Models;

namespace WebApiEntityFramework.Repositories
{
    public class EmployeeRepository
    {
        private readonly EmployeeContext _context;

        public EmployeeRepository(EmployeeContext context)
        {
            _context = context;
        }

        public IEnumerable<Employee> GetAllEmployees()
        {
            return _context.Employees.ToList();
        }

        public Employee GetEmployeeById(int id)
        {
            Employee? existingEmployee = _context.Employees.Find(id);

            if (existingEmployee == null)
                throw new CustomException($"No se encontró el empleado con Id: {id}.");

            return existingEmployee;
        }

        public BaseResponse AddEmployee(Employee employee)
        {
            if (employee == null)
                throw new CustomException($"Los datos del empleado no pueden ser nulos.");

            _context.Employees.Add(employee);
            _context.SaveChanges();

            return new BaseResponse() { Success = true, Message = "Empleado agregado exitosamente." };
        }

        public BaseResponse UpdateEmployee(int id, Employee updatedEmployee)
        {
            if (updatedEmployee == null || id == 0)
                throw new CustomException($"Los datos del empleado no pueden ser nulos.");

            Employee? existingEmployee = _context.Employees.Find(id);

            if (existingEmployee == null)
                throw new CustomException($"No se encontró el empleado con Id: {updatedEmployee.EmployeeId}.");

            // Actualizar propiedades individuales
            existingEmployee.FirstName = updatedEmployee.FirstName;
            existingEmployee.LastName = updatedEmployee.LastName;
            existingEmployee.Salary = updatedEmployee.Salary;

            _context.SaveChanges();

            return new BaseResponse() { Success = true, Message = "Empleado actualizado con éxito." };
        }

        public BaseResponse DeleteEmployee(int id)
        {
            Employee? employee = _context.Employees.Find(id);
            if (employee != null)
            {
                _context.Employees.Remove(employee);
                _context.SaveChanges();
            }
            else
                throw new CustomException($"No hay datos del empleado con Id: {id}.");

            return new BaseResponse() { Success = true, Message = "Empleado eliminado exitosamente." };
        }
    }
}