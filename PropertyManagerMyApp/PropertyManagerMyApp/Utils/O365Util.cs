using Microsoft.IdentityModel.Clients.ActiveDirectory;
using Microsoft.Office365.OutlookServices;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.Office365.Discovery;
using System.Security.Claims;

namespace SuiteLevelWebApp.Utils
{
    public static class O365Util
    {
        private static IDictionary<string, CapabilityDiscoveryResult> capabilityDiscoveryResults;

        /// <summary>
        /// GetAccessToken
        /// </summary>
        /// <param name="capacity"></param>
        /// <exception cref="AdalException">AdalException</exception>
        /// <returns>Access Token</returns>
        public static async Task<string> GetAccessToken(Capabilities capability)
        {
            var result = await GetCapabilityDiscoveryResult(capability.ToString());
            return await GetAccessTokenCore(result.ServiceResourceId);
        }

        /// <summary>
        /// GetAccessTokenByResource
        /// </summary>
        /// <param name="resource"></param>
        /// <exception cref="AdalException">AdalException</exception>
        /// <returns>Access Token</returns>
        public static async Task<string> GetAccessToken(string resource)
        {
            return await GetAccessTokenCore(resource.ToString());
        }

        /// <summary>
        /// GetOutlookClient
        /// </summary>
        /// <param name="capability"></param>
        /// <exception cref="AdalException">AdalException</exception>
        /// <returns>OutlookServicesClient</returns>
        public static async Task<OutlookServicesClient> GetOutlookClient(string capability)
        {
            var result = await GetCapabilityDiscoveryResult(capability);

            return new OutlookServicesClient(result.ServiceEndpointUri,
                async () => await GetAccessTokenCore(result.ServiceResourceId));
        }

        /// <summary>
        /// GetOutlookClient
        /// </summary>
        /// <param name="capability"></param>
        /// <exception cref="AdalException">AdalException</exception>
        /// <returns>OutlookServicesClient</returns>
        public static async Task<OutlookServicesClient> GetOutlookClient(Capabilities capability)
        {
            return await GetOutlookClient(capability.ToString());
        }

        public static async Task<Uri> GetServiceEndpointUri(Capabilities capability)
        {
            var result = await GetCapabilityDiscoveryResult(capability.ToString());
            return result.ServiceEndpointUri;
        }

        private static async Task<string> GetAccessTokenCore(string resource)
        {
            var userObjectId = ClaimsPrincipal.Current.FindFirst("http://schemas.microsoft.com/identity/claims/objectidentifier").Value;
            var context = GetAuthenticationContext();

            var token = await context.AcquireTokenSilentAsync(
                resource,
                new ClientCredential(AADAppSettings.ClientId, AADAppSettings.AppKey),
                new UserIdentifier(userObjectId, UserIdentifierType.UniqueId));
            return token.AccessToken;
        }

        private static AuthenticationContext GetAuthenticationContext()
        {
            var signInUserId = ClaimsPrincipal.Current.FindFirst(ClaimTypes.NameIdentifier).Value;
            var tenantId = ClaimsPrincipal.Current.FindFirst("http://schemas.microsoft.com/identity/claims/tenantid").Value;

            return new AuthenticationContext(
                string.Format("{0}/{1}", AADAppSettings.AuthorizationUri, tenantId),
                new NaiveSessionCache(signInUserId));
        }

        private static async Task<CapabilityDiscoveryResult> GetCapabilityDiscoveryResult(string capability)
        {
            if (capabilityDiscoveryResults == null)
                capabilityDiscoveryResults = await DiscoverCapabilities();
            return capabilityDiscoveryResults[capability];
        }

        private static async Task<IDictionary<string, CapabilityDiscoveryResult>> DiscoverCapabilities()
        {
            var resource = AADAppSettings.DiscoveryServiceResourceId;
            var discoveryClient = new DiscoveryClient(
               AADAppSettings.DiscoveryServiceEndpointUri,
               async () => await GetAccessTokenCore(resource));
            return await discoveryClient.DiscoverCapabilitiesAsync();
        }
    }
}