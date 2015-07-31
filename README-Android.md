# Property Inspection Code Sample

Mobile Repair App Azure Active Directory Application Installation
=================================================================

The Android, Cordova, and Xamarin Repair Apps use O365 APIs and SharePoint REST APIs to interact with an O365 / Azure tenancy.  The Azure Active Directory Application is used to authorize the Android, Cordova, and Xamarin Repair Apps.  To register the Android, Cordova, and Xamarin Repair Apps with an Azure Active Directory see the [Install iOS README](https://github.com/OfficeDev/Property-Inspection-Code-Sample/blob/master/README-iOS.md) for complete instructions.

Android Repair App
------------------

The mobile Repair App in the demo may also be run on Android in addition to the iOS version. The Android version of the Repair App is written in Java, the native language for an Android device.  

Some configuration is required to enable the Android Repair App to work with an O365 environment.  Read on to learn about the configuration process.

> This sample was tested with version 1.2.1.1 of Android Studio.

Android Repair App Installation
-------------------------------

Now you are ready to install the Android App.  

In the AndroidRepairApp folder you will find runnable sample code for Android Repair App.

1. On a PC or Mac machine, clone the GitHub repository.  

Configure Android Repair App settings
-------------------------------------

To configure the Android Repair App follow these instructions.

1. Open **Android Studio**.  If it a project is already open, then close that project.
2. In the Quick Start menu, select **Open an existing Android Studio project**.
3. Select the **AndroidRepairApp** directory you cloned from the GitHub repository.
4. Click **OK**.
5. Open the **\app\src\main\java\com.canviz.repairapp\Constants.java** file (See screenshot below for reference)

	![](https://raw.githubusercontent.com/OfficeDev/Property-Inspection-Code-Sample/master/Documents/android constants file.png)

6. Edit the **SHAREPOINT_URL** variable to match your O365 / Azure Tenancy by **replacing the TENANCY placeholder** with your tenancy name.  In the example below, the TENANCY placeholder was replaced with contoso.

	**SHAREPOINT_URL** is the URL for the Site Collection created by the Property Manager web app.  Use the same value you configured in the web.config for the Property Manager web app for the DemoSiteCollectionUrl app setting.

    Example: contoso.onmicrosoft.com

7. Edit the **DISPATCHEREMAIL** variable to match your O365 / Azure Tenancy by **replacing the TENANCY placeholder** with your tenancy name.  In the example below, the TENANCY placeholder was replaced with contoso.

	**DISPATCHEREMAIL** is the email address for the dispatcher account you created.

    Example: katiej@contoso.onmicrosoft.com

8. Edit the **AAD_CLIENT_ID** variable.  This is the Client ID value you copied and pasted in the steps above.  This value is also displayed in the CONFIGURE page for the PropertyManagementRepairApp Azure Active Directory Application in the Azure Management Portal.

9. Edit the **AAD_REDIRECT_URL** variable.  This is the Redirect URI value you copied and pasted in the steps above.  This value is also displayed in the CONFIGURE page for the PropertyManagementRepairApp Azure Active Directory Application in the Azure Management Portal.

Set Up Android Virtual Device
-----------------------------

The Android Repair App targets the Nexus 9 device.  These steps describe how to configure an Android Virtual Device that replicates the Nexus 9.

1. In Android Studio, click the **Tools** menu, select **Android**, and click **AVD Manager** to open the Android Virtual Device Manager.
2. Use the Android Virtual Device Manager to create the Nexus 9 device.  **Click Create Virtual Device.**  Refer to the image below.

	![](https://raw.githubusercontent.com/OfficeDev/Property-Inspection-Code-Sample/master/Documents/Create AVD.png)

3. In the category list select **Tablet**, then select the **Nexus 9** device and click **Next**.  Refer to the image below.

	![](https://raw.githubusercontent.com/OfficeDev/Property-Inspection-Code-Sample/master/Documents/AVD Tablet Nexus 9.png)

4. Select **Lollipop 22 x86**. (Select Lollipop 22 armeabi-v7a if you can’t install HAXM.  For example: If your Android Studio is installed on a virtual machine that does not support VT-x)  Click **Next**.  Refer to the image below.

	![](https://raw.githubusercontent.com/OfficeDev/Property-Inspection-Code-Sample/master/Documents/AVD System Image Lollipop.png)

5. Ensure the Orientation is set to **Landscape** and click **Finish**.  Refer to the image below.

	![](https://raw.githubusercontent.com/OfficeDev/Property-Inspection-Code-Sample/master/Documents/AVD Nexus 9 Advanced Settings.png)

3. In the Android Virtual Device Manager, start the Nexus 9 Android Virtual Device.

	> **Note:** When the device is starting you can see if HAXM is enabled on your system and if the emulator is taking advantage of it.

	![](https://raw.githubusercontent.com/OfficeDev/Property-Inspection-Code-Sample/master/Documents/Select Nexus 9 AVD - 2.png)

	![](https://raw.githubusercontent.com/OfficeDev/Property-Inspection-Code-Sample/master/Documents/Starting Nexus 9 AVD.png)

4. Wait for the device to boot, and unlock it.  

	> **Note:** This can take a long time, up to 20 minutes if you have a slow computer or if you are using the ARM version of the device.

Run the Repair App on the Nexus 9 Android Virtual Device
--------------------------------------------------------

1. In Android Studio, click the **Run** menu and select **Run app**.
2. Select the **Nexus 9 Android Virtual Device** you already started.
3. Click **OK**.

The Sign in screen will appear and you can now use the Android Repair App during the demo.

**Android Repair App Installation Complete!**

## License
Copyright (c) Microsoft, Inc. All rights reserved. Licensed under the Apache License, Version 2.0.


