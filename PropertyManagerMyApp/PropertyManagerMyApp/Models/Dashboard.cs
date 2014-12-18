using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.Threading.Tasks;
using SuiteLevelWebApp.Utils;
using Microsoft.Office365.OutlookServices;

namespace SuiteLevelWebApp.Models
{
    public class Dashboard
    {
        #region private properties
        private Dictionary<int, string> _cachePropertyPhotos = new Dictionary<int, string>();
        private string _token = string.Empty;
        #endregion

        #region constructor
        public Dashboard(string token)
        {
            _token = token;
            HttpContext.Current.Session["SPsessionCache"] = token;
        }
        #endregion

        #region public methods
        public async Task<DashboardPropertyViewModel> GetDashboardPropertiesViewModel(int propertyId = 0)
        {
            var inspections = (await GetInspectionsByPropertyId(propertyId)).ToList();
            var incidents = (await GetIncidentsByPropertyId(propertyId)).ToList();

            DashboardPropertyViewModel viewModel = new DashboardPropertyViewModel();

            foreach (var inspection in inspections)
            {
                if (inspection.sl_propertyID != null)
                {
                    if (inspection.sl_propertyID.Id > 0)
                    {
                        inspection.sl_propertyID.propertyImgUrl = await GetPropertyPhoto(inspection.sl_propertyID.Id);

                        if (propertyId > 0 && viewModel.PropertyDetail == null)
                        {
                            viewModel.PropertyDetail = inspection.sl_propertyID;
                        }
                    }
                }
            }

            foreach (var incident in incidents)
            {
                if (incident.sl_inspectionIDId != null)
                {
                    incident.inspection = inspections.Where(i => i.Id == incident.sl_inspectionIDId.Value).FirstOrDefault();
                }

                if (incident.sl_propertyID.Id > 0)
                {
                    incident.sl_propertyID.propertyImgUrl = await GetPropertyPhoto(incident.sl_propertyID.Id);
                }
            }

            viewModel.Inspections = inspections;
            viewModel.Incidents = incidents;

            return viewModel;
        }

        public async Task<DashboardInspectionDetailsViewModel> GetDashboardInspectionDetailsViewModel(int incidentId)
        {
            var incident = await GetIncidentById(incidentId);
            Inspection inspection = null;

            if (incident.sl_inspectionIDId == null)
            {
                return null;
            }

            inspection = await GetInspectionById(incident.sl_inspectionIDId.Value);

            DashboardInspectionDetailsViewModel viewModel = new DashboardInspectionDetailsViewModel();

            viewModel.incidentId = incidentId;
            viewModel.inspection = inspection;

            if (inspection.sl_propertyID != null)
            {
                if (inspection.sl_propertyID.Id > 0)
                {
                    inspection.sl_propertyID.propertyImgUrl = await GetPropertyPhoto(inspection.sl_propertyID.Id);
                }
            }
            viewModel.incident = incident;

            if (incident.sl_repairScheduled == null)
            {
                viewModel.viewName = "schedule a repair";
                viewModel.repairPeople = await GetRepairPeople();
                viewModel.roomInspectionPhotos = await GetInspectionPhotos(inspection.Id);
                viewModel.inspectionComment = await GetInspectionComment(inspection.Id);
            }
            else if (incident.sl_repairCompleted == null)
            {
                viewModel.viewName = "repair in progress";
                viewModel.roomInspectionPhotos = await GetInspectionPhotos(inspection.Id);
                viewModel.inspectionComment = await GetInspectionComment(inspection.Id);
            }
            else if (incident.sl_repairApproved == null)
            {
                viewModel.viewName = "repair complete";
                viewModel.roomInspectionPhotos = await GetInspectionPhotos(inspection.Id);
                viewModel.inspectionComment = await GetInspectionComment(inspection.Id);
                viewModel.repairPhotos = await GetRepairPhotos(incidentId);
            }

            return viewModel;
        }
        public async Task<Event> ScheduleRepair(DashboardInspectionDetailsViewModel model)
        {
            DateTime repairDate = DateTime.Parse(model.timeSlotsSelectedValue);
            ScheduleRepairUpdate updateJson = new ScheduleRepairUpdate();
            updateJson.sl_dispatcherComments = model.dispatcherComments;
            updateJson.sl_repairScheduled = repairDate.ToUniversalTime();
            updateJson.sl_repairPerson = model.repairPeopleSelectedValue;
            updateJson.__metadata = new metadata { type = "SP.Data.IncidentsListItem" };
            await SuiteLevelWebApp.Utils.RestHelper.PostRestDataToDemoSite("/_api/lists/GetByTitle('Incidents')/Items(" + model.incidentId + ")", JsonConvert.SerializeObject(updateJson), _token);

            var incident = await GetIncidentById(model.incidentId);
            var repairPeople = await GetRepairPeopleByEmailAddress(model.repairPeopleSelectedValue);

            //create a new event 
            Attendee attendee = new Attendee
            {
                EmailAddress = new EmailAddress
                {
                    Address = repairPeople.sl_emailaddress,
                    Name = repairPeople.Title
                },
                Type = AttendeeType.Required
            };

            Attendee[] attendees = new Attendee[1];
            attendees[0] = attendee;

            Event newEvent = new Event
            {
                Subject = "Repair Event",
                Body = new ItemBody
                {
                    Content = incident.sl_dispatcherComments,
                    ContentType = BodyType.HTML
                },
                ShowAs = FreeBusyStatus.Busy,
                Start = repairDate.ToUniversalTime(),
                End = (repairDate.AddHours(1)).ToUniversalTime(),
                Location =  new Location
                {
                    DisplayName = incident.sl_roomID.Title
                },
                Attendees = attendees
            };

            return newEvent;
        }

        public async Task ApproveRepair(int incidentId)
        {
            ApproveRepairUpdate updateJson = new ApproveRepairUpdate();
            updateJson.sl_repairApproved = System.DateTime.Now;
            updateJson.__metadata = new metadata { type = "SP.Data.IncidentsListItem" };
            await SuiteLevelWebApp.Utils.RestHelper.PostRestDataToDemoSite("/_api/lists/GetByTitle('Incidents')/Items(" + incidentId + ")", JsonConvert.SerializeObject(updateJson), _token);
        }
        #endregion

        #region private methods
        private async Task<Inspection[]> GetInspectionsByPropertyId(int propertyId = 0)
        {
            string resturl = "/_api/lists/GetByTitle('Inspections')/Items?"
                + "$select=Id,sl_datetime,sl_finalized,sl_inspector,sl_emailaddress,sl_propertyID/Id,sl_propertyID/Title,sl_propertyID/sl_owner,sl_propertyID/sl_address1,sl_propertyID/sl_address2"
                + "&$expand=sl_propertyID/Id,sl_propertyID/Title,sl_propertyID/sl_owner,sl_propertyID/sl_address1,sl_propertyID/sl_address2";

            if (propertyId > 0)
            {
                resturl += string.Format("&$Filter=(sl_propertyIDId eq {0})", propertyId);
            }
            string responseString = await RestHelper.GetRestData(resturl, _token);
            return JObject.Parse(responseString)["d"]["results"].ToObject<Inspection[]>();
            
        }

        private async Task<Incident[]> GetIncidentsByPropertyId(int propertyId = 0)
        {
            string resturl = "/_api/lists/GetByTitle('Incidents')/Items?"
                + "$select=Id,sl_inspectionIDId,sl_status,sl_repairScheduled,sl_repairCompleted,sl_repairApproved,sl_propertyID/Id,sl_propertyID/Title,sl_roomID/Id,sl_roomID/Title"
                + "&$expand=sl_propertyID/Id,sl_propertyID/Title,sl_roomID/Id,sl_roomID/Title";

            if (propertyId > 0)
            {
                resturl += string.Format("&$Filter=(sl_propertyIDId eq {0})", propertyId);
            }

            string responseString = await RestHelper.GetRestData(resturl, _token);
            return JObject.Parse(responseString)["d"]["results"].ToObject<Incident[]>();
        }

        private async Task<string> GetPropertyPhoto(int Id)
        {
            if (_cachePropertyPhotos.ContainsKey(Id))
            {
                return _cachePropertyPhotos[Id];
            }
            string resturl = string.Format("/_api/lists/GetByTitle('Property Photos')/Items?$select=Id&$Filter=(sl_propertyIDId eq {0})", Id);

            string responseString = await RestHelper.GetRestData(resturl, _token);

            string id = JObject.Parse(responseString)["d"]["results"][0]["Id"].ToString();

            resturl = string.Format("/_api/lists/GetByTitle('Property Photos')/Items({0})/File?$select=ServerRelativeUrl", id);

            responseString = await RestHelper.GetRestData(resturl, _token);

            var url = JObject.Parse(responseString)["d"]["ServerRelativeUrl"].ToString();

            _cachePropertyPhotos[Id] = "/ShowImage.ashx?url=" + url;

            return _cachePropertyPhotos[Id];
        }

        private async Task<List<RoomInspectionPhoto>> GetInspectionPhotos(int inspectionId)
        {
            string resturl = string.Format("/_api/lists/GetByTitle('Room Inspection Photos')/Items?$select=Id,sl_incidentIDId,sl_roomID/Title&$expand=sl_roomID/Title&$Filter=(sl_inspectionID eq {0})", inspectionId);

            string responseString = await RestHelper.GetRestData(resturl, _token);

            List<RoomInspectionPhoto> roomInspectionPhotos = JObject.Parse(responseString)["d"]["results"].ToObject<RoomInspectionPhoto[]>().ToList();

            foreach (RoomInspectionPhoto item in roomInspectionPhotos)
            {
                resturl = string.Format("/_api/lists/GetByTitle('Room Inspection Photos')/Items({0})/File?$select=ServerRelativeUrl", item.Id);

                responseString = await RestHelper.GetRestData(resturl, _token);

                var url = JObject.Parse(responseString)["d"]["ServerRelativeUrl"].ToString();

                item.sl_roomID.imgUrl = "/ShowImage.ashx?url=" + url;
            }

            return roomInspectionPhotos;
        }

        private async Task<List<RepairPhoto>> GetRepairPhotos(int incidentId)
        {
            string resturl = string.Format("/_api/lists/GetByTitle('Repair Photos')/Items?$select=Id&$Filter=(sl_incidentID eq {0})", incidentId);

            string responseString = await RestHelper.GetRestData(resturl, _token);

            List<RepairPhoto> repairPhotos = JObject.Parse(responseString)["d"]["results"].ToObject<RepairPhoto[]>().ToList();

            foreach (RepairPhoto item in repairPhotos)
            {
                resturl = string.Format("/_api/lists/GetByTitle('Repair Photos')/Items({0})/File?$select=ServerRelativeUrl", item.Id);

                responseString = await RestHelper.GetRestData(resturl, _token);

                var url = JObject.Parse(responseString)["d"]["ServerRelativeUrl"].ToString();

                item.imgUrl = "/ShowImage.ashx?url=" + url;
            }

            return repairPhotos;
        }

        private async Task<Inspection> GetInspectionById(int id)
        {
            string resturl = "/_api/lists/GetByTitle('Inspections')/Items?"
                + "$select=Id,sl_datetime,sl_finalized,sl_inspector,sl_emailaddress,sl_propertyID/Id,sl_propertyID/Title,sl_propertyID/sl_owner,sl_propertyID/sl_address1,sl_propertyID/sl_address2"
                + "&$expand=sl_propertyID/Id,sl_propertyID/Title,sl_propertyID/sl_owner,sl_propertyID/sl_address1,sl_propertyID/sl_address2"
                + string.Format("&$Filter=(Id eq {0})", id);

            string responseString = await RestHelper.GetRestData(resturl, _token);

            return JObject.Parse(responseString)["d"]["results"].ToObject<Inspection[]>().FirstOrDefault();
        }

        private async Task<Incident> GetIncidentById(int id)
        {
            string resturl = "/_api/lists/GetByTitle('Incidents')/Items?"
                + "$select=Id,sl_inspectionIDId,sl_status,sl_type,sl_inspectorIncidentComments,sl_repairComments,sl_dispatcherComments,sl_repairScheduled,sl_repairCompleted,sl_repairApproved,sl_propertyID/Id,sl_propertyID/Title,sl_roomID/Id,sl_roomID/Title"
                + "&$expand=sl_propertyID/Id,sl_propertyID/Title,sl_roomID/Id,sl_roomID/Title"
                + string.Format("&$Filter=(Id eq {0})", id);

            string responseString = await RestHelper.GetRestData(resturl, _token);

            return JObject.Parse(responseString)["d"]["results"].ToObject<Incident[]>().FirstOrDefault();
        }

        private async Task<List<RepairPeople>> GetRepairPeople()
        {
           /* string resturl = "/_api/lists/GetByTitle('Repair People')/Items?"
                + "$select=Id,Title,sl_accountname,sl_emailaddress";

            string responseString = await RestHelper.GetRestData(resturl, _token);

            return JObject.Parse(responseString)["d"]["results"].ToObject<RepairPeople[]>();*/
            List<RepairPeople> repairlist = new List<RepairPeople>();
            AuthenticationHelper adHelp = new AuthenticationHelper();
            List<Microsoft.Azure.ActiveDirectory.GraphClient.User> allUsers = await adHelp.GetADUsersByGroupName("Repair People");
            foreach(Microsoft.Azure.ActiveDirectory.GraphClient.User user in allUsers)
            {
                RepairPeople repairPeople = new RepairPeople()
                {
                    Title = user.DisplayName,
                    sl_emailaddress = user.UserPrincipalName
                };
                repairlist.Add(repairPeople);
            }
            return repairlist;
        }

        private async Task<RepairPeople> GetRepairPeopleByEmailAddress(string userPrincipalName)
        {
            AuthenticationHelper adHelp = new AuthenticationHelper();
            Microsoft.Azure.ActiveDirectory.GraphClient.User repairPeople = await adHelp.GetADUserByPrincipalName(userPrincipalName);

            RepairPeople retRepairPeople = null;
            if(repairPeople!=null)
            {
                retRepairPeople= new RepairPeople()
                {
                    Title = repairPeople.DisplayName,
                    sl_emailaddress = repairPeople.UserPrincipalName
                };
            }
            return retRepairPeople;

            /*string resturl = "/_api/lists/GetByTitle('Repair People')/Items?"
                + "$select=Id,Title,sl_accountname,sl_emailaddress"
                + string.Format("&$Filter=(Id eq {0})", id);

            string responseString = await RestHelper.GetRestData(resturl, _token);

            return JObject.Parse(responseString)["d"]["results"].ToObject<RepairPeople[]>().FirstOrDefault();*/


        }

        private async Task<InspectionComment> GetInspectionComment(int inspectionId)
        {
            string resturl = string.Format("/_api/lists/GetByTitle('Inspection Comments')/Items?$select=Id,Title&$Filter=(sl_inspectionIDId eq {0})", inspectionId);

            string responseString = await RestHelper.GetRestData(resturl, _token);

            return JObject.Parse(responseString)["d"]["results"].ToObject<InspectionComment[]>().FirstOrDefault();
        }
        #endregion
    }

    #region viewmodles
    public class DashboardPropertyViewModel
    {
        public List<Inspection> Inspections { get; set; }
        public List<Incident> Incidents { get; set; }
        public Property PropertyDetail { get; set; }
    }

    public class DashboardInspectionDetailsViewModel
    {
        public int incidentId { get; set; }
        public string repairPeopleSelectedValue { get; set; }
        public string timeSlotsSelectedValue { get; set; }
        public string dispatcherComments { get; set; }
        public Inspection inspection { get; set; }
        public Incident incident { get; set; }
        public List<RepairPeople> repairPeople { get; set; }
        public string viewName { get; set; }
        public List<RoomInspectionPhoto> roomInspectionPhotos { get; set; }
        public InspectionComment inspectionComment { get; set; }
        public List<RepairPhoto> repairPhotos { get; set; }
        public List<TimeSlot> timeSlots { get; set; }
    }
    #endregion

    #region models

    public class TimeSlot
    {
        public int Start { get; set; }
        public string Value { get; set; }
    }
    public class Inspection
    {
        public int Id { get; set; }
        public DateTime? sl_datetime { get; set; }
        public string sl_inspector { get; set; }
        public string sl_emailaddress { get; set; }
        public Property sl_propertyID { get; set; }
        public DateTime? sl_finalized { get; set; }
    }

    //public class Inspector
    //{
    //    public int Id { get; set; }
    //    public string Title { get; set; }
    //    public string sl_emailaddress { get; set; }
    //}

    public class Property
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string sl_owner { get; set; }
        public string sl_emailaddress { get; set; }
        public string sl_address1 { get; set; }
        public string sl_address2 { get; set; }
        public string propertyImgUrl { get; set; }
    }

    public class Room
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string imgUrl { get; set; }
    }

    public class RoomInspectionPhoto
    {
        public int Id { get; set; }
        public int? sl_incidentIDId { get; set; }
        public Room sl_roomID { get; set; }
    }

    public class RepairPhoto
    {
        public int Id { get; set; }
        public string imgUrl { get; set; }
    }

    public class Incident
    {
        public int Id { get; set; }
        public Property sl_propertyID { get; set; }
        public int? sl_inspectionIDId { get; set; }
        public DateTime? sl_date { get; set; }
        public DateTime? sl_repairScheduled { get; set; }
        public DateTime? sl_repairCompleted { get; set; }
        public DateTime? sl_repairApproved { get; set; }
        public string sl_inspectorIncidentComments { get; set; }
        public string sl_dispatcherComments { get; set; }
        public string sl_repairComments { get; set; }
        public Inspection sl_inspectionID { get; set; }
        public Inspection inspection { get; set; }
        public Room sl_roomID { get; set; }
        public string sl_status { get; set; }
        public string sl_type { get; set; }
    }

    public class RepairPeople
    {
        //public int Id { get; set; }
        public string Title { get; set; }
        public string sl_emailaddress { get; set; }
    }

    public class InspectionComment
    {
        public int Id { get; set; }
        public string Title { get; set; }
    }

    public class ScheduleRepairUpdate
    {
        public metadata __metadata { get; set; }
        public DateTime sl_repairScheduled { get; set; }
        public string sl_repairPerson { get; set; }
        public string sl_dispatcherComments { get; set; }
    }

    public class ApproveRepairUpdate
    {
        public metadata __metadata { get; set; }
        public DateTime sl_repairApproved { get; set; }
    }

    public class metadata
    {
        public string type { get; set; }
    }

    #endregion
}