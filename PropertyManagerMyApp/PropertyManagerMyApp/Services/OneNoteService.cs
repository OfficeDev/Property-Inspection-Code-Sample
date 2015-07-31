using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using RazorEngine.Templating;
using SuiteLevelWebApp.Models;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;

namespace SuiteLevelWebApp.Services
{
    public class OneNoteService
    {
        private string serviceBaseUrl;
        private string pageEndPoint;
        private string accessToken;

        public OneNoteService(string serviceBaseUrl, string accessToken)
        {
            this.serviceBaseUrl = serviceBaseUrl.EndsWith("/")
                ? serviceBaseUrl.Substring(0, serviceBaseUrl.Length - 1)
                : serviceBaseUrl;
            this.serviceBaseUrl += "/me/notes";
            this.accessToken = accessToken;
        }

        public async Task<string> CreatePageForIncidentAsync(string siteRootDirectory, string sectionId, Incident incident, IEnumerable<FileContent> inspectionPhotos, IEnumerable<Video> incidentVideos)
        {
            var templateFile = Path.Combine(siteRootDirectory, @"Templates\IncidentOneNotePage.cshtml");
            var template = System.IO.File.ReadAllText(templateFile);
            var viewBag = new RazorEngine.Templating.DynamicViewBag();
            viewBag.AddValue("InspectionPhotos", inspectionPhotos);
            viewBag.AddValue("IncidentVideos", incidentVideos);

            var html = RazorEngine.Engine.Razor.RunCompile(template, "IncidentOneNotePage", typeof(Incident), incident, viewBag);
            var content = new MultipartFormDataContent();
            content.Add(new StringContent(html, Encoding.UTF8, "text/html"), "Presentation");

            foreach (var image in inspectionPhotos)
            {
                var itemContent = new ByteArrayContent(image.Bytes);
                var contentType = MimeMapping.GetMimeMapping(image.Name);
                itemContent.Headers.ContentType = new MediaTypeHeaderValue(contentType);
                content.Add(itemContent, image.Id);
            }

            this.pageEndPoint = string.Format("{0}/sections/{1}/pages", serviceBaseUrl, sectionId);
            var requestMessage = new HttpRequestMessage(HttpMethod.Post, pageEndPoint);
            requestMessage.Content = content;

            var responseMessage = await HttpSendAsync(requestMessage, accessToken);
            if (responseMessage.StatusCode != System.Net.HttpStatusCode.Created)
                throw new HttpResponseException(responseMessage.StatusCode);

            var reponseObject = await GetReponseObjectAsync(responseMessage);
            return (string)reponseObject.links.oneNoteWebUrl.href;
        }

        internal async Task<NoteBook> GetNoteBookAsync(string name)
        {
            var url = string.Format("{0}/notebooks?$filter=name eq '{1}'", serviceBaseUrl, name);

            dynamic result;

            try
            {
                result = await HttpGetAsync(url);
            }
            catch (HttpResponseException)
            {
                return null;
            }

            dynamic array = result.value;
            if (array.Count > 0)
            {
                dynamic notebook = array.First;
                return new NoteBook
                {
                    Id = notebook.id.Value,
                    Url = notebook.links.oneNoteWebUrl.href.Value
                };
            }
            return null;
        }

        internal async Task<NoteBook> CreateNoteBookAsync(string name)
        {
            var url = string.Format("{0}/notebooks", serviceBaseUrl);
            var notebook = await HttpPostAsync(url, new { name = name });
            return new NoteBook
            {
                Id = notebook.id.Value,
                Url = notebook.links.oneNoteWebUrl.href.Value,
            };
        }

        internal async Task<string> GetSectionIdAsync(string notebookId, string sectionName)
        {
            var url = string.Format("{0}/notebooks/{1}/sections?$select=id&$filter=name eq '{2}'", serviceBaseUrl, notebookId, sectionName);

            dynamic result;
            try
            {
                result = await HttpGetAsync(url);
            }
            catch (HttpResponseException)
            {
                return null;
            }

            dynamic array = result.value;
            if (array.Count > 0)
            {
                dynamic section = array.First;
                return section.id.Value;
            }
            return null;
        }

        internal async Task<HyperLink[]> GetPagesAsync(string secitonId, int incidentId)
        {
            var url = string.Format("{0}/sections/{1}/pages?$filter=title eq 'Incident[{2}]'&$select=title,links", serviceBaseUrl, secitonId, incidentId);

            dynamic result;
            try
            {
                result = await HttpGetAsync(url);
            }
            catch (HttpResponseException)
            {
                return new HyperLink[0];
            }

            return (result.value as JArray).OfType<dynamic>()
                .Select(i => HyperLink.Create((string)i.title, (string)i.links.oneNoteWebUrl.href))
                .ToArray();
        }

        internal async Task<string> CreateSectionAsync(string notebookId, string sectionName)
        {
            var url = string.Format("{0}/notebooks/{1}/sections", serviceBaseUrl, notebookId);
            var reponseObject = await HttpPostAsync(url, new { name = sectionName });
            return (string)reponseObject.id;
        }

        private async Task<dynamic> HttpGetAsync(string url)
        {
            var requestMessage = new HttpRequestMessage(HttpMethod.Get, url);
            var responseMessage = await HttpSendAsync(requestMessage, accessToken);
            if (responseMessage.StatusCode != System.Net.HttpStatusCode.OK)
                throw new HttpResponseException(responseMessage.StatusCode);
            return await GetReponseObjectAsync(responseMessage);
        }

        private async Task<dynamic> HttpPostAsync(string url, object contentObj)
        {
            var requestMessage = new HttpRequestMessage(HttpMethod.Post, url);
            requestMessage.Content = new StringContent(
                JsonConvert.SerializeObject(contentObj), Encoding.UTF8, "application/json");

            var responseMessage = await HttpSendAsync(requestMessage, accessToken);
            if (responseMessage.StatusCode != System.Net.HttpStatusCode.Created)
                throw new HttpResponseException(responseMessage.StatusCode);
            return await GetReponseObjectAsync(responseMessage);
        }

        private async Task<HttpResponseMessage> HttpSendAsync(HttpRequestMessage message, string accessToken)
        {
            var client = new HttpClient();
            client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
            return await client.SendAsync(message);
        }

        private async Task<dynamic> GetReponseObjectAsync(HttpResponseMessage responseMessage)
        {
            var payload = await responseMessage.Content.ReadAsStringAsync();
            return JsonConvert.DeserializeObject(payload);
        }

        public class NoteBook
        {
            public string Id { get; set; }
            public string Url { get; set; }
        }
    }
}