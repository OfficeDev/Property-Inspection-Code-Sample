using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using Android.App;
using Android.Content;
using Android.OS;
using Android.Runtime;
using Android.Views;
using Android.Widget;

using XamarinRepairApp.Model;
using XamarinRepairApp.Utils;

namespace XamarinRepairApp.Utils
{
    public class IncidentAdapter : BaseAdapter<IncidentModel>
    {
        private Activity context;
        private List<IncidentModel> incidents;
        private Dictionary<int, View> viewMap = new Dictionary<int, View>();

        public IncidentAdapter(Activity activity, List<IncidentModel> objects)
            : base()
        {
            context = activity;
            incidents = objects;
        }

        public override long GetItemId(int position)
        {
            return position;
        }

        public override IncidentModel this[int position]
        {
            get { return incidents[position]; }
        }

        public override int Count
        {
            get { return incidents.Count; }
        }

        public override View GetView(int position, View convertView, ViewGroup parent)
        {
            IncidentModel model = incidents[position];

            View rowView = null;
            if (this.viewMap.ContainsKey(position))
                rowView = this.viewMap[position];
            if (rowView == null || model.ItemChanged)
            {
                rowView = context.LayoutInflater.Inflate(Resource.Layout.Incident_item, null);

                String roomTitle = model.GetRoom().GetTitle();
                String repairDate = model.GetInspection().GetFinalized();
                String incidentTitle = model.GetTitle();
                String inspectionDate = model.GetInspection().GetDateTime();
                String approved = model.GetStatus();
                if (!string.IsNullOrEmpty(repairDate))
                {
                    repairDate = "Repair Date: " + repairDate;
                }
                if (!string.IsNullOrEmpty(approved))
                {
                    approved = "Approved: " + approved;
                }
                ((TextView)rowView.FindViewById(Resource.Id.incident_item1)).SetText("Room: " + roomTitle, TextView.BufferType.Normal);
                ((TextView)rowView.FindViewById(Resource.Id.incident_item2)).SetText(repairDate, TextView.BufferType.Normal);
                ((TextView)rowView.FindViewById(Resource.Id.incident_item3)).SetText("Incident: " + incidentTitle, TextView.BufferType.Normal);
                ((TextView)rowView.FindViewById(Resource.Id.incident_item4)).SetText("Inspection Date: " + inspectionDate, TextView.BufferType.Normal);
                ((TextView)rowView.FindViewById(Resource.Id.incident_item5)).SetText(approved, TextView.BufferType.Normal);

                if (model.Image != null)
                {
                    ((ImageView)rowView.FindViewById(Resource.Id.incident_item_img)).SetImageBitmap(model.Image);
                }

                //rowView.SetTag(position,((object)model));
                if (!viewMap.ContainsKey(position))
                    viewMap.Add(position, rowView);
            }
            return rowView;
        }
    }
}