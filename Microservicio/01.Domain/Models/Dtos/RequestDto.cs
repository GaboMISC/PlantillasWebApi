using System.ComponentModel.DataAnnotations;

namespace Microservicio._01.Domain.Models.Dtos
{
    public class RequestDto : IValidatableObject
	{
		[Required(ErrorMessage = "The Identifier field is required.")]
		public string Id { get; set; } = string.Empty;

		[Range(1, int.MaxValue, ErrorMessage = "The Version must be greater than or equal to 1.")]
		public int Version { get; set; }

		[Range(1, int.MaxValue, ErrorMessage = "The HierarchyIdentifier must be greater than or equal to 1.")]
		public int HierarchyIdentifier { get; set; }

		public IEnumerable<ValidationResult> Validate(ValidationContext validationContext)
		{
			if (Version == 0)
			{
				yield return new ValidationResult("The Version must be greater than or equal to 1.");
				yield break;
			}

			List<string> errorValidations = new List<string>(); 
			
			Validations(errorValidations);

			foreach (string message in errorValidations)
				yield return new ValidationResult(message);
		}

		private void Validations(List<string> errorValidations)
		{
			if (string.IsNullOrWhiteSpace(Id))
				errorValidations.Add("The Identifier field is required.");

			if (HierarchyIdentifier == 0)
				errorValidations.Add("The HierarchyIdentifier must be greater than or equal to 1.");
		}
	}
}