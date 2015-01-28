using System.Collections.Generic;

namespace SuiteLevelWebApp.DTO
{
    public class PropertyDTO
    {
        public PropertyDTO() { }

        public int Id { get; set; }
        public string Name { get; set; }
        public string Owner { get; set; }
        public string Address1 { get; set; }
        public string Address2 { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string PostalCode { get; set; }
        public string latitude { get; set; }
        public string longitude { get; set;}
        public List<InspectionDTO> Inspections { get; set; }
    }
}