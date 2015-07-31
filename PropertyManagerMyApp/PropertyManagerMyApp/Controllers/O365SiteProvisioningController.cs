using Microsoft.SharePoint.Client;
using SuiteLevelWebApp.Models;
using SuiteLevelWebApp.Utils;
using System;
using System.Text.RegularExpressions;
using System.Threading;
using System.Threading.Tasks;
using System.Web.Mvc;

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
            var graphService = await AuthenticationHelper.GetGraphServiceAsync(); // Prepare Graph Service in advance.
            SuiteLevelWebApp.Models.ProvisionDemoData model = TempData["datetime"] as SuiteLevelWebApp.Models.ProvisionDemoData;
            if (TempData["datetime"] == null)
            {
                model = new SuiteLevelWebApp.Models.ProvisionDemoData();
            }
            return View(model);
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

        //provision demo site collection, information architecture and workflow.
        [HttpPost]
        public void StartSiteProvisioning()
        {
            if (siteProvisioningTask == null || siteProvisioningTask.Task.IsCompleted)
            {
                siteProvisioningTask = new SiteProvisioningTask
                {
                    Task = Task.Factory.StartNew(() =>
                    {
                        try
                        {
                            SiteProvisioning siteProvisioning = new SiteProvisioning(this.TempData.Peek("demoSiteClientContext") as ClientContext);

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
                    })
                };
            }
        }

        [HttpPost]
        public async Task<ActionResult> CreateDemoData(SuiteLevelWebApp.Models.ProvisionDemoData model)
        {
            var token = AuthenticationHelper.GetAccessTokenAsync(AppSettings.DemoSiteServiceResourceId);
            var graphService = AuthenticationHelper.GetGraphServiceAsync();

            using (var clientContext = await AuthenticationHelper.GetDemoSiteClientContextAsync())
            {
                var siteProvisioning = new SiteProvisioning(clientContext);
                await siteProvisioning.AddSiteContentsAsync(new VideoPortalHelper(await token));
                siteProvisioning.UpdateInspectionAndIncidentListItems(model.DateDemo);
                await siteProvisioning.AddGroupsAndUsersAsync(await graphService);
                await siteProvisioning.CreateUnifiedGroupsForPropertiesAsync(await graphService);

                model.Message = "The AAD Groups, AAD Users, and demo data have been created successfully.  The initial password for all the users is: TempP@ssw0rd!";
                TempData["datetime"] = model;
                return RedirectToAction("ProvisionDemoData");
            }
        }
    }
}