using System.Configuration;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;

namespace SuiteLevelWebApp.Utils
{
    public class RestHelper
    {
        public static async Task<string> GetRestData(string restapi, string token)
        {
            var requestUrl = ConfigurationManager.AppSettings["DemoSiteCollectionUrl"] + restapi;

            using (HttpClient client = new HttpClient())
            {
                client.DefaultRequestHeaders.Add("Accept", "application/json;odata=verbose");
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

                using (HttpResponseMessage response = await client.GetAsync(requestUrl))
                {
                    if (response.IsSuccessStatusCode)
                    {
                        string responseString = await response.Content.ReadAsStringAsync();
                        return responseString;
                    }
                    
                    if (response.StatusCode == System.Net.HttpStatusCode.Unauthorized)
                    {
                        throw new System.Web.Http.HttpResponseException(System.Net.HttpStatusCode.Unauthorized);
                    }

                    return null;
                }
            }
        }

        public static async Task<string> PostRestDataToDemoSite(string restapi, string body, string token)
        {
            var requestUrl = ConfigurationManager.AppSettings["DemoSiteCollectionUrl"] + restapi;

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
    }
}