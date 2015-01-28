using System;
using Android.App;
using Android.Content;
using Android.Runtime;
using Android.Views;
using Android.Widget;
using Android.OS;
using Com.Microsoft.Aad.Adal;

namespace XamarinRepairApp
{
    [Activity(Label = "XamarinOffice365.Android",
        Theme = "@style/NoTitle",
        MainLauncher = true,
        Icon = "@drawable/ic_repair")]
    [IntentFilter(new[] { Intent.ActionView },
        DataScheme = "repairapp",
        Categories = new[] { Intent.CategoryBrowsable, Intent.CategoryDefault })]

    public class MainActivity : Activity
    {
        static AuthenticationContext authContext;

        protected override void OnCreate(Bundle bundle)
        {
            base.OnCreate(bundle);

            // Set our view from the "main" layout resource
            SetContentView(Resource.Layout.Main);

            SetIncidentId();

            DefaultTokenCacheStore cache = new DefaultTokenCacheStore(this);

            authContext = new AuthenticationContext(this,
                Constants.AAD_AUTHORITY,
                false,
                cache);

            // Get our button from the layout resource,
            // and attach an event to it
            Button button = FindViewById<Button>(Resource.Id.signIn_btn);

            button.Click += delegate
            {
                authContext.AcquireToken(this,
                    Constants.SHAREPOINT_URL,
                    Constants.AAD_CLIENT_ID,
                    Constants.AAD_REDIRECT_URL,
                    PromptBehavior.RefreshSession,
                    new SignInCallback(this));
            };
        }

        protected override void OnActivityResult(int requestCode, Result resultCode, Intent data)
        {
            base.OnActivityResult(requestCode, resultCode, data);

            if (authContext != null)
            {
                authContext.OnActivityResult(requestCode, (int)resultCode, data);
            }
        }

        class SignInCallback : Java.Lang.Object, IAuthenticationCallback
        {
            Context context;

            public SignInCallback(Context ctx)
            {
                context = ctx;
            }

            public void OnError(Java.Lang.Exception exc)
            {
                AlertDialog.Builder builder = new AlertDialog.Builder(context);
                builder.SetTitle("Error");
                builder.SetMessage(exc.Message);
                builder.SetCancelable(true);
                builder.SetNegativeButton("Cancel", (EventHandler<DialogClickEventArgs>)null);

                var dialog = builder.Create();
                dialog.Show();

                var cancelBtn = dialog.GetButton((int)DialogButtonType.Negative);
                cancelBtn.Click += (sender, args) =>
                {
                    dialog.Dismiss();
                };
            }

            public void OnSuccess(Java.Lang.Object result)
            {
                AuthenticationResult aresult = result.JavaCast<AuthenticationResult>();
                if (aresult != null)
                {
                    App.Token = aresult.AccessToken;

                    authContext.AcquireToken((Activity)context,
                        Constants.EXCHANGE_RESOURCE_ID,
                        Constants.AAD_CLIENT_ID,
                        Constants.AAD_REDIRECT_URL,
                        PromptBehavior.RefreshSession,
                        new ExchangeCallback((Activity)context));
                }
            }
        }

        class ExchangeCallback : Java.Lang.Object, IAuthenticationCallback
        {
            Context context;

            public ExchangeCallback(Context ctx)
            {
                context = ctx;
            }

            public void OnError(Java.Lang.Exception exc)
            {
                AlertDialog.Builder builder = new AlertDialog.Builder(context);
                builder.SetTitle("Error");
                builder.SetMessage(exc.Message);
                builder.SetCancelable(true);
                builder.SetNegativeButton("Cancel", (EventHandler<DialogClickEventArgs>)null);

                var dialog = builder.Create();
                dialog.Show();

                var cancelBtn = dialog.GetButton((int)DialogButtonType.Negative);
                cancelBtn.Click += (sender, args) =>
                {
                    dialog.Dismiss();
                };
            }

            public void OnSuccess(Java.Lang.Object result)
            {
                AuthenticationResult aresult = result.JavaCast<AuthenticationResult>();
                if (aresult != null)
                {
                    App.ExchangeToken = aresult.AccessToken;
                    SignInComplete(aresult, context);
                }
            }
        }

        private void SetIncidentId()
        {
            String incidentId = "25";
            try
            {
                if (Intent.Data != null && Intent.Data.Host != null)
                {
                    int _id = 0;
                    if (int.TryParse(Intent.Data.Host, out _id))
                    {
                        if (_id > 0)
                        {
                            incidentId = _id.ToString();
                        }
                    }
                }
            }
            catch (Exception)
            {
                incidentId = "25";
            }
            App.IncidentId = incidentId;
        }

        public static void SignInComplete(AuthenticationResult aresult, Context context)
        {
            App.AuthenticationContext = authContext;

            context.StartActivity(typeof(IncidentActivity));
            ((Activity)context).Finish();
        }
    }
}

