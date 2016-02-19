# Property Management Code Sample

> **IMPORTANT NOTE:** You must install the Web Application before the Android app will work.  During the Web application installation process all of the components and sample data which support the demo are provisioned.  See the [Install Web Application README](https://github.com/OfficeDev/Property-Inspection-Code-Sample/blob/master/PropertyManagerMyApp/README.md) for complete instructions.

Mobile Repair App Azure Active Directory Application Installation
=================================================================

The Android, Cordova, and Xamarin Repair Apps use Office 365 APIs and SharePoint REST APIs to interact with an Office 365 / Azure tenancy.  The Azure Active Directory Application is used to authorize the Android, Cordova, and Xamarin Repair Apps.  To register the Android, Cordova, and Xamarin Repair Apps with an Azure Active Directory see the [Mobile Repair App Azure Active Directory Application Installation README](https://github.com/OfficeDev/Property-Inspection-Code-Sample/blob/master/README-RepairAppAAD.md) for complete instructions.

Android Repair App
------------------

The mobile Repair App in the demo may also be run on Android in addition to the iOS version. The Android version of the Repair App is written in Java, the native language for an Android device.  

Some configuration is required to enable the Android Repair App to work with an Office 365 environment.  Read on to learn about the configuration process.

> This sample was tested with  Android Studio version 1.3.1.

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

	![](https://raw.githubusercontent.com/OfficeDev/Property-Inspection-Code-Sample/master/Documents/android%20constants%20file.png)

6. Edit the **SHAREPOINT_URL** variable to match your Office 365 / Azure Tenancy by **replacing the TENANCY placeholder** with your tenancy name.  In the example below, the TENANCY placeholder was replaced with contoso.

	**SHAREPOINT_URL** is the URL for the Site Collection created by the Property Manager web app.  Use the same value you configured in the web.config for the Property Manager web app for the DemoSiteCollectionUrl app setting.

    Example: contoso.onmicrosoft.com

7. Edit the **DISPATCHEREMAIL** variable to match your Office 365 / Azure Tenancy by **replacing the TENANCY placeholder** with your tenancy name.  In the example below, the TENANCY placeholder was replaced with contoso.

	**DISPATCHEREMAIL** is the email address for the dispatcher account you created.

    Example: katiej@contoso.onmicrosoft.com

8. Edit the **AAD_CLIENT_ID** variable.  This is the Client ID value you copied at step 12 in "Mobile Repair App Azure Active Directory Application Installation README".  This value is also displayed in the CONFIGURE page for the PropertyManagementRepairApp Azure Active Directory Application in the Azure Management Portal.

9. Edit the **AAD_REDIRECT_URL** variable.  This is the Redirect URI value you copied at step 12 in "Mobile Repair App Azure Active Directory Application Installation README".  This value is also displayed in the CONFIGURE page for the PropertyManagementRepairApp Azure Active Directory Application in the Azure Management Portal.

Items that you need a real Android device to run
------------------------------------------------

Some of the functionality int he app will not work in the Android emulator.  You must run the app on a real device to use the following functionality.

1. Uploading a video to the Office 365 Video Portal.
2. Opening Word, Excel, and PowerPoint documents in the native Android Office applications via Deep Links. 

Set Up Android Virtual Device
-----------------------------

The Android Repair App targets the Nexus 9 device.  These steps describe how to configure an Android Virtual Device that replicates the Nexus 9.

1. In Android Studio, click the **Tools** menu, select **Android**, and click **AVD Manager** to open the Android Virtual Device Manager.
2. Use the Android Virtual Device Manager to create the Nexus 9 device.  **Click Create Virtual Device.**  Refer to the image below.

	![](https://raw.githubusercontent.com/OfficeDev/Property-Inspection-Code-Sample/master/Documents/Create%20AVD.png)

3. In the category list select **Tablet**, then select the **Nexus 9** device and click **Next**.  Refer to the image below.

	![](https://raw.githubusercontent.com/OfficeDev/Property-Inspection-Code-Sample/master/Documents/AVD%20Tablet%20Nexus%209.png)

4. Select **Lollipop 22 x86**. (Select Lollipop 22 armeabi-v7a if you can’t install HAXM.  For example: If your Android Studio is installed on a virtual machine that does not support VT-x)  Click **Next**.  Refer to the image below.

	![](https://raw.githubusercontent.com/OfficeDev/Property-Inspection-Code-Sample/master/Documents/AVD%20System%20Image%20Lollipop.png)

5. Ensure the Orientation is set to **Landscape** and click **Finish**.  Refer to the image below.

	![](https://raw.githubusercontent.com/OfficeDev/Property-Inspection-Code-Sample/master/Documents/AVD%20Nexus%209%20Advanced%20Settings.png)

6. In the Android Virtual Device Manager, start the Nexus 9 Android Virtual Device.

	> **Note:** When the device is starting you can see if HAXM is enabled on your system and if the emulator is taking advantage of it.

	![](https://raw.githubusercontent.com/OfficeDev/Property-Inspection-Code-Sample/master/Documents/Select%20Nexus%209%20AVD%20-%202.png)

	![](https://raw.githubusercontent.com/OfficeDev/Property-Inspection-Code-Sample/master/Documents/Starting%20Nexus%209%20AVD.png)

7. Wait for the device to boot, and unlock it.  

	> **Note:** This can take a long time, up to 20 minutes if you have a slow computer or if you are using the ARM version of the device.

Install the OneNote native Android application
----------------------------------------------

The repair app uses deep links to automatically open the native Android OneNote application.  To enable this functionality in an emulator follow these steps.

> **Note:** You can only install the OneNote native Android application in an ARM emulator, it will not work with the Intel HAXM emulators.

> **Note:** We have had limited success with this approach.  It works on some computers and not on others.  If this doe snot work for you then install the native Android OneNote app on a real Android device and run the repair app ont he real Android device.

1. Copy the OneNote.apk file to the Android SDK platform-tools folder on your machine.
2. Open a command prompt as an administrator.
3. Change to the Android SDK platform-tools folder.
4. Execute the following command:

	`adb install OneNote.apk
	`
5. Wait for the installation to complete. The image below shows what a successful installation looks like in the command prompt.

	![](https://raw.githubusercontent.com/OfficeDev/Property-Inspection-Code-Sample/master/Documents/Install%20OneNote%20In%20Android%20Emulator.png)

	> **Note:** You must access OneDrive or OneNote in the web browser to provision the OneDrive and Notebook first.  If you do not do this then the OneNote client app will fail to load even outside the context of launching it from the repair app.
 
Run the Repair App on the Nexus 9 Android Virtual Device
--------------------------------------------------------

1. In Android Studio, click the **Run** menu and select **Run app**.
2. Select the **Nexus 9 Android Virtual Device** you already started.
3. Click **OK**.

The Sign in screen will appear and you can now use the Android Repair App during the demo.

**Android Repair App Installation Complete!**

## License
Copyright (c) Microsoft, Inc. All rights reserved. Licensed under the Apache License, Version 2.0.



