using Newtonsoft.Json;
using System;
using System.Configuration;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;

namespace SuiteLevelWebApp.Service
{

    public enum ApprovalResult
    {
        Approved,
        Rejected
    }

    public class TasksService
    {
        private readonly string accessToken;

        private readonly string taskItemUrlFormat;
        private readonly string incidentItemUrlFormat;

        public TasksService(string accessToken)
        {
            this.accessToken = accessToken;
            var serviceEndPointUrl = ConfigurationManager.AppSettings["DashboardServiceEndpointUri"];
            this.incidentItemUrlFormat = serviceEndPointUrl + "Lists/GetByTitle('Incidents')/Items({0})";
            this.taskItemUrlFormat = serviceEndPointUrl + "Lists/GetByTitle('Incident Workflow Tasks')/Items({0})";
        }

        public async Task CompleteRepairAssignmentTask(int incidentId)
        {
            var taskId = await GetTaskId(incidentId);
            var value = new
            {
                Status = "Completed",
                PercentComplete = 1
            };
            await UpdateTask(taskId, value);
        }

        public async Task CompleteRepairApprovalTask(int incidentId, ApprovalResult result)
        {
            var taskId = await GetTaskId(incidentId);
            var value = new
            {
                Status = "Completed",
                PercentComplete = 1,
                TaskOutcome = result.ToString()
            };
            await UpdateTask(taskId, value);
        }

        private async Task<int> GetTaskId(int incidentId)
        {
            var url = string.Format(incidentItemUrlFormat, incidentId) + "/sl_taskId/$value";
            var value = await HttpGet(url, accessToken);
            return int.Parse(value);
        }

        private async Task UpdateTask(int taskId, object value)
        {
            var url = string.Format(taskItemUrlFormat, taskId);
            var json = JsonConvert.SerializeObject(value);
            await UpdateListItem(url, accessToken, json);
        }

        public static async Task<string> HttpGet(string url, string bearer)
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

        public static async Task<string> UpdateListItem(string url, string bearer, string json)
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