namespace Microservicio._01.Domain.Models.Entities
{
    public class ValidationRequestEntity
    {
        public string Identifier { get; set; } = string.Empty;
        public int Version { get; set; }
    }
}