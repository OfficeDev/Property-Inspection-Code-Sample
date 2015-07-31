using System.Configuration;

namespace SuiteLevelWebApp.Utils
{
    public class AADAppSettings
    {
        private static string _clientId = ConfigurationManager.AppSettings["ida:ClientId"]
            ?? ConfigurationManager.AppSettings["ida:ClientID"];

        private static string _appKey = ConfigurationManager.AppSettings["ida:AppKey"]
            ?? ConfigurationManager.AppSettings["ida:Password"] ?? ConfigurationManager.AppSettings["ida:ClientSecret"];

        private static string _authorizationUri = ConfigurationManager.AppSettings["ida:AuthorizationUri"];

        private static string _authority = string.Format("{0}/common/", ConfigurationManager.AppSettings["ida:AuthorizationUri"]);

        private static string _graphResourceId = "https://graph.microsoft.com/"; 

        private static string _graphResourceUrl = "https://graph.microsoft.com/beta/";

        private static string _outlookResourceId = "https://outlook.office365.com/";

        private static string _outlookResourceUrl = "https://outlook.office365.com/api/v1.0/"; 

        private static string _oneNoteResourceId = "https://onenote.com/";

        private static string _oneNoteResourceUrl = "https://www.onenote.com/api/beta/"; 

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
                return _authorizationUri;
            }
        }

        public static string Authority
        {
            get
            {
                return _authority;
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

        public static string OutlookResourceId
        {
            get
            {
                return _outlookResourceId;
            }
        }

        public static string OutlookResourceUrl
        {
            get
            {
                return _outlookResourceUrl;
            }
        }

        public static string OneNoteResourceId
        {
            get
            {
                return _oneNoteResourceId;
            }
        }

        public static string OneNoteResourceUrl
        {
            get
            {
                return _oneNoteResourceUrl;
            }
        }
    }
}
