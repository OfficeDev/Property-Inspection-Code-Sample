using System.Web.Mvc;
using System.Threading.Tasks;
using SuiteLevelWebApp.Models;
using SuiteLevelWebApp.Utils;
using System.Configuration;

namespace SuiteLevelWebApp.Controllers
{
    [Authorize, HandleAdalException]
    public class MailAFOController : Controller
    {
        static readonly string DemoSiteServiceResourceId = ConfigurationManager.AppSettings["DemoSiteServiceResourceId"];

        public async Task<ActionResult> Index(int Id)
        {
            var token = await O365Util.GetAccessToken(ServiceResources.DemoSite);

            MailAFOModel dashboardModel = new MailAFOModel(token);
            var model = await dashboardModel.GetMailAFOViewModel(Id);

            if (model == null)
            {
                return new RedirectResult("/MailAFO/Index");
            }

            return View(model);
        }
        public ActionResult Redir()
        {
            return View();
        }
    }
}