using System;
using Android.App;
using Android.Content;
using Android.Runtime;
using Android.Views;
using Android.Widget;
using Android.OS;
using Microsoft.IdentityModel.Clients.ActiveDirectory;
using System.Threading.Tasks;
using Microsoft.Graph;

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
        protected override void OnCreate(Bundle bundle)
        {
            base.OnCreate(bundle);

            // Set our view from the "main" layout resource
            SetContentView(Resource.Layout.Main);

            SetIncidentId();

            // Get our button from the layout resource,
            // and attach an event to it
            Button button = FindViewById<Button>(Resource.Id.signIn_btn);
            button.Click += OnSignInButtonClick;
        }

        private async void OnSignInButtonClick(object sender, EventArgs args)
        {
            try
            {
				App.Token = await AuthenticationHelper.GetAccessTokenAsync(this, Constants.SHAREPOINT_URL);

				App.GraphService = await AuthenticationHelper.GetGraphServiceAsync (this);
            }
            catch (Exception ex)
            {
                ShowErrorDialog(ex);
                return;
            }

            this.StartActivity(typeof(IncidentActivity));
            ((Activity)this).Finish();
        }

        private void ShowErrorDialog(Exception ex)
        {
            AlertDialog.Builder builder = new AlertDialog.Builder(this);
            builder.SetTitle("Error");
            builder.SetMessage(ex.Message);
            builder.SetCancelable(true);
            builder.SetNegativeButton("Cancel", (EventHandler<DialogClickEventArgs>)null);

            var dialog = builder.Create();
            dialog.Show();

            var cancelBtn = dialog.GetButton((int)DialogButtonType.Negative);
            cancelBtn.Click += (sender, args) => dialog.Dismiss();
        }

        protected override void OnActivityResult(int requestCode, Result resultCode, Intent data)
        {
            base.OnActivityResult(requestCode, resultCode, data);
            AuthenticationAgentContinuationHelper.SetAuthenticationAgentContinuationEventArgs(requestCode, resultCode, data);
        }

        private void SetIncidentId()
        {
            int id;
			if (Intent.Data == null || Intent.Data.Host == null || int.TryParse (Intent.Data.Host, out id) || id <= 0) {
				id = -1;
			}
            App.IncidentId = id;
        }
    }
}