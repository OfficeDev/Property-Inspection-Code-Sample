using System.Configuration;

namespace SuiteLevelWebApp.Utils
{
    public class AADAppSettings
    {
        private static string _clientId = ConfigurationManager.AppSettings["ida:ClientId"];
        private static string _appKey = ConfigurationManager.AppSettings["ida:ClientSecret"];
        private static string _authorizationUri = ConfigurationManager.AppSettings["ida:AADInstance"];
        private static string _authority = string.Format("{0}/common/", ConfigurationManager.AppSettings["ida:AADInstance"]);
        private static string _tenantId = ConfigurationManager.AppSettings["ida:TenantId"];

        private static string _graphResourceId = "https://graph.microsoft.com/";

        private static string _graphResourceUrl = "https://graph.microsoft.com/beta/";

        private static string _outlookUrl = "https://outlook.office.com/";

        private static string _officeUrl = "https://tasks.office.com/";

        public static string ClientId
        {
            get
            {
                return _clientId;
            }
        }

        public static string AppKey
        {
            get
            {
                return _appKey;
            }
        }

        public static string AuthorizationUri
        {
            get
            {
                return _authorizationUri.TrimEnd('/') + "/";
            }
        }

        public static string Authority
        {
            get
            {
                return _authority;
            }
        }

        public static string TenantId
        {
            get
            {
                return _tenantId;
            }
        }

        public static string GraphResourceId
        {
            get
            {
                return _graphResourceId;
            }
        }

        public static string GraphResourceUrl
        {
            get
            {
                return _graphResourceUrl;
            }
        }

        public static string OutlookUrl
        {
            get
            {
                return _outlookUrl;
            }
        }

        public static string OfficeUrl
        {
            get
            {
                return _officeUrl;
            }
        }
    }
}
