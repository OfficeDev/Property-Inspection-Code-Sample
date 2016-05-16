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
        //public async Task<ActionResult> OneNote(string groupName = "Au Residence")
        //{
        //    var service = await AuthenticationHelper.GetGraphServiceAsync();

        //    var group = await service.Groups.Request().Filter(string.Format("DisplayName eq '{0}'", groupName)).Top(1).GetAsync();

        //    var groupFetcher = service.Groups[group[0].Id];

        //    var notebook = await groupFetcher.notes.notebooks
        //        .Where(i => i.name == groupName + " Notebook")
        //        .ExecuteSingleAsync();
          
        //    var tagBuilder = new TagBuilder("a");
        //    tagBuilder.Attributes.Add("href", notebook.links.oneNoteWebUrl.href);
        //    tagBuilder.InnerHtml = notebook.name;

        //    return Content(tagBuilder.ToString());
        //}
        
        //public async Task<ActionResult> DeleteAllPropertyGroups()
        //{
        //    var service = await AuthenticationHelper.GetGraphServiceAsync();
        //    var propertyGroups = await service.Groups.Request().Filter("Description eq 'Property Group'").GetAsync();

        //    foreach (var group in propertyGroups)
        //        await group.DeleteAsync();

        //    return Content(propertyGroups.Length + " property group(s) have been deleted.");
        //}

    }
}