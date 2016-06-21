# Property Management Code Sample

> **IMPORTANT NOTE:** You must install the Web Application before the Xamarin app will work.  During the Web application installation process all of the components and sample data which support the demo are provisioned.  See the [Install Web Application README](https://github.com/OfficeDev/Property-Inspection-Code-Sample/blob/master/PropertyManagerMyApp/README.md) for complete instructions.

Mobile Repair App Azure Active Directory Application Installation
=================================================================

The Android, Cordova, and Xamarin Repair Apps use Office 365 APIs and SharePoint REST APIs to interact with an Office 365 / Azure tenancy.  The Azure Active Directory Application is used to authorize the Android, Cordova, and Xamarin Repair Apps.  To register the Android, Cordova, and Xamarin Repair Apps with an Azure Active Directory see the [Mobile Repair App Azure Active Directory Application Installation README](https://github.com/OfficeDev/Property-Inspection-Code-Sample/blob/master/README-RepairAppAAD.md) for complete instructions.

Xamarin Repair App
------------------

The mobile Repair App in the demo has also been built for Android devices with Xamarin.  The Xamarin version of the Repair App is written in .NET.

Some configuration is required to enable the Cordova Repair App to work with an Office 365 environment.  Read on to learn about the configuration process.

Xamarin Android Repair App Installation
---------------------------------------

Now you are ready to install the Xamarin Android App.  

In the XamarinRepairApp folder you will find runnable sample code for Xamarin Android Repair App.

1. On a PC, clone the GitHub repository.  

Configure Xamarin Android Repair App settings
---------------------------------------------

To configure the Xamarin Android Repair App follow these instructions.

1. Open Visual Studio 2015.
2. Open the **XamarinRepairApp.sln** you cloned from the GitHub repository.
3. In Visual Studio, right click the **XamarinRepairApp solution** and select **Clean**.
4. In the **XamarinRepairApp project**, open the **Constants.cs** file.
5. Edit the **SHAREPOINT_URL** variable to match your Office 365 / Azure Tenancy by **replacing the TENANCY placeholder** with your tenancy name.  In the example below, the TENANCY placeholder was replaced with contoso.

	**SHAREPOINT_URL** is the URL for the Site Collection created by the Property Manager web app.  Use the same value you configured in the web.config for the Property Manager web app for the DemoSiteCollectionUrl app setting.

    Example: contoso.sharepoint.com

6. Edit the **DISPATCHEREMAIL** variable to match your Office 365 / Azure Tenancy by **replacing the TENANCY placeholder** with your tenancy name.  In the example below, the TENANCY placeholder was replaced with contoso.

	**DISPATCHEREMAIL** is the email address for the dispatcher account you created.

    Example: katiej@contoso.onmicrosoft.com

7. Edit the **AAD_CLIENT_ID** variable.  This is the Client ID value you copied at step 12 in "Mobile Repair App Azure Active Directory Application Installation README".  This value is also displayed in the CONFIGURE page for the PropertyManagementRepairApp Azure Active Directory Application in the Azure Management Portal.


Set Up Android Virtual Device
-----------------------------

The Android Repair App targets the Nexus 9 device.  These steps describe how to configure an Android Virtual Device that replicates the Nexus 9.

1. In Visual Studio, click the **Tools** menu, select **Android**, and click **Open Android Emulator Manager** to open the Android Virtual Device Manager.
2. Use the Android Virtual Device Manager to configure the Nexus 9 device.  Refer to the image below.

	![](https://raw.githubusercontent.com/OfficeDev/Property-Inspection-Code-Sample/master/Documents/Nexus%209%20AVD%20Settings.png)

3. In the Android Virtual Device Manager, start the Nexus 9 Android Virtual Device.

	> **Note:** When the device is starting you can see if HAXM is enabled on your system and if the emulator is taking advantage of it.

	![](https://raw.githubusercontent.com/OfficeDev/Property-Inspection-Code-Sample/master/Documents/Starting%20Nexus%209%20AVD.png)

4. Wait for the device to boot, unlock it, and click the OK button.  

	> **Note:** This can take a long time, even up to 20 minutes if you have a slow computer or if you are using the ARM version of the device.

Run the Xamarin Android Repair App on the Nexus 9 Android Virtual Device
------------------------------------------------------------------------

1. In Visual Studio, select the **Any CPU Configuration** and the **Nexus_9** emulator.

	![](https://raw.githubusercontent.com/OfficeDev/Property-Inspection-Code-Sample/master/Documents/Xamarin%20Nexus%209%20Simulator.png)

2. Click **Build | Deploy Solution** to deploy the application to the Android emulator.
3. In the Android emulator, click the **apps button**.
4. Click the **Xamarin repair app icon** to load the repair app.
5. The Sign in screen will appear and you can now use the Xamarin Repair App during the demo.

**Xamarin Android Repair App Installation Complete!**

## License
Copyright (c) Microsoft, Inc. All rights reserved. Licensed under the Apache License, Version 2.0.




