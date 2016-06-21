using Microsoft.Graph;
using Newtonsoft.Json.Linq;
using RazorEngine.Templating;
using SuiteLevelWebApp.Models;
using SuiteLevelWebApp.Utils;
using System;
using System.Collections.Generic;
using System.IO;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
using System.Linq;
using Newtonsoft.Json;
using GraphModelsExtension;

namespace SuiteLevelWebApp.Services
{
    public class OneNoteService
    {
        public static async Task<Notebook> GetNoteBookByURLAsync(string sectionUrl)
        {
            var accessToken = AuthenticationHelper.GetGraphAccessTokenAsync();
            try
            {
                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", await accessToken);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    var responseMessage = await client.GetAsync(sectionUrl);

                    if (responseMessage.StatusCode != System.Net.HttpStatusCode.OK)
                        throw new Exception();

                    var payload = await responseMessage.Content.ReadAsStringAsync();

                    var jobject = JObject.Parse(payload);

                    if (jobject["value"].Children().Count() > 0)
                    {
                        JToken jnotebook = jobject["value"][0];
                        return new Notebook
                        {
                            id = jnotebook["id"].ToString(),
                            name = jnotebook["name"].ToString(),
                            sectionsUrl = jnotebook["sectionsUrl"].ToString(),
                            sectionGroupsUrl = jnotebook["sectionGroupsUrl"].ToString(),
                            oneNoteWebUrl = jnotebook["links"]["oneNoteWebUrl"]["href"].ToString(),
                        };
                    }
                    else
                    {
                        return null;
                    }
                }
            }
            catch
            {
                return null;
            }
        }
        public static async Task<Notebook> GetNoteBookByNameAsync(Group group, string name)
        {
            return await GetNoteBookByURLAsync(string.Format("{0}groups/{1}/notes/notebooks?$filter=name eq '{2}'", AADAppSettings.GraphBetaResourceUrl, group.Id, name));
        }
        public static async Task<Notebook> GetNoteBookByIdAsync(Group group, string Id)
        {
            return await GetNoteBookByURLAsync(string.Format("{0}groups/{1}/notes/notebooks?$filter=id eq '{2}'", AADAppSettings.GraphBetaResourceUrl, group.Id, Id));
        }

        public static async Task<Section> GetSectionByURLAsync(string sectionsUrl)
        {
            Section section = null;
            var accessToken = AuthenticationHelper.GetGraphAccessTokenAsync();

            using (var client = new HttpClient())
            {
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", await accessToken);
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                var responseMessage = await client.GetAsync(sectionsUrl);

                if (responseMessage.StatusCode != System.Net.HttpStatusCode.OK)
                    throw new Exception();

                var payload = await responseMessage.Content.ReadAsStringAsync();

                var jobject = JObject.Parse(payload);

                if (jobject["value"].Children().Count() > 0)
                {
                    section =  new Section
                    {
                        id = jobject["value"][0]["id"].ToString(),
                        name = jobject["value"][0]["name"].ToString(),
                        pagesUrl = jobject["value"][0]["pagesUrl"].ToString()
                    };
                }
            }
            return section;
        }
        public static async Task<Section> GetOrCreateSectionIdAsync(string sectionsUrl, string sectionName)
        {
            Section section = await GetSectionByURLAsync(string.Format("{0}?$filter=name eq '{1}'", sectionsUrl, sectionName));
            if (section != null)
            {
                return section;
            }
            else
            {
                //create section
                var accessToken = AuthenticationHelper.GetGraphAccessTokenAsync();
                section = new Section
                {
                    name = sectionName
                };

                var requestMessage = new HttpRequestMessage(HttpMethod.Post, sectionsUrl);
                requestMessage.Content = new StringContent(JsonConvert.SerializeObject(section), System.Text.Encoding.UTF8, "application/json");

                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", await accessToken);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    var responseMessage = await client.SendAsync(requestMessage);

                    

                    if (responseMessage.StatusCode != System.Net.HttpStatusCode.Created)
                        throw new Exception();

                    var payload = await responseMessage.Content.ReadAsStringAsync();
                    var jobject = JObject.Parse(payload);
                    section.id = jobject["id"].ToString();
                    section.pagesUrl = jobject["pagesUrl"].ToString();
                }
            }
            return section;
        }

        public async static Task<string> CreatePageForIncidentAsync(GraphServiceClient graphService, string siteRootDirectory, Group group, Section section, Incident incident, IEnumerable<FileContent> inspectionPhotos, IEnumerable<Models.Video> incidentVideos)
        {
            var accessToken = AuthenticationHelper.GetGraphAccessTokenAsync();
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

            var pageEndPoint = string.Format("{0}groups/{1}/notes/sections/{2}/pages", AADAppSettings.GraphBetaResourceUrl, group.Id, section.id);
            var requestMessage = new HttpRequestMessage(HttpMethod.Post, pageEndPoint);
            requestMessage.Content = content;

            using (var client = new HttpClient())
            {
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", await accessToken);
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                var responseMessage = await client.SendAsync(requestMessage);

                if (responseMessage.StatusCode != System.Net.HttpStatusCode.Created)
                    throw new HttpResponseException(responseMessage.StatusCode);

                var payload = await responseMessage.Content.ReadAsStringAsync();

                return JObject.Parse(payload)["links"]["oneNoteWebUrl"]["href"].ToString();
            }
        }

        public static async Task<HyperLink[]> GetOneNotePagesAsync(GraphServiceClient graphService, Group group)
        {
            List<HyperLink> hyperLinks = null;

            Section section = await GetSectionByURLAsync(string.Format("{0}groups/{1}/notes/sections?$filter=name eq '{2}'", AADAppSettings.GraphBetaResourceUrl, group.Id, group.DisplayName));
            if(section!= null)
            {
                var accessToken = AuthenticationHelper.GetGraphAccessTokenAsync();
                try
                {
                    using (var client = new HttpClient())
                    {
                        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", await accessToken);
                        client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                        var responseMessage = await client.GetAsync(section.pagesUrl);

                        if (responseMessage.StatusCode != System.Net.HttpStatusCode.OK)
                            throw new Exception();

                        var payload = await responseMessage.Content.ReadAsStringAsync();

                        var jobject = JObject.Parse(payload);

                        if (jobject["value"].Children().Count() > 0)
                        {
                            hyperLinks = new List<HyperLink>();
                            foreach (var item in jobject["value"].Children())
                            {
                                HyperLink hy = new HyperLink {
                                    Title = item["title"].ToString(),
                                    WebUrl = item["links"]["oneNoteWebUrl"]["href"].ToString()
                                };
                                hyperLinks.Add(hy);

                            }
                        }
                    }

                }
                catch
                {
                }
            }
            return hyperLinks == null ? new HyperLink[0] : hyperLinks.ToArray();
        }
    }
}