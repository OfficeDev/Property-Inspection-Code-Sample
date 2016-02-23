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
15.	Click the + button next to **Microsoft Office 365 SharePoint** and **Microsoft Graph API**.
16.	Click the **Checkmark button**
17.	Select the following permissions for **Microsoft Graph API**:
	- Read all notebooks that user can access (preview)
	- Sign users in
	- Send email as a user
	- Read and write all groups
	- Read all users' full profiles
	- Sign in and read user profile
17.	Select the following permissions for **Microsoft Office 365 SharePoint**:
	- Have full control of all site collections
19. Click **Save**

## License
Copyright (c) Microsoft, Inc. All rights reserved. Licensed under the Apache License, Version 2.0.


