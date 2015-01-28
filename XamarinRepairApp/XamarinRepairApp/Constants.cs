using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace XamarinRepairApp
{
    public class Constants
    {
        public static readonly String SHAREPOINT_URL = "https://TENANCY.sharepoint.com";
        public static readonly String SHAREPOINT_SITE_PATH = "/sites/SuiteLevelAppDemo";
        public static readonly String AAD_CLIENT_ID = "YOUR CLIENT ID";
        public static readonly String AAD_AUTHORITY = "https://login.windows.net/common";
        public static readonly String AAD_REDIRECT_URL = "http://propertymanagementrepairapp";
        public static readonly String AAD_RESOURCE_ID = SHAREPOINT_URL;
        public static readonly String EXCHANGE_RESOURCE_ID = "https://outlook.office365.com/";
        public static readonly String ENDPOINT_ID = EXCHANGE_RESOURCE_ID + "api/v1.0";

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
