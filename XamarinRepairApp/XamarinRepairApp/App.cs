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
using Microsoft.IdentityModel.Clients.ActiveDirectory;
using XamarinRepairApp.Model;
using MSGraph = Microsoft.Graph;

namespace XamarinRepairApp
{
    public class App : Application
    {
        public static String Token;

        public static int IncidentId;

        public static String PropertyId;

        public static IncidentModel SelectedIncidet;

		public static MSGraph.GraphService GraphService;
    }
}