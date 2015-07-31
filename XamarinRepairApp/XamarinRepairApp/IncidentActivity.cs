using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Android.App;
using Android.Content;
using Android.OS;
using Android.Runtime;
using Android.Views;
using Android.Widget;
using Android.Graphics;
using XamarinRepairApp.Utils;
using XamarinRepairApp.Model;

namespace XamarinRepairApp
{
    [Activity(Label = "IncidentActivity")]
    public class IncidentActivity : Activity
    {
        List<IncidentModel> incidents;
        private ProgressDialog process;
        private ListView listView;
        private IncidentAdapter adapter;

        protected override void OnCreate(Bundle bundle)
        {
            base.OnCreate(bundle);
            SetContentView(Resource.Layout.Incident);

            listView = (ListView)FindViewById(Resource.Id.incident_list);

            LoadData();
        }

        #region data binding

        private void BindPropertyData()
        {
            ((TextView)FindViewById(Resource.Id.incident_propertyName)).SetText("Property Name: " + incidents[0].GetProperty().GetTitle(), TextView.BufferType.Normal);
            ((TextView)FindViewById(Resource.Id.incident_propertyOwner)).SetText("Owner: " + incidents[0].GetProperty().GetOwner(), TextView.BufferType.Normal);
            ((TextView)FindViewById(Resource.Id.incident_propertyAddress)).SetText(incidents[0].GetProperty().GetAddress1(), TextView.BufferType.Normal);
            ((TextView)FindViewById(Resource.Id.incident_contactOwner)).SetText(incidents[0].GetProperty().GetEmail(), TextView.BufferType.Normal);
            ((TextView)FindViewById(Resource.Id.incident_contactOffice)).SetText(Constants.DISPATCHEREMAIL, TextView.BufferType.Normal);

            ((TextView)FindViewById(Resource.Id.incident_contactOwner)).Click += delegate
            {
                SendEmail(incidents[0].GetProperty().GetEmail());
            };
            ((TextView)FindViewById(Resource.Id.incident_contactOffice)).Click += delegate
            {
                SendEmail(Constants.DISPATCHEREMAIL);
            };
        }

        private void BindIncidentData()
        {
            adapter = new IncidentAdapter(this, incidents);
            listView.Adapter = adapter;
            listView.ItemClick += OnListItemClick;
        }

        #endregion

        #region async methods

        async void LoadData()
        {
            process = ProgressDialog.Show(this, "Loading", "Loading data from SharePoint List...");

			if (App.IncidentId == -1) {
				int availableIncidentId = await ListHelper.GetAvailableIncidentId ();
				if (availableIncidentId > 0) {
					App.IncidentId = availableIncidentId;
					process.Dismiss ();
					LoadData ();
					return;
				} else {
					Toast.MakeText (this, "Incident no found", ToastLength.Long).Show ();
				}
			} else {
				int propertyId = await ListHelper.GetPropertyIdByIncidentId();
				if (propertyId > 0)
				{
					App.PropertyId = propertyId.ToString();
					incidents = await ListHelper.GetIncidents();
					if (incidents != null && incidents.Any())
					{
						LoadPropertyPhoto();
						LoadIncidentPhoto();
						BindPropertyData();
						BindIncidentData();
					}
				}
				else
				{
					Toast.MakeText(this, "The incident with ID "+ App.IncidentId +" was not find.", ToastLength.Long).Show();
				}
			}

            process.Dismiss();
        }

        async void LoadPropertyPhoto()
        {
            Bitmap bitmap = await ListHelper.GetPropertyPhoto(Convert.ToInt32(App.PropertyId));
            if (bitmap != null)
            {
                ((ImageView)FindViewById(Resource.Id.incident_propertyLogo)).SetImageBitmap(bitmap);
            }
        }

        async void LoadIncidentPhoto()
        {
            for (int i = 0; i < incidents.Count; i++)
            {
                Bitmap bitmap = await ListHelper.GetIncidentPhoto(incidents[i].GetId(), incidents[i].GetInspectionId(), incidents[i].GetRoomId());
                if (bitmap != null)
                {
                    incidents[i].Image = bitmap;
                    incidents[i].ItemChanged = true;
                    adapter.NotifyDataSetChanged();
                }
            }
        }

        #endregion

        #region events

        void OnListItemClick(object sender, AdapterView.ItemClickEventArgs e)
        {
            App.SelectedIncidet = incidents[e.Position];
            StartActivityForResult(typeof(IncidentDetailActivity), 200);
        }

        private void SendEmail(String to)
        {
            Intent intent = new Intent(Android.Content.Intent.ActionSend);
            intent.SetType("plain/text");
            intent.PutExtra(Android.Content.Intent.ExtraEmail, new String[] { to });
            intent.PutExtra(Android.Content.Intent.ExtraSubject, "");
            intent.PutExtra(Android.Content.Intent.ExtraText, "Sent from Xamarin Android");
            Intent chooserIntent = Intent.CreateChooser(intent, "Send Email");
            StartActivity(chooserIntent);
        }

        #endregion

        protected override void OnActivityResult(int requestCode, Result resultCode, Intent data)
        {
            base.OnActivityResult(requestCode, resultCode, data);

            if (App.SelectedIncidet.HasChanged)
            {
                foreach (IncidentModel item in incidents)
                {
                    if (item.GetId() == App.SelectedIncidet.GetId())
                    {
                        item.SetStatus(App.SelectedIncidet.GetStatus());
                        item.SetRepairComments(App.SelectedIncidet.GetRepairComments());
                        item.ItemChanged = true;
                        adapter.NotifyDataSetChanged();
                        break;
                    }
                }
            }
        }
    }
}