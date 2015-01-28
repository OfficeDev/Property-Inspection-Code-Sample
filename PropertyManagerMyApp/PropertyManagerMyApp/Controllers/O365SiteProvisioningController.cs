using System;
using System.Configuration;
using System.Web.Mvc;
using System.Threading.Tasks;
using Microsoft.Online.SharePoint.TenantAdministration;
using SuiteLevelWebApp.Utils;
using SuiteLevelWebApp.Service;
using System.Text.RegularExpressions;

namespace SuiteLevelWebApp.Controllers
{
    [Authorize]
    [HandleAdalException]
    public class O365SiteProvisioningController : Controller
    {
        static string AdminServiceResourceId = ConfigurationManager.AppSettings["ServiceResourceId"];
        static string DashboardServiceResourceId = ConfigurationManager.AppSettings["DashboardServiceResourceId"];
        static readonly string DemoSiteCollectionUrl = ConfigurationManager.AppSettings["DemoSiteCollectionUrl"];
        static readonly string DemoSiteCollectionOwner = ConfigurationManager.AppSettings["DemoSiteCollectionOwner"];

        public async Task<ActionResult> Index()
        {
            string token = await O365Util.GetAccessToken(ServiceResources.Admin);

            //Determine if the site collection used for the demo is already created
            using (var adminClientContext = TokenHelper.GetClientContextWithAccessToken(AdminServiceResourceId, token))
            {
                switch (CSOMUtil.GetSiteCollectionStatusByUrl(adminClientContext, DemoSiteCollectionUrl))
                {
                    case "Active":
                        ViewBag.refresh = string.Empty;
                        ViewBag.Message = "The demo site collection was successfully created.  Proceeding to provision information architecture and content.  This process may take several minutes, please be patient and do not refresh the page during this process.  If you are eager to see the progress you may browse to the new site collection in your browser and inspect the new components as they are provisioned.";

                        return new RedirectResult("/O365SiteProvisioning/ProvisionSiteComponents");
                    case "Creating":
                        ViewBag.refresh = "refresh";
                        ViewBag.Message += DateTime.Now.ToString() + " - The demo site collection is being created.  The page will be refreshed automatically to check status.  This operation can take up to 20 minutes to complete.";
                        break;
                    case "None":
                        try
                        {
                            CSOMUtil.CreateSiteCollection(adminClientContext, new SiteCreationProperties
                            {
                                Url = DemoSiteCollectionUrl,
                                Owner = DemoSiteCollectionOwner,
                                Template = "BLANKINTERNETCONTAINER#0",
                                Title = "Contoso Property Management Dashboard",
                                StorageMaximumLevel = 1000,
                                StorageWarningLevel = 750,
                                TimeZoneId = 7,
                                UserCodeMaximumLevel = 1000,
                                UserCodeWarningLevel = 500
                            });

                            ViewBag.refresh = "refresh";
                            ViewBag.Message = "The demo site collection is being created, please wait a few minutes, and the page will be refreshed automatically to check status.";
                            ViewBag.serviceResourceId = AdminServiceResourceId;
                        }
                        catch (Exception el)
                        {
                            ViewBag.refresh = "";
                            ViewBag.Message = el.Message + " If the Site Collection still exists in the Recycle Bin use the SharePoint Online Management Shell to delete it completely. Remove-SPODeletedSite -Identity <Site Collection URL>";
                        }
                        break;
                }
            }

            return View();
        }

        public async Task<ActionResult> ProvisionSiteComponents()
        {
            string token = await O365Util.GetAccessToken(ServiceResources.Dashboard);
            using (var clientContext = TokenHelper.GetClientContextWithAccessToken(DemoSiteCollectionUrl, token))
            {
                SiteProvisioning siteProvisioning = new SiteProvisioning(clientContext);
                siteProvisioning.AddSiteComponents();
                //siteProvisioning.RemoveSiteComponents();
                ViewBag.Message = "The demo site collection has been created successfully.  Click the Provision Workflow menu item to proceed.";
            }
            return View();
        }

        public ActionResult ProvisionDemoData()
        {
            SuiteLevelWebApp.Models.ProvisionDemoData model = TempData["datetime"] as SuiteLevelWebApp.Models.ProvisionDemoData;
            if (TempData["datetime"] == null)
            {
                model = new SuiteLevelWebApp.Models.ProvisionDemoData();
            }
            return View(model);
        }

        [HttpPost]
        public async Task<ActionResult> CreateDemoData(SuiteLevelWebApp.Models.ProvisionDemoData model)
        {
            string token = await O365Util.GetAccessToken(ServiceResources.Dashboard);            
            using (var clientContext = TokenHelper.GetClientContextWithAccessToken(DemoSiteCollectionUrl, token))
            {
                AuthenticationHelper adHelp =new AuthenticationHelper();
                await adHelp.CreateADUsersAndGroups();
                SiteProvisioning siteProvisioning = new SiteProvisioning(clientContext);
                siteProvisioning.AddSiteContents();
                siteProvisioning.UpdateInspectionListItem(model.dateDemo);

                model.Message = "The AAD Groups, AAD Users, and demo data have been created successfully.  The initial password for all the users is: TempP@ssw0rd!";
                TempData["datetime"] = model;
                return RedirectToAction("ProvisionDemoData");
            }
        }

        public async Task<ActionResult> ProvisionWorkflow(string message)
        {
            await O365Util.GetAccessToken(ServiceResources.Dashboard); // Prepare token in advance.
            ViewBag.Message = message;
            return View();
        }

        [HttpPost, ActionName("ProvisionWorkflow")]
        public async Task<ActionResult> ProvisionWorkflowPost()
        {
            var token = await O365Util.GetAccessToken(ServiceResources.Dashboard);
            var suiteLevelWebAppUrl = Regex.Match(Request.Url.AbsoluteUri, "https?://[^/]+?(?=/)", RegexOptions.Compiled).Value;
            using (var clientContext = TokenHelper.GetClientContextWithAccessToken(DemoSiteCollectionUrl, token))
            {
                var service = new WorkflowProvisionService(clientContext);
                var incidentsList = CSOMUtil.getListByTitle(clientContext, "Incidents");

                service.Unsubscribe(incidentsList.Id, "Incident");
                service.DeleteDefinitions("Incident");
                service.DeleteList("Incident Workflow Tasks");
                service.DeleteList("Incident Workflow History");

                var workflow = System.IO.File.ReadAllText(Server.MapPath("~/Workflows/Incident.xaml"));

                workflow = workflow.Replace("(SuiteLevelWebAppUrlPlaceholder)", suiteLevelWebAppUrl)
                                   .Replace("(dispatcherPlaceHolder)", ConfigurationManager.AppSettings["DispatcherName"]);
                workflow = WorkflowUtil.TranslateWorkflow(workflow);
                var definitionId = service.SaveDefinitionAndPublish("Incident", workflow);
                var taskListId = service.CreateTaskList("Incident Workflow Tasks");
                var historyListId = service.CreateHistoryList("Incident Workflow History");
                service.Subscribe("Incident Workflow", definitionId, incidentsList.Id, WorkflowSubscritpionEventType.ItemAdded, taskListId, historyListId);

                ViewBag.Message = "Incident Workflow, Incident Workflow Tasks list and Incident Workflow History list have been created successfully. Click the Create Sample Data menu item to proceed.";
            }
            return View();
        }
    }
}