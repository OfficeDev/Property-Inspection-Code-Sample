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

![alt tag](https://github.com/OfficeDev/Property-Inspection-Code-Sample/blob/master/Documents/demo_video_thumb.png)

The [MS Open Tech](http://msopentech.com)'s open source project **Office 365 SDK for iOS** is used to integrate the iOS Apps with several O365 services.

What is in this repo?

The iOS Repair App is located in the iOSInspectionApp folder.
The iOS Inspection App is located in the iOSRepairApp folder.
The Property Manager My App is located in the PropertyManagerMyApp folder.
The Mail App for Office is located in the MailAFO folder.

Property Management My App

The Property Manager My App demonstrates many different patterns used in real world scenarios.  At a high level, the Property Manager My App does the following things.
<ul>
    <li>Provisions the Site Collection used by the Property Manager My App</li>
    <li>Provisions information architecture and supporting components into the new Site Collection</li>
    <li>Provisions content into the new Site Collection</li>
    <li>Serves as a line of business application</li>
</ul>

Line Of Business Application
<p>
    This Property Manager My App provides a dashboard application used in a property management scenario.
    This dashboard is used by dispatchers at the property management company's home office to coordinate inspections and repairs.
    The dashboard uses O365 APIs and the SharePoint REST APIs to read and write information in Exchange and SharePoint.
</p>

The sections below provide more information about these patterns and how to get up and running.

iOS Applications

The iOS Apps demonstrate many different patterns used in real world scenarios.  At a high level, the iOS Apps do the following things.
<ul>
    <li>Provide property inspectors and repair people information about properties they are scheduled to inspect and repair.</li>
    <li>Allow property inspectors and repair people to submit photos and comments about inspections, incidents, and repairs.</li>
</ul>

The sections below provide more information about these iOS Apps and how to get up and running.

Mail App for Office

The Mail App for Office uses Outlook and Outlook Web Access to display data from Office 365 SharePoint lists.  The Mail App for Office is implemented with two main components.
<ul>
    <li>Mail App for Office – xml file installed on the O365 tenancy as an Exchange App</li>
    <li>Web pages – Part of the Property Manager My App running on ASP.NET MVC</li>
</ul>

These files contain the code which implements the Mail App for Office:
    <ul>
        <li>/Controllers/MailAFOController.cs</li>        
        <li>/Views/MailAFO/Redir.cshmtl</li>
        <li>/Views/MailAFO/Index.cshtml</li>
        <li>/Models/MailAFOModel.cs</li>
        <li>/Models/Dashboard.cs</li>
    </ul>

The sections below provide more information about these components and how to get up and running.</p>

## Install-MyApp
To set up and configure the demo first download the Property Manager My App and open it in Visual Studio 2013.

To register the Property Manager My App with your Azure Active Directory right click the PropertyManagerMyApp project and select Add -> Connected Service.  Authenticate with the credentials associated with your tenancy and use the wizard to configure the appropriate permissions.  The following images demonstrate how your app settings and api permissions should be configured for the Property Manager My App to work.

O365 API Calendar Permissions

![alt tag](https://github.com/OfficeDev/Property-Inspection-Code-Sample/blob/master/Documents/O365 API Calendar Permissions.jpg)

O365 API Mail Permissions

![alt tag](https://github.com/OfficeDev/Property-Inspection-Code-Sample/blob/master/Documents/O365 API Mail Permissions.jpg)

O365 API Sites Permissions

![alt tag](https://github.com/OfficeDev/Property-Inspection-Code-Sample/blob/master/Documents/O365 API Sites Permissions.jpg)

O365 API AD Permissions

![alt tag](https://github.com/OfficeDev/Property-Inspection-Code-Sample/blob/master/Documents/O365 API AD Permissions.jpg)

O365 App Settings

![alt tag](https://github.com/OfficeDev/Property-Inspection-Code-Sample/blob/master/Documents/O365 App Settings.jpg)

web.config
<p>The Property Manager My App stores configuration settings in the web.config file.  These settings must be configured for your environment in order for the Property Manager My App to work.  The Add Connected Service wizard creates some of these settings in the web.config file when it registers you app with Azure Active Directory.  These settings the Add Connected Service wizard creates include:</p>
<ul>
    <li>ida:ClientID</li>
    <li>ida:AppKey</li>
    <li>ida:PostLogoutRedirectUri</li>
    <li>ida:GraphResourceId</li>
    <li>ida:GraphUserUrl</li>
    <li>ida:AuthorizationUri</li>
</ul>
<p>In addition to the settings above, other settings exist which allow you to perform additional required configuration values.  These settings include:</p>
<ul>
    <li>ServiceResourceId - Url for the O365 tenant admin site</li>
    <li>DashboardServiceResourceId - Url for the root Site Collection in the O365 Tenancy</li>
    <li>DashboardServiceEndpointUri - Api Endpoint for the Site Collection used by the Property Manager My App</li>
    <li>DemoSiteServiceResourceId - Url for the root Site Collection in the O365 Tenancy</li>
    <li>DemoSiteCollectionUrl - Url used to create the Site Collection used by Property Manager My App</li>
    <li>DemoSiteCollectionOwner - Email address for Site Collection owner (admin&#64;&lt;Your Tenancy&gt;.onmicrosoft.com)</li>
    <li>DispatcherName - Display Name for Dispatcher (Katie Jordan)</li>
    <li>DispatcherEmail - Email address for Dispatcher (katiej&#64;&lt;Your Tenancy&gt;.onmicrosoft.com)</li>
</ul>
<p>Configure these settings in the web.config file to match your O365 / Azure Tenancy.</p>

Azure Active Directory User Accounts
<p>The Property Manager My App and demo rely on Azure Active Directory Accounts to work.  Create the following users in Azure Active Directory.  Note: It may take up to 24 hours for the O365 infrastructure to create an Exchange Mailbox and Calendar.</p>
<ul>
    <li>Inspector: Rob Barker - alias: robb</li>
    <li>Dispatcher: Katie Jordan - alias: katiej</li>
    <li>Repair Person: Ron Gabel - alias: rong</li>
    <li>Property Owner: Margaret Au - alias: marga</li>
    <li>Inspector: Alisa Lawyer - alias: alisal</li>
    <li>Repair Person: Chris Gray - alias: chrisg</li>
    <li>Property Owner: Steven Wright - alias: stevenw</li>
</ul>

Trusted Sites
<p>Add <b>http://localhost</b> to the Trusted Sites list in Internet Explorer.</p>

Site Collection Provisioning
<p>
    The O365SiteProvisingController is used to create the Site Collection used to store data and facilitate workflow for the Property Manager My App.
    First, this controller retrieves an access token for the tenancy admin Site Collection.
    Then it uses the access token to authenticate the call to determine if the Site Collection exists.
    If the Site Collection exists this controller then redirects to the DashboardController.
    If the Site Collection does not exist then the controller creates the Site Collection.
    After the Site Collection is created the controller signs out from O365 and retrieves an access token for the new Site Collection.
    Then it uses the access token to authenticate the calls to create the information architecture and supporting components in the new Site Collection.
    Finally, the controller creates content in the new site collection to support the demo and redirects to the DashboardController.

    These files contain the code which implements the Site Collection provisioning functionality:
    <ul>
    <li>/Controllers/O365SiteProvisioningController.cs</li>
    <li>/Util/csomUtil.cs</li>
    <li>/Util/SiteProvisioning.cs</li>
    <li>/Views/O365SiteProvisioning/CreateSiteCollection.cshmtl</li>
    <li>/Views/O365SiteProvisioning/Index.cshtml</li>
    <li>/Views/O365SiteProvisioning/ProvisioningSiteComponents.cshmtl</li>
    <li>/Content/SampleData.xml</li>
    </ul>
    </p>
    <p>After you have performed the configuration steps described above, provision the Site Collection and content.</p>
    <p>In your web browser, navigate to http://localhost:41322/O365SiteProvisioning to invoke the O365SiteProvisioning controller and create the Site Collection and content</p>

    User Account Permission
<p>After you have provisioned the Site Collection and content you must grant Member access to the Dispatcher account.</p>
<ul>
    <li>Dispatcher: Katie Jordan - alias: katiej</li>
</ul>

Property Manager My App Configuration
<p>If you wish to add a custom logo to your Property Manager My App you can update the logo corresponding to the AAD App Visual Studio creates in your AAD.  Use the following file you can find in the PropertyManagementMyApp Visual Studio Solution.  /Content/Images/AADAppLogos/logo-prop-man.jpg</p>

Property Manager My App Installation Complete!
<p>Now you can access the Property Manager My App dashboard landing page.</p>
<p>In your web browser, navigate to http://localhost:41322/Dashboard" to open the dashboard landing page.</p>

## Install-iOS
<p>The demo also relies upon iOS Apps to function end to end.  Some configuration is required to enable the iOS Apps to work with an O365 environment.  Read on to learn about the configuration process.</p>

Azure Active Directory Apps
<p>The iOS Apps use O365 APIs and SharePoint REST APIs to interact with an O365 / Azure tenancy.  The Azure Active Directory Applications are used to authorize the iOS Apps.  To register the iOS Apps with an Azure Active Directory follow these instructions.</p>

Create Azure Active Directory App for the iPad Apps
<ol>
    <li>Open the Azure Management Portal</li>
    <li>Select <b>Active Directory</b></li>
    <li>Click on your AAD</li>
    <li>Click <b>Applications</b></li>
    <li>Click <b>Add</b></li>
    <li>Click <b>Add an application my organization is developing</b></li>
    <li>In the Name textbox enter <b>PropertyManagementiOSiPadApp</b></li>
    <li>For Type, select <b>NATIVE CLIENT APPLICATION</b></li>
    <li>Click the <b>Arrow button</b></li>
    <li>In the Redirect URI textbox enter <b><u>http://PropertyManagementiOSiPadApp</u></b></li>
    <li>Click the <b>Checkmark button</b></li>
    <li>Expand the update your code section and <b>copy</b> the Redirect URI and Client ID values and <b>paste</b> them into a text file.  You will use these values when you configure the iPad app on your iPad.</li>
    <li>Click <b>Configure</b></li>
    <li>
        In the permissions to other applications section, click the dropdown list next to Windows Azure Active Directory and select the following permissions.
        <br />
        ![alt tag](https://github.com/OfficeDev/Property-Inspection-Code-Sample/blob/master/Documents/iOS App AAD Perms.png)
    </li>
    <li>
        Configure the permissions to Exchange, use the screenshot below for reference.
        <br />
        ![alt tag](https://github.com/OfficeDev/Property-Inspection-Code-Sample/blob/master/Documents/iOS App Exchange Perms.png)
    </li>
    <li>
        Configure the permissions to SharePoint, use the screenshot below for reference.
        <br />
        ![alt tag](https://github.com/OfficeDev/Property-Inspection-Code-Sample/blob/master/Documents/iOS App SP Perms.png)
    </li>
    <li>Click <b>Save</b></li>
</ol>

iOS App Installation

<p>Now you are ready to install the iOS Apps.  This section provides details about your installation options.</p>
<p>The easiest way to install the iOS apps to your iPad is to download the .ipa files to your computer and install them on your iPad.  iFunBox is a tool capable of deploying iOS Apps to a non-rooted iPad.</p>
<p>Optionally, you can clone the GitHub repository and load the iOS App Workspaces in XCode then run them in the iOS Simulator or deploy them to an iPad.  This option requires a Mac and XCode.  If you choose this option please see the installation notes in the [XCode](#xcode) section which describe how to register the CocoaPods with the iOS projects.  The CocoaPods must be installed to enable the iOS Apps project workspaces to build and run.</p>
<p><b>Note:</b> A Mac and XCode is required if you wish to debug the iOS code.</p>

iOS App Configuration
<p>After the iOS Apps are deployed, you need to configure them to work with an O365 / Azure Tenancy and the Azure Active Directory Applications you created.</p>

Configure iPad Apps settings
<p>
    To configure the iPad Apps settings follow these instructions.  You need to perform these same steps for both the Inspection and Repair iOS apps.
</p>
<ol>
    <li>Tap the <b>iPad App</b> on the iPad to open it.</li>
    <li>After the iPad App is loaded and the Sign In screen is displayed, push the <b>home button</b> two times and close the running instance of the application.</li>
    <li>Next, open the <b>native iOS Settings App</b>.</li>
    <li>In the left column, tap the <b>name of the app.</b></li>
    <li>Enter the values which correspond to the Azure Active Directory application you created for the iPad Apps.</li>
    <li>Enter the URL to the Site Collection created by the Property Manager My App.</li>
    <li>Enter the email address for the Dispatcher. (katiej&#64;&lt;Your Tenancy&gt;.onmicrosoft.com)</li>
</ol>
<p>These are the values that must be configured.</p>
<ul>
    <li>
        clientID - This is the value you copied and pasted in the steps above.  This value is also displayed in the CONFIGURE page for the iOSiPadApp Azure Active Directory Application in the Azure Management Portal.
    </li>
    <li>
        redirectUriString - This is the value you copied and pasted in the steps above.  This value is also displayed in the CONFIGURE page for the iOSiPadApp Azure Active Directory Application in the Azure Management Portal.
    </li>
    <li>
        authority - This value is partially displayed in the VIEW ENDPOINTS popup page for the Azure Active Directory Application in the Azure Management Portal.  Use the domain associated with the OAUTH 2.0 TOKEN ENDPOINT.  If you are running on production O365 this value is https://login.windows.net.
    </li>
    <li>
        resourceId - This value is partially displayed in the VIEW ENDPOINTS popup page for the Azure Active Directory Application in the Azure Management Portal.  Use the domain associated with the OAUTH 2.0 TOKEN ENDPOINT and append /common to it.  If you are running on production O365 this value is https://login.windows.net/common.
    </li>
    <li>
        demoSiteCollectionUrl - Url for the Site Collection created by the Property Manager My App.  Use the same value you configured in the web.config for the Property Manager My App for the DemoSiteCollectionUrl app setting.
    </li>
    <li>dispatcherEmail - Email address for the dispatcher account you created.</li>
</ul>

iOS Apps Installation Complete!

## Install-MailApp

Some configuration is required to enable the Mail App for Office to work with an O365 environment.  Read on to learn about the configuration process.
    
Mail App for Office

<p>The Mail App for Office runs on an ASP.NET Web site.  You must configure the Mail App for Office to use the web site where you deployed the Property Manager My App.  To configure the Mail App for Office to use your web site follow these instructions.</p>

Modify Manifest
<ol>
    <li>Open the <b>MailAFO Visual Studio Solution</b></li>
    <li>In the MailAFO project, open the <b>MailAFO.xml</b> file</li>
    <li>Replace the <b>SourceLocation endpoints</b> in the DesktopSettings, TabletSettings, and PhoneSettings nodes with the URL to your Property Manager My App ASP.NET web site.<br />
        Use the following template for the SoureLocation URL:
        https://&lt;Your Web Site&gt;.azurewebsites.net/Mailafo/redir
    </li>
    <li>Save <b>MailApp.xml</b></li>
    <li>Right click the MailApp project and select <b>Publish</b></li>
    <li>Click <b>Package the app</b></li>        
</ol>   

Mail App for Office Installation
<ol>
    <li>Log into your O365 Tenancy with your admin account</li>
    <li>Click the <b>waffle</b> button, then click the <b>Admin app</b>
    <br />
        ![alt tag](https://github.com/OfficeDev/Property-Inspection-Code-Sample/blob/master/Documents/Mail AFO - Admin.png)
    </li>
    <li>In the left menu, click <b>Exchange</b></li>
    <li>Under organization, click <b>apps</b></li>
    <li>Click the <b>+ icon</b> to add a new app</li>
    <li>Select <b>Add from file</b></li>
    <li>In the dialog select the <b>MailAppManifest.xml file</b> you created when you published the MailApp project</li>
    <li>Click <b>next</b></li>
</ol> 
   
Mail App for Office Installation Complete!

<p>When demo users open an email with the string <b>Incident ID: &lt;number&gt;</b> in the email body they can view the Incident details in the Mail App for Office by clicking the Property Details link.
    <br />
    ![alt tag](https://github.com/OfficeDev/Property-Inspection-Code-Sample/blob/master/Documents/Mail AFO - Link.png)
</p>
<p>When the Mail App for Office loads, users are taken to a redirect page which uses office.js to extract the Incident ID from the email body.  This page includes the text <b>Redir</b> so you can see it happening in the demo.  In a production scenario you might display loading text or leave this page blank.
    <br />
    ![alt tag](https://github.com/OfficeDev/Property-Inspection-Code-Sample/blob/master/Documents/Mail AFO - Redir.png)
</p>
<p>
    The redirect page then uses JavaScript to redirect to another controller (index.cshtml) and passes the IncidentId on the query string.  The second controller uses the IncidentId passed to it to invoke the server side O365 ASP.NET APIs to retrieve the data from SP.
    <br />
    ![alt tag](https://github.com/OfficeDev/Property-Inspection-Code-Sample/blob/master/Documents/Mail AFO - Incident Details.png)
</p>

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


