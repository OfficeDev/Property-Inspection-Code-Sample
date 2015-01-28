using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using Android.App;
using Android.Content;
using Android.OS;
using Android.Runtime;
using Android.Views;
using Android.Widget;
using Com.Microsoft.Aad.Adal;
using XamarinRepairApp.Model;

namespace XamarinRepairApp
{
    public class App : Application
    {
        public static String Token;

        public static String ExchangeToken;

        public static String IncidentId;

        public static String PropertyId;

        public static AuthenticationContext AuthenticationContext;

        public static IncidentModel SelectedIncidet;
    }
}