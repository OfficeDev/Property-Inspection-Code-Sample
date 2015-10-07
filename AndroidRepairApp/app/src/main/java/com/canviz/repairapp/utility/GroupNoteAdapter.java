package com.canviz.repairapp.utility;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.canviz.repairapp.R;
import android.content.Context;
import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.view.LayoutInflater;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.canviz.repairapp.data.*;

public class GroupNoteAdapter extends ArrayAdapter<GroupNoteBookModel> {

    private Context context;

    public GroupNoteAdapter(Activity activity,List<GroupNoteBookModel> objects) {
        super(activity, 0, objects);
    }

    private Map<Integer, View> viewMap = new HashMap<Integer, View>();

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        View rowView = this.viewMap.get(position);
        final GroupNoteBookModel model = this.getItem(position);

        if(rowView == null)
        {
            context = this.getContext();
            LayoutInflater inflater = ((Activity) this.getContext()).getLayoutInflater();
            rowView = inflater.inflate(R.layout.note_item, null);
            final TextView txtTitle = ((TextView)rowView.findViewById(R.id.group_note_item_title));
            final ImageView img = ((ImageView)rowView.findViewById(R.id.group_note_item_img));
            final RelativeLayout openInOneNote =  (RelativeLayout)rowView.findViewById(R.id.group_note_item_open);
            txtTitle.setText(model.getTitle());
            openInOneNote.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    try{
                        Uri uri = Uri.parse("onenote:" + model.getUrl());
                        Intent intent = new Intent(Intent.ACTION_VIEW, uri);
                        context.startActivity(intent);
                    }
                    catch(Exception ex){
                        Toast.makeText(context,"Open in onenote failed.",Toast.LENGTH_SHORT).show();
                    }
                }
            });
            rowView.setTag(model);
            viewMap.put(position, rowView);
        }
        return rowView;
    }
}



