using System.Configuration;

namespace SuiteLevelWebApp.Utils
{
    public static class AppSettings
    {
        public static readonly string AdminSiteServiceResourceId = ConfigurationManager.AppSettings["ServiceResourceId"];

        public static readonly string DemoSiteServiceResourceId = ConfigurationManager.AppSettings["DemoSiteServiceResourceId"];
        public static readonly string DemoSiteCollectionUrl = ConfigurationManager.AppSettings["DemoSiteCollectionUrl"];
        public static readonly string DemoSiteCollectionOwner = ConfigurationManager.AppSettings["DemoSiteCollectionOwner"];

        public static readonly string DispatcherName = ConfigurationManager.AppSettings["DispatcherName"];
        public static readonly string DispatcherEmail = ConfigurationManager.AppSettings["DispatcherEmail"];

        public static readonly string VideoPortalEndpointUri = ConfigurationManager.AppSettings["VideoPortalEndpointUri"];
        public static readonly string VideoPortalIncidentsChannelName = ConfigurationManager.AppSettings["VideoPortalIncidentsChannelName"];
        public static readonly string VideoPortalInspectionsChannelName = ConfigurationManager.AppSettings["VideoPortalInspectionsChannelName"];
        public static readonly string VideoPortalRepairsChannelName = ConfigurationManager.AppSettings["VideoPortalRepairsChannelName"];
    }
}