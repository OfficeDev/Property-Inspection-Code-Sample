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

import com.canviz.repairapp.data.*;

public class GroupConversationAdapter extends ArrayAdapter<GroupConversationModel> {

    private Context context;

    public GroupConversationAdapter(Activity activity,List<GroupConversationModel> objects) {
        super(activity, 0, objects);
    }

    private Map<Integer, View> viewMap = new HashMap<Integer, View>();

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        View rowView=this.viewMap.get(position);
        GroupConversationModel model = this.getItem(position);

        if(rowView==null)
        {
            context = this.getContext();
            LayoutInflater inflater = ((Activity) this.getContext()).getLayoutInflater();
            rowView = inflater.inflate(R.layout.conversation_item, null);
            ((TextView)rowView.findViewById(R.id.group_conversation_item_title)).setText(model.getTitle());
            ((TextView)rowView.findViewById(R.id.group_conversation_item_preview)).setText(model.getPreview());
            rowView.setTag(model);
            viewMap.put(position, rowView);
        }
        return rowView;
    }
}


