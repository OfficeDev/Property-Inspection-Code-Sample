using System;

namespace SuiteLevelWebApp.Models
{
    public class ScheduleRepairModel
    {
        public int IncidentId { get; set; }
        public string RepairPeopleSelectedValue { get; set; }
        public string DispatcherComments { get; set; }
        public DateTime TimeSlotsSelectedValue { get; set; }
        public string TimeSlotsSelectedDateValue { get; set; }
        public string TimeSlotsSelectedHoursValue { get; set; }
    }
}