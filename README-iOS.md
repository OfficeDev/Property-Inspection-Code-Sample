# Property Inspection Code Sample

Install iOS Apps
================

The demo relies upon the iOS inspection app to function end to end.  Some configuration is required to enable the iOS Apps to work with an O365 environment.  Read on to learn about the configuration process.

Azure Active Directory Application
----------------------------------

The iOS Apps use O365 APIs and SharePoint REST APIs to interact with an O365 / Azure tenancy.  The Azure Active Directory Application is used to authorize the iOS Apps.  To register the iOS Apps with an Azure Active Directory follow these instructions.

Create Azure Active Directory App for the iPad Apps
---------------------------------------------------

1. Open the Azure Management Portal
2. Select **Active Directory**
3. Click on your Azure Active Directory
4. Click **Applications**
5. Click **Add**
6. Click **Add an application my organization is developing**
7. In the Name textbox enter **PropertyManagementiOSiPadApp**
8. For Type, select **NATIVE CLIENT APPLICATION**
9. Click the **Arrow button**
10. In the Redirect URI textbox enter **http://PropertyManagementiOSiPadApp**
11. Click the **Checkmark button**
12. Expand the update your code section and **copy** the Redirect URI and Client ID values and **paste** them into a text file.  You will use these values when you configure the iPad app on your iPad.
13. Click **CONFIGURE**
14.	In the permissions to other applications section, click the **Add application** button.
15.	Click the + button next to **Office 365 SharePoint Online** and **Office 365 unified API (preview)**.
16.	Click the **Checkmark button**
17.	Configure the permission to Office 365 unified API (preview), use the screenshot below for reference.
![](https://raw.githubusercontent.com/OfficeDev/Property-Inspection-Code-Sample/master/Documents/O365 Unified API AD Permissions.jpg)
18.	Configure the permission to Microsoft Office 365 SharePoint, use the screenshot below for reference.
![](https://raw.githubusercontent.com/OfficeDev/Property-Inspection-Code-Sample/master/Documents/O365 SP AAD App Permissions.jpg)
19. Click **Save**

iOS Apps Installation
---------------------

Now you are ready to install the iOS Apps.  

In the iOSInspectionApp and iOSRepairApp folder you will find runnable sample code for iOS Apps.

1. On a Mac machine, clone the GitHub repository.  

The samples utilize Cocoapods to configure both the Office365 SDKs and ADAL.  To use Cocoapods to add the SDKs to the workspaces perform these steps for both the Inspection and Repair iOS Apps.

1. Open Terminal.
2. Navigate to inside the project's folder.
3. Run `pod install`.
4. Run `open iOSInspectionApp.xcworkspace` or `open iOSRepairApp.xcworkspace` to open the workspace with all projects and dependencies loaded appropriately.

See the screenshot of these commands being run in the terminal below for reference.

![](https://raw.githubusercontent.com/OfficeDev/Property-Inspection-Code-Sample/master/Documents/pod install.png)

> For more info on Cocoapods setup see the Office 365 SDK for iOS [wiki](https://github.com/OfficeDev/Office-365-SDK-for-iOS/wiki/Cocoapods-Setup) and [their site](http://cocoapods.org).

iOS Apps Configuration
----------------------

After the Coacoa Pods are registered, you need to configure the apps to work with the O365 / Azure Tenancy and the Azure Active Directory Application you created.  This section describes how to do it.

Configure iPad Apps settings
----------------------------

To configure the iPad Apps settings follow these instructions.  You need to perform these same steps for both the Inspection and Repair iOS apps.

1. In XCode, run the **iPad App**.
2. After the iPad App is loaded and the Sign In screen is displayed, push the **home button** two times and close/terminate the running instance of the application.

	> On the iPad simulator, press command + shift + H to simulate the Home button.

3. Next, open the **native iOS Settings App**.
4. In the left column, tap the **name of the app**.
5. Enter the values which correspond to the Azure Active Directory application you created for the iPad Apps.
6. Enter the URL to the Site Collection created by the Property Manager web app.
7. Enter the email address for the Dispatcher. (katiej&#64;&lt;Your Tenancy&gt;.onmicrosoft.com)

These are the values that must be configured.

- **clientID** This is the value you copied and pasted in the steps above.  This value is also displayed in the CONFIGURE page for the iOSiPadApp Azure Active Directory Application in the Azure Management Portal.
- **redirectUriString** This is the value you copied and pasted in the steps above.  This value is also displayed in the CONFIGURE page for the iOSiPadApp Azure Active Directory Application in the Azure Management Portal.
- **demoSiteServiceResourceId** Url for the root Site Collection in the O365 Tenancy. Use the same value you configured in the web.config for the Property Manager web app for the DemoSiteServiceResourceId app setting.
- **demoSiteCollectionUrl** Url for the Site Collection created by the Property Manager web app.  Use the same value you configured in the web.config for the Property Manager web app for the DemoSiteCollectionUrl app setting.
- **dispatcherEmail** Email address for the dispatcher account you created.

**iOS Apps Installation Complete!**

## License
Copyright (c) Microsoft, Inc. All rights reserved. Licensed under the Apache License, Version 2.0.


