using System;

namespace SuiteLevelWebApp.DTO
{
    public class InspectionDTO
    {
        public InspectionDTO() { }

        public int Id { get; set; }
        public DateTime Date { get; set; }
        public int PropertyId { get; set; }
        public InspectorDTO Inspector { get; set; }        
    }
}