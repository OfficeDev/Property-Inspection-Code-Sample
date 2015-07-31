# Property Inspection Code Sample

Mobile Repair App Azure Active Directory Application Installation
=================================================================

The Android, Cordova, and Xamarin Repair Apps use O365 APIs and SharePoint REST APIs to interact with an O365 / Azure tenancy.  The Azure Active Directory Application is used to authorize the Android, Cordova, and Xamarin Repair Apps.  To register the Android, Cordova, and Xamarin Repair Apps with an Azure Active Directory see the [Mobile Repair App Azure Active Directory Application Installation README](https://github.com/OfficeDev/Property-Inspection-Code-Sample/blob/master/README-RepairAppAAD.md) for complete instructions.
Cordova Repair App
------------------

The mobile Repair App in the demo may also be run on Cordova in addition to the iOS version. The Cordova version of the Repair App is written in HTML, JavaScript and CSS.  It uses the Knockout.js framework for data binding.

The Cordova Repair App supports iOS, Android, and Windows devices.

Some configuration is required to enable the Cordova Repair App to work with an O365 environment.  Read on to learn about the configuration process.

Cordova Repair App Installation
-------------------------------

Now you are ready to install the Cordova App.  

In the CordovaRepairApp folder you will find runnable sample code for Cordova Repair App.

1. On a PC, clone the GitHub repository.  

Configure Cordova Repair App settings
-------------------------------------

To configure the Cordova Repair App follow these instructions.

1. Open Visual Studio 2013 Studio.
2. Open the **CordovaRepairApp.sln** Visual Studio 2013 Solution you cloned from the GitHub repository.

	> **Note:**  There are three different settings files which allow you to configure each version of the Cordova App separately.  This is helpful when your emulator redirect URIs are not all the same and also when you wish to use different Azure Active Directory applications when testing the applications in a larger development and testing team in separate environments.

3. To configure the iOS version of the Cordova Repair App, open the **\CordovaRepairApp\services\office365\settings\settings.js** file.
4. To configure the Android version of the Cordova Repair App, open the **\CordovaRepairApp\merges\android\services\office365\settings\settings.js** file.
5. To configure the Cordova version of the Cordova Repair App, open the **\CordovaRepairApp\merges\windows\services\office365\settings\settings.js** file.

	In each file make the following edits and corresponding Azure Active Directory App modifications. 

6. Edit the **Settings.sitecollectionUrl** variable to match your O365 / Azure Tenancy by **replacing the TENANCY placeholder** with your tenancy name.  In the example below, the TENANCY placeholder was replaced with contoso.

	**Settings.sitecollectionUrl** is the URL for the Site Collection created by the Property Manager web app.  Use the same value you configured in the web.config for the Property Manager web app for the DemoSiteCollectionUrl app setting.

    Example: https://contoso.sharepoint.com/sites/SuiteLevelAppDemo

7. Edit the **Settings.dispatcherEmail** variable to match your O365 / Azure Tenancy by **replacing the TENANCY placeholder** with your tenancy name.  In the example below, the TENANCY placeholder was replaced with contoso.

	**Settings.dispatcherEmail** is the email address for the dispatcher account you created.

    Example: katiej@contoso.onmicrosoft.com

8. Edit the **Settings.resourceId** variable to match your O365 / Azure Tenancy by **replacing the TENANCY placeholder** with your tenancy name.  In the example below, the TENANCY placeholder was replaced with contoso.

	**Settings.resourceId** is the URL for the root site collection in your O365 tenancy.

    Example: https://contoso.sharepoint.com/

9. Edit the **Settings.clientId** variable.  This is the Client ID value you copied and pasted in the steps above.  This value is also displayed in the CONFIGURE page for the PropertyManagementRepairApp Azure Active Directory Application in the Azure Management Portal.

10. Copy the **Settings.redirectUri** variable.  In the Windows Azure Management Portal, open the CONFIGURE page for the PropertyManagementRepairApp Azure Active Directory Application in the Azure Management Portal.
11. Paste the copied **Settings.redirectUri** value into the Redirect URIs section.

12. **Save** the PropertyManagementRepairApp Azure Active Directory Application.

Run the Repair App on the Windows Simulator
-------------------------------------------

The Cordova Windows Repair App targets the Windows Surface Pro device.  This is the easiest emulator to set up.

1. In Visual Studio, right click the **CordovaRepairApp solution** and select **Clean**.
2. In Visual Studio, select the **Windows-AnyCPU Configuration** and the **Simulator**.

	![](https://raw.githubusercontent.com/OfficeDev/Property-Inspection-Code-Sample/master/Documents/Cordova - Windows Simulator.png)

3. Click the **green arrow** to run the application.

The Sign in screen will appear and you can now use the Cordova Windows Repair App during the demo.

Set Up Android Virtual Device
-----------------------------

The Cordova Android Repair App targets the Nexus 9 device.  These steps describe how to configure an Android Virtual Device that replicates the Nexus 9.

1. In Visual Studio, click the **Tools** menu, select **Android**, and click **Android Emulator Manager** to open the Android Virtual Device Manager.
2. Use the Android Virtual Device Manager to configure the Nexus 9 device.  Refer to the image below.

	![](https://raw.githubusercontent.com/OfficeDev/Property-Inspection-Code-Sample/master/Documents/Nexus 9 AVD Settings.png)

3. In the Android Virtual Device Manager, start the Nexus 9 Android Virtual Device.

	> **Note:** When the device is starting you can see if HAXM is enabled on your system and if the emulator is taking advantage of it.

	![](https://raw.githubusercontent.com/OfficeDev/Property-Inspection-Code-Sample/master/Documents/Starting Nexus 9 AVD.png)

4. Wait for the device to boot, unlock it, and click the OK button.  

	> **Note:** This can take a long time, even up to 20 minutes if you have a slow computer or if you are using the ARM version of the device.

Run the Repair App on the Nexus 9 Android Virtual Device
--------------------------------------------------------

1. In Visual Studio, right click the **CordovaRepairApp solution** and select **Clean**.
2. In Visual Studio, select the **Android Configuration** and the **Android Emulator**.

	![](https://raw.githubusercontent.com/OfficeDev/Property-Inspection-Code-Sample/master/Documents/Cordova - Android Simulator.png)

3. Click the **green arrow** to run the application.

The Sign in screen will appear and you can now use the Cordova Android Repair App during the demo.

Run the Repair App on the iOS Simulator
---------------------------------------

The Cordova iOS Repair App targets the iPad Air device.  Using the iOS Sumlator for iPad requires a Mac in addition to your PC.  Follow the steps in the following MSDN articles to configure your PC and Mac to enable you to build the Cordova iOS Repair App on your PC and run it in the iOS Simulator on your Mac.

- Installing: http://msdn.microsoft.com/en-us/library/dn757054.aspx
- Configuring: http://msdn.microsoft.com/en-us/library/dn771551.aspx
- Running: http://msdn.microsoft.com/en-us/library/dn757056.aspx

1. In Visual Studio, right click the **CordovaRepairApp solution** and select **Clean**.
2. In Visual Studio, select the **iOS Configuration** and the **Simulator - iPad Air**.

	![](https://raw.githubusercontent.com/OfficeDev/Property-Inspection-Code-Sample/master/Documents/Cordova - iOS Simulator.png)

3. Click the **green arrow** to run the application.

The Sign in screen will appear and you can now use the Cordova Windows Repair App during the demo.

**Cordova Repair App Installation Complete!**

## License
Copyright (c) Microsoft, Inc. All rights reserved. Licensed under the Apache License, Version 2.0.