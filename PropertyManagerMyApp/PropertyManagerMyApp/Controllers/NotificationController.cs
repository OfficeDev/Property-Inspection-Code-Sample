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
using System.Xml;
using Microsoft.Graph;

namespace SuiteLevelWebApp.Controllers
{
    public class NotificationController : Controller
    {
        [HttpPost]
        public ActionResult Listen()
        {
            // Validate the new subscription by sending the token back to MS Graph.
            // This response is required for each subscription.
            if (Request.QueryString["validationToken"] != null)
            {
                var token = Request.QueryString["validationToken"];
                return Content(token, "plain/text");
            }
            // Parse the received notifications.
            else
            {
                try
                {
                    var notifications = new Dictionary<string, Notification>();
                    using (var inputStream = new StreamReader(Request.InputStream))
                    {
                        string resp = inputStream.ReadToEnd();
                        string xmlpath = AppDomain.CurrentDomain.BaseDirectory + "App_Data\\Notifications.xml";
                        XmlDocument xmldoc = new XmlDocument();
                        xmldoc.Load(xmlpath);
                        if (xmldoc != null)
                        {
                            XmlNodeList valuesItems = xmldoc.SelectNodes("//value");
                            if (valuesItems != null && valuesItems.Count > 0)
                            {
                                XmlDocument newXmlNode = JsonConvert.DeserializeXmlNode(resp, "root");

                                foreach (XmlNode node in newXmlNode.DocumentElement.ChildNodes)
                                {
                                    XmlNode imported = xmldoc.ImportNode(node, true);
                                    xmldoc.DocumentElement.AppendChild(imported);
                                }
                            }
                            else
                            {
                                xmldoc = JsonConvert.DeserializeXmlNode(resp, "root");
                            }
                            xmldoc.Save(xmlpath);
                        }
                    }
                    return new HttpStatusCodeResult(200);
                }
                catch
                {
                    return new HttpStatusCodeResult(200);
                }
            }
        }

        public JsonResult GetNotification()
        {
            Subscription subscription = System.Web.HttpContext.Current.Session["WebHookSubscription"] as Subscription;
            if(subscription != null)
            {
                string xmlpath = AppDomain.CurrentDomain.BaseDirectory + "App_Data\\Notifications.xml";
                try
                {
                    XmlDocument doc = new XmlDocument();
                    doc.Load(xmlpath);
                    Dictionary<string, NotionficationToClientItem> dic = new Dictionary<string, NotionficationToClientItem>();
                    XmlNodeList items = doc.SelectNodes("//value");
                    List<XmlNode> removeItems = new List<XmlNode>();

                    foreach (XmlNode item in items)
                    {
                        string resource = string.Empty, changeType = string.Empty, clientState = string.Empty;
                        foreach (XmlNode ss in item.ChildNodes)
                        {
                            if (ss.Name.ToLower().Equals("clientstate"))
                            {
                                if (ss.InnerText != subscription.ClientState)
                                {
                                    resource = string.Empty;
                                    break;
                                }
                            }
                            if (ss.Name.ToLower().Equals("resource"))
                            {
                                resource = ss.InnerText;
                            }
                            if (ss.Name.ToLower().Equals("changetype"))
                            {
                                changeType = ss.InnerText;
                            }
                        }
                        if (resource != string.Empty)
                        {
                            dic[resource] = new NotionficationToClientItem() { resource = resource, changeType = changeType };
                        }
                        removeItems.Add(item);
                    }
                    if(removeItems.Count >0)
                    {
                        XmlNode root = doc.DocumentElement;
                        foreach (XmlNode node in removeItems)
                        {
                            root.RemoveChild(node);
                        }
                        doc.Save(xmlpath);
                    }
                    return Json(new { status = "ok", notifications = dic.Values }, JsonRequestBehavior.AllowGet);
                }
                catch (Exception e)
                {
                    Console.WriteLine(e.Message);
                }
            }
            return Json(new { status = "ok" }, JsonRequestBehavior.AllowGet);
        }
    }
}