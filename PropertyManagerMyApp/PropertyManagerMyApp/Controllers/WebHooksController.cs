using SuiteLevelWebApp.Models;
using SuiteLevelWebApp.Services;
using SuiteLevelWebApp.Utils;
using System;
using System.Configuration;
using System.Web;
using System.Threading.Tasks;
using System.Web.Mvc;
using System.IO;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Web.Http.Results;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.Collections.Generic;
using Microsoft.Graph;


namespace SuiteLevelWebApp.Controllers
{
    [Authorize, HandleAdalException]
    public class WebHooksController : Controller
    {
        // GET: WebHooks
        public ActionResult Index()
        {
            return View();
        }
        public ActionResult Notification()
        {
            return View("Notification");
        }

        public ActionResult Subscription(Subscription sub)
        {
            Subscription subscription = System.Web.HttpContext.Current.Session["WebHookSubscription"] as Subscription;

            if (subscription != null)
            {
                return View(subscription);
            }
            else
            {
                return Content("Subscription not found.");
            }
                
        }

        //Delete Subcription
        [HttpPost]
        public async Task<ActionResult> DeleteSubscription()
        {
            Subscription subscription = System.Web.HttpContext.Current.Session["WebHookSubscription"] as Subscription;

            if (subscription != null)
            {
                try
                {
                    GraphServiceClient graphServiceClient = await AuthenticationHelper.GetGraphServiceAsync(AADAppSettings.GraphResourceUrl);
                    var accessToken = await AuthenticationHelper.GetGraphAccessTokenAsync();
                    await graphServiceClient.DeleteSubscriptionAsync(accessToken, subscription.Id);
                    System.Web.HttpContext.Current.Session.Remove("WebHookSubscription");
                }
                catch (ServiceException e)
                {
                    return Content("Throw exception " + e.Error.Message.ToString());
                }
                return RedirectToAction("Index", "WebHooks");
            }
            return Content("Subscription not found.");

        }
        [HttpGet]
        public async Task<ActionResult> DeleteSubscription(string subscriptionId)
        {
            try
            {
                GraphServiceClient graphServiceClient = await AuthenticationHelper.GetGraphServiceAsync(AADAppSettings.GraphResourceUrl);
                var accessToken = await AuthenticationHelper.GetGraphAccessTokenAsync();
                await graphServiceClient.DeleteSubscriptionAsync(accessToken, subscriptionId);
            }
            catch (ServiceException e)
            {
                return Content("Throw exception " + e.Error.Message.ToString());
            }
            return RedirectToAction("Index", "WebHooks");

        }
    }
}