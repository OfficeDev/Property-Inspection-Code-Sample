# [ARCHIVED] Property Management Code Sample

**Note:** This repo is archived and no longer actively maintained. Security vulnerabilities may exist in the project, or its dependencies. If you plan to reuse or run any code from this repo, be sure to perform appropriate security checks on the code or dependencies first. Do not use this project as the starting point of a production Office Add-in. Always start your production code by using the Office/SharePoint development workload in Visual Studio, or the [Yeoman generator for Office Add-ins](https://github.com/OfficeDev/generator-office), and follow security best practices as you develop the add-in.


**Table of Contents**

- [Overview](#overview)
- [Web Application Installation](#web-application-installation)
- [iOS, Android, Cordova, and Xamarin Mobile Applications](#ios-android-cordova-and-xamarin-mobile-applications)
- [iOS Apps Installation](#ios-apps-installation)
- [Android App Installation](#android-app-installation)
- [Cordova App Installation](#cordova-app-installation)
- [Xamarin App Installation](#xamarin-app-installation)
- [Office Add-in for Outlook (previously known as a Mail App for Office)](#Office-Add-in-for-Outlook)
- [Office Add-in for Outlook Installation](#office-add-in-for-outlook-installation)
- [API Notes](#api-notes)
- [Office Add-in for Outlook Notes](##office-add-in-for-outlook-notes)
- [Deep Links](#deep-links)
- [License](#license)

## Overview
The Property Management Code Sample demonstrates how to create a line of business system with Office 365 and mobile technologies.

**See the sample in action!**

You can watch the entire end to end demo of the sample in the following video.  If you are looking to see everything this code sample does and all the pieces of the Office 365 platform it uses then this is the video you want to watch.

[![Property Manager Demo Walkthrough](https://github.com/OfficeDev/Property-Inspection-Code-Sample/blob/master/Documents/Demo Walk Through Video.png)](https://youtu.be/0q7vjEegGkk "Click to see the code sample from end to end.")

> Speaker: [Todd Baginski](http://channel9.msdn.com/Events/Speakers/Todd-Baginski)

**Where can I find things in this repo?**

- Web application
	+ The Property Management web app is located in the PropertyManagerMyApp folder.
- Mobile applications
	+ The iOS Inspection App is located in the iOSRepairApp folder.
	+ The iOS Repair App is located in the iOSInspectionApp folder.
	+ The Android Repair App is located in the AndroidRepairApp folder.
	+ The Cordova Repair App is located in the CordovaRepairApp folder.
	+ The Xamarin Repair App is located in the XamarinRepairApp folder.
- Office Addiin
	+ The Office Add-in for Outlook is located in the MailAFO folder.

**What does the sample do?**

The Property Manager web application demonstrates many different patterns used in real world scenarios.  At a high level, the Property Manager web application does the following things.

- Provisions the Site Collection used by the Property Manager web application
- Provisions information architecture and supporting components into the new Site Collection
- Provisions content into the new Site Collection
- Provisions Azure Active Directory groups and users
- Assigns Office 365 licenses to Azure Active Directory users
- Provisions Office 365 unified groups
- Adds Azure Active Directory users to Office 365 unified groups
- Provisions videos to the Office 365 Video Portal
- Serves as a line of business application

This Property Manager web application provides a dashboard application used in a property management scenario.
This dashboard is used by dispatchers at the property management company's home office to coordinate inspections and repairs.
The dashboard uses the ***Microsoft Graph, Office 365 APIs, and the SharePoint REST APIs*** to read and write information in Active Directory, Office 365 Groups, Exchange and SharePoint.

The README files linked below provide more information about these patterns and how to get up and running.

## Training
See the [Training README](https://github.com/OfficeDev/Property-Inspection-Code-Sample/blob/master/README-Training.md) for more training resources.

## Web Application Installation

See the [Web App Installation README](https://github.com/OfficeDev/Property-Inspection-Code-Sample/blob/master/PropertyManagerMyApp/README.md) for web application installation instructions.

![Property Manager web application dashboard a property management scenario](https://raw.githubusercontent.com/OfficeDev/Property-Inspection-Code-Sample/master/Documents/dashboard%203.jpg)

## iOS Android Cordova and Xamarin Mobile Applications

The iOS, Android, Cordova, and Xamarin mobile apps demonstrate many different patterns used in real world scenarios.  At a high level, the mobile apps do the following things.

- Provide property inspectors and repair people information about properties they are scheduled to inspect and repair.
- Allow property inspectors and repair people to submit photos and comments about inspections, incidents, and repairs.

## iOS Apps Installation

The demo relies upon the iOS inspection mobile app and any version of the repair mobile app to function end to end.  The repair mobile app is written in iOS, Android, Cordova, and Xamarin.  You may use any version of the repair mobile app that you like.  

Some configuration is required to enable the iOS Apps to work with an Office 365 environment.  

See the [iOS Inspection App README](https://github.com/OfficeDev/Property-Inspection-Code-Sample/blob/master/iOSInspectionApp/README-iOS.md) for iOS Inspection App installation instructions.

See the [iOS Repair App README](https://github.com/OfficeDev/Property-Inspection-Code-Sample/blob/master/iOSRepairApp/README-iOS.md) for iOS Repair App installation instructions.

## Android App Installation

The mobile Repair App in the demo may also be run on Android in addition to the iOS version. The Android version of the Repair App is written in Java, the native language for an Android device.  

Some configuration is required to enable the Android Repair App to work with an Office 365 environment.  See the [Install Android README](https://github.com/OfficeDev/Property-Inspection-Code-Sample/blob/master/AndroidRepairApp/README-Android.md) for complete instructions.

## Cordova App Installation

The mobile Repair App in the demo may also be run on Cordova in addition to the iOS version. The Cordova version of the Repair App is written in HTML, JavaScript and CSS.  It uses the Knockout.js framework for data binding.

The Cordova Repair App supports iOS, Android, and Windows devices.

Some configuration is required to enable the Cordova Repair App to work with an Office 365 environment.  See the [Install Cordova README](https://github.com/OfficeDev/Property-Inspection-Code-Sample/blob/master/CordovaRepairApp/README-Cordova.md) for complete instructions.

## Xamarin App Installation

The mobile Repair App in the demo has also been built for Android devices with Xamarin.  The Xamarin version of the Repair App is written in .NET.

Some configuration is required to enable the Xamarin Repair App to work with an Office 365 environment.  See the [Install Xamarin README](https://github.com/OfficeDev/Property-Inspection-Code-Sample/blob/master/XamarinRepairApp/README-Xamarin.md) for complete instructions.

## Office Add-in for Outlook

The Office Add-in for Outlook and Outlook Web Access displays data from Office 365 SharePoint lists.  The Office Add-in for Outlook is implemented with two main components.

- Office Add-in – xml file installed on the Office 365 tenancy as an Exchange App
- Web pages – Part of the Property Manager web app running on ASP.NET MVC

These files contain the code which implements the Office Add-in for Outlook:

- /Controllers/MailAFOController.cs
- /Views/MailAFO/Redir.cshmtl
- /Views/MailAFO/Index.cshtml
- /Models/MailAFOModel.cs
- /Models/Dashboard.cs

The README files linked below provide more information about these components and how to get up and running.

## Office Add-in for Outlook Installation
Some configuration is required to enable the Office Add-in for Outlook to work with an Office 365 environment.  See the [Install Office Add-in README](https://github.com/OfficeDev/Property-Inspection-Code-Sample/blob/master/MailAFO/README-Mail.md) for complete instructions and a detailed technical description of how the Office Add-in works.    

## API Notes
When this demo was built the Microsoft Graph SDKs for ASP.Net and iOS were in the alpha/beta stages.  Consequently, some of the code in the demo uses REST based approaches to perform operations with Office 365 services like SharePoint.  The following parts of the sample use REST based approaches to access Office 365 Services.

* Working with SharePoint files in the web app and mobile apps.  

	> See [MS Open Tech](http://msopentech.com)'s open source project **Office 365 SDK for iOS** to see how this is done.

Additionally, you will notice a project named Microsoft.Graph in the web application.  This project generates a Microsoft Graph SDK based on a class obtained by using VIPR against the production Microsoft Graph endpoint.  When the Microsoft Graph SDK for ASP.NET is released this sample will be updated accordingly to use the official Microsoft Graph SDK from Microsoft.

## Office Add-in for Outlook Notes
The Office Add-in for Outlook included in the demo renders properly in PC web browsers but it does not render in iOS devices in Safari, the OWA app, or the native iOS email client.  At this time they are not supported in Safari, the OWA app, or the native iOS email client.

## Deep links
The links in the workflow emails which open the native iOS apps on an iOS device work when using the native iOS email client.  At this time they are not supported in Safari or the OWA app.

## License
Copyright (c) Microsoft, Inc. All rights reserved. Licensed under the Apache License, Version 2.0.




This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/). For more information, see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
