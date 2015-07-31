using System.ComponentModel.DataAnnotations;

namespace SuiteLevelWebApp.Models
{
    public class CreateTaskViewModel
    {
        public int InspectionId { get; set; }

        [Required(ErrorMessage = "*")]
        public string Title { get; set; }

        public string Description { get; set; }
    }
}