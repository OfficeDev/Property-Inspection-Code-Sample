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
    public class RoomModel
    {
        private JsonValue mData;

        public RoomModel(JsonValue jsonValue)
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
    }
}