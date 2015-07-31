package com.canviz.repairapp.data;

import org.json.JSONException;
import org.json.JSONObject;

public class PropertyModel {
    private final JSONObject mData;

    public PropertyModel(JSONObject data) {
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

    public String getEmail(){
        try{
            return mData.getString("sl_emailaddress");
        }catch(JSONException e) {
            return null;
        }
    }

    public String getOwner(){
        try{
            return mData.getString("sl_owner");
        }catch(JSONException e) {
            return null;
        }
    }

    public String getAddress1(){
        try{
            return mData.getString("sl_address1");
        }catch(JSONException e) {
            return null;
        }
    }

    public String getAddress2(){
        try{
            return mData.getString("sl_address2");
        }catch(JSONException e) {
            return null;
        }
    }

    public String getCity(){
        try{
            return mData.getString("sl_city");
        }catch(JSONException e) {
            return null;
        }
    }

    public String getState(){
        try{
            return mData.getString("sl_state");
        }catch(JSONException e) {
            return null;
        }
    }

    public String getPostalCode(){
        try{
            return mData.getString("sl_postalCode");
        }catch(JSONException e) {
            return null;
        }
    }
}
