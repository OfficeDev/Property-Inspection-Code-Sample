
namespace SuiteLevelWebApp.DTO
{
    public class InspectionCommentDTO
    {
        public InspectionCommentDTO() { }

        public string Comment { get; set; }
        public int InspectionId { get; set; }
        public int RoomId { get; set; }
    }
}