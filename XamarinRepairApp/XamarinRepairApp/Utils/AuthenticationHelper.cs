using System;
using Microsoft.Graph;
using System.Threading.Tasks;
using Microsoft.IdentityModel.Clients.ActiveDirectory;
using Android.App;

namespace XamarinRepairApp
{
	public class AuthenticationHelper
	{
		private static TokenCache tokenCache = new TokenCache();
		private static AuthenticationContext authContext = new AuthenticationContext(Constants.AAD_AUTHORITY, false, tokenCache);

		public static async Task<GraphService> GetGraphServiceAsync(Activity activity)
		{
			var rootUri = new Uri (Constants.GraphResourceUrl + Constants.DISPATCHEREMAIL.Split('@')[1]);
			var accessToken = GetAccessTokenAsync (activity, Constants.GraphResourceId);
			await accessToken;
			return new GraphService(rootUri, () => accessToken);
		}

		public static async Task<string> GetAccessTokenAsync(Activity activity, string resource)
		{
			var aresult = authContext.AcquireTokenAsync(
				resource,
				Constants.AAD_CLIENT_ID,
				new Uri(Constants.AAD_REDIRECT_URL),
				new PlatformParameters(activity));
			return (await aresult).AccessToken;
		}

		public static async Task<string> GetGraphAccessTokenAsync(Activity activity)
		{
			var accessToken = GetAccessTokenAsync (activity, Constants.GraphResourceId);
			return await accessToken;
		}
	}
}