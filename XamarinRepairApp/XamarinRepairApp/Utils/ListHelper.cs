using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Android.App;
using Android.Content;
using Android.OS;
using Android.Runtime;
using Android.Views;
using Android.Widget;
using XamarinRepairApp.Model;
using Android.Graphics;

namespace XamarinRepairApp.Utils
{
    public class ListHelper
    {
        public static async Task<int> GetPropertyIdByIncidentId()
        {
            int propertyId = 0;
            try
            {
                string select = "sl_propertyIDId";
                string filter = string.Format("ID eq {0} and sl_propertyIDId gt 0 and sl_inspectionIDId gt 0 and sl_roomIDId gt 0", App.IncidentId);
                string orderBy = "sl_date desc";

                List<ListItem> listItems = await ListClient.GetListItems("Incidents", select, string.Empty, 1, filter, orderBy);
                if (listItems != null && listItems.Any())
                {
                    propertyId = Helper.GetInt(listItems[0].mData["sl_propertyIDId"]);
                }
            }
            catch (Exception)
            {
                propertyId = 0;
            }

            return propertyId;
        }

        public static async Task<List<IncidentModel>> GetIncidents()
        {
            List<IncidentModel> incidents = new List<IncidentModel>();
            string select = "ID,Title,sl_inspectorIncidentComments,sl_dispatcherComments,sl_repairComments,sl_status,sl_type,sl_date,sl_repairCompleted,sl_propertyIDId,sl_inspectionIDId,sl_roomIDId,sl_taskId,sl_inspectionID/ID,sl_inspectionID/sl_datetime,sl_inspectionID/sl_finalized,sl_inspectionID/sl_inspector,sl_inspectionID/sl_emailaddress,sl_propertyID/ID,sl_propertyID/Title,sl_propertyID/sl_emailaddress,sl_propertyID/sl_owner,sl_propertyID/sl_address1,sl_propertyID/sl_address2,sl_propertyID/sl_city,sl_propertyID/sl_state,sl_propertyID/sl_postalCode,sl_roomID/ID,sl_roomID/Title";
            string expand = "sl_inspectionID,sl_propertyID,sl_roomID";
            string filter = string.Format("sl_propertyIDId eq {0} and sl_inspectionIDId gt 0 and sl_roomIDId gt 0", App.PropertyId);
            string orderBy = "sl_date desc";

            List<ListItem> listItems = await ListClient.GetListItems("Incidents", select, expand, 0, filter, orderBy);
            foreach (ListItem item in listItems)
            {
                incidents.Add(new IncidentModel(item.mData));
            }

            return incidents;
        }

        public static async Task<Bitmap> GetPropertyPhoto(int propertyId)
        {
            Bitmap bitmap = null;
            try
            {
                string select = "Id";
                string filter = string.Format("sl_propertyIDId eq {0}", propertyId);
                string orderBy = "Modified desc";
                List<ListItem> listItems = await ListClient.GetListItems("Property%20Photos", select, string.Empty, 1, filter, orderBy);
                if (listItems != null && listItems.Any())
                {
                    int photoId = Helper.GetInt(listItems[0].mData["Id"]);
                    if (photoId > 0)
                    {
                        string fileServerRelativeUrl = await ListClient.GetFileServerRelativeUrl("Property%20Photos", photoId);
                        if (!string.IsNullOrEmpty(fileServerRelativeUrl))
                        {
                            bitmap = await ListClient.GetFile(fileServerRelativeUrl);
                        }
                    }
                }
            }
            catch (Exception)
            {
                bitmap = null;
            }
            return bitmap;
        }

        public static async Task<Bitmap> GetIncidentPhoto(int incidentId, int inspectionId, int roomId)
        {
            Bitmap bitmap = null;
            try
            {
                string select = "Id";
                string filter = string.Format("sl_incidentIDId eq {0} and sl_inspectionIDId eq {1} and sl_roomIDId eq {2}", incidentId, inspectionId, roomId);
                string orderBy = "Modified desc";
                List<ListItem> listItems = await ListClient.GetListItems("Room%20Inspection%20Photos", select, string.Empty, 1, filter, orderBy);
                if (listItems != null && listItems.Any())
                {
                    int photoId = Helper.GetInt(listItems[0].mData["Id"]);
                    if (photoId > 0)
                    {
                        string fileServerRelativeUrl = await ListClient.GetFileServerRelativeUrl("Room%20Inspection%20Photos", photoId);
                        if (!string.IsNullOrEmpty(fileServerRelativeUrl))
                        {
                            bitmap = await ListClient.GetFile(fileServerRelativeUrl);
                        }
                    }
                }
            }
            catch (Exception)
            {
                bitmap = null;
            }
            return bitmap;
        }

        public static async Task<List<int>> GetPhotoIdCollection(string listName, int incidentId, int inspectionId, int roomId)
        {
            List<int> idCollection = new List<int>();
            try
            {
                string select = "Id";
                string filter = string.Format("sl_incidentIDId eq {0} and sl_inspectionIDId eq {1} and sl_roomIDId eq {2}", incidentId, inspectionId, roomId);
                string orderBy = "Modified desc";
                List<ListItem> listItems = await ListClient.GetListItems(listName, select, string.Empty, 1000, filter, orderBy);
                if (listItems != null && listItems.Any())
                {
                    for (int i = 0; i < listItems.Count; i++)
                    {
                        int photoId = Helper.GetInt(listItems[i].mData["Id"]);
                        if (photoId > 0)
                        {
                            idCollection.Add(photoId);
                        }
                    }
                }
            }
            catch (Exception)
            {
                idCollection = new List<int>();
            }
            return idCollection;
        }

        public static async Task<Bitmap> GetPhoto(string listName, int photoId)
        {
            Bitmap bitmap = null;
            try
            {
                string fileServerRelativeUrl = await ListClient.GetFileServerRelativeUrl(listName, photoId);
                if (!string.IsNullOrEmpty(fileServerRelativeUrl))
                {
                    bitmap = await ListClient.GetFile(fileServerRelativeUrl);
                }
            }
            catch (Exception)
            {
                bitmap = null;
            }
            return bitmap;
        }

        public static async Task<bool> UploadImage(string listName, string listName2, string imageName, Bitmap bitmap, int incidentId, int inspectionId, int roomId)
        {
            bool success = false;
            try
            {
                bool uploadSuccess = await ListClient.UploadPhoto(listName, imageName, bitmap);
                if (uploadSuccess)
                {
                    int fileId = await ListClient.GetFileId(listName, imageName);
                    if (fileId > 0)
                    {
                        string type = "SP.Data.RepairPhotosItem";
                        string metadata = string.Format("'sl_incidentIDId':{0},'sl_inspectionIDId':{1},'sl_roomIDId':{2}", incidentId, inspectionId, roomId);
                        success = await ListClient.UpdateListItem(type, metadata, listName2, fileId);
                    }
                }
            }
            catch (Exception)
            {
                success = false;
            }

            return success;
        }

        public static async Task<bool> UploadRepairComments(int incidentId, string comments)
        {
            bool success = false;
            try
            {

                string type = "SP.Data.IncidentsListItem";
                string metadata = string.Format("'sl_repairComments':'{0}'", comments);
                success = await ListClient.UpdateListItem(type, metadata, "Incidents", incidentId);
            }
            catch (Exception)
            {
                success = false;
            }

            return success;
        }

        public static async Task<bool> UploadRepairComplete(int incidentId)
        {
            bool success = false;
            try
            {
                string type = "SP.Data.IncidentsListItem";
                string metadata = string.Format("'sl_repairCompleted':'{0}','sl_status':'Repair Pending Approval'", DateTime.Now.ToString("yyyy/MM/dd"));
                success = await ListClient.UpdateListItem(type, metadata, "Incidents", incidentId);
            }
            catch (Exception)
            {
                success = false;
            }

            return success;
        }

        public static async Task<bool> UploadRepairWorkFlowTask(int taskId)
        {
            bool success = false;
            try
            {
                string type = "SP.Data.Incident_x0020_Workflow_x0020_TasksListItem";
                string metadata = "'PercentComplete':1,'Status':'Completed'";
                success = await ListClient.UpdateListItem(type, metadata, "Incident%20Workflow%20Tasks", taskId);
            }
            catch (Exception)
            {
                success = false;
            }

            return success;
        }
    }
}