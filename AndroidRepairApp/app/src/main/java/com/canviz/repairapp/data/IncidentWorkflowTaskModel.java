package com.canviz.repairapp.data;

import com.canviz.repairapp.utility.SPListItemWrapper;
import com.microsoft.services.sharepoint.SPListItem;

public class IncidentWorkflowTaskModel {
    public static final String[] SELECT = {
            "Id","PercentComplete","Status"
    };

    public static final String[] EXPAND = {

    };

    private final SPListItemWrapper mData;

    public IncidentWorkflowTaskModel() {
        this(new SPListItem());
    }

    public IncidentWorkflowTaskModel(SPListItem listItem) {
        mData = new SPListItemWrapper(listItem);
    }

    public int getId(){
        return mData.getInt("Id");
    }

    public void setId(int id){
        mData.setInt("Id",id);
    }

    public String getPercentComplete(){
        return mData.getString("PercentComplete");
    }

    public void setPercentComplete(String value){
        mData.setString("PercentComplete",value);
    }

    public String getStatus(){
        return mData.getString("Status");
    }

    public void setStatus(String value){
        mData.setString("Status",value);
    }

    public SPListItem getData(){
        return mData.getInner();
    }
}
