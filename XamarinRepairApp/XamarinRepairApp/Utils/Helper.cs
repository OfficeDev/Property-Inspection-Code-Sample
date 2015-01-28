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
    public class Helper
    {
        public static int GetInt(JsonValue value) {
            try
            {
                int temp = 0;
                if (value != null && !string.IsNullOrEmpty(value.ToString())) {
                    int.TryParse(value.ToString(), out temp);
                }
                return temp;
            }
            catch {
                return 0;
            }
        }

        public static string GetString(JsonValue value)
        {
            try
            {
                string temp = string.Empty;
                if (value != null && !string.IsNullOrEmpty(value.ToString()))
                {
                    temp = value.ToString().TrimStart('"').TrimEnd('"');
                }
                return temp;
            }
            catch
            {
                return string.Empty;
            }
        }

        public static string GetDateTime(JsonValue value)
        {
            try
            {
                DateTime temp;
                string dateTime = string.Empty;
                string dateTimeStr = GetString(value);
                if (value != null && !string.IsNullOrEmpty(dateTimeStr))
                {
                    if (DateTime.TryParse(dateTimeStr, out temp))
                    {
                        dateTime = temp.ToString("MM/dd/yyyy");
                    }
                }
                return dateTime;
            }
            catch
            {
                return string.Empty;
            }
        }

        public static string GetImageName()
        {
            DateTime date = DateTime.Now;
            return date.ToString("yyMMddHHmmssfff") + ".jpg";
        }
    }
}