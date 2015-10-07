package com.canviz.repairapp.data;

import org.json.JSONException;
import org.json.JSONObject;

public class RoomModel {
    private final JSONObject mData;

    public RoomModel(JSONObject data) {
        mData = data;
    }

    public int getId(){
        try{
            return mData.getInt("ID");
        }catch(JSONException e) {
            return 0;
        }
    }

    public String getTitle(){
        try{
            return mData.getString("Title");
        }catch(JSONException e) {
            return null;
        }
    }
}
