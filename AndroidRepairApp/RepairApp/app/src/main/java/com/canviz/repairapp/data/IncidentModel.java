package com.canviz.repairapp.data;

import android.graphics.Bitmap;

import com.canviz.repairapp.utility.SPListItemWrapper;
import com.microsoft.listservices.SPListItem;

import org.json.JSONObject;

public class IncidentModel {
    public static final String[] SELECT = {
            "ID","Title","sl_inspectorIncidentComments",
            "sl_dispatcherComments","sl_repairComments","sl_status",
            "sl_type","sl_date","sl_repairCompleted","sl_propertyIDId","sl_inspectionIDId","sl_roomIDId","sl_taskId",
            "sl_inspectionID/ID",
            "sl_inspectionID/sl_datetime",
            "sl_inspectionID/sl_finalized",
            "sl_propertyID/ID",
            "sl_propertyID/Title",
            "sl_propertyID/sl_emailaddress",
            "sl_propertyID/sl_owner",
            "sl_propertyID/sl_address1",
            "sl_propertyID/sl_address2",
            "sl_propertyID/sl_city",
            "sl_propertyID/sl_state",
            "sl_propertyID/sl_postalCode",
            "sl_roomID/ID",
            "sl_roomID/Title",
    };

    public static final String[] EXPAND = {
            "sl_inspectionID","sl_propertyID","sl_roomID"
    };

    private final SPListItemWrapper mData;

    public IncidentModel() {
        this(new SPListItem());
    }

    public IncidentModel(SPListItem listItem) {
        mData = new SPListItemWrapper(listItem);
    }

    public int getId() {
        return mData.getInt("ID");
    }

    public String getTitle() {
        return mData.getString("Title");
    }

    public String getInspectorIncidentComments(){
        return mData.getString("sl_inspectorIncidentComments");
    }

    public String getDispatcherComments()
    {
        return mData.getString("sl_dispatcherComments");
    }

    public String getRepairComments()
    {
        return mData.getString("sl_repairComments");
    }

    public void setRepairComments(String value){
        mData.setString("sl_repairComments",value);
    }

    public String getStatus()
    {
        return mData.getString("sl_status");
    }

    public void setStatus(String value)
    {
        mData.setString("sl_status",value);
    }

    public String getType()
    {
        return mData.getString("sl_type");
    }

    public String getDate()
    {
        return mData.getString("sl_date");
    }

    public String getRepairCompleted()
    {
        return mData.getString("sl_repairCompleted");
    }

    public void setRepairCompleted(String value)
    {
        mData.setString("sl_repairCompleted",value);
    }

    public int getPropertyId()
    {
        return mData.getInt("sl_propertyIDId");
    }

    public int getInspectionId()
    {
        return mData.getInt("sl_inspectionIDId");
    }

    public int getRoomId()
    {
        return mData.getInt("sl_roomIDId");
    }

    public int getTaskId()
    {
        return mData.getInt("sl_taskId");
    }

    public SPListItem getData(){
        return mData.getInner();
    }

    public InspectionModel getInspection(){
        JSONObject data = mData.getObject("sl_inspectionID");
        return new InspectionModel(data);
    }

    public PropertyModel getProperty(){
        JSONObject data = mData.getObject("sl_propertyID");
        return new PropertyModel(data);
    }

    public RoomModel getRoom(){
        JSONObject data = mData.getObject("sl_roomID");
        return new RoomModel(data);
    }

    private Boolean IsChanged;

    public void setIsChanged(Boolean value){
        IsChanged = value;
    }

    public Boolean getIsChanged(){
        return IsChanged;
    }

    private String Token;

    public void setToken(String value){
        Token = value;
    }

    public String getToken(){
        return Token;
    }

    private Bitmap Image;

    public void setImage(Bitmap bitmap){
        Image = bitmap;
    }

    public Bitmap getImage(){
        return Image;
    }
}
