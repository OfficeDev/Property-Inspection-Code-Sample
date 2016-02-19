using Newtonsoft.Json;
using SuiteLevelWebApp.Models;
using SuiteLevelWebApp.Utils;
using System;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;

namespace SuiteLevelWebApp.Services
{
    public class TasksService
    {
        private readonly string accessToken;

        private readonly string taskItemUrlFormat;
        private readonly string incidentItemUrlFormat;

        public TasksService(string accessToken)
        {
            this.accessToken = accessToken;
            this.incidentItemUrlFormat = AppSettings.DemoSiteCollectionUrl  + "/_api/Lists/GetByTitle('Incidents')/Items({0})";
            this.taskItemUrlFormat = AppSettings.DemoSiteCollectionUrl  + "/_api/Lists/GetByTitle('Incident Workflow Tasks')/Items({0})";
        }

        public async Task CompleteRepairAssignmentTaskAsync(int incidentId)
        {
            var taskId = await GetTaskIdAsync(incidentId);
            var value = new
            {
                Status = "Completed",
                PercentComplete = 1
            };
            await UpdateTaskAsync(taskId, value);
        }

        public async Task CompleteRepairApprovalTaskAsync(AuditRepairModel model)
        {
            var taskId = await GetTaskIdAsync(model.IncidentId);
            var value = new
            {
                Status = "Completed",
                PercentComplete = 1,
                TaskOutcome = model.Result.ToString()
            };
            await UpdateTaskAsync(taskId, value);
        }

        private async Task<int> GetTaskIdAsync(int incidentId)
        {
            var url = string.Format(incidentItemUrlFormat, incidentId) + "/sl_taskId/$value";
            var value = await HttpGetAsync(url, accessToken);
            return int.Parse(value);
        }

        private async Task UpdateTaskAsync(int taskId, object value)
        {
            var url = string.Format(taskItemUrlFormat, taskId);
            var json = JsonConvert.SerializeObject(value);
            await UpdateListItemAsync(url, accessToken, json);
        }

        public static async Task<string> HttpGetAsync(string url, string bearer)
        {
            using (var client = new HttpClient())
            {
                client.DefaultRequestHeaders.Add("Accept", "application/json;odata=verbose");
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", bearer);

                var response = await client.GetAsync(url);
                var content = await response.Content.ReadAsStringAsync();

                if (!response.IsSuccessStatusCode) throw new ApplicationException(content);
                return content;
            }
        }

        public static async Task<string> UpdateListItemAsync(string url, string bearer, string json)
        {
            using (HttpClient client = new HttpClient())
            {
                var request = new HttpRequestMessage(HttpMethod.Post, url);
                request.Headers.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", bearer);
                request.Headers.Add("IF-MATCH", "*");
                request.Headers.Add("X-HTTP-Method", "MERGE");
                request.Content = new StringContent(json, Encoding.UTF8, "application/json");

                var response = await client.SendAsync(request);
                var content = await response.Content.ReadAsStringAsync();

                if (!response.IsSuccessStatusCode) throw new ApplicationException(content);
                return content;
            }
        }
    }
}