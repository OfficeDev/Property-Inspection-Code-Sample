package com.canviz.repairapp.data;

import org.json.JSONException;
import org.json.JSONObject;

public class InspectionModel {
    private final JSONObject mData;

    public InspectionModel(JSONObject data) {
        mData = data;
    }

    public int getId(){
        try{
            return mData.getInt("ID");
        }catch(JSONException e) {
            return 0;
        }
    }

    public String getDateTime(){
        try{
            return mData.getString("sl_datetime");
        }catch(JSONException e) {
            return null;
        }
    }

    public String getFinalized(){
        try{
            return mData.getString("sl_finalized");
        }catch(JSONException e) {
            return null;
        }
    }
}
