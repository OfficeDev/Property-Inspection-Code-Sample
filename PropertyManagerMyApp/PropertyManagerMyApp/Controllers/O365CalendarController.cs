using SuiteLevelWebApp.Models;
using SuiteLevelWebApp.Utils;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web.Mvc;
using Microsoft.Graph;
using System.Net.Http;
using System.Net.Http.Headers;
using Newtonsoft.Json.Linq;

namespace SuiteLevelWebApp.Controllers
{
    [Authorize, HandleAdalException]
    public class O365CalendarController : Controller
    {
        public async Task<ActionResult> Index()
        {
            var graphServer = await Utils.AuthenticationHelper.GetGraphServiceAsync();
            var events = await GetEventsByRestAPI();

            return Content(events.Count.ToString());
        }

        public async Task<JsonResult> GetAvailableTimeSlots(string localTimeUtc)
        {
            // //Get the Utc time from 9 AM to 6 PM 
            DateTime startLocalTimeUtc = Convert.ToDateTime(localTimeUtc).ToUniversalTime();
            var beginTime = startLocalTimeUtc.AddHours(9);
            var endTime = startLocalTimeUtc.AddHours(18);

            // //Get all time slot that we need within 9AM - 6 PM
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

            List<CalendarEvent> myEvents = await GetEventsByRestAPI();

            // Use the ExchangeClient object to call the Calendar API.
            // Get all events that have an end time after now.
            var eventsResults = (from i in myEvents
                                 where ((i.Start >= beginTime && i.Start <= endTime) || (i.End >= beginTime && i.End <= endTime) || (i.Start <= beginTime && i.End >= endTime))
                                 select i).Take(10);

            // Order the results by start time.
            var events = eventsResults.OrderBy(e => e.Start);

            // Create a CalendarEvent object for each event returned
            // by the API.
            foreach (var calendarEvent in events)
            {
                if (calendarEvent.ShowAs == "busy")
                {
                    var Start = calendarEvent.Start;
                    var End = calendarEvent.End;

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

        private async Task<List<CalendarEvent>> GetEventsByRestAPI()
        {
            var result = new List<CalendarEvent>();
            var accessToken = AuthenticationHelper.GetGraphAccessTokenAsync();
            var restURL = string.Format("{0}/me/events", AADAppSettings.GraphResourceUrl);
            try
            {
                using (HttpClient client = new HttpClient())
                {
                    var accept = "application/json";

                    client.DefaultRequestHeaders.Add("Accept", accept);
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", await accessToken);

                    using (var response = await client.GetAsync(restURL))
                    {
                        if (response.IsSuccessStatusCode)
                        {
                            var jsonresult = JObject.Parse(await response.Content.ReadAsStringAsync());

                            foreach (var item in jsonresult["value"])
                            {
                                result.Add(new CalendarEvent
                                {
                                    Start = !string.IsNullOrEmpty(item["start"]["dateTime"].ToString()) ? DateTime.Parse(item["start"]["dateTime"].ToString()) : new DateTime(),
                                    End = !string.IsNullOrEmpty(item["end"]["dateTime"].ToString()) ? DateTime.Parse(item["end"]["dateTime"].ToString()) : new DateTime(),
                                    ShowAs = !string.IsNullOrEmpty(item["showAs"].ToString()) ? item["showAs"].ToString() : string.Empty
                                });
                            }
                        }

                        if (response.StatusCode == System.Net.HttpStatusCode.Unauthorized)
                            throw new System.Web.Http.HttpResponseException(System.Net.HttpStatusCode.Unauthorized);
                    }
                }
            }
            catch (Exception el)
            {
                el.ToString();
            }

            return result;
        }
    }

    public class CalendarEvent
    {
        public DateTime Start { get; set; }
        public DateTime End { get; set; }
        public string ShowAs { get; set; }
    }
}