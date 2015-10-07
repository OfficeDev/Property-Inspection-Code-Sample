package com.canviz.repairapp.utility;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.canviz.repairapp.R;
import android.content.Context;
import android.app.Activity;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.view.LayoutInflater;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.canviz.repairapp.data.*;

public class GroupMemberAdapter extends ArrayAdapter<UserModel> {

    private Context context;

    public GroupMemberAdapter(Activity activity,List<UserModel> objects) {
        super(activity, 0, objects);
    }

    private Map<Integer, View> viewMap = new HashMap<Integer, View>();

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        View rowView=this.viewMap.get(position);
        UserModel model = this.getItem(position);

        if(rowView==null || (model.getIsChanged() != null && model.getIsChanged()))
        {
            context = this.getContext();
            LayoutInflater inflater = ((Activity) this.getContext()).getLayoutInflater();
            rowView = inflater.inflate(R.layout.member_item, null);

            String name = model.getName();

            ((TextView)rowView.findViewById(R.id.group_member_item1)).setText(name);
            if(model.getImage()!=null){
                ((ImageView)rowView.findViewById(R.id.group_member_item_img)).setImageBitmap(model.getImage());
            }

            rowView.setTag(model);
            viewMap.put(position, rowView);
        }
        return rowView;
    }
}

