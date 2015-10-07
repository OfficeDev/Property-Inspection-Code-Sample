using SuiteLevelWebApp.Models;
using SuiteLevelWebApp.Utils;
using System.Threading.Tasks;
using System.Web.Mvc;

namespace SuiteLevelWebApp.Controllers
{
    [Authorize, HandleAdalException]
    public class MailAFOController : Controller
    {
        public async Task<ActionResult> Index(int Id)
        {
            var token = await AuthenticationHelper.GetAccessTokenAsync(AppSettings.DemoSiteServiceResourceId);

            MailAFOModel dashboardModel = new MailAFOModel(token);
            var model = await dashboardModel.GetMailAFOViewModelAsync(Id);

            if (model == null)
            {
                return Content("Incident not found");
            }

            return View(model);
        }
        public ActionResult Redir()
        {
            return View();
        }
    }
}