using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Json;

using Android.App;
using Android.Content;
using Android.OS;
using Android.Runtime;
using Android.Views;
using Android.Widget;
using Android.Graphics;

using XamarinRepairApp.Utils;

namespace XamarinRepairApp.Model
{
    public class IncidentModel
    {
        private JsonValue mData;

        public IncidentModel(JsonValue jsonValue)
        {
            mData = jsonValue;
        }

        public int GetId()
        {
            return Helper.GetInt(mData["ID"]);
        }

        public String GetTitle()
        {
            return Helper.GetString(mData["Title"]);
        }

        public String GetInspectorIncidentComments()
        {
            return Helper.GetString(mData["sl_inspectorIncidentComments"]);
        }

        public String GetDispatcherComments()
        {
            return Helper.GetString(mData["sl_dispatcherComments"]);
        }

        public String GetRepairComments()
        {
            return Helper.GetString(mData["sl_repairComments"]);
        }

        public void SetRepairComments(string value)
        {
            mData["sl_repairComments"] = value;
        }

        public String GetStatus()
        {
            return Helper.GetString(mData["sl_status"]);
        }

        public void SetStatus(string value)
        {
            mData["sl_status"] = value;
        }

        public String GetType()
        {
            return Helper.GetString(mData["sl_type"]);
        }

        public String GetDate()
        {
            return Helper.GetDateTime(mData["sl_date"]);
        }

        public String GetRepairCompleted()
        {
            return Helper.GetDateTime(mData["sl_repairCompleted"]);
        }

        public void SetRepairCompleted(string value)
        {
            mData["sl_repairCompleted"] = value;
        }

        public int GetPropertyId()
        {
            return Helper.GetInt(mData["sl_propertyIDId"]);
        }

        public int GetInspectionId()
        {
            return Helper.GetInt(mData["sl_inspectionIDId"]);
        }

        public int GetRoomId()
        {
            return Helper.GetInt(mData["sl_roomIDId"]);
        }

        public int GetTaskId()
        {
            return Helper.GetInt(mData["sl_taskId"]);
        }

        public InspectionModel GetInspection()
        {
            return new InspectionModel(mData["sl_inspectionID"]);
        }

        public PropertyModel GetProperty()
        {
            return new PropertyModel(mData["sl_propertyID"]);
        }

        public RoomModel GetRoom()
        {
            return new RoomModel(mData["sl_roomID"]);
        }

        private Bitmap _image;

        public Bitmap Image
        {
            get { return _image; }
            set { _image = value; }
        }

        private bool _itemChanged;

        public bool ItemChanged
        {
            get { return _itemChanged; }
            set { _itemChanged = value; }
        }

        private bool _hasChanged;

        public bool HasChanged
        {
            get { return _hasChanged; }
            set { _hasChanged = value; }
        }
    }
}