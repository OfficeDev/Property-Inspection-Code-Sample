using System;
using System.Xml;
using System.Web;
using Microsoft.SharePoint.Client;
using System.Collections.Generic;

namespace SuiteLevelWebApp.Utils
{
    public class SiteProvisioning
    {
        private ClientContext _clientContext = null;

        #region Site Schema

        // field definition
        private readonly string[] _siteColumns = {
            "<Field DisplayName='Account name' Description='Account alias of person' Name='sl_accountname' ID='{df1dbcc9-970a-4c7a-8a69-a5cac17009a3}' Group='Suite Level App Columns' Type='Text' />",
            "<Field DisplayName='Email address' Description='Email address of person' Name='sl_emailaddress' ID='{b728cca4-1454-4873-97f4-e09ed2327be8}' Group='Suite Level App Columns' Type='Text' />",
            "<Field DisplayName='Inspection ID' Description='Lookup to Inspection list ID column' Name='sl_inspectionID' ID='{f5b97839-99bb-4b27-8b33-18d71aa41512}' Group='Suite Level App Columns' Type='Lookup' />",
            "<Field DisplayName='Incident ID' Description='Lookup to Incidents list ID column' Name='sl_incidentID' ID='{248e75d1-0ddd-447f-80c8-48e735a627ae}' Group='Suite Level App Columns' Type='Lookup' />",
            "<Field DisplayName='Room ID' Description='Lookup to Room list ID column' Name='sl_roomID' ID='{7cc87a4c-4cfc-45b6-8a48-0477d93cb02a}' Group='Suite Level App Columns' Type='Lookup' />",
            "<Field DisplayName='Date' Description='Date incident is reported' Name='sl_date' ID='{f3381d67-eb89-4863-be16-fc6074b8a0aa}' Group='Suite Level App Columns' Type='DateTime' Format='DateOnly'/>",
            "<Field DisplayName='Inspector incident comments' Description='' Name='sl_inspectorIncidentComments' ID='{1ba3be38-139f-460a-a21f-7c030ba7ba53}' Group='Suite Level App Columns' Type='Note' />",
            "<Field DisplayName='Dispatcher comments' Description='' Name='sl_dispatcherComments' ID='{6ba2d404-ee91-490d-8157-75e4f73f359d}' Group='Suite Level App Columns' Type='Note' />",
            "<Field DisplayName='Repair comments' Description='' Name='sl_repairComments' ID='{7ecd465b-de35-426c-b63f-7eee3eb2889d}' Group='Suite Level App Columns' Type='Note' />",
            "<Field DisplayName='Status' Description='Stores value used for workflow tracking' Name='sl_status' ID='{8970c7a0-2ca0-4e41-96ed-7fd28c881d5e}' Group='Suite Level App Columns' Type='Text' />",
            "<Field DisplayName='Property ID' Description='' Name='sl_propertyID' ID='{9c4fa332-2823-476e-b4c9-f82ac7deed8c}' Group='Suite Level App Columns' Type='Lookup'/>",
            "<Field DisplayName='Type' Description='' Name='sl_type' ID='{e7ba3ba3-bd77-4e5e-9d54-eaf54e23c0df}' Group='Suite Level App Columns' Type='Choice'><CHOICES><CHOICE>Plumbing</CHOICE><CHOICE>Electrical</CHOICE><CHOICE>Structural</CHOICE><CHOICE>Appliances</CHOICE></CHOICES></Field>",
            "<Field DisplayName='Owner' Description='Property Owner Display Name' Name='sl_owner' ID='{e91964c7-674a-4dea-8e79-c701c36ba7c7}' Group='Suite Level App Columns' Type='Text' />",
            "<Field DisplayName='Address 1' Description='First address line' Name='sl_address1' ID='{8efdc65c-77f9-4298-b2fc-d198aed3e185}' Group='Suite Level App Columns' Type='Text' />",
            "<Field DisplayName='Address 2' Description='Second address line' Name='sl_address2' ID='{f49794c4-02a0-4fe0-8d59-cba445f39f8d}' Group='Suite Level App Columns' Type='Text' />",
            "<Field DisplayName='City' Description='' Name='sl_city' ID='{7eda9354-dd7d-4c45-b67f-dc13c2c851ab}' Group='Suite Level App Columns' Type='Text' />",
            "<Field DisplayName='State' Description='' Name='sl_state' ID='{e6bf4436-70f4-4167-a0bb-4f811dac4445}' Group='Suite Level App Columns' Type='Text' />",
            "<Field DisplayName='Postal Code' Description='' Name='sl_postalCode' ID='{eb730fd9-0666-4d94-b7e2-8d06f51d0556}' Group='Suite Level App Columns' Type='Text' />",
            "<Field DisplayName='DateTime' Description='Date and time inspection is scheduled' Name='sl_datetime' ID='{2c92efc9-e22d-4887-a4ca-739f0ae72a8c}' Group='Suite Level App Columns' Type='DateTime'/>",
            "<Field DisplayName='Inspector Name' Description='' Name='sl_inspector' ID='{347cba7a-8cab-40fd-822b-c36c9bf7d4fb}' Group='Suite Level App Columns' Type='Text'/>",
            "<Field DisplayName='Latitude' Description='Location' Name='sl_latitude' ID='{9df940ae-8015-4758-8878-85f34c41e3fa}' Group='Suite Level App Columns' Type='Text' />",
            "<Field DisplayName='Longitude' Description='Location' Name='sl_longitude' ID='{6e717b81-afcc-43fa-a1b8-05f5be92622e}' Group='Suite Level App Columns' Type='Text' />",
            "<Field DisplayName='Finalized' Description='Date and time inspection is finalized' Name='sl_finalized' ID='{9310f0f3-88ab-4f21-9188-99dbc2c71cb7}' Group='Suite Level App Columns' Type='DateTime'/>",
            "<Field DisplayName='Repair Scheduled' Description='The date the repair is scheduled to happen' Name='sl_repairScheduled' ID='{438e53b8-dee5-41e5-8148-6367c3017b02}' Group='Suite Level App Columns' Type='DateTime' Format='DateOnly'/>",
            "<Field DisplayName='Repair Completed' Description='The date the repair is completed' Name='sl_repairCompleted' ID='{75546877-b81d-44ed-9b3c-dbc2e2a98787}' Group='Suite Level App Columns' Type='DateTime' Format='DateOnly'/>",
            "<Field DisplayName='Repair Approved' Description='The date the repair is approved' Name='sl_repairApproved' ID='{a6555266-c470-49eb-8ab7-3b5444146fab}' Group='Suite Level App Columns' Type='DateTime' Format='DateOnly'/>",
            "<Field DisplayName='Repair Person' Description='' Name='sl_repairPerson' ID='{f04884c1-7296-48c5-9720-b6944ce72eb4}' Group='Suite Level App Columns' Type='Text'/>",
            "<Field DisplayName='Task ID' Description='' Name='sl_taskId' ID='{247185a7-f335-4e51-b94e-a04f87e6e775}' Group='Suite Level App Columns' Type='Number'/>"
        };

        public SiteProvisioning(ClientContext clientContext)
        {
            _clientContext = clientContext;
        }

        public void AddSiteComponents()
        {
            // Create site columns
            CSOMUtil.CreateSiteColumns(_clientContext, _siteColumns);

            // Create Content Type "Property" and List "Properties"
            CSOMUtil.CreateContentType(_clientContext, "Property", "", "0x0100DA7D2213C0CC4C4782C9C50DE696DB86", new string[] { 
                "sl_owner",
                "sl_emailaddress",
                "sl_address1", 
                "sl_address2", 
                "sl_city", 
                "sl_state", 
                "sl_postalCode",
                "sl_latitude",
                "sl_longitude"
            });
            CSOMUtil.AddSharePointList(_clientContext, "0x0100DA7D2213C0CC4C4782C9C50DE696DB86", "Properties", "Lists/Properties", (int)ListTemplateType.GenericList);

            // Create Content Type "Room" and List "Rooms"
            CSOMUtil.CreateContentType(_clientContext, "Room", "", "0x0100981711E5CE33481C85F37734423082DB", new string[] { 
                "sl_propertyID" 
            });
            CSOMUtil.AddSharePointList(_clientContext, "0x0100981711E5CE33481C85F37734423082DB", "Rooms", "Lists/Rooms", (int)ListTemplateType.GenericList);
            CSOMUtil.BindLookupField(_clientContext, "Rooms", "sl_propertyID", "ID", "Properties");

            // Create Content Type "Inspection" and List "Inspections"
            CSOMUtil.CreateContentType(_clientContext, "Inspection", "", "0x01001D53426644A048A7A6E29683A8351143", new string[] { 
                "sl_datetime", 
                "sl_inspector", 
                "sl_emailaddress",
                "sl_propertyID",
                "sl_finalized"
            });
            CSOMUtil.AddSharePointList(_clientContext, "0x01001D53426644A048A7A6E29683A8351143", "Inspections", "Lists/Inspections", (int)ListTemplateType.GenericList, true);
            CSOMUtil.BindLookupField(_clientContext, "Inspections", "sl_propertyID", "ID", "Properties");

            // Create Content Type "Inspection Comment" and List "Inspection Comments"
            CSOMUtil.CreateContentType(_clientContext, "Inspection Comment", "", "0x0100232C3EC9E48A4838983CC2F8FFB3D8E3", new string[] {
                "sl_inspectionID", 
                "sl_roomID" 
            });
            CSOMUtil.AddSharePointList(_clientContext, "0x0100232C3EC9E48A4838983CC2F8FFB3D8E3", "Inspection Comments", "Lists/InspectionComments", (int)ListTemplateType.GenericList);
            CSOMUtil.BindLookupField(_clientContext, "Inspection Comments", "sl_inspectionID", "ID", "Inspections");
            CSOMUtil.BindLookupField(_clientContext, "Inspection Comments", "sl_roomID", "ID", "Rooms");

            // Create Content Type "Incident" and List "Incidents"
            CSOMUtil.CreateContentType(_clientContext, "Incident", "", "0x0100B34132E48D364D4781878210F1663255", new string[] { 
                "sl_date", 
                "sl_inspectorIncidentComments", 
                "sl_dispatcherComments", 
                "sl_repairComments",
                "sl_status",
                "sl_repairScheduled",
                "sl_repairCompleted",
                "sl_repairApproved",
                 "sl_repairPerson",
                "sl_propertyID", 
                "sl_inspectionID",
                "sl_roomID", 
                "sl_type",
                "sl_taskId"
            });
            CSOMUtil.AddSharePointList(_clientContext, "0x0100B34132E48D364D4781878210F1663255", "Incidents", "Lists/Incidents", (int)ListTemplateType.GenericList);
            CSOMUtil.BindLookupField(_clientContext, "Incidents", "sl_propertyID", "ID", "Properties");
            CSOMUtil.BindLookupField(_clientContext, "Incidents", "sl_inspectionID", "ID", "Inspections");
            CSOMUtil.BindLookupField(_clientContext, "Incidents", "sl_roomID", "ID", "Rooms");
           
            // Create Content Type "Room Inspection Photo" and Document Lib "Room Inspection Photos"
            CSOMUtil.CreateContentType(_clientContext, "Room Inspection Photo", "", "0x010100ECBC5A98AA6F42729342F940B0F10493", new string[] { 
                "sl_inspectionID", 
                "sl_incidentID", 
                "sl_roomID" 
            });
            CSOMUtil.AddSharePointList(_clientContext, "0x010100ECBC5A98AA6F42729342F940B0F10493", "Room Inspection Photos", "RoomInspectionPhotos", (int)ListTemplateType.DocumentLibrary);
            CSOMUtil.BindLookupField(_clientContext, "Room Inspection Photos", "sl_inspectionID", "ID", "Inspections");
            CSOMUtil.BindLookupField(_clientContext, "Room Inspection Photos", "sl_incidentID", "ID", "Incidents");
            CSOMUtil.BindLookupField(_clientContext, "Room Inspection Photos", "sl_roomID", "ID", "Rooms");

            // Create Content Type "Repair Photo" and Document Lib "Repair Photos"
            CSOMUtil.CreateContentType(_clientContext, "Repair Photo", "", "0x010100F15273431C9143FCBA2C914F293399E9", new string[] { 
                "sl_inspectionID", 
                "sl_incidentID", 
                "sl_roomID" 
            });
            CSOMUtil.AddSharePointList(_clientContext, "0x010100F15273431C9143FCBA2C914F293399E9", "Repair Photos", "RepairPhotos", (int)ListTemplateType.DocumentLibrary);
            CSOMUtil.BindLookupField(_clientContext, "Repair Photos", "sl_inspectionID", "ID", "Inspections");
            CSOMUtil.BindLookupField(_clientContext, "Repair Photos", "sl_incidentID", "ID", "Incidents");
            CSOMUtil.BindLookupField(_clientContext, "Repair Photos", "sl_roomID", "ID", "Rooms");

            // Create Content Type "Property Photo" and Document Lib "Property Photos"
            CSOMUtil.CreateContentType(_clientContext, "Property Photo", "", "0x0101006C010CC23D0643E3AADDC173CE461770", new string[] { 
                "sl_propertyID" 
            });
            CSOMUtil.AddSharePointList(_clientContext, "0x0101006C010CC23D0643E3AADDC173CE461770", "Property Photos", "PropertyPhotos", (int)ListTemplateType.DocumentLibrary);
            CSOMUtil.BindLookupField(_clientContext, "Property Photos", "sl_propertyID", "ID", "Properties");
        }

        public void RemoveSiteComponents()
        {
            //Delete lists
            CSOMUtil.RemoveSharePointList(_clientContext, "Properties");
            CSOMUtil.RemoveSharePointList(_clientContext, "Rooms");
            CSOMUtil.RemoveSharePointList(_clientContext, "Inspections");
            CSOMUtil.RemoveSharePointList(_clientContext, "Inspection Comments");
            CSOMUtil.RemoveSharePointList(_clientContext, "Incidents");
            CSOMUtil.RemoveSharePointList(_clientContext, "Room Inspection Photos");
            CSOMUtil.RemoveSharePointList(_clientContext, "Repair Photos");
            CSOMUtil.RemoveSharePointList(_clientContext, "Property Photos");

            //Delete content types
            CSOMUtil.RemoveContentType(_clientContext, "0x0100EF599D47A3D2409193AC8276BE6DECB8");
            CSOMUtil.RemoveContentType(_clientContext, "0x0100DA7D2213C0CC4C4782C9C50DE696DB86");
            CSOMUtil.RemoveContentType(_clientContext, "0x0100981711E5CE33481C85F37734423082DB");
            CSOMUtil.RemoveContentType(_clientContext, "0x0100D2E3A1E1221041048FCCF4ACA70716FC");
            CSOMUtil.RemoveContentType(_clientContext, "0x01001D53426644A048A7A6E29683A8351143");
            CSOMUtil.RemoveContentType(_clientContext, "0x0100232C3EC9E48A4838983CC2F8FFB3D8E3");
            CSOMUtil.RemoveContentType(_clientContext, "0x0100B34132E48D364D4781878210F1663255");
            CSOMUtil.RemoveContentType(_clientContext, "0x010100ECBC5A98AA6F42729342F940B0F10493");
            CSOMUtil.RemoveContentType(_clientContext, "0x010100F15273431C9143FCBA2C914F293399E9");
            CSOMUtil.RemoveContentType(_clientContext, "0x0101006C010CC23D0643E3AADDC173CE461770");

            //Delete site columns
            CSOMUtil.RemoveSiteColumns(_clientContext, _siteColumns);
        }

        #endregion

        #region Sample Data

        public void AddSiteContents()
        {
            XmlDocument sampleData = new XmlDocument();

            var sampleDataUrl = HttpContext.Current.Request.Url.Scheme + "://" + HttpContext.Current.Request.Url.Authority + "/Content/SampleData.xml";

            sampleData.Load(sampleDataUrl);
            replaceTenantId(sampleData);

           //add items to Properties list
            CSOMUtil.AddListItems(_clientContext, "Properties", sampleData);

            //add items to Rooms list
            CSOMUtil.AddListItems(_clientContext, "Rooms", sampleData);

            //add items to Inspections list
            CSOMUtil.AddListItems(_clientContext, "Inspections", sampleData);

            //add items to Inspection Comments list
            CSOMUtil.AddListItems(_clientContext, "Inspection Comments", sampleData);

            //add items to Incidents list
            CSOMUtil.AddListItems(_clientContext, "Incidents", sampleData);

            //add items to Room Inspection Photos list
            CSOMUtil.AddDocumentLibItems(_clientContext, "Room Inspection Photos", sampleData);

            //add items to Repair Photos list
            CSOMUtil.AddDocumentLibItems(_clientContext, "Repair Photos", sampleData);

            //add items to Property Photos list
            CSOMUtil.AddDocumentLibItems(_clientContext, "Property Photos", sampleData);
        }

        private void replaceTenantId(XmlDocument sampleData)
        {
            var emails = sampleData.SelectNodes("//column[@name='sl_emailaddress']");
            var Tenant = System.Configuration.ConfigurationManager.AppSettings["DemoSiteCollectionOwner"].Split('@')[1];

            if (string.IsNullOrEmpty(Tenant)) return;

            foreach (XmlNode email in emails)
            {
                email.InnerText = email.InnerText.Replace("(tenancy)", Tenant);
            }
        }

        public void UpdateInspectionListItem(DateTime demodate)
        {
            List inspctionlist = _clientContext.Web.Lists.GetByTitle("Inspections");
            CamlQuery inspectionquery = new CamlQuery();
            String inspectionqueryxml = "<View><Query><OrderBy><FieldRef Name=\"ID\" Ascending=\"FALSE\"></FieldRef></OrderBy></Query><ViewFields><FieldRef Name=\"ID\"/><FieldRef Name=\"sl_datetime\"/><FieldRef Name=\"sl_finalized\"/></ViewFields><RowLimit>5</RowLimit></View>";
            inspectionquery.ViewXml = inspectionqueryxml;

            List incidentlist = _clientContext.Web.Lists.GetByTitle("Incidents");
            CamlQuery incidentquery = new CamlQuery();
            String incidentqueryxml = "<View><Query><OrderBy><FieldRef Name=\"ID\" Ascending=\"FALSE\"></FieldRef></OrderBy></Query><ViewFields><FieldRef Name=\"ID\"/><FieldRef Name=\"sl_date\"/></ViewFields><RowLimit>3</RowLimit></View>";
            incidentquery.ViewXml = incidentqueryxml;

            ListItemCollection inspectionitems = inspctionlist.GetItems(inspectionquery);
            ListItemCollection incidentitems = incidentlist.GetItems(incidentquery);

            _clientContext.Load(inspectionitems);
            _clientContext.Load(incidentitems);
            _clientContext.ExecuteQuery();

            if (inspectionitems.Count == 5)
            {
                ListItem listItem0 = inspectionitems[0];
                listItem0["sl_datetime"] = this.getNewDateTime(1, 20, 0, demodate);
                listItem0.Update();

                ListItem listItem1 = inspectionitems[1];
                listItem1["sl_datetime"] = this.getNewDateTime(1, 19, 0, demodate);
                listItem1.Update();

                ListItem listItem2 = inspectionitems[2];
                listItem2["sl_datetime"] = this.getNewDateTime(0, 21, 0, demodate);
                listItem2["sl_finalized"] = this.getNewDateTime(0, 21, 30, demodate);
                listItem2.Update();

                ListItem listItem3 = inspectionitems[3];
                listItem3["sl_datetime"] = this.getNewDateTime(0, 20, 0, demodate);
                listItem3["sl_finalized"] = this.getNewDateTime(0, 20, 30, demodate);
                listItem3.Update();

                ListItem listItem4 = inspectionitems[4];
                listItem4["sl_datetime"] = this.getNewDateTime(0, 19, 0, demodate);
                listItem4["sl_finalized"] = this.getNewDateTime(0, 19, 30, demodate);
                listItem4.Update();
                _clientContext.ExecuteQuery();

            }
            if (incidentitems.Count == 3)
            {
                ListItem listItem2 = incidentitems[0];
                listItem2["sl_date"] = this.getNewDateTime(0, 21, 10, demodate);
                listItem2.Update();

                ListItem listItem3 = incidentitems[1];
                listItem3["sl_date"] = this.getNewDateTime(0, 20, 10, demodate);
                listItem3.Update();

                ListItem listItem4 = incidentitems[2];
                listItem4["sl_date"] = this.getNewDateTime(0, 19, 10, demodate);
                listItem4.Update();
                _clientContext.ExecuteQuery();
            }

        }
        private DateTime getNewDateTime(int days, int hours,int min, DateTime olddate)
        {
            DateTime date = olddate.AddDays(days);
            return new DateTime(date.Year, date.Month, date.Day, hours, min, 0);
        }
        #endregion
    }
}