using Microsoft.SharePoint.Client;
using SuiteLevelWebApp.Utils;
using System.IO;
using System.Net;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
using Microsoft.Graph;
using System;

namespace SuiteLevelWebApp.Controllers
{
    [Authorize, HandleAdalException]
    public class PhotoController : Controller
    {
        [OutputCache(Duration = 600, VaryByParam = "*")]
        public async Task<ActionResult> UserPhoto(string userId)
        {
            try
            {
                GraphServiceClient graphService = await AuthenticationHelper.GetGraphServiceAsync(AADAppSettings.GraphResourceUrl);
                var fileStream = await graphService.Users[userId].Photo.Content.Request().GetAsync();
                if(fileStream != null)
                      return File(fileStream, "image/jpeg");
            }
            catch {

            }
            return File(Server.MapPath("/Content/images/DefaultUserPhoto.jpg"), "image/jpeg");
        }

        [OutputCache(Duration = 600, VaryByParam = "*")]
        public async Task<ActionResult> DriveItemThumbnail(string groupId, string fileId)
        {
            try
            {
                var graphService = await AuthenticationHelper.GetGraphServiceAsync(AADAppSettings.GraphResourceUrl);
                var thumbnails = await graphService.Groups[groupId].Drive.Items[fileId].Thumbnails["0"].Request().GetAsync();
                var uri = thumbnails.Medium.Url;
                var token = AuthenticationHelper.GetAccessTokenAsync(AppSettings.DemoSiteServiceResourceId);
                var request = (HttpWebRequest)HttpWebRequest.Create(uri);

                request.Method = "GET";
                request.Headers.Add("Authorization", "Bearer " + await token);


                var response = (HttpWebResponse)(await request.GetResponseAsync());
                if (response.StatusCode == HttpStatusCode.OK)
                    return File(response.GetResponseStream(), response.ContentType);
            }
            catch { }

            throw new HttpException(404, "File not found");
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