using Microsoft.Graph;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;

namespace SuiteLevelWebApp.Services
{
    public class OneNoteServiceFactory
    {
        private string oneNoteResourceUrl;
        private string accessToken;

        public OneNoteServiceFactory(string oneNoteResourceUrl, string accessToken)
        {
            this.oneNoteResourceUrl = oneNoteResourceUrl.EndsWith("/")
                ? oneNoteResourceUrl.Substring(0, oneNoteResourceUrl.Length - 1)
                : oneNoteResourceUrl;
            this.accessToken = accessToken;
        }

        public async Task<OneNoteService> CreateOneNoteServiceForUnifiedGroup(IGroup group)
        {
            var groupSiteUrl = "https://TENANCY.sharepoint.com/sites/" + WebUtility.UrlEncode(group.mailNickname);
            var groupNoteBookName = group.displayName + " Notebook";

            var getIdsUrl = string.Format(
                "{0}/myOrganization/siteCollections/FromUrl(url='{1}')",
                oneNoteResourceUrl,
                WebUtility.UrlEncode(groupSiteUrl));
            var ids = await HttpGetAsync<JObject>(getIdsUrl);

            var serviceBaseUrl = string.Format(
                "{0}/myOrganization/siteCollections/{1}/sites/{2}/notes",
                oneNoteResourceUrl,
                ids["siteCollectionId"],
                ids["siteId"]);
            return new OneNoteService(serviceBaseUrl, accessToken);
        }

        public async Task<OneNoteService> CreateOneNoteServiceForCurrentUser()
        {
            var serviceBaseUrl = oneNoteResourceUrl + "/me/notes";
            var oneNoteService = new OneNoteService(serviceBaseUrl, accessToken);
            return await Task.FromResult(oneNoteService);
        }

        private async Task<T> HttpGetAsync<T>(string url)
        {
            var client = new HttpClient();
            client.DefaultRequestHeaders.Add("Authorization", "Bearer " + accessToken);
            client.DefaultRequestHeaders.Add("Accept", "application/json;odata=light");
            using (var response = await client.GetAsync(url))
            {
                var content = await response.Content.ReadAsStringAsync();
                return JsonConvert.DeserializeObject<T>(content);
            }
        }
    }
}