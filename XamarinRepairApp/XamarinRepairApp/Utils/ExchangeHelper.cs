using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Json;
using System.Threading.Tasks;
using System.Net;

namespace XamarinRepairApp.Utils
{
    public class ExchangeHelper
    {
        public static async Task<bool> SendEmail(string subject, string[] to, string[] cc, string body)
        {
            bool success = false;
            try
            {
                string requestUrl = string.Format("{0}/me/sendmail", Constants.ENDPOINT_ID);
                string toString = string.Empty;
                for (int i = 0; i < to.Count(); i++)
                {
                    toString += "{\"EmailAddress\": {\"Address\": \"" + to[i] + "\"}}";
                    if (i != to.Count() - 1)
                    {
                        toString += ",";
                    }
                }
                string ccString = string.Empty;
                for (int i = 0; i < cc.Count(); i++)
                {
                    ccString += "{\"EmailAddress\": {\"Address\": \"" + cc[i] + "\"}}";
                    if (i != cc.Count() - 1)
                    {
                        ccString += ",";
                    }
                }
                string postString = "{\"Message\": {\"Subject\": \"" + subject + "\",\"Body\": {\"ContentType\": \"HTML\",\"Content\": \"" + body + "\"},\"ToRecipients\": [" + toString + "],\"CcRecipients\":[" + ccString + "]},\"SaveToSentItems\": \"false\"}";
                HttpWebRequest request = (HttpWebRequest)HttpWebRequest.Create(requestUrl);
                request.Method = "POST";
                request.ContentType = "application/json;odata=verbose";
                request.Headers.Add("Authorization", "Bearer " + App.ExchangeToken);
                byte[] btBodys = Encoding.UTF8.GetBytes(postString);
                request.GetRequestStream().Write(btBodys, 0, btBodys.Length);

                using (HttpWebResponse response = await request.GetResponseAsync() as HttpWebResponse)
                {
                    success = response.StatusCode == HttpStatusCode.OK || response.StatusCode == HttpStatusCode.Accepted;
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
