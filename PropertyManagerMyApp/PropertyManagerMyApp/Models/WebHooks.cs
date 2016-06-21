using System;
using System.Collections.Generic;
using System.Linq;
using System.IO;
using System.Web;
using System.Configuration;
using System.Threading.Tasks;
using System.Web.Mvc;
using System.Net.Http;
using System.Net.Http.Headers;
using Newtonsoft.Json;
using SuiteLevelWebApp.Utils;


namespace SuiteLevelWebApp.Models
{
    #region models
    public class NotificationItem
    {
        public string changeType { get; set; }
        public string clientState { get; set; }
        public string resource { get; set; }

        public string expirationDateTime { get; set; }
        public string subscriptionId { get; set; }
        public ResourceData resourceData { get; set; }
    }
    public class ResourceData
    {

        [JsonProperty(PropertyName = "id")]
        public string Id { get; set; }

        [JsonProperty(PropertyName = "@odata.etag")]
        public string ODataEtag { get; set; }

        [JsonProperty(PropertyName = "@odata.id")]
        public string ODataId { get; set; }

        [JsonProperty(PropertyName = "@odata.type")]
        public string ODataType { get; set; }
    }

    public class Notification
    {
        public NotionficationToClientItem[] value { get; set; }
    }
    public class NotionficationToClientItem
    {
        public string resource { get; set; }
        public string changeType { get; set; }
    }

    #endregion
}