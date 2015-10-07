package com.canviz.repairapp.utility;

import java.text.DecimalFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.canviz.repairapp.R;
import android.content.Context;
import android.app.Activity;
import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.provider.ContactsContract;
import android.support.v4.content.ContextCompat;
import android.view.View;
import android.view.LayoutInflater;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.LinearLayout;

import com.canviz.repairapp.data.*;

import org.w3c.dom.Text;

public class GroupFileAdapter extends ArrayAdapter<GroupFileModel> {

    private Context context;

    public GroupFileAdapter(Activity activity,List<GroupFileModel> objects) {
        super(activity, 0, objects);
    }

    private Map<Integer, View> viewMap = new HashMap<Integer, View>();

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        View rowView=this.viewMap.get(position);
        final GroupFileModel model = this.getItem(position);

        if(rowView==null)
        {
            context = this.getContext();
            LayoutInflater inflater = ((Activity) this.getContext()).getLayoutInflater();
            rowView = inflater.inflate(R.layout.file_item, null);
            ((TextView)rowView.findViewById(R.id.group_file_item_title)).setText(model.getTitle());
            ((TextView)rowView.findViewById(R.id.group_file_item_title2)).setText(model.getLastModifiedBy());
            ((TextView)rowView.findViewById(R.id.group_file_item_title3)).setText("Last Modified: " + (1 + model.getLastModified().get(Calendar.MONTH)) + "/" + model.getLastModified().get(Calendar.DAY_OF_MONTH) + "/" + model.getLastModified().get(Calendar.YEAR));
            DecimalFormat df = new DecimalFormat("#.#");
            String sizeStr = "";
            if(model.getSize()<1024){
                sizeStr = df.format(model.getSize()) + " kb";
            }
            else{
                sizeStr = df.format((double)model.getSize() / ((double) 1024)) + " mb";
            }
            ((TextView) rowView.findViewById(R.id.group_file_item_title4)).setText("Size: " + sizeStr);
            LinearLayout rightPanel = (LinearLayout)rowView.findViewById(R.id.group_file_item_right);
            ImageView rightImg = (ImageView)rowView.findViewById(R.id.group_file_item_icon);
            TextView rightText = (TextView)rowView.findViewById(R.id.group_file_item_text);
            Boolean showRightButton = true;
            String rightBtnText = "";
            Drawable rightBtnIco = null;
            final String officeAppName = model.getTitle().toLowerCase().endsWith("docx") ? "word" :
                (
                    model.getTitle().toLowerCase().endsWith("pptx") ? "power point" : (model.getTitle().toLowerCase().endsWith("xlsx") ? "excel" : "")
                );
            if(officeAppName.equalsIgnoreCase("word")){
                rightBtnIco = ContextCompat.getDrawable(context, R.drawable.ico_word);
                rightBtnText = "Open in\n  Word";
            }
            else if(officeAppName.equalsIgnoreCase("power point")){
                rightBtnIco = ContextCompat.getDrawable(context, R.drawable.ico_powerpoint);
                rightBtnText = "   Open in\nPower Point";
            }
            else if(officeAppName.equalsIgnoreCase("excel")){
                rightBtnIco = ContextCompat.getDrawable(context, R.drawable.ico_excel);
                rightBtnText = "Open in\n  Excel";
            }
            else{
                showRightButton = false;
            }
            if(showRightButton){
                rightImg.setImageDrawable(rightBtnIco);
                rightText.setText(rightBtnText);
                rightPanel.setVisibility(View.VISIBLE);

                rightPanel.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        try {
                            String urlSchema = officeAppName.equalsIgnoreCase("word") ? "ms-word" : (officeAppName.equalsIgnoreCase("power point") ? "ms-powerpoint" : "ms-excel");
                            Uri uri = Uri.parse(urlSchema + ":ofv|u|" + model.getUrl());
                            Intent intent = new Intent(Intent.ACTION_VIEW, uri);
                            context.startActivity(intent);
                        } catch (Exception ex) {
                            Toast.makeText(context, "Open in "+ officeAppName +" failed.", Toast.LENGTH_SHORT).show();
                        }
                    }
                });
            }
            else{
                rightPanel.setVisibility(View.GONE);
            }

            rowView.setTag(model);
            viewMap.put(position, rowView);
        }
        return rowView;
    }
}



