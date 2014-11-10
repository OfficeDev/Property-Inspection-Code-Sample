using SuiteLevelWebApp.Service;
using SuiteLevelWebApp.Utils;
using System.Threading.Tasks;
using System.Web.Mvc;

namespace SuiteLevelWebApp.Controllers
{

    [Authorize, HandleAdalException]
    public class EmailController : Controller
    {
        public async Task<ActionResult> SendEmailTest(int incidentId)
        {
            var outlookToken = await O365Util.GetAccessToken(Capabilities.Mail);
            var sharePointToken = await O365Util.GetAccessToken(ServiceResources.DemoSite);

            return await SendEmail(outlookToken, sharePointToken, incidentId);
        }

        public async Task<ActionResult> SendEmail(string outlookToken, string sharePointToken, int incidentId)
        {
            var outlookClient = await O365Util.GetOutlookClient(Capabilities.Mail);

            var service = new EmailService(sharePointToken, Server.MapPath("/"));
            var message = await service.ComposeRepairCompletedEmailMessage(incidentId);
            await outlookClient.Me.SendMailAsync(message, true);

            return Content("Success");
        }
    }
}