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
    public class PropertyModel
    {
        private JsonValue mData;

        public PropertyModel(JsonValue jsonValue)
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

        public String GetEmail()
        {
            return Helper.GetString(mData["sl_emailaddress"]);
        }

        public String GetOwner()
        {
            return Helper.GetString(mData["sl_owner"]);
        }

        public String GetAddress1()
        {
            return Helper.GetString(mData["sl_address1"]);
        }

        public String GetAddress2()
        {
            return Helper.GetString(mData["sl_address2"]);
        }

        public String GetCity()
        {
            return Helper.GetString(mData["sl_city"]);
        }

        public String GetState()
        {
            return Helper.GetString(mData["sl_state"]);
        }

        public String GetPostalCode()
        {
            return Helper.GetString(mData["sl_postalCode"]);
        }
    }
}