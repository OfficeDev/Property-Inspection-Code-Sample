# Property Management Code Sample

> **IMPORTANT NOTE:** You must install the Web Application before the Office Add-in will work.  During the Web application installation process all of the components and sample data which support the demo are provisioned.  See the [Install Web Application README](https://github.com/OfficeDev/Property-Inspection-Code-Sample/blob/master/PropertyManagerMyApp/README.md) for complete instructions.

Office Add-in for Outlook (previously known as a Mail App for Office)
=====================================================================

The Office Add-in for Outlook and Outlook Web Access displays data from Office 365 SharePoint lists.  The Mail App for Office is implemented with two main components.

- Office Add-in – xml file installed on the 
-  tenancy as an Exchange App
- Web pages – Part of the Property Manager web app running on ASP.NET MVC

These files contain the code which implements the Office Add-in for Outlook:

- /Controllers/MailAFOController.cs
- /Views/MailAFO/Redir.cshmtl
- /Views/MailAFO/Index.cshtml
- /Models/MailAFOModel.cs
- /Models/Dashboard.cs

The sections below provide more information about these components and how to get up and running.
    
Office Add-in for Outlook
-------------------------

The Office Add-in for Outlook runs on an ASP.NET Web site.  You must configure the Office Add-in for Outlook to use the web site where you deployed the Property Manager web app.  To configure the Office Add-in for Outlook to use your web site follow these instructions.

Modify Manifest
---------------

1. Open the **MailApp Visual Studio Solution**
2. In the MailApp project, open the **MailApp.xml** file
3. Replace the **SourceLocation endpoints** in the DesktopSettings, TabletSettings, and PhoneSettings nodes with the URL to your Property Manager web app ASP.NET web site

	Use the following template for the SoureLocation URL:
	**https://&lt;Your Web Site&gt;.azurewebsites.net/Mailafo/redir**

	> **Note:** You must use an HTTPS URL for Office Add-in for Outlook.
4. Save **MailApp.xml**
5. Right click the MailApp project and select **Publish**
6. Click **Package the app**        
   
Office Add-in for Outlook Installation
--------------------------------------

1. Log into your Office 365 Tenancy with your admin account</li>
2. Click the **app launcher** button, then click the **Admin app**
![](https://raw.githubusercontent.com/OfficeDev/Property-Inspection-Code-Sample/master/Documents/Mail AFO - Admin.png)
3. In the left menu, click **Exchange**
4. Under organization, click **apps**
5. Click the **+ icon** to add a new app
6. Select **Add from file**
7. In the dialog select the **MailAppManifest.xml file** you created when you published the MailApp project
8. Click **next**
9. After the Office Add-in for Outlook is uploaded, select it in the list.  It is named **Property Details**.
10. Click the **Edit** button in the toolbar
11. In the **Specify user defaults** section, select the **Optional, enabled by default** radio button
12. Click **save**
 
**Office Add-in for Outlook Installation Complete!**

Important Authentication Note 
------------------------------
The Office Add-in for Outlook uses the SharePoint REST APIs to return list item data and pictures from the  SharePoint site collection.  The REST APIs use a different token to authenticate than the token used to authenticate to Exchange in Office 365.  

Signing into Office 365 and viewing emails does not obtain the token used to authenticate to the SharePoint site.  Furthermore, when the Office Add-in for Outlook makes the SharePoint REST API calls, the login page for the SharePoint site collection cannot be displayed because the Office 365 login page sets the X-Frame-Options to DENY.  This setting is designed to ensure the Office 365 login page cannot open in an IFRAME.  Because the Office Add-in for Outlook is displayed in an IFRAME the login page cannot be loaded.  ***Since this is the case you must first log into the SharePoint site collection before you try to access the Office Add-in for Outlook.***

To log into the SharePoint site collection, open a web browser and navigate to https://<Your Tenancy>.sharepoint.com/sites/SuitelevelAppDemo.

In future releases the Unified API will include the ability to query SharePoint list items and document libraries.  Once the Unified API includes this functionality the Office Add-in for Outlook will be updated to use the Unified API.  After the Office Add-in for Outlook has been converted to use the Unified API the separate token needed to access the SP REST APIs is no longer needed and there will be no need to  log into the SharePoint site collection before accessing the Office Add-in for Outlook.

How It Works
------------

When demo users open an email with the string **Incident ID: &lt;number&gt;** in the email body they can view the Incident details in the Office Add-in for Outlook by clicking the Property Details link.

![](https://raw.githubusercontent.com/OfficeDev/Property-Inspection-Code-Sample/master/Documents/Mail AFO - Link.png)

When the Office Add-in for Outlook loads, users are taken to a redirect page which uses office.js to extract the Incident ID from the email body.  This page includes the text **Redir** so you can see it happening in the demo.  In a production scenario you might display loading text or leave this page blank.

![](https://raw.githubusercontent.com/OfficeDev/Property-Inspection-Code-Sample/master/Documents/Mail AFO - Redir.png)

The redirect page then uses JavaScript to redirect to another controller (index.cshtml) and passes the IncidentId on the query string.  The second controller uses the IncidentId passed to it to invoke the server side Office 365 ASP.NET APIs to retrieve the data from SharePoint.

![](https://raw.githubusercontent.com/OfficeDev/Property-Inspection-Code-Sample/master/Documents/Mail AFO - Incident Details.png)

## Mail Add-in for Office Notes
The Office Add-in for Outlook included in the demo renders properly in PC web browsers but it does not render in iOS devices in Safari, the OWA app, or the native iOS email client.  At this time they are not supported in Safari, the OWA app, or the native iOS email client.

## Deep links
The links in the workflow emails which open the native iOS apps on an iOS device work when using the native iOS email client.  At this time they are not supported in Safari or the OWA app.

## License
Copyright (c) Microsoft, Inc. All rights reserved. Licensed under the Apache License, Version 2.0.