using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.IO;
using System.Linq;
using System.Net;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Xml;

namespace SuiteLevelWebApp.Utils
{
    public class VideoPortalHelper
    {
        private string _accessToken = string.Empty;
        private string _baseVideoApiUrl = string.Empty;
        private readonly string _videoPortalEndpoint = AppSettings.VideoPortalEndpointUri;
        private readonly string _incidentsChannelName = AppSettings.VideoPortalIncidentsChannelName;
        private readonly string _inspectionsChannelName = AppSettings.VideoPortalInspectionsChannelName;
        private readonly string _repairsChannelName = AppSettings.VideoPortalRepairsChannelName;

        public VideoPortalHelper(string accessToken)
        {
            _accessToken = accessToken;
            _baseVideoApiUrl = string.Format("{0}/_api", _videoPortalEndpoint);
        }

        private async Task<XmlDocument> GetResponseAsync(HttpMethod method, Uri requestUri, NameValueCollection headers = null, byte[] body = null)
        {
            XmlDocument xmlDocument = new XmlDocument();

            HttpWebRequest request = (HttpWebRequest)HttpWebRequest.Create(requestUri);

            if (method == HttpMethod.GET)
            {
                request.Method = "GET";
            }
            else
            {
                request.Method = "POST";
            }

            request.Headers.Add("Authorization", "Bearer " + _accessToken);

            if (headers != null)
            {
                foreach (var key in headers.AllKeys)
                {
                    if (key == "Content-Type")
                    {
                        request.ContentType = headers["Content-Type"];
                    }
                    else
                    {
                        request.Headers.Add(key, headers[key]);
                    }

                }
            }

            if (method == HttpMethod.POST)
            {
                if (body != null)
                {
                    using (Stream dataStream = request.GetRequestStream())
                    {
                        dataStream.Write(body, 0, body.Length);
                    }
                }
                else
                {
                    request.ContentLength = 0;
                }
            }

            try
            {
                using (var response = (HttpWebResponse)(await request.GetResponseAsync()))
                {
                    if (response.StatusCode == HttpStatusCode.OK || response.StatusCode == HttpStatusCode.Created)
                    {
                        xmlDocument.Load(response.GetResponseStream());
                    }
                }
            }
            catch (Exception ex)
            {
                string message = ex.Message.ToString();
            }

            return xmlDocument;

        }

        public async Task<string> GetRequestDigestAsync()
        {

            XmlDocument xdt = await GetResponseAsync(HttpMethod.POST, new Uri(_baseVideoApiUrl + "/contextinfo"));

            XmlNamespaceManager nsmgr = new XmlNamespaceManager(xdt.NameTable);

            nsmgr.AddNamespace("d", "http://schemas.microsoft.com/ado/2007/08/dataservices");

            return xdt.SelectSingleNode("//d:FormDigestValue", nsmgr).InnerText;
        }

        private async Task<string> CreateVideoPlaceHolderAsync(string Url, string Title, string Description, string FileName)
        {
            string videoId = "";
            var headers = new NameValueCollection();
            headers["X-RequestDigest"] = await GetRequestDigestAsync();
            headers["Content-Type"] = "application/json; charset=UTF-8";

            string body = string.Format("{{'odata.type': 'SP.Publishing.VideoItem', 'Description':'{1}', 'Title':'{0}', 'FileName': '{2}'}}", Title, Description, FileName);

            XmlDocument xdt = await GetResponseAsync(HttpMethod.POST, new Uri(Url), headers, System.Text.Encoding.UTF8.GetBytes(body));

            if (string.IsNullOrEmpty(xdt.InnerXml))
            {
                return string.Empty;
            }
            XmlNamespaceManager nsmgr = new XmlNamespaceManager(xdt.NameTable);
            nsmgr.AddNamespace("a", "http://www.w3.org/2005/Atom");
            if (xdt.SelectSingleNode("//a:entry/a:id", nsmgr) != null)
            {
                videoId = xdt.SelectSingleNode("//a:entry/a:id", nsmgr).InnerText;
            }

            return string.Format("{0}/GetFile()/SaveBinaryStream", videoId);
        }

        public async Task<string> GetChannelUrlAsync(string ChannelName)
        {
            var resultUrl = string.Empty;
            if (string.IsNullOrEmpty(ChannelName))
            {
                return resultUrl;
            }
            Uri uri = new Uri(string.Format("{0}/VideoService/Channels?$filter=Title eq '{1}'", _baseVideoApiUrl, ChannelName));
            XmlDocument xdt = await GetResponseAsync(HttpMethod.GET, uri);
            XmlNamespaceManager nsmgr = new XmlNamespaceManager(xdt.NameTable);
            nsmgr.AddNamespace("a", "http://www.w3.org/2005/Atom");

            if (xdt.SelectSingleNode("//a:entry/a:id", nsmgr) != null)
            {
                resultUrl = xdt.SelectSingleNode("//a:entry/a:id", nsmgr).InnerText;
            }
            else
            {
                resultUrl = string.Format("{0}/VideoService/Channels(guid'{1}')", _baseVideoApiUrl, await CreateChannelAsync(ChannelName));
            }
            return resultUrl;
        }

        public async Task<string> CreateChannelAsync(string ChannelName)
        {
            var headers = new NameValueCollection();
            headers["X-RequestDigest"] = await GetRequestDigestAsync();
            headers["Content-Type"] = "application/json;odata=verbose";

            string body = string.Format("{{ 'siteInfo' : {{'__metadata':{{ 'type':'SP.Publishing.PublishSiteInformation' }}, 'Title':'{0}', 'SiteType':'4'}}}}", ChannelName);

            Uri createChannelRestUri = new Uri(string.Format("{0}/publishingsitemanager/Create", _baseVideoApiUrl));

            XmlDocument result1 = await GetResponseAsync(HttpMethod.POST, createChannelRestUri, headers, System.Text.Encoding.UTF8.GetBytes(body));

            int counter = 10;
            Uri checkStatusRestUri = new Uri(string.Format("{0}/publishingsitemanager/GetSiteStatus?siteInfo={{\"Title\":\"{1}\",\"SiteType\":4}}", _baseVideoApiUrl, ChannelName));
            while (counter-- > 0)
            {
                XmlDocument result2 = await GetResponseAsync(HttpMethod.GET, checkStatusRestUri);

                XmlNamespaceManager nsmgr = new XmlNamespaceManager(result2.NameTable);
                nsmgr.AddNamespace("d", "http://schemas.microsoft.com/ado/2007/08/dataservices");

                if (result2.SelectSingleNode("//d:Status", nsmgr) != null && result2.SelectSingleNode("//d:Status", nsmgr).InnerText == "2")
                {
                    return result2.SelectSingleNode("//d:SiteId", nsmgr).InnerText;
                }

                System.Threading.Thread.Sleep(30 * 1000);
            }

            return string.Empty;
        }

        public async Task<NameValueCollection[]> GetVideosAsync(string ChannelName, string Id)
        {
            List<NameValueCollection> videos = new List<NameValueCollection>();

            string ChannelUrl = await GetChannelUrlAsync(ChannelName);

            if (string.IsNullOrEmpty(ChannelUrl)) return videos.ToArray();

            XmlDocument xdt = await GetResponseAsync(HttpMethod.GET, new Uri(string.Format("{0}/Videos", ChannelUrl)));

            XmlNamespaceManager nsmgr = new XmlNamespaceManager(xdt.NameTable);
            nsmgr.AddNamespace("a", "http://www.w3.org/2005/Atom");
            nsmgr.AddNamespace("d", "http://schemas.microsoft.com/ado/2007/08/dataservices");

            foreach (XmlNode node in xdt.SelectNodes("//a:entry", nsmgr))
            {
                var title = node.SelectSingleNode(".//d:Title", nsmgr).InnerText;
                var match = Regex.Match(title, @"(?is)(?<=\[)(.*)(?=\])");
                if (match.Success && match.Captures[0].Value == Id)
                {
                    NameValueCollection videoObject = new NameValueCollection();
                    videoObject["Title"] = node.SelectSingleNode(".//d:Title", nsmgr).InnerText;
                    videoObject["ThumbnailUrl"] = node.SelectSingleNode(".//d:ThumbnailUrl", nsmgr).InnerText;
                    videoObject["YammerObjectUrl"] = node.SelectSingleNode(".//d:YammerObjectUrl", nsmgr).InnerText;
                    videos.Add(videoObject);
                }
            }

            return videos.ToArray();
        }

        public async Task UploadVideoAsync(string ChannelName, string PhysicalPath, string Title, string Description)
        {
            if (!File.Exists(PhysicalPath))
            {
                return;
            }

            FileStream fs = new FileStream(PhysicalPath, FileMode.Open, FileAccess.Read);
            byte[] binaryArray = new byte[fs.Length];
            fs.Read(binaryArray, 0, binaryArray.Length);
            fs.Close();

            string fileName = System.DateTime.Now.Ticks.ToString() + "_" + PhysicalPath.Split('\\').Last();

            string ChannelUrl = await GetChannelUrlAsync(ChannelName);

            if (string.IsNullOrEmpty(ChannelUrl))
            {
                return;
            }

            string location = string.Format("{0}/Videos", ChannelUrl);

            string uploadPostUrl = await CreateVideoPlaceHolderAsync(location, Title, Description, fileName);

            if (string.IsNullOrEmpty(uploadPostUrl))
            {
                return;
            }

            var headers = new NameValueCollection();

            headers["X-RequestDigest"] = await GetRequestDigestAsync();

            await GetResponseAsync(HttpMethod.POST, new Uri(uploadPostUrl), headers, binaryArray);
        }

        enum HttpMethod
        {
            POST,
            GET
        }
    }

}