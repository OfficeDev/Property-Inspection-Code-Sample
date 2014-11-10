using Microsoft.Office365.OutlookServices;
using SuiteLevelWebApp.Models;
using SuiteLevelWebApp.Utils;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web.Mvc;

namespace SuiteLevelWebApp.Controllers
{
    [Authorize, HandleAdalException]
    public class O365CalendarController : Controller
    {
        public static async Task Create(Event newEvent)
        {
            var client = await O365Util.GetOutlookClient(Capabilities.Calendar);

            await client.Me.Events.AddEventAsync(newEvent);
        }
        // GET: O365Calendar
        public async Task<ActionResult> Index()
        {
            List<CalendarEvent> myEvents = new List<CalendarEvent>();

            // Call the GetExchangeClient method, which will authenticate
            // the user and create the ExchangeClient object.
            var client = await O365Util.GetOutlookClient(Capabilities.Calendar);

            // Use the ExchangeClient object to call the Calendar API.
            // Get all events that have an end time after now.
            var eventsResults = await (from i in client.Me.Events
                                       //where i.End >= DateTimeOffset.UtcNow
                                       select i).Take(10).ExecuteAsync();

            // Order the results by start time. 
            var events = eventsResults.CurrentPage.OrderBy(e => e.Start);

            // Create a CalendarEvent object for each event returned
            // by the API.
            foreach (Event calendarEvent in events)
            {
                CalendarEvent newEvent = new CalendarEvent();
                newEvent.Subject = calendarEvent.Subject;
                newEvent.Location = new CalendarEventLocation { DisplayName = calendarEvent.Location.DisplayName };
                newEvent.Start = calendarEvent.Start.GetValueOrDefault().DateTime;
                newEvent.End = calendarEvent.End.GetValueOrDefault().DateTime;

                myEvents.Add(newEvent);
            }
            return View(myEvents);
        }

        public async Task<JsonResult> GetAvailableTimeSlots(string localTimeUtc)
        {
            // Call the GetExchangeClient method, which will authenticate
            // the user and create the ExchangeClient object.
            var client = await O365Util.GetOutlookClient(Capabilities.Calendar);

            //Get the Utc time from 9 AM to 6 PM 
            DateTime startLocalTimeUtc = Convert.ToDateTime(localTimeUtc).ToUniversalTime();
            var beginTime = startLocalTimeUtc.AddHours(9);
            var endTime = startLocalTimeUtc.AddHours(18);

            //Get all time slot that we need within 9AM - 6 PM
            List<TimeSlot> timeSlots = new List<TimeSlot>();
            for (var i = 9; i < 18; i++)
            {
                TimeSlot timeSlot = new TimeSlot
                {
                    Start = i,
                    Value = string.Format("{0}:00 - {1}:00", i, i + 1)
                };
                timeSlots.Add(timeSlot);
            }

            List<CalendarEvent> myEvents = new List<CalendarEvent>();

            // Use the ExchangeClient object to call the Calendar API.
            // Get all events that have an end time after now.
            var eventsResults = await (from i in client.Me.Events
                                       where ((i.Start >= beginTime && i.Start <= endTime) || (i.End >= beginTime && i.End <= endTime) || (i.Start <= beginTime && i.End >= endTime))
                                       select i).Take(10).ExecuteAsync();

            // Order the results by start time.
            var events = eventsResults.CurrentPage.OrderBy(e => e.Start);

            // Create a CalendarEvent object for each event returned
            // by the API.
            foreach (Event calendarEvent in events)
            {
                if (calendarEvent.ShowAs == FreeBusyStatus.Busy)
                {
                    var Start = calendarEvent.Start.GetValueOrDefault().DateTime;
                    var End = calendarEvent.End.GetValueOrDefault().DateTime;

                    //Remove all time slot which is between Start and End
                    RemoveBusyTime(startLocalTimeUtc, timeSlots, Start, End);
                }
            }

            return Json(timeSlots, JsonRequestBehavior.AllowGet);
        }

        private void RemoveBusyTime(DateTime startLocalTimeUtc, List<TimeSlot> timeSlots, DateTime start, DateTime end)
        {

            if (timeSlots != null && timeSlots.Count > 0)
            {
                for (int i = timeSlots.Count - 1; i >= 0; i--)
                {
                    var beginTimeSpan = startLocalTimeUtc.AddHours(Convert.ToInt32(timeSlots[i].Value.Split('-')[0].Trim().Split(':')[0]));
                    var endTimeSpan = startLocalTimeUtc.AddHours(Convert.ToInt32(timeSlots[i].Value.Split('-')[1].Trim().Split(':')[0]));

                    if (beginTimeSpan >= start && endTimeSpan <= end)
                    {
                        timeSlots.RemoveAt(i);
                    }
                }
            }
        }
    }
}