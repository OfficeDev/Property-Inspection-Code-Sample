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

namespace XamarinRepairApp.Utils
{
    public class ListItem
    {
        public JsonValue mData;
        public ListItem(JsonValue jsonValue) {
            mData = jsonValue;
        }
    }
}