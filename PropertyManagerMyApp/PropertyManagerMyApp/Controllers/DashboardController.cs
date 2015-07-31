using SuiteLevelWebApp.Models;
using SuiteLevelWebApp.Service;
using SuiteLevelWebApp.Services;
using SuiteLevelWebApp.Utils;
using System.Threading.Tasks;
using System.Web.Mvc;

namespace SuiteLevelWebApp.Controllers
{
    [Authorize, HandleAdalException]
    public class DashboardController : Controller
    {
        public async Task<ActionResult> Index()
        {
            var sharePointToken = await AuthenticationHelper.GetAccessTokenAsync(AppSettings.DemoSiteServiceResourceId);
            Dashboard dashboardModel = new Dashboard(sharePointToken);
            var model = await dashboardModel.GetDashboardPropertiesViewModelAsync();

            return View(model);
        }

        public async Task<ActionResult> Property(int id)
        {
            var sharePointToken = await AuthenticationHelper.GetAccessTokenAsync(AppSettings.DemoSiteServiceResourceId);
            Dashboard dashboardModel = new Dashboard(sharePointToken);
            var model = await dashboardModel.GetDashboardPropertiesViewModelAsync(id);

            return View(model);
        }

        public async Task<ActionResult> InspectionDetails(int id)
        {
            var outlookToken = await AuthenticationHelper.GetAccessTokenAsync(AADAppSettings.OutlookResourceId);
            var sharePointToken = AuthenticationHelper.GetAccessTokenAsync(AppSettings.DemoSiteServiceResourceId);
            var graphService = AuthenticationHelper.GetGraphServiceAsync();

            var oneNoteToken = AuthenticationHelper.GetOneNoteAccessTokenAsync();
            var oneNoteService = new OneNoteService(AADAppSettings.OneNoteResourceUrl, await oneNoteToken);

            Dashboard dashboardModel = new Dashboard(await sharePointToken);
            var model = await dashboardModel.GetDashboardInspectionDetailsViewModelAsync(await graphService, oneNoteService, id, User.Identity.Name);
            if (model == null) return HttpNotFound();

            return View(model);
        }

        [HttpPost]
        public async Task<ActionResult> ScheduleRepair(ScheduleRepairModel model)
        {
            var sharePointToken = AuthenticationHelper.GetAccessTokenAsync(AppSettings.DemoSiteServiceResourceId);
            var graphService = AuthenticationHelper.GetGraphServiceAsync();

            var tasksService = new TasksService(await sharePointToken);
            var dashboardModel = new Dashboard(await sharePointToken);

            await dashboardModel.UpdateRepairScheduleInfoToIncidentAsync(model)
                .ContinueWith(async task => await tasksService.CompleteRepairAssignmentTaskAsync(model.IncidentId));

            await dashboardModel.ScheduleRepairAsync(await graphService, model);
            await dashboardModel.CreateGroupRepairEventAsync(await graphService, model);

            return RedirectToAction("Index");
        }

        [HttpPost]
        public async Task<ActionResult> AuditRepair(AuditRepairModel model)
        {
            var sharePointToken = await AuthenticationHelper.GetAccessTokenAsync(AppSettings.DemoSiteServiceResourceId);
            Dashboard dashboardModel = new Dashboard(sharePointToken);

            var tasksService = new TasksService(sharePointToken);
            await tasksService.CompleteRepairApprovalTaskAsync(model);

            if (model.Result == ApprovalResult.Approved)
                await dashboardModel.ApproveRepairAsync(model.IncidentId);

            return RedirectToAction("Index");
        }

        //[HttpPost]
        //public async Task<ActionResult> CreateTask(CreateTaskViewModel model)
        //{
        //    if (!ModelState.IsValid)
        //    {
        //        ViewBag.CreateTaskViewModel = model;
        //        return await InspectionDetails(model.InspectionId);
        //    }

        //    var sharePointToken = await AuthenticationHelper.GetAccessToken(ServiceResources.DemoSite);
        //    var dashboardService = new Dashboard(sharePointToken);
        //    var graphService = AuthenticationHelper.GetGraphService();

        //    await dashboardService.CreateTaskAsync(graphService, model);
        //    return RedirectToAction("InspectionDetails", new { id = model.InspectionId });
        //}

        [HttpPost]
        public async Task<ActionResult> AnnotateImages(int incidentId)
        {
            var sharePointToken = AuthenticationHelper.GetAccessTokenAsync(AppSettings.DemoSiteServiceResourceId);
            var oneNoteToken = AuthenticationHelper.GetOneNoteAccessTokenAsync();

            var graphService = AuthenticationHelper.GetGraphServiceAsync();
            var dashboardService = new Dashboard(await sharePointToken);

            var oneNoteService = new OneNoteService(AADAppSettings.OneNoteResourceUrl, await oneNoteToken);
            var pageUrl = await dashboardService.AnnotateImagesAsync(await graphService, oneNoteService, Server.MapPath("/"), incidentId);
            return Redirect(pageUrl);
        }

        [HttpPost]
        public async Task<ActionResult> UploadFile(UploadFileModel model)
        {
            if (model.File != null)
            {
                var token = AuthenticationHelper.GetAccessTokenAsync(AppSettings.DemoSiteServiceResourceId);
                var graphService = AuthenticationHelper.GetGraphServiceAsync();

                var dashboardService = new Dashboard(await token);
                await dashboardService.UploadFileAsync(await graphService, model);
            }
            return RedirectToAction("InspectionDetails", new { id = model.IncidentId });
        }
    }
}