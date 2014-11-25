# Property Inspection Code Sample

**Table of Contents**

- [Overview](#overview)
- [My App Installation](#install-myapp)
- [iOS Installation](#install-ios)
- [Mail App for Office Installation](#install-mailapp)
- [Running the sample end to end](#running)
- [API Notes](#apis)
- [Mail App for Office Notes](#mailafo)
- [Links that open native iOS Apps Notes](#deeplinks)
- [Working with the iOS apps in XCode](#xcode)
- [Contributing](#contributing)
- [License](#license)

## Overview
The Property Inspection Code Sample demonstrates how to create a line of business system with O365 and mobile technologies.

You can see the demo in action in the [Office 365 Developer Kick Off session] (http://channel9.msdn.com/events/TechEd/Europe/2014/DEV-B207) from TechEd Europe 2014.

![](https://raw.githubusercontent.com/OfficeDev/Property-Inspection-Code-Sample/master/Documents/demo_video_thumb.png)

The [MS Open Tech](http://msopentech.com)'s open source project **Office 365 SDK for iOS** is used to integrate the iOS Apps with several O365 services.

**Where can I find things in this repo?**

- The iOS Repair App is located in the iOSInspectionApp folder.
- The iOS Inspection App is located in the iOSRepairApp folder.
- The Property Manager My App is located in the PropertyManagerMyApp folder.
- The Mail App for Office is located in the MailApp folder.

**Property Management My App - A Line Of Business Application**

The Property Manager My App demonstrates many different patterns used in real world scenarios.  At a high level, the Property Manager My App does the following things.

- Provisions the Site Collection used by the Property Manager My App
- Provisions information architecture and supporting components into the new Site Collection
- Provisions content into the new Site Collection
- Serves as a line of business application

This Property Manager My App provides a dashboard application used in a property management scenario.
This dashboard is used by dispatchers at the property management company's home office to coordinate inspections and repairs.
The dashboard uses O365 APIs and the SharePoint REST APIs to read and write information in Exchange and SharePoint.

The sections below provide more information about these patterns and how to get up and running.

**iOS Applications**

The iOS Apps demonstrate many different patterns used in real world scenarios.  At a high level, the iOS Apps do the following things.

- Provide property inspectors and repair people information about properties they are scheduled to inspect and repair.
- Allow property inspectors and repair people to submit photos and comments about inspections, incidents, and repairs.

The sections below provide more information about these iOS Apps and how to get up and running.

**Mail App for Office**

The Mail App for Office uses Outlook and Outlook Web Access to display data from Office 365 SharePoint lists.  The Mail App for Office is implemented with two main components.

- Mail App for Office – xml file installed on the O365 tenancy as an Exchange App
- Web pages – Part of the Property Manager My App running on ASP.NET MVC

These files contain the code which implements the Mail App for Office:

- /Controllers/MailAFOController.cs
- /Views/MailAFO/Redir.cshmtl
- /Views/MailAFO/Index.cshtml
- /Models/MailAFOModel.cs
- /Models/Dashboard.cs

The sections below provide more information about these components and how to get up and running.

## Install-MyApp
To set up and configure the demo first download the Property Manager My App and open it in Visual Studio 2013.

To register the Property Manager My App with your Azure Active Directory right click the PropertyManagerMyApp project and select Add -> Connected Service.  Authenticate with the credentials associated with your tenancy and use the wizard to configure the appropriate permissions.  The following images demonstrate how your app settings and api permissions should be configured for the Property Manager My App to work.

O365 API Calendar Permissions

![](https://raw.githubusercontent.com/OfficeDev/Property-Inspection-Code-Sample/master/Documents/O365 API Calendar Permissions.jpg)

O365 API Mail Permissions

![](https://raw.githubusercontent.com/OfficeDev/Property-Inspection-Code-Sample/master/Documents/O365 API Mail Permissions.jpg)

O365 API Sites Permissions

![](https://raw.githubusercontent.com/OfficeDev/Property-Inspection-Code-Sample/master/Documents/O365 API Sites Permissions.jpg)

O365 API AD Permissions

![](https://raw.githubusercontent.com/OfficeDev/Property-Inspection-Code-Sample/master/Documents/O365 API AD Permissions.jpg)

O365 App Settings

![](https://raw.githubusercontent.com/OfficeDev/Property-Inspection-Code-Sample/master/Documents/O365 App Settings.jpg)

**web.config**
The Property Manager My App stores configuration settings in the web.config file.  These settings must be configured for your environment in order for the Property Manager My App to work.  The Add Connected Service wizard creates some of these settings in the web.config file when it registers you app with Azure Active Directory.  These settings the Add Connected Service wizard creates include:

- ida:ClientID
- ida:Password
- ida:AuthorizationUri

In addition to the settings above, other settings exist which allow you to perform additional required configuration values.  These settings include:

- **ServiceResourceId** Url for the O365 tenant admin site
- **DashboardServiceResourceId** Url for the root Site Collection in the O365 Tenancy
- **DashboardServiceEndpointUri** Api Endpoint for the Site Collection used by the Property Manager My App
- **DemoSiteServiceResourceId** Url for the root Site Collection in the O365 Tenancy
- **DemoSiteCollectionUrl** Url used to create the Site Collection used by Property Manager My App
- **O365SvcResourceId** Url for the O365 Discovery Service
- **O365SvcEndpointUri** Api Endpoint for the O365 Discovery Service API
- **DemoSiteCollectionOwner** Email address for Site Collection owner (admin&#64;&lt;Your Tenancy&gt;.onmicrosoft.com)
- **DispatcherName** Display Name for Dispatcher (Katie Jordan)
- **DispatcherEmail** Email address for Dispatcher (katiej&#64;&lt;Your Tenancy&gt;.onmicrosoft.com)

Configure these settings in the web.config file to match your O365 / Azure Tenancy.

**Azure Active Directory User Accounts**
The Property Manager My App and demo rely on Azure Active Directory Accounts to work.  Create the following users in Azure Active Directory.  Note: It may take up to 24 hours for the O365 infrastructure to create an Exchange Mailbox and Calendar.

- Inspector: Rob Barker alias: robb
- Dispatcher: Katie Jordan alias: katiej
- Repair Person: Ron Gabel alias: rong
- Property Owner: Margaret Au alias: marga
- Inspector: Alisa Lawyer alias: alisal
- Repair Person: Chris Gray alias: chrisg
- Property Owner: Steven Wright alias: stevenw

**Trusted Sites**
Add **http://localhost** to the Trusted Sites list in Internet Explorer.

- Site Collection Provisioning

The O365SiteProvisingController is used to create the Site Collection used to store data and facilitate workflow for the Property Manager My App.

First, this controller retrieves an access token for the tenancy admin Site Collection.
Then it uses the access token to authenticate the call to determine if the Site Collection exists.

If the Site Collection exists this controller then redirects to the DashboardController.

If the Site Collection does not exist then the controller creates the Site Collection.

After the Site Collection is created the controller signs out from O365 and retrieves an access token for the new Site Collection.

Then it uses the access token to authenticate the calls to create the information architecture and supporting components in the new Site Collection.

Finally, the controller creates content in the new site collection to support the demo and redirects to the DashboardController.

These files contain the code which implements the Site Collection provisioning functionality:

- /Controllers/O365SiteProvisioningController.cs
- /Util/csomUtil.cs
- /Util/SiteProvisioning.cs
- /Views/O365SiteProvisioning/CreateSiteCollection.cshmtl
- /Views/O365SiteProvisioning/Index.cshtml
- /Views/O365SiteProvisioning/ProvisioningSiteComponents.cshmtl
- /Content/SampleData.xml

After you have performed the configuration steps described above, provision the Site Collection and content.

In your web browser, navigate to **http://localhost:41322/O365SiteProvisioning** to invoke the O365SiteProvisioning controller and create the Site Collection and content.

**User Account Permission**

After you have provisioned the Site Collection and content you must grant Member access to the Dispatcher account.

- Dispatcher: Katie Jordan alias: katiej

**Property Manager My App Configuration**
If you wish to add a custom logo to your Property Manager My App you can update the logo corresponding to the AAD App Visual Studio creates in your AAD.  Use the following file you can find in the PropertyManagementMyApp Visual Studio Solution.  **/Content/Images/AADAppLogos/logo-prop-man.jpg**

**Property Manager My App Installation Complete!**

Now you can access the Property Manager My App dashboard landing page.

In your web browser, navigate to **http://localhost:44312/Dashboard** to open the dashboard landing page.

## Install-iOS

The demo also relies upon iOS Apps to function end to end.  Some configuration is required to enable the iOS Apps to work with an O365 environment.  Read on to learn about the configuration process.

**Azure Active Directory Apps**
The iOS Apps use O365 APIs and SharePoint REST APIs to interact with an O365 / Azure tenancy.  The Azure Active Directory Applications are used to authorize the iOS Apps.  To register the iOS Apps with an Azure Active Directory follow these instructions.

**Create Azure Active Directory App for the iPad Apps**

1. Open the Azure Management Portal
2.     Select **Active Directory**
3.     Click on your AAD
4.     Click **Applications**
5.     Click **Add**
6.     Click **Add an application my organization is developing**
7.     In the Name textbox enter **PropertyManagementiOSiPadApp**
8.     For Type, select **NATIVE CLIENT APPLICATION**
9.     Click the **Arrow button**
10.    In the Redirect URI textbox enter **http://PropertyManagementiOSiPadApp**
11.    Click the **Checkmark button**
12.    Expand the update your code section and **copy** the Redirect URI and Client ID values and **paste** them into a text file.  You will use these values when you configure the iPad app on your iPad.
13.    Click **Configure**
14.    In the permissions to other applications section, click the dropdown list next to Windows Azure Active Directory and select the following permissions.
![](https://raw.githubusercontent.com/OfficeDev/Property-Inspection-Code-Sample/master/Documents/iOS App AAD Perms.png)
15.    Configure the permissions to Exchange, use the screenshot below for reference.
![](https://raw.githubusercontent.com/OfficeDev/Property-Inspection-Code-Sample/master/Documents/iOS App Exchange Perms.png)
16.    Configure the permissions to SharePoint, use the screenshot below for reference.
![](https://raw.githubusercontent.com/OfficeDev/Property-Inspection-Code-Sample/master/Documents/iOS App SP Perms.png)
17.    Click **Save**

**iOS App Installation**

Now you are ready to install the iOS Apps.  This section provides details about your installation options.

The easiest way to install the iOS apps to your iPad is to download the .ipa files to your computer and install them on your iPad.  iFunBox is a tool capable of deploying iOS Apps to a non-rooted iPad.

Optionally, you can clone the GitHub repository and load the iOS App Workspaces in XCode then run them in the iOS Simulator or deploy them to an iPad.  This option requires a Mac and XCode.  If you choose this option please see the installation notes in the [XCode](#xcode) section which describe how to register the CocoaPods with the iOS projects.  The CocoaPods must be installed to enable the iOS Apps project workspaces to build and run.

**Note:** A Mac and XCode is required if you wish to debug the iOS code.

**iOS App Configuration**
After the iOS Apps are deployed, you need to configure them to work with an O365 / Azure Tenancy and the Azure Active Directory Applications you created.

**Configure iPad Apps settings**

To configure the iPad Apps settings follow these instructions.  You need to perform these same steps for both the Inspection and Repair iOS apps.

1. Tap the **iPad App** on the iPad to open it.After the iPad App is loaded and the Sign In screen is displayed, push the **home button** two times and close the running instance of the application.
2. Next, open the **native iOS Settings App**.
3. In the left column, tap the **name of the app**.
4. Enter the values which correspond to the Azure Active Directory application you created for the iPad Apps.
5. Enter the URL to the Site Collection created by the Property Manager My App.
6. Enter the email address for the Dispatcher. (katiej&#64;&lt;Your Tenancy&gt;.onmicrosoft.com)

These are the values that must be configured.

- **clientID** This is the value you copied and pasted in the steps above.  This value is also displayed in the CONFIGURE page for the iOSiPadApp Azure Active Directory Application in the Azure Management Portal.
- **redirectUriString** This is the value you copied and pasted in the steps above.  This value is also displayed in the CONFIGURE page for the iOSiPadApp Azure Active Directory Application in the Azure Management Portal.
- **authority** This value is partially displayed in the VIEW ENDPOINTS popup page for the Azure Active Directory Application in the Azure Management Portal.  Use the domain associated with the OAUTH 2.0 TOKEN ENDPOINT.  If you are running on production O365 this value is https://login.windows.net.
- **resourceId** This value is partially displayed in the VIEW ENDPOINTS popup page for the Azure Active Directory Application in the Azure Management Portal.  Use the domain associated with the OAUTH 2.0 TOKEN ENDPOINT and append /common to it.  If you are running on production O365 this value is https://login.windows.net/common.
- **demoSiteCollectionUrl** Url for the Site Collection created by the Property Manager My App.  Use the same value you configured in the web.config for the Property Manager My App for the DemoSiteCollectionUrl app setting.
- **dispatcherEmail** Email address for the dispatcher account you created.

**iOS Apps Installation Complete!**

## Install-MailApp

Some configuration is required to enable the Mail App for Office to work with an O365 environment.  Read on to learn about the configuration process.
    
**Mail App for Office**

The Mail App for Office runs on an ASP.NET Web site.  You must configure the Mail App for Office to use the web site where you deployed the Property Manager My App.  To configure the Mail App for Office to use your web site follow these instructions.

**Modify Manifest**

1. Open the **MailAFO Visual Studio Solution**
2. In the MailAFO project, open the **MailAFO.xml** file
3. Replace the **SourceLocation endpoints** in the DesktopSettings, TabletSettings, and PhoneSettings nodes with the URL to your Property Manager My App ASP.NET web site

	Use the following template for the SoureLocation URL:
	**https://&lt;Your Web Site&gt;.azurewebsites.net/Mailafo/redir**
4. Save **MailApp.xml**
5. Right click the MailApp project and select **Publish**
6. Click **Package the app**        
   
**Mail App for Office Installation**

1. Log into your O365 Tenancy with your admin account</li>
2. Click the **waffle** button, then click the **Admin app**
![](https://raw.githubusercontent.com/OfficeDev/Property-Inspection-Code-Sample/master/Documents/Mail AFO - Admin.png)
3. In the left menu, click **Exchange**
4. Under organization, click **apps**
5. Click the **+ icon** to add a new app
6. Select **Add from file**
7. In the dialog select the **MailAppManifest.xml file** you created when you published the MailApp project
8. Click **next**
 
**Mail App for Office Installation Complete!**

When demo users open an email with the string **Incident ID: &lt;number&gt;** in the email body they can view the Incident details in the Mail App for Office by clicking the Property Details link.

![](https://raw.githubusercontent.com/OfficeDev/Property-Inspection-Code-Sample/master/Documents/Mail AFO - Link.png)

When the Mail App for Office loads, users are taken to a redirect page which uses office.js to extract the Incident ID from the email body.  This page includes the text **Redir** so you can see it happening in the demo.  In a production scenario you might display loading text or leave this page blank.

![](https://raw.githubusercontent.com/OfficeDev/Property-Inspection-Code-Sample/master/Documents/Mail AFO - Redir.png)

The redirect page then uses JavaScript to redirect to another controller (index.cshtml) and passes the IncidentId on the query string.  The second controller uses the IncidentId passed to it to invoke the server side O365 ASP.NET APIs to retrieve the data from SP.

![](https://raw.githubusercontent.com/OfficeDev/Property-Inspection-Code-Sample/master/Documents/Mail AFO - Incident Details.png)

## Running
The [PowerPoint slide deck] (https://github.com/OfficeDev/Property-Inspection-Code-Sample/blob/master/Documents/Demo%20Prep%20And%20Walkthrough.pptx) describes how to prep your environment with sample data and execute the sample scenario end to end.  It also describes all of the different places where data is created or updated throughout the entire scenario.  This is an excellent place to see what this demo really does and how the scenario in it unfolds.

## APIs
When this demo was built the O365 SDKs for ASP.Net and iOS were in the alpha/beta stages.  Consequently, some of the code in the demo uses REST based approaches to perform operations with O365 services like SharePoint and Exchange.  The following parts of the sample use REST based approaches to access O365 Services.

* Working with Files in the iOS Apps and My Apps.  See [MS Open Tech](http://msopentech.com)'s open source project **Office 365 SDK for iOS** to see how this is done.
* Sending Email with attachments in the Property Manager My App.  See the Office 365 SDK for ASP.NET to see how this is done.  The sample sends email from the Property Manager My App, but no attachments are included.

## MailAFO
The Mail App for Office included in the demo renders properly in PC web browsers but it does not render in iOS devices in Safari, the OWA app, or the native iOS email client.  At this time they are not supported in Safari, the OWA app, or the native iOS email client.

## Deeplinks
The links in the workflow emails which open the native iOS apps on an iOS device work when using the native iOS email client.  At this time they are not supported in Safari or the OWA app.

## XCode
In the iOSInspectionApp and iOSRepairApp folder you will find runnable sample code for iOS Apps which use Outlook Services (aka Exchange), Files Services (aka Drive), and the Discovery Service.

The samples utilize Cocoapods to configure both the Office365 SDKs and ADAL.

Here's how to run these samples.  You need to perform these steps for both the Inspection and Repair iOS Apps.

1. Open Terminal.
2. Navigate to inside the project's folder.
3. Run `pod install`.
4. Run `open iOSInspectionApp.xcworkspace` or `open iOSRepairApp.xcworkspace` to open the workspace with all projects and dependencies loaded appropriately.

> For more info on Cocoapods setup see the Office 365 SDK for iOS [wiki](https://github.com/OfficeDev/Office-365-SDK-for-iOS/wiki/Cocoapods-Setup) and [their site](http://cocoapods.org).

## Contributing
You will need to sign a [Contributor License Agreement](https://cla.msopentech.com/) before submitting your pull request. To complete the Contributor License Agreement (CLA), you will need to submit a request via the form and then electronically sign the Contributor License Agreement when you receive the email containing the link to the document. This needs to only be done once for any Microsoft Open Technologies OSS project.

## License
Copyright (c) Microsoft Open Technologies, Inc. All rights reserved. Licensed under the Apache License, Version 2.0.


