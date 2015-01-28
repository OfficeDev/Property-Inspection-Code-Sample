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

using XamarinRepairApp.Utils;

namespace XamarinRepairApp.Model
{
    public class InspectionModel
    {
        private JsonValue mData;

        public InspectionModel(JsonValue jsonValue)
        {
            mData = jsonValue;
        }

        public int GetId()
        {
            return Helper.GetInt(mData["ID"]);
        }

        public String GetDateTime()
        {
            return Helper.GetDateTime(mData["sl_datetime"]);
        }

        public String GetFinalized()
        {
            return Helper.GetDateTime(mData["sl_finalized"]);
        }

        public String GetInspector()
        {
            return Helper.GetString(mData["sl_inspector"]);
        }

        public String GetEmailaddress()
        {
            return Helper.GetString(mData["sl_emailaddress"]);
        }

    }
}