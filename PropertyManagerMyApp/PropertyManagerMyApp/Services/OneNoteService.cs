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

namespace SuiteLevelWebApp.Services
{
    public class OneNoteService
    {
        public static async Task<Inotebook> GetNoteBookAsync(IgroupFetcher groupFetcher, string name)
        {
            return await groupFetcher.notes.notebooks.Where(i => i.name == name).ExecuteSingleAsync();
        }

        public static async Task CreateNoteBookAsync(IgroupFetcher groupFetcher, string name)
        {
            var note = new notebook
            {
                name = name
            };

            await groupFetcher.notes.notebooks.AddnotebookAsync(note);
        }

        public static async Task<Isection> GetOrCreateSectionIdAsync(InotebookFetcher notebookFetcher, string name)
        {
            Isection section = null;

            section = await notebookFetcher.sections.Where(i => i.name == name).ExecuteSingleAsync();

            if (section == null)
            {
                section = new section
                {
                    name = name
                };

                await notebookFetcher.sections.AddsectionAsync(section);
            }


            return section;
        }

        public async static Task<string> CreatePageForIncidentAsync(GraphService graphService, string siteRootDirectory, Igroup group, Isection section, Incident incident, IEnumerable<FileContent> inspectionPhotos, IEnumerable<Video> incidentVideos)
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

            var pageEndPoint = string.Format("{0}groups/{1}/notes/sections/{2}/pages", AADAppSettings.GraphResourceUrl, group.id, section.id);
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

        public static async Task<Ipage[]> GetOneNotePagesAsync(GraphService graphService, Igroup group)
        {
            var section = await graphService.groups.GetById(group.id).notes.sections.Where(i => i.name == group.displayName).ExecuteSingleAsync();

            if (section == null)
                return new Ipage[0];

            var pages = await (await graphService.groups.GetById(group.id).notes.sections.GetById(section.id).pages.ExecuteAsync()).GetAllAsnyc();

            return pages.OfType<Ipage>().ToArray();
        }
    }
}