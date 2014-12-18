using System;

namespace SuiteLevelWebApp.DTO
{
    public class IncidentDTO
    {
        public IncidentDTO() { }

        public int Id { get; set; }
        public string IncidentType { get; set; }
        public string Name { get; set; }
        public DateTime Date { get; set; }
        public string InspectorIncidentComments { get; set; }
        public string DispatcherComments { get; set; }
        public string RepairComments { get; set; }
        public string Status { get; set; }
        public int PropertyId { get; set; }
        public int InspectionId { get; set; }
        public int RoomId { get; set; }
        public RepairPersonDTO RepairPerson { get; set; }
    }
}