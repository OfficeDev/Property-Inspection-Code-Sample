using SuiteLevelWebApp.Models;
using SuiteLevelWebApp.Services;
using SuiteLevelWebApp.Utils;
using System;
using System.Configuration;
using System.Web;
using System.Threading.Tasks;
using System.Web.Mvc;
using Microsoft.Graph;
using System.IO;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Web.Http.Results;
using Newtonsoft.Json;
using System.Collections.Generic;

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
            var sharePointToken = await AuthenticationHelper.GetAccessTokenAsync(AppSettings.DemoSiteServiceResourceId);
            var graphService = await AuthenticationHelper.GetGraphServiceAsync(AADAppSettings.GraphResourceUrl);
            Dashboard dashboardModel = new Dashboard(sharePointToken);
            var model = await dashboardModel.GetDashboardInspectionDetailsViewModelAsync(graphService, id, User.Identity.Name);
            if (model == null) return HttpNotFound();
            var accessToken = await AuthenticationHelper.GetGraphAccessTokenAsync();
            TempData["accesstoken"] = accessToken;
            await dashboardModel.CheckSubscriptionAsync(graphService, accessToken);
            return View(model);
        }

        
        [HttpGet]
        public async Task<FileResult> GetPropertyGroupExcelChart(string groupId, string fileId, string title)
        {
            var imageBinary = await ExcelService.GetPropertyExcelWorkbookChartImageAsync(groupId, fileId, title);
            return new FileContentResult(imageBinary, "image/bmp"); ;
        }

        [HttpPost]
        public async Task<ActionResult> ScheduleRepair(ScheduleRepairModel model)
        {
            model.TimeSlotsSelectedValue = DateTime.ParseExact(string.Format("{0} {1}:00", model.TimeSlotsSelectedDateValue, model.TimeSlotsSelectedHoursValue),
                "yyyy-MM-dd HH:mm", null);
            var sharePointToken = AuthenticationHelper.GetAccessTokenAsync(AppSettings.DemoSiteServiceResourceId);
            var graphService = AuthenticationHelper.GetGraphServiceAsync(AADAppSettings.GraphResourceUrl);

            var tasksService = new TasksService(await sharePointToken);
            var dashboardModel = new Dashboard(await sharePointToken);

            await dashboardModel.UpdateRepairScheduleInfoToIncidentAsync(model)
                .ContinueWith(async task => await tasksService.CompleteRepairAssignmentTaskAsync(model.IncidentId));

            await dashboardModel.ScheduleRepairAsync(await graphService, model);
            await dashboardModel.CreateGroupRepairEventAsync(await graphService, model);
            await dashboardModel.CreateO365TaskAsync(await graphService, model);

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

        [HttpPost]
        public async Task<ActionResult> AnnotateImages(int incidentId)
        {
            var sharePointToken = AuthenticationHelper.GetAccessTokenAsync(AppSettings.DemoSiteServiceResourceId);
            var graphService = AuthenticationHelper.GetGraphServiceAsync(AADAppSettings.GraphResourceUrl);
            var dashboardService = new Dashboard(await sharePointToken);

            var pageUrl = await dashboardService.AnnotateImagesAsync(await graphService, Server.MapPath("/"), incidentId);
            return Redirect(pageUrl);
        }

        [HttpPost]
        public async Task<ActionResult> UploadFile(UploadFileModel model)
        {
            if (model.File != null)
            {
                var token = AuthenticationHelper.GetAccessTokenAsync(AppSettings.DemoSiteServiceResourceId);
                var graphService = AuthenticationHelper.GetGraphServiceAsync(AADAppSettings.GraphResourceUrl);

                var dashboardService = new Dashboard(await token);
                await dashboardService.UploadFileAsync(await graphService, model);
            }

            return RedirectToAction("InspectionDetails", new { id = model.IncidentId });
        }

    }
}