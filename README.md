# Property Inspection Code Sample

**Table of Contents**

- [Overview](#overview)
- [Getting Started](#installation)
- [Running the sample end to end](#demo)
- [Working with the iOS apps in XCode](#xcode)
- [Contributing](#contributing)
- [License](#license)

## Overview
The Property Inspection Code Sample demonstrates how to create a line of business system with O365 and mobile technologies.

The [MS Open Tech](http://msopentech.com)'s open source project **Office 365 SDK for iOS** is used to integrate the iOS Apps with several O365 services.

The iOS Repair App is located in the iOSInspectionApp folder.
The iOS Inspection App is located in the iOSRepairApp folder.
The Suite Level App is located in the PropertyManagementSLA folder.

## Installation
To set up and configure the demo first download the Suite Level App and F5 in Visual Studio.  Then navigate the to /Home controller.  The Home controller includes all the setup and configuration instructions you need to runt he demo end to end.

## Demo
The PowerPoint slide deck in the Documents folder describes how to prep your environment with sample data and execute the sample scenario end to end.  It also describes all of the different places where data is created or updated throughout the entire scenario.

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


