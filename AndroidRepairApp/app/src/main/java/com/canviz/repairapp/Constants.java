package com.canviz.repairapp;

public final class Constants {;
        
    public static final String AAD_CLIENT_ID = "YOUR CLIENT ID";
    public static final String AAD_REDIRECT_URL = "http://PropertyManagementRepairApp";
    public static final String AAD_AUTHORITY = "https://login.microsoftonline.com/common";

    public static final String GRAPH_RESOURCE_ID = "https://graph.microsoft.com/";
    public static final String GRAPH_RESOURCE_URL = "https://graph.microsoft.com/beta/";

    public static final String SHAREPOINT_URL = "https://TENANCY.sharepoint.com";
    public static final String SHAREPOINT_SITE_PATH = "/sites/SuiteLevelAppDemo";
    public static final String SHAREPOINT_RESOURCE_ID = SHAREPOINT_URL;

    public static final String OUTLOOK_RESOURCE_ID = "https://outlook.office365.com/";
    public static final String ONENOTE_RESOURCE_ID = "https://onenote.com/";
    public static final String ONENOTE_RESOURCE_URL = "https://www.onenote.com/api/beta/";
    public static final String ONENOTE_NAME = "Contoso Property Management";
    public static final String VIDEO_RESOURCE_URL = "https://TENANCY.sharepoint.com/portals/hub";
    public static final String VIDEO_CHANNEL_NAME = "Incidents";

    public static final String DISPATCHEREMAIL = "katiej@TENANCY.onmicrosoft.com";
    public static final String LIST_NAME_INCIDENTS = "Incidents";
    public static final String LIST_NAME_INSPECTIONS = "Inspections";
    public static final String LIST_NAME_INCIDENTWORKFLOWTASKS = "Incident Workflow Tasks";
    public static final String LIST_NAME_PROPERTYPHOTOS = "Property Photos";
    public static final String LIST_NAME_ROOMINSPECTIONPHOTOS = "Room Inspection Photos";
    public static final String LIST_NAME_REPAIRPHOTOS = "Repair Photos";
    public static final String LOCALIMAGE_SAVEPATH="/mnt/sdcard/repair/images/";

    public static final int SUCCESS = 0x111;
    public static final int FAILED = 0x112;
}
