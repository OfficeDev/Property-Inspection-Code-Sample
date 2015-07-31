using Microsoft.Graph;
using Microsoft.IdentityModel.Clients.ActiveDirectory;
using Microsoft.Office365.OutlookServices;
using Microsoft.SharePoint.Client;
using System;
using System.Security.Claims;
using System.Threading.Tasks;

namespace SuiteLevelWebApp.Utils
{
    internal class AuthenticationHelper
    {
        #region Get Service Client

        public static async Task<GraphService> GetGraphServiceAsync()
        {
            var serviceRoot = GetGraphServiceRoot();

            var accessToken = GetAccessTokenAsync(AADAppSettings.GraphResourceId);
            // AdalException thrown by GetAccessTokenAsync is swallowed 
            // by GraphService so we need to wait here.
            await accessToken;
            return new GraphService(serviceRoot, () => accessToken);
        }

        public static async Task<OutlookServicesClient> GetOutlookServiceAsync()
        {
            var serviceRoot = new Uri(AADAppSettings.OutlookResourceUrl);
            var accessToken = GetAccessTokenAsync(AADAppSettings.OutlookResourceId);
            // AdalException thrown by GetAccessTokenAsync ise swallowed 
            // by EntityContainer so we need to wait here.
            await accessToken;
            return new OutlookServicesClient(serviceRoot, () => accessToken);
        }
        
        public static Task<ClientContext> GetDemoSiteClientContextAsync()
        {
            return AuthenticationHelper.GetSharePointClientContextAsync(
                AppSettings.DemoSiteServiceResourceId, 
                AppSettings.DemoSiteCollectionUrl);
        }

        public static Task<ClientContext> GetAdminSiteClientContextAsync()
        {
            return AuthenticationHelper.GetSharePointClientContextAsync(
                AppSettings.AdminSiteServiceResourceId,
                AppSettings.AdminSiteServiceResourceId);
        }
        
        public static async Task<ClientContext> GetSharePointClientContextAsync(string resource, string targetUrl)
        {
            var token = await AuthenticationHelper.GetAccessTokenAsync(resource);
            var clientContext = new ClientContext(targetUrl)
            {
                AuthenticationMode = ClientAuthenticationMode.Anonymous,
                FormDigestHandlingEnabled = false
            };
            clientContext.ExecutingWebRequest += (sender, args) =>
                    args.WebRequestExecutor.RequestHeaders["Authorization"] = "Bearer " + token;
            return clientContext;
        }

        #endregion

        #region Get Access Token

        public static string GetAccessToken(string resource)
        {
            var clientCredential = new ClientCredential(AADAppSettings.ClientId, AADAppSettings.AppKey);

            var userObjectId = ClaimsPrincipal.Current.FindFirst("http://schemas.microsoft.com/identity/claims/objectidentifier").Value;
            var userIdentifier = new UserIdentifier(userObjectId, UserIdentifierType.UniqueId);

            var context = GetAuthenticationContext();
            var token = context.AcquireTokenSilent(resource, clientCredential, userIdentifier);
            return token.AccessToken;
        }

        public static async Task<string> GetAccessTokenAsync(string resource)
        {
            var clientCredential = new ClientCredential(AADAppSettings.ClientId, AADAppSettings.AppKey);

            var userObjectId = ClaimsPrincipal.Current.FindFirst("http://schemas.microsoft.com/identity/claims/objectidentifier").Value;
            var userIdentifier = new UserIdentifier(userObjectId, UserIdentifierType.UniqueId);

            var context = GetAuthenticationContext();
            var token = await context.AcquireTokenSilentAsync(resource, clientCredential, userIdentifier);
            return token.AccessToken;
        }

        public static async Task<string> GetGraphAccessTokenAsync()
        {
            return await GetAccessTokenAsync(AADAppSettings.GraphResourceId);
        }

        public static async Task<string> GetOutlookAccessTokenAsync()
        {
            return await GetAccessTokenAsync(AADAppSettings.OutlookResourceId);
        }

        public static async Task<string> GetOneNoteAccessTokenAsync()
        {
            //To provision and run the demo without OneNote uncomment the next 
            //line and comment out the line of code currently used in this method.
            //return await Task.FromResult("");
            return await GetAccessTokenAsync(AADAppSettings.OneNoteResourceId);
        }

        #endregion

        #region Private methods

        private static Uri GetGraphServiceRoot()
        {
            var servicePointUri = new Uri(AADAppSettings.GraphResourceUrl);
            var tenantId = ClaimsPrincipal.Current.FindFirst("http://schemas.microsoft.com/identity/claims/tenantid").Value;
            return new Uri(servicePointUri, tenantId);
        }

        private static AuthenticationContext GetAuthenticationContext()
        {
            var tenantId = ClaimsPrincipal.Current.FindFirst("http://schemas.microsoft.com/identity/claims/tenantid").Value;
            var authority = string.Format("{0}/{1}", AADAppSettings.AuthorizationUri, tenantId);

            var signInUserId = ClaimsPrincipal.Current.FindFirst(ClaimTypes.NameIdentifier).Value;
            var tokenCache = new NaiveSessionCache(signInUserId);

            return new AuthenticationContext(authority, tokenCache);
        }

        #endregion
    }
}