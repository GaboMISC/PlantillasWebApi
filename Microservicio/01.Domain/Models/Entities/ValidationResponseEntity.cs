namespace Microservicio._01.Domain.Models.Entities
{
    public class ValidationResponseEntity
    {
        public bool Success { get; set; }
        public string Message { get; set; } = string.Empty;
    }
}