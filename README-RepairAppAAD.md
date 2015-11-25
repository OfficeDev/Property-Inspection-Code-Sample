# Property Management Code Sample

Mobile Repair App Azure Active Directory Application Installation
=================================================================

The Android, Cordova, and Xamarin Repair Apps use Office 365 APIs and SharePoint REST APIs to interact with an Office 365 / Azure tenancy.  The Azure Active Directory Application is used to authorize the Android, Cordova, and Xamarin Repair Apps.  To register the Android, Cordova, and Xamarin Repair Apps with an Azure Active Directory follow these instructions.

Create Azure Active Directory Application for the Android, Cordova, and Xamarin Repair Apps
-------------------------------------------------------------------------------------------

1. Open the Azure Management Portal
2. Select **Active Directory**
3. Click on your AAD
4. Click **Applications**
5. Click **Add**
6. Click **Add an application my organization is developing**
7. In the Name textbox enter **PropertyManagementRepairApp**
8. For Type, select **NATIVE CLIENT APPLICATION**
9. Click the **Arrow button**
10. In the Redirect URI textbox enter **http://PropertyManagementRepairApp**
11. Click the **Checkmark button**
12. Expand the update your code section and **copy** the Redirect URI and Client ID values and **paste** them into a text file.  You will use these values when you configure the Android Repair App in Android Studio.
13. Click **CONFIGURE**
14.	In the permissions to other applications section, click the **Add application** button.
15.	Click the + button next to **Office 365 SharePoint Online** and **Office 365 unified API (preview)**.
16.	Click the **Checkmark button**
17.	Configure the permission to Office 365 unified API (preview), use the screenshot below for reference.
![](https://raw.githubusercontent.com/OfficeDev/Property-Inspection-Code-Sample/master/Documents/O365 Unified API AD Permissions.jpg)
18.	Configure the permission to Microsoft Office 365 SharePoint, use the screenshot below for reference.
![](https://raw.githubusercontent.com/OfficeDev/Property-Inspection-Code-Sample/master/Documents/O365 SP AAD App Permissions.jpg)
19. Click **Save**

## License
Copyright (c) Microsoft, Inc. All rights reserved. Licensed under the Apache License, Version 2.0.


