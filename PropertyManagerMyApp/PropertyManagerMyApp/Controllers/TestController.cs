using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using SuiteLevelWebApp.Services;
using SuiteLevelWebApp.Utils;
using System;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using System.Web.Mvc;
using Microsoft.OData.Client;
using MicrosoftGraph = Microsoft.Graph;
using Microsoft.SharePoint.Client;
using System.Xml;
using Microsoft.Graph;

namespace SuiteLevelWebApp.Controllers
{
    [Authorize, HandleAdalException]
    public class TestController : Controller
    {
        public async Task<ActionResult> OneNote(string groupName = "Au Residence")
        {
            var service = await AuthenticationHelper.GetGraphServiceAsync();

            var group =  await service.groups
                .Where(i => i.displayName == groupName)
                .ExecuteSingleAsync();

            var groupFetcher = service.groups.GetById(group.id);

            var notebook = await groupFetcher.notes.notebooks
                .Where(i => i.name == groupName + " Notebook")
                .ExecuteSingleAsync();
          
            var tagBuilder = new TagBuilder("a");
            tagBuilder.Attributes.Add("href", notebook.links.oneNoteWebUrl.href);
            tagBuilder.InnerHtml = notebook.name;

            return Content(tagBuilder.ToString());
        }
        
        public async Task<ActionResult> DeleteAllPropertyGroups()
        {
            var service = await AuthenticationHelper.GetGraphServiceAsync();

            var groups = await (await service.groups.ExecuteAsync()).GetAllAsnyc();
            var propertyGroups = groups
                .Where(i => i.description == "Property Group")
                .ToArray();

            foreach (var group in propertyGroups)
                await group.DeleteAsync();

            return Content(propertyGroups.Length + " property group(s) have been deleted.");
        }

    }
}