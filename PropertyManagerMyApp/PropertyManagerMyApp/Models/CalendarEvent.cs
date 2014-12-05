using System;

namespace SuiteLevelWebApp.Models
{
    public class CalendarEvent
    {
        public string Subject { get; set; }
        public CalendarEventBody Body { get; set; }
        public DateTime Start { get; set; }
        public DateTime End { get; set; }
        public CalendarEventLocation Location { get; set; }
        public string ShowAs { get; set; }
        public CalendarEventAttendee[] Attendees { get; set; }
    }

    public class CalendarEventBody
    {
        public string ContentType { get; set; }
        public string Content { get; set; }
    }

    public class CalendarEventLocation
    {
        public string DisplayName { get; set; }
    }

    public class CalendarEventAttendee
    {
        public CalendarEventEmailAddress EmailAddress { get; set; }
        public string Type { get; set; }
    }

    public class CalendarEventEmailAddress
    {
        public string Name { get; set; }
        public string Address { get; set; }
    }
}