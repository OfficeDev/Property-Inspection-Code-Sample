package com.canviz.repairapp.utility;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.canviz.repairapp.R;
import android.content.Context;
import android.app.Activity;
import android.view.View;
import android.view.LayoutInflater;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.canviz.repairapp.data.IncidentModel;

public class IncidentAdapter extends ArrayAdapter<IncidentModel> {

    private Context context;

    public IncidentAdapter(Activity activity,List<IncidentModel> objects) {
        super(activity, 0, objects);
    }

    private Map<Integer, View> viewMap = new HashMap<Integer, View>();

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        // TODO Auto-generated method stub

        View rowView=this.viewMap.get(position);
        IncidentModel model = this.getItem(position);

        if(rowView==null || (model.getIsChanged() != null && model.getIsChanged()))
        {
            context = this.getContext();
            LayoutInflater inflater = ((Activity) this.getContext()).getLayoutInflater();
            rowView = inflater.inflate(R.layout.incident_item, null);

            String roomTitle = model.getRoom().getTitle();
            String repairDate = model.getInspection().getFinalized();
            String incidentTitle = model.getTitle();
            String inspectionDate = model.getInspection().getDateTime();
            String approved = model.getStatus();
            if(Helper.IsNullOrEmpty(roomTitle)){
                roomTitle = "";
            }
            if(Helper.IsNullOrEmpty(incidentTitle)){
                incidentTitle = "";
            }
            if(Helper.IsNullOrEmpty(approved)){
                approved = "";
            }

            if(!Helper.IsNullOrEmpty(repairDate) && !Helper.IsNullOrEmpty(Helper.formatString(repairDate))){
                repairDate = "Repair Date: " + Helper.formatString(repairDate);
            }
            else{
                repairDate="";
            }
            if(!Helper.IsNullOrEmpty(inspectionDate)){
                inspectionDate = "Inspection Date: " + Helper.formatString(inspectionDate);
            }
            else{
                inspectionDate = "";
            }
            ((TextView)rowView.findViewById(R.id.incident_item1)).setText("Room: " + roomTitle);
            ((TextView)rowView.findViewById(R.id.incident_item2)).setText(repairDate);
            ((TextView)rowView.findViewById(R.id.incident_item3)).setText("Incident: " + incidentTitle);
            ((TextView)rowView.findViewById(R.id.incident_item4)).setText(inspectionDate);
            ((TextView)rowView.findViewById(R.id.incident_item5)).setText("Approved: " + approved);
            if(model.getImage()!=null){
                ((ImageView)rowView.findViewById(R.id.incident_item_img)).setImageBitmap(model.getImage());
            }

            rowView.setTag(model);
            viewMap.put(position, rowView);
        }
        return rowView;
    }
}
