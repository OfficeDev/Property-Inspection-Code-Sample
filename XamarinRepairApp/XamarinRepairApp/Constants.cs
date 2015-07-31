using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace XamarinRepairApp
{
	public class Constants
	{
		public static readonly String AAD_CLIENT_ID = "YOUR CLIENT ID";
		public static readonly String AAD_REDIRECT_URL = "http://propertymanagementrepairapp";
		public static readonly String AAD_AUTHORITY = "https://login.microsoftonline.com/common";

		public static readonly String GraphResourceId = "https://graph.microsoft.com/";
		public static readonly String GraphResourceUrl = "https://graph.microsoft.com/beta/";

		public static readonly String SHAREPOINT_URL = "https://TENANCY.sharepoint.com";
		public static readonly String SHAREPOINT_SITE_PATH = "/sites/SuiteLevelAppDemo";
		public static readonly String AAD_RESOURCE_ID = SHAREPOINT_URL;

		public static readonly String LIST_NAME_INCIDENTS = "Incidents";
		public static readonly String LIST_NAME_INSPECTIONS = "Inspections";
		public static readonly String LIST_NAME_INCIDENTWORKFLOWTASKS = "Incident Workflow Tasks";
		public static readonly String LIST_NAME_PROPERTYPHOTOS = "Property Photos";
		public static readonly String LIST_NAME_ROOMINSPECTIONPHOTOS = "Room Inspection Photos";
		public static readonly String LIST_NAME_REPAIRPHOTOS = "Repair Photos";

		public static readonly String DISPATCHEREMAIL = "katiej@TENANCY.onmicrosoft.com";

		public static readonly int SUCCESS = 0x111;
		public static readonly int FAILED = 0x112;
	}	   
}
