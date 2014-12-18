using Newtonsoft.Json.Linq;
using SuiteLevelWebApp.Models;
using System;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Office365.OutlookServices;

namespace SuiteLevelWebApp.Service
{
    public class EmailService
    {
        public static readonly string DispatcherName = ConfigurationManager.AppSettings["DispatcherName"];
        public static readonly string DispatcherEmail = ConfigurationManager.AppSettings["DispatcherEmail"];

        private string sharePointServiceEndpointUri;
        private string sharePointAccessToken;

        private string siteRootDirectory;
        private string bodyTemplateFile;

        public EmailService(string sharePointAccessToken, string siteRootDirectory)
        {
            this.sharePointAccessToken = sharePointAccessToken;
            this.siteRootDirectory = siteRootDirectory;

            this.sharePointServiceEndpointUri = ConfigurationManager.AppSettings["DashboardServiceEndpointUri"];
            this.bodyTemplateFile = Path.Combine(siteRootDirectory, @"Templates\RepairCompetedEmailBody.cshtml");
        }

        public async Task<Message> ComposeRepairCompletedEmailMessage(int incidentId)
        {
            var incident = await GetIncident(incidentId);
            var attachments = await GetInspectionOrRepairPhotosAsAttachments("Room Inspection Photos", incident.sl_inspectionID.Id, incident.sl_roomID.Id);

            var property = incident.sl_propertyID;

            var propertyOwnerRecipientEmail = new EmailAddress { Address = property.sl_emailaddress, Name = property.sl_owner };
            var dispacherRecipientEmail = new EmailAddress { Address = DispatcherEmail, Name = DispatcherName };

            var bodyTemplate = System.IO.File.ReadAllText(bodyTemplateFile);
            var viewBag = new RazorEngine.Templating.DynamicViewBag();
            viewBag.AddValue("InspectionPhotosAttachments", attachments);
            var body = RazorEngine.Razor.Parse(bodyTemplate, incident, viewBag, "EmailBody");

            var message = new Message
            {
                Subject = string.Format("Repair Report - {0} - {1:MM/dd/yyyy}", property.Title, DateTime.UtcNow),
                Importance = Importance.Normal,
                Body = new ItemBody
                {
                    ContentType = BodyType.HTML,
                    Content = body
                },
            };
            message.ToRecipients.Add(new Recipient { EmailAddress = propertyOwnerRecipientEmail });
            message.CcRecipients.Add(new Recipient { EmailAddress = dispacherRecipientEmail });
            foreach (var attachment in attachments)
                message.Attachments.Add(attachment);

            return message;
        }

        private async Task<Incident> GetIncident(int incidentId)
        {
            var expandFields = "sl_propertyID/Id,sl_propertyID/sl_emailaddress,sl_propertyID/sl_owner,sl_propertyID/Title,sl_propertyID/sl_address1,sl_propertyID/sl_address2," +
                    "sl_roomID/Id, sl_roomID/Title," +
                    "sl_inspectionID/Id,sl_inspectionID/sl_datetime";
            var url = sharePointServiceEndpointUri +
                "lists/GetByTitle('Incidents')/Items(" + incidentId + ")" +
                "?$select=Id,sl_date,sl_inspectorIncidentComments,sl_dispatcherComments,sl_repairComments,sl_repairScheduled,sl_repairCompleted,sl_repairApproved,sl_type," +
                expandFields +
                "&$expand=" + expandFields;
            var json = await HttpGetJson(url, sharePointAccessToken);
            return JObject.Parse(json).ToObject<Incident>();
        }

        private async Task<FileAttachment[]> GetInspectionOrRepairPhotosAsAttachments(string listName, int inspectionId, int roomId)
        {
            var format = "{0}lists/GetByTitle('{1}')/Items?&$Filter=(sl_inspectionID eq {2} and sl_roomID eq {3})&$select=Id,Title"; //&$select=File/TimeLastModified,File/Name

            var url = string.Format(format, sharePointServiceEndpointUri, listName, inspectionId, roomId);
            var json = await HttpGetJson(url, sharePointAccessToken);

            var items = JObject.Parse(json)["value"].ToArray();

            var attachments = new FileAttachment[items.Length];

            for (int i = 0; i < items.Length; i++)
            {
                var fileId = items[i]["Id"];
                var fileName = items[i]["Title"].ToString();
                var fileUrl = string.Format("{0}lists/GetByTitle('{1}')/Items({2})/File/$value", sharePointServiceEndpointUri, listName, fileId);
                var data = await HttpGetData(fileUrl, sharePointAccessToken);

                var attachment = new FileAttachment
                {
                    ContentId = (i + 1).ToString("000"),
                    Name = fileName,
                    ContentBytes = data
                };
                attachments[i] = attachment;
            }
            return attachments;
        }

        private async Task<string> HttpGetJson(string url, string bearer)
        {
            var request = new HttpRequestMessage(HttpMethod.Get, url);
            request.Headers.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
            request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", bearer);

            using (HttpClient client = new HttpClient())
            {
                var response = await client.SendAsync(request);
                if (response.StatusCode != System.Net.HttpStatusCode.OK)
                    throw new ApplicationException("");
                return await response.Content.ReadAsStringAsync();
            }
        }

        private async Task<byte[]> HttpGetData(string url, string bearer)
        {
            var request = new HttpRequestMessage(HttpMethod.Get, url);
            //request.Headers.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
            request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", bearer);

            using (HttpClient client = new HttpClient())
            {
                var response = await client.SendAsync(request);
                if (response.StatusCode != System.Net.HttpStatusCode.OK)
                    throw new ApplicationException("");
                return await response.Content.ReadAsByteArrayAsync();
            }
        }

        private async Task<HttpResponseMessage> HttpPostJson(string url, string json, string bearer)
        {
            var request = new HttpRequestMessage(HttpMethod.Post, url);
            request.Headers.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
            request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", bearer);
            request.Content = new StringContent(json, Encoding.UTF8, "application/json");

            var client = new HttpClient();
            return await client.SendAsync(request);
        }
    }
}