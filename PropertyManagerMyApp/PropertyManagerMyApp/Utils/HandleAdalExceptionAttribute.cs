using Microsoft.IdentityModel.Clients.ActiveDirectory;
using Microsoft.Owin.Security;
using Microsoft.Owin.Security.OpenIdConnect;
using System.Web;
using System.Web.Mvc;

namespace SuiteLevelWebApp.Utils
{
    public class HandleAdalExceptionAttribute: ActionFilterAttribute, IExceptionFilter
    {
        public void OnException(ExceptionContext filterContext)
        {
            if (filterContext.Exception is AdalException)
            {
                var httpContext = HttpContext.Current;
                var requestUrl = httpContext.Request.Url.ToString();
                
                httpContext.GetOwinContext().Authentication.Challenge(
                     new AuthenticationProperties { RedirectUri = requestUrl },
                     OpenIdConnectAuthenticationDefaults.AuthenticationType);

                filterContext.ExceptionHandled = true;
            }
        }
    }
}