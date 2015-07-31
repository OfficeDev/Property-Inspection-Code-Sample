using System;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;

namespace SuiteLevelWebApp.Utils
{
    public class RestHelper
    {
        private static readonly string DemoSiteCollectionUrl = AppSettings.DemoSiteCollectionUrl;

        public static async Task<string> GetJsonAsync(string url, string accessToken, string odata = "")
        {
            using (HttpClient client = new HttpClient())
            {
                var accept = "application/json";
                if (!string.IsNullOrEmpty(odata)) accept += ";odata=" + odata;

                client.DefaultRequestHeaders.Add("Accept", accept);
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);

                using (var response = await client.GetAsync(url))
                {
                    if (response.IsSuccessStatusCode)
                        return await response.Content.ReadAsStringAsync();

                    if (response.StatusCode == System.Net.HttpStatusCode.Unauthorized)
                        throw new System.Web.Http.HttpResponseException(System.Net.HttpStatusCode.Unauthorized);

                    return null;
                }
            }
        }

        public static async Task<string> GetDemoSiteJsonAsync(string relativeUrl, string accessToken)
        {
            var requestUrl = DemoSiteCollectionUrl + relativeUrl;
            return await GetJsonAsync(requestUrl, accessToken, "verbose");
        }

        public static async Task<string> PostRestDataToDemoSiteAsync(string restapi, string body, string token)
        {
            var requestUrl = DemoSiteCollectionUrl + restapi;

            using (HttpClient client = new HttpClient())
            {
                client.DefaultRequestHeaders.Add("Accept", "application/json;odata=verbose");
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
                client.DefaultRequestHeaders.Add("IF-MATCH", "*");
                client.DefaultRequestHeaders.Add("X-HTTP-Method", "MERGE");

                HttpContent content = new StringContent(body);
                content.Headers.ContentType = new MediaTypeHeaderValue("application/json");
                content.Headers.ContentType.Parameters.Add(new NameValueHeaderValue("odata", "verbose"));

                using (HttpResponseMessage response = await client.PostAsync(requestUrl, content))
                {
                    string responseString = await response.Content.ReadAsStringAsync();
                    return responseString;
                }
            }
        }

        public static async Task<byte[]> GetDemoSiteBytesAsync(string url, string token)
        {
            var requestUrl = DemoSiteCollectionUrl + url;
            var request = new HttpRequestMessage(System.Net.Http.HttpMethod.Get, requestUrl);
            request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", token);

            using (HttpClient client = new HttpClient())
            {
                var response = await client.SendAsync(request);
                if (response.StatusCode != System.Net.HttpStatusCode.OK)
                    throw new ApplicationException("");
                return await response.Content.ReadAsByteArrayAsync();
            }
        }
    }
}