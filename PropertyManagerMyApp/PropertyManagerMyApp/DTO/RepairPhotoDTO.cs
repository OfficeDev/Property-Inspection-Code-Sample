
namespace SuiteLevelWebApp.DTO
{
    public class RepairPhotoDTO
    {
        public RepairPhotoDTO() { }

        public string Name { get; set; }
        public int InspectionId { get; set; }
        public int RoomId { get; set; }
        public int IncidentId { get; set; }
    }
}