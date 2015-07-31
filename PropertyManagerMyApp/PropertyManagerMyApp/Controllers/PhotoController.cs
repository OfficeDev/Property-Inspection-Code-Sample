using Microsoft.SharePoint.Client;
using SuiteLevelWebApp.Utils;
using System.IO;
using System.Net;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;

namespace SuiteLevelWebApp.Controllers
{
    [Authorize, HandleAdalException]
    public class PhotoController : Controller
    {
        [OutputCache(Duration = 600, VaryByParam = "*")]
        public async Task<ActionResult> UserPhoto(string userId)
        {
            //Graph rest API
            //this is a known bug, once the bug gets fixed we will replace the Outlook API code with the Graph API code 
            //var token = AuthenticationHelper.GetGraphAccessTokenAsync();
            //var uri = string.Format("{0}{1}/users/{2}/UserPhotos/48X48/$Value", AADAppSettings.GraphResourceUrl, AppSettings.DemoSiteCollectionOwner.Split('@')[1], userId);

            //Outlook rest API
            var token = AuthenticationHelper.GetAccessTokenAsync(AADAppSettings.OutlookResourceId);
            var uri = string.Format("{0}api/beta/Users('{1}')/UserPhotos('48X48')/$Value", AADAppSettings.OutlookResourceId, userId);

            var request = (HttpWebRequest)HttpWebRequest.Create(uri);

            request.Method = "GET";
            request.Headers.Add("Authorization", "Bearer " + await token);

            try
            {
                var response = (HttpWebResponse)(await request.GetResponseAsync());
                if (response.StatusCode == HttpStatusCode.OK)
                    return File(response.GetResponseStream(), response.ContentType);
            }
            catch { }

            return File(Server.MapPath("/Content/images/DefaultUserPhoto.jpg"), "image/jpeg");
        }

        [OutputCache(Duration = 600, VaryByParam = "*")]
        public async Task<ActionResult> GetPhoto(string url)
        {
            try
            {
                using (var clientContext = await AuthenticationHelper.GetDemoSiteClientContextAsync())
                {
                    Match match = (new Regex(@"(?<=\.)(\w*)")).Match(url);
                    string contentType = string.Format("image/{0}", match.Captures[match.Captures.Count - 1].Value);

                    Microsoft.SharePoint.Client.File file = clientContext.Web.GetFileByServerRelativeUrl(url);
                    clientContext.Load(file);
                    clientContext.ExecuteQuery();

                    ClientResult<Stream> clientResult = file.OpenBinaryStream();
                    clientContext.ExecuteQuery();

                    using (Stream stream = clientResult.Value)
                    {
                        byte[] data = new byte[stream.Length];
                        stream.Read(data, 0, data.Length);
                        return File(data, contentType);
                    }
                }
            }
            catch
            { }

            throw new HttpException(404, "File not found");

        }
    }
}