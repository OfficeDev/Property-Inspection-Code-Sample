using Microsoft.SharePoint.Client;
using SuiteLevelWebApp.Models;
using SuiteLevelWebApp.Utils;
using System;
using System.Text.RegularExpressions;
using System.Threading;
using System.Threading.Tasks;
using System.Web.Mvc;
using Microsoft.Graph;
using System.Linq;
using SuiteLevelWebApp.Services;

namespace SuiteLevelWebApp.Controllers
{
    [Authorize]
    [HandleAdalException]
    public class O365SiteProvisioningController : Controller
    {
        private SiteProvisioningTask siteProvisioningTask
        {
            get
            {
                if (HttpContext.Application["SiteProvisioningTask"] != null)
                {
                    return HttpContext.Application["SiteProvisioningTask"] as SiteProvisioningTask;
                }
                else
                {
                    return null;
                }
            }
            set
            {
                HttpContext.Application["SiteProvisioningTask"] = value;
            }
        }

        private SiteProvisioningTask demoDataProvisioningTask
        {
            get
            {
                if (HttpContext.Application["DemoDataProvisioningTask"] != null)
                {
                    return HttpContext.Application["DemoDataProvisioningTask"] as SiteProvisioningTask;
                }
                else
                {
                    return null;
                }
            }
            set
            {
                HttpContext.Application["DemoDataProvisioningTask"] = value;
            }
        }

        private System.Collections.Generic.List<Igroup> office365groups
        {
            get
            {
                if (HttpContext.Application["office365groups"] != null)
                {
                    return HttpContext.Application["office365groups"] as System.Collections.Generic.List<Igroup>;
                }
                else
                {
                    return null;
                }
            }
            set
            {
                HttpContext.Application["office365groups"] = value;
            }
        }

        //Index page view
        public async Task<ActionResult> Index()
        {
            var adminClientContext = AuthenticationHelper.GetAdminSiteClientContextAsync();
            var demoSiteClientContext = AuthenticationHelper.GetDemoSiteClientContextAsync();

            this.TempData["adminClientContext"] = await adminClientContext;
            this.TempData["demoSiteClientContext"] = await demoSiteClientContext;

            if (siteProvisioningTask != null && !siteProvisioningTask.Task.IsCompleted)
            {
                ViewBag.siteProvisioningInProgress = true;
            }

            return View();
        }

        //ProvisionDemoData page view
        public async Task<ActionResult> ProvisionDemoData()
        {
            this.TempData["demoSiteToken"] = await AuthenticationHelper.GetAccessTokenAsync(AppSettings.DemoSiteServiceResourceId);
            this.TempData["demoSiteClientContext"] = await AuthenticationHelper.GetDemoSiteClientContextAsync();
            this.TempData["graphService"] = await AuthenticationHelper.GetGraphServiceAsync();
            this.TempData["graphServiceToken"] = await AuthenticationHelper.GetGraphAccessTokenAsync();

            if (demoDataProvisioningTask != null && demoDataProvisioningTask.Phase != "Completed")
            {
                ViewBag.siteProvisioningInProgress = true;
            }

            return View();
        }

        //The api is consumed only by client side to check site provisioning status
        public JsonResult GetSiteProvisioningStatus()
        {
            HttpContext.Session.Clear();
            if (siteProvisioningTask != null)
            {
                return Json(new { phase = siteProvisioningTask.Phase, status = siteProvisioningTask.Task.Status.ToString(), message = DateTime.Now.ToString() + " - " + siteProvisioningTask.Message }, JsonRequestBehavior.AllowGet);
            }
            else
            {
                return Json(new { status = "fail" }, JsonRequestBehavior.AllowGet);
            }
        }

        public JsonResult GetDemoDataProvisioningStatus()
        {
            HttpContext.Session.Clear();

            if (demoDataProvisioningTask != null)
            {
                string currentStatus = string.Empty;
                string message = string.Empty;

                if (demoDataProvisioningTask.Phase == "Completed" || demoDataProvisioningTask.Phase == "Error")
                {
                    currentStatus = "RanToCompletion";
                    message = demoDataProvisioningTask.Message;
                }
                else
                {
                    currentStatus = "Running";
                    message = DateTime.Now.ToString() + " - " + demoDataProvisioningTask.Message;
                }
                return Json(new { phase = demoDataProvisioningTask.Phase, status = currentStatus, message = message }, JsonRequestBehavior.AllowGet);
            }
            else
            {
                return Json(new { status = "fail" }, JsonRequestBehavior.AllowGet);
            }
        }

        //provision demo site collection, information architecture and workflow.
        [HttpPost]
        public void StartSiteProvisioning()
        {
            var baseFolderPath = Server.MapPath("~/");
            if (siteProvisioningTask == null || siteProvisioningTask.Task.IsCompleted)
            {
                siteProvisioningTask = new SiteProvisioningTask();
                siteProvisioningTask.Task = Task.Factory.StartNew(() =>
                {
                    try
                    {
                        SiteProvisioning siteProvisioning = new SiteProvisioning(this.TempData.Peek("demoSiteClientContext") as ClientContext, baseFolderPath);

                        //provision site collection
                        siteProvisioningTask.Phase = "provision site collection";
                        while (true)
                        {
                            using (var adminClientContext = this.TempData.Peek("adminClientContext") as ClientContext)
                            {
                                siteProvisioningTask.Message = "The demo site collection is being created. This operation can take up to 20 minutes to complete.  Please be patient and do not refresh the page during this process.";


                                var status = siteProvisioning.CreateSiteCollection(adminClientContext);

                                if (status == "created")
                                {
                                    siteProvisioningTask.Message = "The demo site collection was successfully created.  Proceeding to provision information architecture.  This process may take several minutes, please be patient and do not refresh the page during this process.  If you are eager to see the progress you may browse to the new site collection in your browser and inspect the new components as they are provisioned.";
                                    break;
                                }

                                if (status == "fail")
                                {
                                    siteProvisioningTask.Message = "An error occurred.  This is usually due to one of two reasons.  1. You did not log in with an account that is a Global Administrator for your tenancy.  If you have logged in with a Global Administrator account, log out and close all browser windows then try this step again.  2. The site collection exists in the Recycle Bin.  If the Site Collection still exists in the Recycle Bin use the SharePoint Online Management Shell to delete it completely. The How to re-provision the entire information architecture and demo data section in the README describes how to use the following command to delete the site collection from the Recycle Bin. Remove-SPODeletedSite -Identity <Site Collection URL>";
                                    return;
                                }
                            }

                            Thread.Sleep(1000 * 30);
                        }

                        //reset demosite client context
                        siteProvisioning.clientContext = this.TempData["demoSiteClientContext"] as ClientContext;

                        //provision information architecture 
                        siteProvisioningTask.Phase = "provision information architecture";
                        siteProvisioning.RemoveSiteComponents();
                        siteProvisioning.AddSiteComponents();
                        siteProvisioningTask.Message = "The information architecture has been created successfully.  Proceeding to provision Workflows. This process may take several minutes, please be patient and do not refresh the page during this process. ";

                        //provision workflow
                        siteProvisioningTask.Phase = "provision workflow";
                        string incidentWorkflowFile = Server.MapPath("~/Workflows/Incident.xaml");
                        string suiteLevelWebAppUrl = Request.Url.GetLeftPart(UriPartial.Authority);
                        siteProvisioning.RemoveIncidentWorkflowAndRelatedLists();
                        siteProvisioning.ProvisionIncidentWorkflowAndRelatedLists(incidentWorkflowFile, suiteLevelWebAppUrl, AppSettings.DispatcherName);
                        siteProvisioningTask.Message = "Incident Workflow, Incident Workflow Tasks list and Incident Workflow History list have been created successfully. Click the Create Sample Data menu item to proceed.";

                        siteProvisioning.clientContext.Dispose();

                    }
                    catch (Exception ex)
                    {
                        siteProvisioningTask.Message = "An unexpected error occurred, please try again, error message: " + ex.Message;
                    }
                });
            }
        }

        [HttpPost]
        public void CreateDemoData(DemoDate demoDate)
        {
            var baseFolderPath = Server.MapPath("~/");
            var currentUsername = HttpContext.User.Identity.Name;
            var graphServiceToken = this.TempData.Peek("graphServiceToken").ToString();
            if (demoDataProvisioningTask == null || demoDataProvisioningTask.Phase == "Completed")
            {
                demoDataProvisioningTask = new SiteProvisioningTask();
                demoDataProvisioningTask.Task = Task.Factory.StartNew(async () =>
                {
                    try
                    {
                        var token = this.TempData.Peek("demoSiteToken") as string;
                        var graphService = this.TempData.Peek("graphService") as GraphService;

                        using (var clientContext = this.TempData.Peek("demoSiteClientContext") as Microsoft.SharePoint.Client.ClientContext)
                        {
                            demoDataProvisioningTask.Phase = "provision SharePoint demo data";
                            demoDataProvisioningTask.Message = "The SharePoint demo data is being provisioned. This operation can take up to 20 minutes to complete.  Please be patient and do not refresh the page during this process.";

                            var siteProvisioning = new SiteProvisioning(clientContext, baseFolderPath, currentUsername, graphServiceToken);
                            await siteProvisioning.AddSiteContentsAsync(new VideoPortalHelper(token));
                            siteProvisioning.UpdateInspectionAndIncidentListItems(DateTime.Parse(demoDate.date));

                            demoDataProvisioningTask.Phase = "provision demo users and AAD groups";
                            demoDataProvisioningTask.Message = "The SharePoint demo data has been provisioned successfully.  Proceeding to provision Demo users and AAD groups. Please be patient and do not refresh the page during this process.";
                            await siteProvisioning.AddGroupsAndUsersAsync(graphService, graphServiceToken);

                            demoDataProvisioningTask.Phase = "provision o365 groups";
                            demoDataProvisioningTask.Message = "The Demo users and AAD groups have been provisioned successfully.  Proceeding to provision Office 365 groups. Please be patient and do not refresh the page during this process.";
                            await siteProvisioning.CreateUnifiedGroupsForPropertiesAsync(graphService, graphServiceToken);

                            office365groups = await GetO365DemoGroups(graphService);
                            demoDataProvisioningTask.Phase = "Completed";
                            demoDataProvisioningTask.Message = "The AAD Groups, AAD Users, and demo data have been created successfully.  The initial password for all the users is: TempP@ssw0rd!";
                        }
                    }
                    catch (Exception ex)
                    {
                        demoDataProvisioningTask.Message = "An unexpected error occurred, please try again, error message: " + ex.Message;
                        demoDataProvisioningTask.Phase = "Error";
                    }
                });
            }
        }

        private async Task<bool> VerifyNotebooks(GraphService graphService)
        {
            foreach (var group in office365groups)
            {
                try
                {
                    await OneNoteService.GetNoteBookAsync(graphService.groups.GetById(group.id), group.displayName + " Notebook");
                }
                catch
                {
                    return false;
                }
            }

            return true;
        }

        public JsonResult GetO365GroupLinks()
        {
            System.Collections.Generic.List<object> groupLinks = new System.Collections.Generic.List<object>();

            foreach (var group in office365groups)
            {
                groupLinks.Add(new { link = string.Format("{0}/_layouts/groupstatus.aspx?id={1}&target=notebook", AppSettings.DemoSiteCollectionUrl, group.id) });
            }

            return Json(groupLinks.ToArray(), JsonRequestBehavior.AllowGet);
        }

        public async Task<System.Collections.Generic.List<Igroup>> GetO365DemoGroups(GraphService graphService)
        {
            var groups = await (await graphService.groups.ExecuteAsync()).GetAllAsnyc();
            return groups
                .Where(i => i.description == "Property Group")
                .ToList();
        }
    }
}