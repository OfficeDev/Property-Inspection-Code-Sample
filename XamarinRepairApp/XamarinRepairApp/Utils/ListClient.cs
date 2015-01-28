using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net;
using System.Json;
using System.Threading.Tasks;

using Android.App;
using Android.Content;
using Android.OS;
using Android.Runtime;
using Android.Views;
using Android.Widget;
using System.IO;
using Android.Graphics;

namespace XamarinRepairApp.Utils
{
    public class ListClient
    {
        static string Url = Constants.SHAREPOINT_URL + Constants.SHAREPOINT_SITE_PATH + "/_api/lists";
        public static async Task<List<ListItem>> GetListItems(string listName, string select, string expand, int top, string filter, string orderBy)
        {
            List<ListItem> listItems = new List<ListItem>();
            try
            {
                string requestUrl = string.Format("{0}/GetByTitle('{1}')/Items", Url, listName);
                if (!string.IsNullOrEmpty(select))
                {
                    requestUrl += string.Format("?$select={0}", select);
                }
                if (!string.IsNullOrEmpty(expand))
                {
                    requestUrl += string.Format("&$expand={0}", expand);
                }
                if (top > 0)
                {
                    requestUrl += string.Format("&$top={0}", top);
                }
                if (!string.IsNullOrEmpty(filter))
                {
                    requestUrl += string.Format("&$filter={0}", filter.Replace(" ", "%20"));
                }
                if (!string.IsNullOrEmpty(orderBy))
                {
                    requestUrl += string.Format("&$orderby={0}", orderBy.Replace(" ", "%20"));
                }

                HttpWebRequest request = (HttpWebRequest)HttpWebRequest.Create(requestUrl);
                request.Method = "GET";
                request.Accept = "application/json; odata=verbose";
                request.Headers.Add("Authorization", "Bearer " + App.Token);

                using (HttpWebResponse response = await request.GetResponseAsync() as HttpWebResponse)
                {
                    if (response.StatusCode == HttpStatusCode.OK)
                    {
                        using (StreamReader stream = new StreamReader(response.GetResponseStream()))
                        {
                            string content = await stream.ReadToEndAsync();
                            JsonValue jsonValue = JsonValue.Parse(content);
                            if (jsonValue.ContainsKey("d") && jsonValue["d"].ContainsKey("results"))
                            {
                                for (int i = 0; i < jsonValue["d"]["results"].Count; i++)
                                {
                                    listItems.Add(new ListItem(jsonValue["d"]["results"][i]));
                                }
                            }
                        }
                    }
                }
            }
            catch (Exception)
            {
                listItems = new List<ListItem>();
            }

            return listItems;
        }

        public static async Task<string> GetFileServerRelativeUrl(string listName, int id)
        {
            string serverRelativeUrl = string.Empty;
            try
            {
                string requestUrl = string.Format("{0}/GetByTitle('{1}')/Items({2})/File?$select=ServerRelativeUrl", Url, listName, id);
                HttpWebRequest request = (HttpWebRequest)HttpWebRequest.Create(requestUrl);
                request.Method = "GET";
                request.Accept = "application/json; odata=verbose";
                request.Headers.Add("Authorization", "Bearer " + App.Token);

                using (HttpWebResponse response = await request.GetResponseAsync() as HttpWebResponse)
                {
                    if (response.StatusCode == HttpStatusCode.OK)
                    {
                        using (StreamReader stream = new StreamReader(response.GetResponseStream()))
                        {
                            string content = await stream.ReadToEndAsync();
                            JsonValue jsonValue = JsonValue.Parse(content);
                            if (jsonValue.ContainsKey("d") && jsonValue["d"].ContainsKey("ServerRelativeUrl"))
                            {
                                serverRelativeUrl = Helper.GetString(jsonValue["d"]["ServerRelativeUrl"]);
                            }
                        }
                    }
                }
            }
            catch (Exception)
            {
                serverRelativeUrl = string.Empty;
            }

            return serverRelativeUrl;
        }

        public static async Task<Bitmap> GetFile(string serverRelativeUrl)
        {
            Bitmap bitmap = null;
            try
            {
                string requestUrl = string.Format("{0}/_api/web/GetFileByServerRelativeUrl('{1}')/$value", Constants.SHAREPOINT_URL + Constants.SHAREPOINT_SITE_PATH, serverRelativeUrl);
                HttpWebRequest request = (HttpWebRequest)HttpWebRequest.Create(requestUrl);
                request.Method = "GET";
                request.Headers.Add("Authorization", "Bearer " + App.Token);

                using (HttpWebResponse response = await request.GetResponseAsync() as HttpWebResponse)
                {
                    if (response.StatusCode == HttpStatusCode.OK)
                    {
                        using (Stream stream = response.GetResponseStream())
                        {
                            if (stream != null)
                            {
                                bitmap = await BitmapFactory.DecodeStreamAsync(stream);
                            }
                        }
                    }
                }
            }
            catch (Exception)
            {
                bitmap = null;
            }

            return bitmap;
        }

        public static async Task<bool> UploadPhoto(string listName, string imageName, Bitmap bitmap)
        {
            bool success = false;
            try
            {
                string requestUrl = string.Format("{0}/_api/web/GetFolderByServerRelativeUrl('{1}')/Files/add(url='{2}',overwrite=true)", Constants.SHAREPOINT_URL + Constants.SHAREPOINT_SITE_PATH, listName, imageName);
                HttpWebRequest request = (HttpWebRequest)HttpWebRequest.Create(requestUrl);
                request.Method = "POST";
                request.Accept = "image/png, image/svg+xml, image/*;q=0.8, */*;q=0.5";
                request.ContentType = "application/octet-stream";
                request.Headers.Add("Authorization", "Bearer " + App.Token);
                Stream requestStream = request.GetRequestStream();
                MemoryStream outputStearm = new MemoryStream();
                await bitmap.CompressAsync(Bitmap.CompressFormat.Jpeg, 100, outputStearm);
                byte[] bytes = outputStearm.ToArray();
                await requestStream.WriteAsync(bytes, 0, bytes.Length);

                using (HttpWebResponse response = await request.GetResponseAsync() as HttpWebResponse)
                {
                    if (response.StatusCode == HttpStatusCode.OK)
                    {
                        success = true;
                    }
                }
            }
            catch (Exception)
            {
                success = false;
            }

            return success;
        }

        public static async Task<int> GetFileId(string listName, string imageName)
        {
            int fileId = 0;
            try
            {
                string requestUrl = string.Format("{0}/_api/web/GetFolderByServerRelativeUrl('{1}')/Files('{2}')/ListItemAllFields", Constants.SHAREPOINT_URL + Constants.SHAREPOINT_SITE_PATH, listName, imageName);
                HttpWebRequest request = (HttpWebRequest)HttpWebRequest.Create(requestUrl);
                request.Method = "GET";
                request.Accept = "application/json; odata=verbose";
                request.Headers.Add("Authorization", "Bearer " + App.Token);

                using (HttpWebResponse response = await request.GetResponseAsync() as HttpWebResponse)
                {
                    if (response.StatusCode == HttpStatusCode.OK)
                    {
                        using (StreamReader stream = new StreamReader(response.GetResponseStream()))
                        {
                            string content = await stream.ReadToEndAsync();
                            JsonValue jsonValue = JsonValue.Parse(content);
                            if (jsonValue.ContainsKey("d"))
                            {
                                fileId = Helper.GetInt(jsonValue["d"]["Id"]);
                            }
                        }
                    }
                }
            }
            catch (Exception)
            {
                fileId = 0;
            }

            return fileId;
        }

        public static async Task<bool> UpdateListItem(string type, string metadata, string listName, int itemId)
        {
            bool success = false;
            try
            {
                string requestUrl = string.Format("{0}/GetByTitle('{1}')/items({2})", Url, listName, itemId);
                string postString = "{'__metadata': {'type': '" + type + "'}, " + metadata + "}";
                HttpWebRequest request = (HttpWebRequest)HttpWebRequest.Create(requestUrl);
                request.Method = "POST";
                request.ContentType = "application/json;odata=verbose";
                request.Headers.Add("Authorization", "Bearer " + App.Token);
                request.Headers.Add("If-Match", "*");
                request.Headers.Add("X-HTTP-Method", "MERGE");
                byte[] btBodys = Encoding.UTF8.GetBytes(postString);
                request.GetRequestStream().Write(btBodys, 0, btBodys.Length);

                using (HttpWebResponse response = await request.GetResponseAsync() as HttpWebResponse)
                {
                    success = response.StatusCode == HttpStatusCode.OK || response.StatusCode == HttpStatusCode.NoContent;
                }
            }
            catch (Exception)
            {
                success = false;
            }

            return success;
        }
    }
}