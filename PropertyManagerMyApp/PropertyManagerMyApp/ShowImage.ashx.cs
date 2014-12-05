using System;
using System.IO;
using System.Configuration;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using System.Net;
using SuiteLevelWebApp.Utils;
using SuiteLevelWebApp.Controllers;
using Microsoft.SharePoint.Client;
using System.Threading.Tasks;

namespace SuiteLevelWebApp
{
    public class ShowImage : IHttpHandler, IRequiresSessionState
    {
        public void ProcessRequest(HttpContext context)
        {
            try
            {
                string imageUrl = context.Request.QueryString["url"];

                if (!string.IsNullOrEmpty(imageUrl))
                {
                    if (HttpContext.Current.Cache[imageUrl] != null)
                    {
                        byte[] data = HttpContext.Current.Cache[imageUrl] as byte[];
                        context.Response.ContentType = "image/jpeg";
                        context.Response.BinaryWrite(data);
                    }
                    else
                    {
                        //This code could be replaced with the O365 Files Api
                        var demoSiteCollectionUrl = ConfigurationManager.AppSettings["DemoSiteCollectionUrl"];
                        var token = HttpContext.Current.Session["SPsessionCache"].ToString();
                        using (var clientContext = TokenHelper.GetClientContextWithAccessToken(demoSiteCollectionUrl, token))
                        {
                            Microsoft.SharePoint.Client.File file = clientContext.Web.GetFileByServerRelativeUrl(imageUrl);
                            clientContext.Load(file);
                            clientContext.ExecuteQuery();

                            ClientResult<Stream> clientResult = file.OpenBinaryStream();
                            clientContext.ExecuteQuery();

                            using (Stream stream = clientResult.Value)
                            {
                                byte[] data = new byte[stream.Length];
                                stream.Read(data, 0, data.Length);
                                HttpContext.Current.Cache[imageUrl] = data;
                                context.Response.ContentType = "image/jpeg";
                                context.Response.BinaryWrite(data);
                            }
                        }
                    }
                    
                    context.Response.Flush();
                }
            }
            catch
            {
                context.Response.End();
            }
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}