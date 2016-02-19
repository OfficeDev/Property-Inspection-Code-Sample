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
            var token = AuthenticationHelper.GetGraphAccessTokenAsync();
            var uri = string.Format("{0}Users/{1}/photos/48X48/$value", AADAppSettings.GraphResourceUrl, userId);

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
        public async Task<ActionResult> DriveItemThumbnail(string groupId, string fileId)
        {
            try
            {
                var graphService = await AuthenticationHelper.GetGraphServiceAsync();
                var thumbnails = await graphService.groups.GetById(groupId).drive.items.GetById(fileId).thumbnails.GetById("0").ExecuteAsync();
                var uri = thumbnails.medium.url;
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