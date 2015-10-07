using Newtonsoft.Json.Linq;
using SuiteLevelWebApp.Utils;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;

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
        }
        #endregion

        public async Task<MailAFOViewModel> GetMailAFOViewModelAsync(int incidentId)
        {
            var incident = await GetIncidentByIdAsync(incidentId);
            Inspection inspection = null;

            if (incident == null || incident.sl_inspectionIDId == null)
            {
                return null;
            }

            inspection = await GetInspectionByIdAsync(incident.sl_inspectionIDId.Value);

            MailAFOViewModel viewModel = new MailAFOViewModel();

            viewModel.incidentId = incidentId;
            viewModel.inspection = inspection;

            if (inspection.sl_propertyID != null)
            {
                if (inspection.sl_propertyID.Id > 0)
                {
                    inspection.sl_propertyID.propertyImgUrl = await GetPropertyPhotoAsync(inspection.sl_propertyID.Id);
                }
            }
            viewModel.incident = incident;

            viewModel.roomInspectionPhotos = await GetInspectionPhotosAsync(inspection.Id);
            viewModel.inspectionComment = await GetInspectionCommentAsync(inspection.Id);

            return viewModel;
        }

        private async Task<Inspection> GetInspectionByIdAsync(int id)
        {
            string resturl = "/_api/lists/GetByTitle('Inspections')/Items?"
                + "$select=Id,sl_datetime,sl_finalized,sl_inspector,sl_emailaddress,sl_propertyID/Id,sl_propertyID/Title,sl_propertyID/sl_owner,sl_propertyID/sl_address1,sl_propertyID/sl_address2"
                + "&$expand=sl_propertyID/Id,sl_propertyID/Title,sl_propertyID/sl_owner,sl_propertyID/sl_address1,sl_propertyID/sl_address2"
                + string.Format("&$Filter=(Id eq {0})", id);

            string responseString = await RestHelper.GetDemoSiteJsonAsync(resturl, _token);

            return JObject.Parse(responseString)["d"]["results"].ToObject<Inspection[]>().FirstOrDefault();
        }

        private async Task<Incident> GetIncidentByIdAsync(int id)
        {
            string resturl = "/_api/lists/GetByTitle('Incidents')/Items?"
                + "$select=Id,sl_inspectionIDId,sl_status,sl_type,sl_inspectorIncidentComments,sl_repairComments,sl_dispatcherComments,sl_repairScheduled,sl_repairCompleted,sl_repairApproved,sl_propertyID/Id,sl_propertyID/Title,sl_roomID/Id,sl_roomID/Title"
                + "&$expand=sl_propertyID/Id,sl_propertyID/Title,sl_roomID/Id,sl_roomID/Title"
                + string.Format("&$Filter=(Id eq {0})", id);

            string responseString = await RestHelper.GetDemoSiteJsonAsync(resturl, _token);

            return JObject.Parse(responseString)["d"]["results"].ToObject<Incident[]>().FirstOrDefault();
        }

        private async Task<string> GetPropertyPhotoAsync(int Id)
        {
            if (_cachePropertyPhotos.ContainsKey(Id))
            {
                return _cachePropertyPhotos[Id];
            }
            string resturl = string.Format("/_api/lists/GetByTitle('Property Photos')/Items?$select=Id&$Filter=(sl_propertyIDId eq {0})", Id);

            string responseString = await RestHelper.GetDemoSiteJsonAsync(resturl, _token);

            string id = JObject.Parse(responseString)["d"]["results"][0]["Id"].ToString();

            resturl = string.Format("/_api/lists/GetByTitle('Property Photos')/Items({0})/File?$select=ServerRelativeUrl", id);

            responseString = await RestHelper.GetDemoSiteJsonAsync(resturl, _token);

            var url = JObject.Parse(responseString)["d"]["ServerRelativeUrl"].ToString();

            _cachePropertyPhotos[Id] = "/Photo/GetPhoto?url=" + url;

            return _cachePropertyPhotos[Id];
        }

        private async Task<List<RoomInspectionPhoto>> GetInspectionPhotosAsync(int inspectionId)
        {
            string resturl = string.Format("/_api/lists/GetByTitle('Room Inspection Photos')/Items?$select=Id,sl_incidentIDId,sl_roomID/Title&$expand=sl_roomID/Title&$Filter=(sl_inspectionID eq {0})", inspectionId);

            string responseString = await RestHelper.GetDemoSiteJsonAsync(resturl, _token);

            List<RoomInspectionPhoto> roomInspectionPhotos = JObject.Parse(responseString)["d"]["results"].ToObject<RoomInspectionPhoto[]>().ToList();

            foreach (RoomInspectionPhoto item in roomInspectionPhotos)
            {
                resturl = string.Format("/_api/lists/GetByTitle('Room Inspection Photos')/Items({0})/File?$select=ServerRelativeUrl", item.Id);

                responseString = await RestHelper.GetDemoSiteJsonAsync(resturl, _token);

                var url = JObject.Parse(responseString)["d"]["ServerRelativeUrl"].ToString();

                item.sl_roomID.imgUrl = "/Photo/GetPhoto?url=" + url;
            }

            return roomInspectionPhotos;
        }
        private async Task<InspectionComment> GetInspectionCommentAsync(int inspectionId)
        {
            string resturl = string.Format("/_api/lists/GetByTitle('Inspection Comments')/Items?$select=Id,Title&$Filter=(sl_inspectionIDId eq {0})", inspectionId);

            string responseString = await RestHelper.GetDemoSiteJsonAsync(resturl, _token);

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