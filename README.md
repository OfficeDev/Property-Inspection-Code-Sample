# Property Inspection Code Sample

**Table of Contents**

- [Overview](#overview)
- [Getting Started](#installation)
- [Running the sample end to end](#running)
- [API Notes](#apis)
- [Mail App for Office Notes](#mailafo)
- [Links that open native iOS Apps](#deeplinks)
- [Working with the iOS apps in XCode](#xcode)
- [Contributing](#contributing)
- [License](#license)

## Overview
The Property Inspection Code Sample demonstrates how to create a line of business system with O365 and mobile technologies.

You can see the demo in action in the [Office 365 Developer Kick Off session] (http://channel9.msdn.com/events/TechEd/Europe/2014/DEV-B207) from TechEd Europe 2014.

![alt tag](https://github.com/OfficeDev/Property-Inspection-Code-Sample/blob/master/Documents/demo_video_thumb.png)

The [MS Open Tech](http://msopentech.com)'s open source project **Office 365 SDK for iOS** is used to integrate the iOS Apps with several O365 services.

The iOS Repair App is located in the iOSInspectionApp folder.
The iOS Inspection App is located in the iOSRepairApp folder.
The Suite Level App is located in the PropertyManagementSLA folder.
The Mail App for Office is located in the MailAFO folder.

## Installation
To set up and configure the demo first download the Suite Level App and run it with F5 in Visual Studio.  Then navigate the to /Home controller.  The Home controller includes all the setup and configuration instructions you need to run the demo end to end.  You cannot run the sample code without following the steps in the various pages in the home controller.  The following image shows what the first page of setup documentation in the home controller looks like.

![alt tag](https://github.com/OfficeDev/Property-Inspection-Code-Sample/blob/master/Documents/home-controller.jpg)

## Running
The [PowerPoint slide deck] (https://github.com/OfficeDev/Property-Inspection-Code-Sample/blob/master/Documents/Demo%20Prep%20And%20Walkthrough.pptx) describes how to prep your environment with sample data and execute the sample scenario end to end.  It also describes all of the different places where data is created or updated throughout the entire scenario.  This is an excellent place to see what this demo really does and how the scenario in it unfolds.

## APIs
When this demo was built the O365 SDKs for ASP.Net and iOS were in the alpha/beta stages.  Consequently, some of the code in the demo uses REST based approaches to perform operations with O365 services like SharePoint and Exchange.  The following parts of the sample use REST based approaches to access O365 Services.

* Working with Files in the iOS Apps and Suite Level Applications.  See [MS Open Tech](http://msopentech.com)'s open source project **Office 365 SDK for iOS** to see how this is done.
* Sending Email with attachments in the Suite Level Application.  See the Office 365 SDK for ASP.NET to see how this is done.  The sample sends email from the Suite Level App, but no attachments are included.

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


