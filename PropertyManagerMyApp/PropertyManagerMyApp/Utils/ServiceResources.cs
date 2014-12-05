using System.Configuration;

namespace SuiteLevelWebApp.Utils
{
    public static class ServiceResources
    {
        public static readonly string DemoSite = ConfigurationManager.AppSettings["DemoSiteServiceResourceId"];
        public static readonly string Admin = ConfigurationManager.AppSettings["ServiceResourceId"];
        public static readonly string Dashboard = ConfigurationManager.AppSettings["DashboardServiceResourceId"];
    }
}