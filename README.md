# Property Manager Code Sample

**Table of Contents**

- [Overview](#overview)
- [Web app Installation](#web-app-installation)
- [iOS, Android, Cordova, and Xamarin Mobile Applications](#ios-android-cordova-and-xamarin-mobile-applications)
- [iOS Apps Installation](#ios-apps-installation)
- [Android App Installation](#android-app-installation)
- [Cordova App Installation](#cordova-app-installation)
- [Xamarin App Installation](#xamarin-app-installation)
- [Office Add-in for Outlook Installation](#office-add-in-for-outlook-installation)
- [Installing the web app on an Azure Web Site](#installing-the-web-app-on-an-azure-web-site)
- [Running the sample end to end](#running-the-sample-end-to-end)
- [Resetting the demo environment](#resetting-the-demo-environment)
- [API Notes](#api-notes)
- [Mail Add-in for Office Notes](#mail-add-in-for-office-notes)
- [Deep Links](#deep-links)
- [License](#license)

## Overview
The Property Inspection Code Sample demonstrates how to create a line of business system with Office 365 and mobile technologies.

You can watch an entire end to end demo of the sample in the following video.  If you are looking to see everything this code sample does and all the pieces of the Office 365 platform it uses then this is the video you want to watch.

[![Property Manager Demo Walkthrough](https://github.com/OfficeDev/Property-Inspection-Code-Sample/blob/master/Documents/Demo Walk Through Video.png)](https://youtu.be/0q7vjEegGkk "Click to see the code sample from end to end.")

> Speaker: [Todd Baginski](http://channel9.msdn.com/Events/Speakers/Todd-Baginski)

You can also see the demo in action in the **Office Development Matters, and Here's Why...** session from Ignite 2015.

[![Office Development Matters, and Here's Why...](https://github.com/OfficeDev/Property-Inspection-Code-Sample/blob/master/Documents/office_dev_matters.png)](http://channel9.msdn.com/events/Ignite/2015/FND2202 "Click to see the sample in action.")

> Speakers: [Tristan Davis](http://channel9.msdn.com/Events/Speakers/tristan-davis), [Rob Lefferts](http://channel9.msdn.com/Events/Speakers/robert-lefferts), [Jeremy Thake](http://channel9.msdn.com/Events/Speakers/Jeremy-Thake)

> Jeremy provides a tour of the Property Manager web app and the pieces of Office 365 it is built on.

You can see the demo in action and learn more about the code in the following sessions from //build 2015.

[![Integrating Web Apps with Office 365](https://github.com/OfficeDev/Property-Inspection-Code-Sample/blob/master/Documents/integrating-web-apps-with-office-365.png)](http://channel9.msdn.com/events/Build/2015/3-728 "Click to see the sample in action.")

> Speakers: [Todd Baginski](http://channel9.msdn.com/Events/Speakers/Todd-Baginski), [Dorrene Brown](http://channel9.msdn.com/Events/Speakers/dorrene-brown)

> Todd and Dorrene show how to make an Office 365 web app from the ground up and explain the fundamental concepts.  Then, Todd demonstrates the web app portion of the Property Management code sample and dives deep into the code to show how the ASP.NET MVC web site is built and how it uses Office 365 and the Office 365 Unified API to integrate with the Office 365 platform and services.  

[![iOS, Cordova, and Android Apps with Office 365](https://github.com/OfficeDev/Property-Inspection-Code-Sample/blob/master/Documents/ios-cordova-android-apps-with-office-365.png)](http://channel9.msdn.com/events/Build/2015/3-722 "Click to see the sample in action.")

> Speakers: [Todd Baginski](http://channel9.msdn.com/Events/Speakers/Todd-Baginski), [Joshua Gavant](http://channel9.msdn.com/Events/Speakers/joshua-gavant)

> Todd demonstrates the iOS repair app at the end of this session and shows how it may be used to take a picture and upload it to a private site collection in O365.

The [MS Open Tech](http://msopentech.com)'s open source SDKs are used to integrate the iOS and Android apps with several Office 365 services.

- [Microsoft Services SDKs for iOS](https://github.com/OfficeDev/Office-365-SDK-for-iOS/)
- [Microsoft Services SDKs for Android](https://github.com/OfficeDev/Office-365-SDK-for-android/)

**Where can I find things in this repo?**

- Web application
	+ The Property Management web app is located in the PropertyManagerMyApp folder.
- Mobile applications
	+ The iOS Inspection App is located in the iOSRepairApp folder.
	+ The iOS Repair App is located in the iOSInspectionApp folder.
	+ The Android Repair App is located in the AndroidRepairApp folder.
	+ The Cordova Repair App is located in the CordovaRepairApp folder.
	+ The Xamarin Repair App is located in the XamarinRepairApp folder.
- Office Add in
	+ The Office Add-in for Outlook is located in the MailApp folder.

**Property Management web app - A Line Of Business Application**

The Property Manager web app demonstrates many different patterns used in real world scenarios.  At a high level, the Property Manager web app does the following things.

- Provisions the Site Collection used by the Property Manager web app
- Provisions information architecture and supporting components into the new Site Collection
- Provisions content into the new Site Collection
- Provisions Azure Active Directory groups and users
- Assigns Office 365 licenses to Azure Active Directory users
- Provisions Office 365 unified groups
- Adds Azure Active Directory users to Office 365 unified groups
- Provisions videos to the Office 365 Video Portal
- Serves as a line of business application

This Property Manager web app provides a dashboard application used in a property management scenario.
This dashboard is used by dispatchers at the property management company's home office to coordinate inspections and repairs.
The dashboard uses O365 APIs, the SharePoint REST APIs, and the Office 365 Unified API to read and write information in Exchange and SharePoint.

The sections below provide more information about these patterns and how to get up and running.

**iOS, Android, Cordova, and Xamarin Applications**

The iOS, Android, Cordova, and Xamarin mobile apps demonstrate many different patterns used in real world scenarios.  At a high level, the mobile apps do the following things.

- Provide property inspectors and repair people information about properties they are scheduled to inspect and repair.
- Allow property inspectors and repair people to submit photos and comments about inspections, incidents, and repairs.

The sections below provide more information about these mobile apps and how to get up and running.

**Office Add-in for Outlook (previously known as a Mail App for Office)**

The Office Add-in for Outlook and Outlook Web Access displays data from Office 365 SharePoint lists.  The Mail App for Office is implemented with two main components.

- Office Add-in – xml file installed on the O365 tenancy as an Exchange App
- Web pages – Part of the Property Manager web app running on ASP.NET MVC

These files contain the code which implements the Office Add-in for Outlook:

- /Controllers/MailAFOController.cs
- /Views/MailAFO/Redir.cshmtl
- /Views/MailAFO/Index.cshtml
- /Models/MailAFOModel.cs
- /Models/Dashboard.cs

The sections below provide more information about these components and how to get up and running.

## Web app installation

**Prerequisites**

- Office 365 Subscription
- Microsoft Azure Subscription
- Visual Studio 2013 Update 4
- [Microsoft Office Developer Tools for Visual Studio 2013 - November 2014 Update](http://download.microsoft.com/download/A/D/0/AD077416-F349-4214-81C6-6650E2AF1AF2/enu/cba_bundle.exe)
- Office 365 Video Portal
	+ Before you start the installation process, ensure the Office 365 video portal is provisioned in your tenancy.  Follow the steps below to enable, provision and verify the Office 365 Video Portal is available in your tenancy.
	
1. In your web browser, open the **Tenant Settings page** for your Office 365 tenancy.  The URL to the Tenant Settings page is shown below.

	```
	https://<TENANCY>-admin.sharepoint.com/_layouts/15/online/TenantSettings.aspx

	Example: https://contoso-admin.sharepoint.com/_layouts/15/online/TenantSettings.aspx
	```

2. In the Streaming Video Service section, select **Enable streaming video through Azure Media Services and enable the Video Portal** (shown below).
 
	![](https://raw.githubusercontent.com/OfficeDev/Property-Inspection-Code-Sample/master/Documents/streaming-video-service.png)

3. Click **OK**.

4.	In your web browser, open the page that lists the site collections in your Office 365 tenancy. The URL for the site collections list page is shown below.

	```
	https://<TENANCY>-admin.sharepoint.com/_layouts/15/online/SiteCollections.aspx

	Example: https://contoso-admin.sharepoint.com/_layouts/15/online/SiteCollections.aspx
	```

5.	Look for the Office 365 Video Portal site collection in the list of site collections in your Office 365 tenancy.
	+ The URL to the Office 365 Video portal follows this format:
	
		```
		https://<TENANCY>.sharepoint.com/portals/hub
		```

6. If the Office 365 Video Portal site collection is in the list, open it in a web browser to verify it works.

7. If the Office 365 Video Portal is not provisioned in your tenancy you can provision it by appending **/_layouts/15/videoredirect.aspx** to your tenancy's base URL and opening the page in the web browser, like this.

	```	
	https://<TENANCY>.sharepoint.com/_layouts/15/videoredirect.aspx

	Example: https://contoso.sharepoint.com/_layouts/15/videoredirect.aspx
	```

Important Notes
---------------  

- Use Internet Explorer or Google Chrome to install and execute the web app portion of the code sample.  The Edge browser is not yet supported.
- The *Microsoft Office Developer Tools for Visual Studio 2013 - April 2015 Update* breaks the Add Connected Service wizard.  If you have it installed, first uninstall it and then install the [Microsoft Office Developer Tools for Visual Studio 2013 - November 2014 Update](http://download.microsoft.com/download/A/D/0/AD077416-F349-4214-81C6-6650E2AF1AF2/enu/cba_bundle.exe).  A fix for this issue is coming shortly in a new update.
- The Add Connected Service wizard is currently broken is Visual Studio 2015 as well.  A fix for this issue is coming shortly in a new update.
- When you save the PropertyManagerMyApp directory to your local machine, save it to the root of one of your drives to ensure all Nuget functionality will work and your file paths will not become too long.

To set up and configure the demo first download the Property Manager web app source code and open it in Visual Studio 2013.

**Restore the Nuget packages the web app depends on**

1. Right click on the  **PropertyManagerMyApp project** and select **Build**.

	> **Note:**  You will get build errors after this step, they are to be expected. 

**Register the Property Manager web app with your Azure Active Directory**

To register the Property Manager web app with your Azure Active Directory follow these steps.

1. Right click the **PropertyManagerMyApp project** and select **Add -> Connected Service**.
2. Click **Register your app** and authenticate with the global administrator credentials associated with your tenancy.
3. Use the wizard to configure the appropriate Office 365 permissions.
  
	The following images demonstrate how your app settings and api permissions should be configured for the Property Manager web app to work.
	
	O365 API Calendar Permissions
	
	![](https://raw.githubusercontent.com/OfficeDev/Property-Inspection-Code-Sample/master/Documents/O365 API Calendar Permissions-2.png)
	
	O365 API Mail Permissions
	
	![](https://raw.githubusercontent.com/OfficeDev/Property-Inspection-Code-Sample/master/Documents/O365 API Mail Permissions-2.png)
	
	O365 API Sites Permissions
	
	![](https://raw.githubusercontent.com/OfficeDev/Property-Inspection-Code-Sample/master/Documents/O365 API Sites Permissions-2.png)
	
	O365 API Users and Groups Permissions
	
	![](https://raw.githubusercontent.com/OfficeDev/Property-Inspection-Code-Sample/master/Documents/O365 API AD Permissions-2.png)	

4. Click **OK** in the Add Connected Services wizard to commit the changes.  

At this point Visual Studio will add the appropriate Office 365 Nuget packages to the Visual Studio Solution.

**Add Office 365 unified API (preview) permissions to the PropertyManagerMyApp AAD app**

1.	In your web browser, open https://portal.office.com and sign in with a global administrator account.
2.	Click the **Admin tile**.
3.	Expand the **ADMIN** menu item.
4.	Click **Azure AD**.
2.	In the left menu, click **Active Directory**
3.	Click your Azure Active Directory
4.	Click **Applications**
5.	In the Show dropdown list, select **Applications my company owns**.
6.	Click the **checkmark** button.
5.	Ensure the **PropertyManagerMyApp.Office365App** application exists, then click it.
6.	Click **Configure** 
7.	Scroll down to **Permissions to other applications** and click **Add application**
8.	Mouse over Office 365 unified API (preview) and click the **+ button**
9.	Click the **checkmark button** on the bottom right
10.	Open the **Delegated Permissions dropdown list** for the Office 365 unified API (preview) item you just added
11.	Select the following permissions:
	- Have full access to user calendars
	- Read and write directory data
	- Read and write all groups (preview)
	- Enable sign-in and read user profile
	- Read and write all user's full profiles

	> **Note:** There is a permission named **Read all users' full profiles** that looks very similar to the **Read and write all user's full profiles** permission.  Make sure you select the **Read and write all user's full profiles** permission.
	
12.	Click **Save**

**Add OneNote permissions to the PropertyManagerMyApp AAD app**

In order to make the OneNote Azure Active Directory Application permission available, you must first provision the default OneNote Online notebook in your tenancy and access it.  To do this, follow these steps.

1. In your web browser, open [](https://login.microsoftonline.com/) and sign in with an account that has an Office 365 license assigned to it that includes OneNote Online.
2. Click the **OneNote Online** tile.
3. Click a **OneNote notebook** in the list to open it.
4.	In your web browser, open [](https://manage.windowsazure.com) and sign in with a subscription administrator account.
5.	In the left menu, select **Active Directory**
6.	Select your Azure Active Directory
7.	Click **Applications**
8.	Click the **PropertyManagerMyApp** application.
9.	Click **Configure** 
10.	Scroll down to **Permissions to other applications** and click **Add application**
11.	Mouse over OneNote and click the **+ button**
12.	Click the **checkmark button** on the bottom right
13.	Open the **Delegated Permissions dropdown list** for the Office 365 unified API (preview) item you just added
14.	Select **all the permissions**.	
15.	Click **Save**

**Edit web.config**

The Property Manager web app stores configuration settings in the web.config file.  These settings must be configured for your environment in order for the Property Manager web app to work.  The Add Connected Service wizard creates some of these settings in the web.config file when it registers you app with Azure Active Directory.  These settings the Add Connected Service wizard creates include:

- ida:ClientID
- ida:ClientSecret (Microsoft Office Developer Tools for Visual Studio 2013 - November 2014 Update) or ida:Password (Microsoft Office Developer Tools for Visual Studio 2013 - April 2015 Update
- ida:AuthorizationUri

In addition to the settings above, other settings exist that you must configure to match your tenancy.  These settings include:

- **ServiceResourceId** Url for the O365 tenant admin site 

    Example: https://contoso-admin.sharepoint.com

- **DemoSiteServiceResourceId** Url for the root Site Collection in the O365 Tenancy 

    Example: https://contoso.sharepoint.com
- **DemoSiteCollectionUrl** Url used to create the Site Collection used by Property Manager web app 

    Example: https://contoso.sharepoint.com/sites/SuiteLevelAppDemo

- **DemoSiteCollectionOwner** Email address for Site Collection owner (admin&#64;&lt;Your Tenancy&gt;.onmicrosoft.com) 

    Example: ADMIN@contoso.onmicrosoft.com
- **DispatcherName** Display Name for Dispatcher (Katie Jordan) 

    Example: Katie Jordan
- **DispatcherEmail** Email address for Dispatcher (katiej&#64;&lt;Your Tenancy&gt;.onmicrosoft.com) 

    Example: katiej@contoso.onmicrosoft.com

- **VideoPortalEndpointUri** Api Endpoint for the Video Portal which comes with your O365 tenancy  

    Example: https://contoso.sharepoint.com/portals/hub

1. Configure these settings in the web.config file to match your O365 / Azure Tenancy by **replacing the TENANCY placeholders in the web.config** with your tenancy name.  In the examples above, the TENANCY placeholder was replaced with contoso.
2. Edit the **DemoSiteCollectionOwner setting** in the web.config file to match your O365 global administrator account.
3. Right click the **PropertyManagerMyApp project** and select **Manage Nuget Packages**.
4. Click the **Updates tab** and select **nuget.org**.
5. Click **Update All**.
6. Click **I Accept**.
7. Click **Close**.
8. In the web.config file **locate the bindingRedirect elements for the Microsoft.OData.Client, Microsoft.OData.Edm, and Microsoft.OData.Core assemblies and edit them to redirect to the latest version of the NuGet packages you downloaded**.  You can find the latest version of these assemblies in the packages.config file.

	In this example the packages.config file looks like this:

		<package id="Microsoft.OData.Client" version="6.13.0" targetFramework="net45" />
	  	<package id="Microsoft.OData.Core" version="6.13.0" targetFramework="net45" />
	  	<package id="Microsoft.OData.Edm" version="6.13.0" targetFramework="net45" />

	Therefore, the bindingRedirect attributes look like this.  Notice the 6.13.0 value used in the oldVersion and newVersion attributes matches the version in the packages.config snippet above.

		<dependentAssembly>
	        <assemblyIdentity name="Microsoft.OData.Client" publicKeyToken="31bf3856ad364e35" culture="neutral" />
	        <bindingRedirect oldVersion="0.0.0.0-6.13.0.0" newVersion="6.13.0.0" />
	    </dependentAssembly>
	    <dependentAssembly>
	        <assemblyIdentity name="Microsoft.OData.Edm" publicKeyToken="31bf3856ad364e35" culture="neutral" />
	        <bindingRedirect oldVersion="0.0.0.0-6.13.0.0" newVersion="6.13.0.0" />
	    </dependentAssembly>
	    <dependentAssembly>
	        <assemblyIdentity name="Microsoft.OData.Core" publicKeyToken="31bf3856ad364e35" culture="neutral" />
	        <bindingRedirect oldVersion="0.0.0.0-6.13.0.0" newVersion="6.13.0.0" />
	    </dependentAssembly>

9. **Save** the web.config file.

**Configure Trusted Sites**

1. Add **https://localhost** and **http://localhost** to the Trusted Sites list in Internet Explorer.

**Site Collection Provisioning**

The O365SiteProvisingController is used to create the Site Collection used to store data and facilitate workflows for the Property Manager web app.

First, this controller retrieves an access token for the tenancy admin Site Collection.
Then it uses the access token to authenticate the call to determine if the demo Site Collection exists.

If the demo Site Collection exists this controller then redirects to the DashboardController.

If the Site Collection does not exist then the controller creates the Site Collection.

After the Site Collection is created the controller  retrieves an access token to interact with the new demo Site Collection.

Then controller uses the access token to authenticate the calls to create the information architecture and supporting components in the new Site Collection.

Finally, the controller creates content in the new site collection to support the demo and redirects to the DashboardController.

These files contain the code which implements the Site Collection provisioning functionality:

- /Controllers/O365SiteProvisioningController.cs
- /Util/csomUtil.cs
- /Util/SiteProvisioning.cs
- /Views/O365SiteProvisioning/Index.cshtml
- /Views/O365SiteProvisioning/ProvisioningDemoData.cshmtl
- /Content/SampleData.xml

After you have performed the configuration steps described above, provision the Site Collection and content.

1. In Visual Studio, **press F5** to run the project.   

	> **When you are prompted to log in you must use your O365 admin account.**  This allows you to grant consent to the Azure Active Directory application so the demo users will be able to use it.  

2. When prompted, click the **Accept** button. 

	![](https://raw.githubusercontent.com/OfficeDev/Property-Inspection-Code-Sample/master/Documents/grant consent.jpg)
	
	After you successfully build and run the project and login, **ignore the error you see in the web browser**.  The error occurs because the Site Collection has not been provisioned yet.
	 
**Provision Site Collection and information architecture**

3. In your web browser, navigate to **http://localhost:44312/O365SiteProvisioning** 
4. Click **Create Demo Site Collection** to invoke the the O365SiteProvisioning controller and create the Site Collection, information architecture, and workflows.

	> **Note:**  This process can take up to 20 minutes to complete.  Do not refresh the page during this process.  The page will refresh every minute and display the current time to let you know it is still running.  When the process completes you will see this screen:
	
	![](https://raw.githubusercontent.com/OfficeDev/Property-Inspection-Code-Sample/master/Documents/sc provision success-2.png)

**Provision Azure Active Directory Groups, Users, and demo data**

Finally, you will create the Azure Active Directory Groups, Users, and demo data to support the demo.  This process creates the following AD Users and Groups.

**Groups**

- Repair People
- Inspectors

**Users**
- Inspector: Rob Barker - alias: robb
- Dispatcher: Katie Jordan - alias: katiej
- Repair Person: Ron Gabel - alias: rong
- Property Owner: Margaret Au - alias: marga
- Inspector: Alisa Lawyer - alias: alisal
- Repair Person: Chris Gray - alias: chrisg
- Property Owner: Steven Wright - alias: stevenw
- Property Owner: Dan Jump - alias: danj
- Property Owner: Chris Johnson - alias: chrisj
- Property Owner: Carol Troup - alias: carolt

	**Running Demo With A Single User Account** 

	If your tenancy does not support multiple users because you do not have 10 licenses available you can run the demo with a single user account.  In this case, the account must meet the following requirements:
	
	- User is a global tenant admin
	- User is is granted the licenses necessary to support the scenario
	- User is added to the Inspectors and Repair People Azure Active Directory Groups
	
	Additionally, in a single user scenario, the accounts set in the web.config file for the web app, as well as all the configuration variables for all the mobile apps should use the single user account. 

8. Next, click the **Create Sample Data** link in the top menu.  Then, click the **Populate** button.

9. Enter the date when you plan to execute the demo, then click the **Populate** button.

	When the process completes you will see this screen:
	
	![](https://raw.githubusercontent.com/OfficeDev/Property-Inspection-Code-Sample/master/Documents/demo data provision success-2.png)
	
	If you navigate to the Site Contents page in the Site Collection you will see the lists and libraries which indicate they just had sample data added to them.
	
	Use this URL to access the Site Contents page:
	
	https://**&lt;Your Tenancy&gt;**.sharepoint.com/sites/SuiteLevelAppDemo/_layouts/15/viewlsts.aspx
	
	If you open the Admin app and browse to your active directory you will see the groups and users are created.  

**Passwords**

The initial password for all the users is **TempP@ssw0rd!**

You will need to specify a new password for each user the first time you log in with them. 

> **IMPORTANT NOTE!  READ THIS!**  
> 
> When users and groups are created with the Unified API there is some lag time associated with provisioning all of the associated O365 functionality.  You may have to wait up to 24 hours for the groups to become fully functional with all Office 365 services.
> Items specifically related to this code sample include:
> 
> Users:
> 
> 1. It may take 15 minutes for files, messages, and events are available for use for each user.  This includes OneDrive, Email, and Calendar functionality.
> 
> Groups:
> 
> 1. The ability to list the group conversations in the web app
> 2. The ability to list the group files in the web app
> 3. The ability to upload files from the web app to groups
> 
> See the [Office 365 REST API release notes for April 2015](https://msdn.microsoft.com/en-us/office/office365/howto/office-365-rest-api-release-notes) for more details.
> 

**Mailbox setup**

1. Next, log in with each user to your tenancy and access Outlook to set up their email.

	> **Note:** It may take up to 24 hours for the O365 infrastructure to create an Exchange Mailbox and Calendar.  Usually, it takes 10 seconds.

**Property Manager web app Configuration**
This step is optional.  If you wish to add a custom logo to your Property Manager web app you can update the logo corresponding to the AAD App Visual Studio creates in your AAD.  

1. To do this, access the AAD App in the Azure Management Portal and use the image file you can find in the PropertyManagementMyApp Visual Studio Solution.  **/Content/Images/AADAppLogos/logo-prop-man.jpg**

**Associate pictures with unified groups**
This step is optional.  If you wish to add pictures tot he unified groups associated with each property in the demo data you can manually upload the pictures to the unified groups.  Currently, this capability is not supported via the API. 

1. Go to https://outlook.office365.com

	For each unified group, perform these steps:

2. Click a **unified group** you created in the Groups section.
3. Click the **edit icon button**, which is found in the default group photo.
4. Click **edit icon** in the edit group section.
5. Upload the **image** for the unified group.  The images for the unified groups are located in the \content\images\properties directory in the PropertyManagementMyApp project.
6. Click **Save**.

**Property Manager web app Installation Complete!**

**Important Authentication Note**  
The web app uses  REST APIs to return list item data and pictures from the SharePoint site collection and video metadata from the Office 365 Video Portal.  The REST APIs use a different token to authenticate than the token used to authenticate to Exchange in Office 365.  

Signing into Office 365 and viewing the web app does not obtain the token used to authenticate to the SharePoint site.  

***Since this is the case you must first log into the SharePoint site collection before you try to access the web app.***

In future releases the Unified API will include the ability to query SharePoint list items and document libraries and the Video Portal.  Once the Unified API includes this functionality the web app will be updated to use the Unified API.  After the web app has been converted to use the Unified API the separate token needed to access the  REST APIs is no longer needed and there will be no need to log into the SharePoint site collection before accessing the web app.

**Access the property management web app dashboard**

1. Access the Property Manager web app dashboard landing page by clicking the **Dashboard** link in the top menu.  You can also access the dashboard by navigating to **http://localhost:44312/Dashboard** in your web browser.  

This is what the dashboard looks like.

![](https://raw.githubusercontent.com/OfficeDev/Property-Inspection-Code-Sample/master/Documents/dashboard%203.jpg)

## iOS Android Cordova and Xamarin Mobile Applications

The iOS, Android, Cordova, and Xamarin mobile apps demonstrate many different patterns used in real world scenarios.  At a high level, the mobile apps do the following things.

- Provide property inspectors and repair people information about properties they are scheduled to inspect and repair.
- Allow property inspectors and repair people to submit photos and comments about inspections, incidents, and repairs.

The sections below provide more information about these mobile apps and how to get up and running.

## iOS Apps Installation

The demo relies upon the iOS inspection mobile app and any version of the repair mobile app to function end to end.  The repair mobile app is written in iOS, Android, Cordova, and Xamarin.  You may use any version of the repair mobile app that you like.  

Some configuration is required to enable the iOS Apps to work with an O365 environment.  See the [Install iOS README](https://github.com/OfficeDev/Property-Inspection-Code-Sample/blob/master/README-iOS.md) for complete instructions.

## Android App Installation

The mobile Repair App in the demo may also be run on Android in addition to the iOS version. The Android version of the Repair App is written in Java, the native language for an Android device.  

Some configuration is required to enable the Android Repair App to work with an O365 environment.

Some configuration is required to enable the Android repair apps to work with an O365 environment.  See the [Install Android README](https://github.com/OfficeDev/Property-Inspection-Code-Sample/blob/master/README-Android.md) for complete instructions.

## Cordova App Installation

The mobile Repair App in the demo may also be run on Cordova in addition to the iOS version. The Cordova version of the Repair App is written in HTML, JavaScript and CSS.  It uses the Knockout.js framework for data binding.

The Cordova Repair App supports iOS, Android, and Windows devices.

Some configuration is required to enable the Cordova Repair App to work with an O365 environment.  See the [Install Cordova README](https://github.com/OfficeDev/Property-Inspection-Code-Sample/blob/master/README-Cordova.md) for complete instructions.

## Xamarin App Installation

The mobile Repair App in the demo has also been built for Android devices with Xamarin.  The Xamarin version of the Repair App is written in .NET.

Some configuration is required to enable the Xamarin Repair App to work with an O365 environment.  See the [Install Xamarin README](https://github.com/OfficeDev/Property-Inspection-Code-Sample/blob/master/README-Xamarin.md) for complete instructions.

## Office Add-in for Outlook Installation

Some configuration is required to enable the Office Add-in for Outlook to work with an Office 365 environment.  See the [Install Office Add-in README](https://github.com/OfficeDev/Property-Inspection-Code-Sample/blob/master/README-Mail.md) for complete instructions and a detailed technical description of how the Office Add-in works.
    
## Installing the web app on an Azure Web Site
In addition to your localhost development environment, the web app may also run on an Azure Web Site.

If you wish to publish the web app to an Azure Web Site it is recommended that you create another AAD application for your Azure Web Site.  This ensures that the registration for the App in the My Apps list in O365 has the appropriate Sign-On URL.

The following article describes how to use Visual Studio Publishing Profiles to set up publishing to an Azure Web Site and how to create separate a web.config file for your Azure Web Site.  

[Managing Multiple Windows Azure Web Site Environments using Visual Studio Publishing Profiles](http://www.bradygaster.com/post/managing-multiple-windows-azure-web-site-environments-using-visual-studio-publishing-profiles)

## Running the sample end to end
The [PowerPoint slide deck](https://github.com/OfficeDev/Property-Inspection-Code-Sample/blob/master/Documents/Demo%20Script.pptx) describes how to prep your environment with sample data and execute the sample scenario end to end.  It also describes all of the different places where data is created or updated throughout the entire scenario.  This is an another excellent resource to see what this demo really does and how the scenario in it unfolds.

## Resetting the demo environment
There are two different ways you can reset the demo so you can run it multiple times with the pre-populated demo data.

- Re-provisioning demo data only
- Re-provisioning the entire information architecture and demo data

> **IMPORTANT NOTE:** If you wish to delete all the users and user groups and run the entire provisioning process again you must ensure you follow these steps to ensure the user accounts are recreated successfully and all their Office 365 components work properly.

For each user, do the following.

1. Remove all the SharePoint site permissions for each user.  Make sure you remove their permissions from ***all*** SharePoint site collections so they are not granted access to any SharePoint sites.
2. Open the Office 365 Admin add-in and delete all of the users.
3. Wait 48 hours for all the Office 365 timer jobs to completely remove all traces of the user account.
4. Follow the steps in this README to re-provision the users and all demo components.

How to re-provision the demo data only
-------------------------------------
To re-provision (reset) the demo data to the original state it was in after you run through the setup process follow these steps:

> **Note:** This procedure deletes list items and documents and re-creates them.

1.	In your web browser, navigate to http://localhost:44312/O365SiteProvisioning/ProvisionDemoData
2.	Log in with the tenant administrator credentials for your tenancy.
2.	Enter the **date** when you plan to execute the demo, then click the **Populate** button.
3.	When the process completes, the demo data is re-provisioned.

How to re-provision the entire information architecture and demo data
---------------------------------------------------------------------
To re-provision (reset) the entire information architecture and demo data to the original state it was in after you run through the setup process follow these steps:

> **Note:** This procedure deletes site columns, content types, lists, workflows, list items and documents and re-creates them.

1.	In your web browser, navigate to https://**<Your Tenancy>**-admin.spoppe.com/_layouts/15/online/SiteCollections.aspx
2.	Log in with the tenant administrator credentials for your tenancy.
3.	Delete the demo site collection you previously created.

	> **Note:** The site collection will go to the recycle bin after you delete it. Office 365 does not currently support manually deleting the site collection from recycle bin, so you have to execute PowerShell script to do it. 

4.	Refer to [Set up the SharePoint Online Management Shell environment (Office 365 support article)](https://support.office.com/en-za/article/Set-up-the-SharePoint-Online-Management-Shell-environment-7b931221-63e2-45cc-9ebc-30e042f17e2c) to set up the SharePoint Online Management Shell.

5.	Open the SharePoint Online Management Shell, and then execute the following PowerShell scripts to delete the demo site collection from the recycle bin.

	```
	$msolcred = get-credential <Your O365 admin account>
	connect-msolservice -credential $msolcred
	Remove-SPODeletedSite –Identity "<Your Demo Site URL>"
	```

6.	In this document, go to the Provision Site Collection and information architecture sub section in the [Web app Installation](#web-app-installation) section and re-execute all the steps up to the [Office Add-in for Outlook Installation](#office-add-in-for-outlook-installation) section.

## API Notes
When this demo was built the Office 365 SDKs for ASP.Net and iOS were in the alpha/beta stages.  Consequently, some of the code in the demo uses REST based approaches to perform operations with Office 365 services like SharePoint.  The following parts of the sample use REST based approaches to access Office 365 Services.

* Working with SharePoint files in the web app and mobile apps.  

	> See [MS Open Tech](http://msopentech.com)'s open source project **Office 365 SDK for iOS** to see how this is done.

## Mail Add-in for Office Notes
The Office Add-in for Outlook included in the demo renders properly in PC web browsers but it does not render in iOS devices in Safari, the OWA app, or the native iOS email client.  At this time they are not supported in Safari, the OWA app, or the native iOS email client.

## Deep links
The links in the workflow emails which open the native iOS apps on an iOS device work when using the native iOS email client.  At this time they are not supported in Safari or the OWA app.

## License
Copyright (c) Microsoft, Inc. All rights reserved. Licensed under the Apache License, Version 2.0.


