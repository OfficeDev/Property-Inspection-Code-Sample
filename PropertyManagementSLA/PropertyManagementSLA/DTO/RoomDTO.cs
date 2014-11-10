using System.Collections.Generic;

namespace SuiteLevelWebApp.DTO
{
    public class RoomDTO
    {
        public RoomDTO() { }

        public int Id { get; set; }
        public string Name { get; set; }
        public int PropertyId { get; set; }
        public List<InspectionPhotoDTO> InspectionPhotos { get; set; }
        public List<RepairPhotoDTO> RepairPhotos { get; set; }
        public IncidentDTO Incident { get; set; }
        public InspectionCommentDTO InspectionComment { get; set; }
    }
}