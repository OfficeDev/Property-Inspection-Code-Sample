using System.Collections.Generic;
using System.Linq;
using System.Web;
using Newtonsoft.Json.Linq;
using System.Threading.Tasks;
using SuiteLevelWebApp.Utils;

namespace SuiteLevelWebApp.Models
{
    public class MailAFOModel
    {
        #region private properties
        private Dictionary<int, string> _cachePropertyPhotos = new Dictionary<int, string>();
        private string _token = string.Empty;
        #endregion

        #region constructor
        public MailAFOModel(string token)
        {
            _token = token;
            HttpContext.Current.Session["SPsessionCache"] = token;
        }
        #endregion

        public async Task<MailAFOViewModel> GetMailAFOViewModel(int incidentId)
        {
            var incident = await GetIncidentById(incidentId);
            Inspection inspection = null;

            if (incident.sl_inspectionIDId == null)
            {
                return null;
            }

            inspection = await GetInspectionById(incident.sl_inspectionIDId.Value);

            MailAFOViewModel viewModel = new MailAFOViewModel();

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

            viewModel.roomInspectionPhotos = await GetInspectionPhotos(inspection.Id);
            viewModel.inspectionComment = await GetInspectionComment(inspection.Id);

            return viewModel;
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
        private async Task<InspectionComment> GetInspectionComment(int inspectionId)
        {
            string resturl = string.Format("/_api/lists/GetByTitle('Inspection Comments')/Items?$select=Id,Title&$Filter=(sl_inspectionIDId eq {0})", inspectionId);

            string responseString = await RestHelper.GetRestData(resturl, _token);

            return JObject.Parse(responseString)["d"]["results"].ToObject<InspectionComment[]>().FirstOrDefault();
        }

        public class MailAFOViewModel
        {
            public int incidentId { get; set; }
            public int repairPeopleSelectedValue { get; set; }
            public int timeSlotsSelectedValue { get; set; }
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
    }
}