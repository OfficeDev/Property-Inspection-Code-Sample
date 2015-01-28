using System;
using System.Configuration;


namespace SuiteLevelWebApp.Utils
{
    public class AADAppSettings
    {

        private static string _clientId = ConfigurationManager.AppSettings["ida:ClientId"] 
            ?? ConfigurationManager.AppSettings["ida:ClientID"];

        private static string _appKey = ConfigurationManager.AppSettings["ida:AppKey"] 
            ?? ConfigurationManager.AppSettings["ida:Password"]; 

        private static string _authorizationUri = ConfigurationManager.AppSettings["ida:AuthorizationUri"];

        private static string _graphResourceId = "https://graph.windows.net/";

        private static string _authority = string.Format("{0}/common/", ConfigurationManager.AppSettings["ida:AuthorizationUri"]);

        private static string _discoverySvcResourceId = "https://api.office.com/discovery/";

        private static string _discoverySvcEndpointUri = "https://api.office.com/discovery/me/";

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

        public static string AADGraphResourceId
        {
            get
            {
                return _graphResourceId;
            }
        }

        public static string DiscoveryServiceResourceId
        {
            get
            {
                return _discoverySvcResourceId;
            }
        }

        public static Uri DiscoveryServiceEndpointUri
        {
            get
            {
                return new Uri(_discoverySvcEndpointUri);
            }
        }
    }
}
