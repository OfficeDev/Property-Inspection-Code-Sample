package com.canviz.repairapp.data;

import com.canviz.repairapp.utility.SPListItemWrapper;
import com.microsoft.listservices.SPListItem;

public class RepairPhotoModel {

    public static final String[] SELECT = {
            "Id","sl_inspectionIDId","sl_incidentIDId","sl_roomIDId"
    };

    public static final String[] EXPAND = {

    };

    private final SPListItemWrapper mData;

    public RepairPhotoModel() {
        this(new SPListItem());
    }

    public RepairPhotoModel(SPListItem listItem) {
        mData = new SPListItemWrapper(listItem);
    }

    public int getId(){
        return mData.getInt("Id");
    }

    public void setId(int id){
        mData.setInt("Id",id);
    }

    public int getInspectionIDId(){
        return mData.getInt("sl_inspectionIDId");
    }

    public void setInspectionIDId(int value){
        mData.setInt("sl_inspectionIDId",value);
    }

    public int getIncidentIDId(){
        return mData.getInt("sl_incidentIDId");
    }

    public void setIncidentIDId(int value){
        mData.setInt("sl_incidentIDId",value);
    }

    public int getRoomIDId(){
        return mData.getInt("sl_roomIDId");
    }

    public void setRoomIDId(int value){
        mData.setInt("sl_roomIDId",value);
    }


    public SPListItem getData(){
        return mData.getInner();
    }
}
