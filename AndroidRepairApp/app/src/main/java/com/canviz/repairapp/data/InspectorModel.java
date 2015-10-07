package com.canviz.repairapp.data;

import org.json.JSONException;
import org.json.JSONObject;

public class InspectorModel {
    private final JSONObject mData;
    public InspectorModel(JSONObject data) {
        mData = data;
    }

    public String getTitle(){
        try{
            return mData.getString("Title");
        }catch(JSONException e) {
            return null;
        }
    }

    public String getEmailAddress(){
        try{
            return mData.getString("sl_emailaddress");
        }catch(JSONException e) {
            return null;
        }
    }
}
