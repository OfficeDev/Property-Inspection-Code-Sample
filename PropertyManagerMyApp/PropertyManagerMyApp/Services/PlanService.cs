using Microsoft.Graph;
using Newtonsoft.Json.Linq;
using SuiteLevelWebApp.Utils;
using System;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using System.Collections.Generic;

namespace SuiteLevelWebApp.Services
{
    public class PlanService
    {
        private static async Task<plan> CreatePlanAsync(Igroup group)
        {
            var accessToken = AuthenticationHelper.GetGraphAccessTokenAsync();

            var pageEndPoint = string.Format("{0}plans", AADAppSettings.GraphResourceUrl);

            dynamic postPlanJSON = new JObject();
            postPlanJSON.title = group.displayName + " Plan";
            postPlanJSON.owner = group.id;

            var requestMessage = new HttpRequestMessage(HttpMethod.Post, pageEndPoint);
            requestMessage.Content = new StringContent(postPlanJSON.ToString(), System.Text.Encoding.UTF8, "application/json");

            using (var client = new HttpClient())
            {
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", await accessToken);
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                var responseMessage = await client.SendAsync(requestMessage);

                if (responseMessage.StatusCode != System.Net.HttpStatusCode.Created)
                    throw new Exception();

                var payload = await responseMessage.Content.ReadAsStringAsync();

                return new plan
                {
                    id = JObject.Parse(payload)["id"].ToString()
                };
            }
        }

        public static async Task<Iplan> GetPlanAsync(Igroup group)
        {
            var accessToken = AuthenticationHelper.GetGraphAccessTokenAsync();

            var pageEndPoint = string.Format("{0}groups/{1}/plans", AADAppSettings.GraphResourceUrl, group.id);

            using (var client = new HttpClient())
            {
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", await accessToken);
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                var responseMessage = await client.GetAsync(pageEndPoint);

                if (responseMessage.StatusCode != System.Net.HttpStatusCode.OK)
                    throw new Exception();

                var payload = await responseMessage.Content.ReadAsStringAsync();

                var jobject = JObject.Parse(payload);

                if (jobject["value"].Children().Count() > 0)
                {
                    return new plan
                    {
                        id = jobject["value"][0]["id"].ToString()
                    };
                }
                else
                {
                    return await CreatePlanAsync(group);
                }
            }
        }

        public static async Task<Ibucket> CreateBucketAsync(Ibucket bucket)
        {
            var accessToken = AuthenticationHelper.GetGraphAccessTokenAsync();
            var pageEndPoint = string.Format("{0}buckets", AADAppSettings.GraphResourceUrl);

            dynamic postBucketJSON = new JObject();
            postBucketJSON.name = bucket.name;
            postBucketJSON.planId = bucket.planId;

            var requestMessage = new HttpRequestMessage(HttpMethod.Post, pageEndPoint);
            requestMessage.Content = new StringContent(postBucketJSON.ToString(), System.Text.Encoding.UTF8, "application/json");

            using (var client = new HttpClient())
            {
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", await accessToken);
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                var responseMessage = await client.SendAsync(requestMessage);

                if (responseMessage.StatusCode != System.Net.HttpStatusCode.Created)
                    throw new Exception();

                var payload = await responseMessage.Content.ReadAsStringAsync();

                var jobject = JObject.Parse(payload);

                return new bucket
                {
                    id = jobject["id"].ToString(),
                    planId = jobject["planId"].ToString()
                };
            }
        }

        public static async Task CreateTaskAsync(Itask task)
        {
            var accessToken = AuthenticationHelper.GetGraphAccessTokenAsync();
            var pageEndPoint = string.Format("{0}tasks", AADAppSettings.GraphResourceUrl);

            dynamic postTaskJSON = new JObject();
            postTaskJSON.title = task.title;
            postTaskJSON.assignedTo = task.assignedTo;
            postTaskJSON.dueDateTime = task.dueDateTime;
            postTaskJSON.percentComplete = task.percentComplete.Value;
            postTaskJSON.planId = task.planId;
            postTaskJSON.bucketId = task.bucketId;

            var requestMessage = new HttpRequestMessage(HttpMethod.Post, pageEndPoint);
            requestMessage.Content = new StringContent(postTaskJSON.ToString(), System.Text.Encoding.UTF8, "application/json");

            using (var client = new HttpClient())
            {
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", await accessToken);
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                var responseMessage = await client.SendAsync(requestMessage);

                if (responseMessage.StatusCode != System.Net.HttpStatusCode.Created)
                    throw new Exception();
            }
        }

        public static async Task<task[]> GetTasksAsync(Iplan plan)
        {
            var accessToken = AuthenticationHelper.GetGraphAccessTokenAsync();

            List<task> tasks = new List<task>();

            var pageEndPoint = string.Format("{0}plans/{1}/Tasks?$filter=percentComplete+ne+100", AADAppSettings.GraphResourceUrl, plan.id);

            using (var client = new HttpClient())
            {
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", await accessToken);
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                var responseMessage = await client.GetAsync(pageEndPoint);

                if (responseMessage.StatusCode != System.Net.HttpStatusCode.OK)
                    throw new Exception();

                var payload = await responseMessage.Content.ReadAsStringAsync();

                var jobject = JObject.Parse(payload);

                foreach (var item in jobject["value"].Children())
                {
                    tasks.Add(new task
                    {
                        title = item["title"].ToString(),
                        assignedTo = !string.IsNullOrEmpty(item["assignedTo"].ToString()) ? item["assignedTo"].ToString() : "",
                        assignedBy = !string.IsNullOrEmpty(item["assignedBy"].ToString()) ? item["assignedBy"].ToString() : "",
                        assignedDateTime = !string.IsNullOrEmpty(item["assignedDateTime"].ToString()) ? DateTimeOffset.Parse(item["assignedDateTime"].ToString()) : (DateTimeOffset?)null,
                        percentComplete = !string.IsNullOrEmpty(item["percentComplete"].ToString()) ? Convert.ToInt32(item["percentComplete"].ToString()) : 0
                    });
                }
            }

            return tasks.Where(i => i.percentComplete.HasValue && i.percentComplete.Value < 100).ToArray();
        }
    }
}