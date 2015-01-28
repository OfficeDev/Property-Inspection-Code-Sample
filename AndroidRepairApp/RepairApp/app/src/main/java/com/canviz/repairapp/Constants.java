package com.canviz.repairapp;

/**
 * Created by Max Liu on 11/28/2014.
 */
public final class Constants {
    public static final String SHAREPOINT_URL = "https://TENANCY.sharepoint.com";
    public static final String SHAREPOINT_SITE_PATH = "/sites/SuiteLevelAppDemo";
    public static final String AAD_CLIENT_ID = "893001c9-3622-4191-b189-c25c16c507e4";
    public static final String AAD_AUTHORITY = "https://login.windows.net/common";
    public static final String AAD_REDIRECT_URL = "http://PropertyManagementRepairApp";
    public static final String AAD_RESOURCE_ID = SHAREPOINT_URL;
    public static final String EXCHANGE_RESOURCE_ID = "https://outlook.office365.com/";
    public static final String ENDPOINT_ID = EXCHANGE_RESOURCE_ID + "api/v1.0";

    public static final String LIST_NAME_INCIDENTS = "Incidents";
    public static final String LIST_NAME_INSPECTIONS = "Inspections";
    public static final String LIST_NAME_INCIDENTWORKFLOWTASKS = "Incident Workflow Tasks";
    public static final String LIST_NAME_PROPERTYPHOTOS = "Property Photos";
    public static final String LIST_NAME_ROOMINSPECTIONPHOTOS = "Room Inspection Photos";
    public static final String LIST_NAME_REPAIRPHOTOS = "Repair Photos";

    public static final String LOCALIMAGE_SAVEPATH="/mnt/sdcard/repair/images/";

    public static final String DISPATCHEREMAIL = "katiej@TENANCY.onmicrosoft.com";

    public static final int SUCCESS = 0x111;
    public static final int FAILED = 0x112;
}
