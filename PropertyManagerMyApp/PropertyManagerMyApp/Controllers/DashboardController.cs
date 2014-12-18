using SuiteLevelWebApp.Models;
using SuiteLevelWebApp.Service;
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
            var sharePointToken = await O365Util.GetAccessToken(ServiceResources.DemoSite);
            Dashboard dashboardModel = new Dashboard(sharePointToken);
            var model = await dashboardModel.GetDashboardPropertiesViewModel();

            return View(model);
        }

        public async Task<ActionResult> Property(int Id)
        {
            var sharePointToken = await O365Util.GetAccessToken(ServiceResources.DemoSite);
            Dashboard dashboardModel = new Dashboard(sharePointToken);
            var model = await dashboardModel.GetDashboardPropertiesViewModel(Id);

            return View(model);
        }

        public async Task<ActionResult> InspectionDetails(int Id)
        {
            await O365Util.GetAccessToken(Capabilities.Mail); // Prepare Outlook token in advance.

            var sharePointToken = await O365Util.GetAccessToken(ServiceResources.DemoSite);
            Dashboard dashboardModel = new Dashboard(sharePointToken);
            var model = await dashboardModel.GetDashboardInspectionDetailsViewModel(Id);

            if (model == null)
            {
                return new RedirectResult("/Dashboard/Index");
            }
            else if (model.viewName == "schedule a repair")
            {
                ViewBag.RepairPeopleList = new SelectList(model.repairPeople, "sl_emailaddress", "Title");
            }
            return View(model);
        }

        [HttpPost]
        public async Task<ActionResult> InspectionDetails(DashboardInspectionDetailsViewModel model)
        {
            var sharePointToken = await O365Util.GetAccessToken(ServiceResources.DemoSite);

            var service = new TasksService(sharePointToken);
            await service.CompleteRepairAssignmentTask(model.incidentId);

            var dashboardModel = new Dashboard(sharePointToken);
            var calendarEvent = await dashboardModel.ScheduleRepair(model);
            await O365CalendarController.Create(calendarEvent);

            return RedirectToAction("InspectionDetails", new { id = model.incidentId });
        }

        [HttpPost]
        public async Task<ActionResult> AuditRepair(string button, DashboardInspectionDetailsViewModel model)
        {
            var outlookToken = await O365Util.GetAccessToken(Capabilities.Mail);
            var sharePointToken = await O365Util.GetAccessToken(ServiceResources.DemoSite);
            var outlookClient = await O365Util.GetOutlookClient(Capabilities.Mail);
            Dashboard dashboardModel = new Dashboard(sharePointToken);

            var result = button == "Approve" ? ApprovalResult.Approved : ApprovalResult.Rejected;

            var tasksService = new TasksService(sharePointToken);
            await tasksService.CompleteRepairApprovalTask(model.incidentId, result);

            if (result == ApprovalResult.Approved)
            {
                await dashboardModel.ApproveRepair(model.incidentId);
                //This is the pattern you would use to send email from O365 APIs.  These emails are sent via the mobile apps.
                //var emailService = new EmailService(sharePointToken, Server.MapPath("/"));
                //var emailMessage = await emailService.ComposeRepairCompletedEmailMessage(model.incidentId);
                //await outlookClient.Me.SendMailAsync(emailMessage, true);
            }
            return new RedirectResult("/Dashboard/Index");
        }
    }
}