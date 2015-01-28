using System;

namespace SuiteLevelWebApp.DTO
{
    public class InspectionPhotoDTO
    {
        public InspectionPhotoDTO() { }

        public string Name { get; set; }
        public int InspectionId { get; set; }
        public int RoomId { get; set; }
        public Nullable<int> IncidentId { get; set; }
    }
}