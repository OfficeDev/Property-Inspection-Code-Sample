package com.canviz.repairapp.data;

import com.canviz.repairapp.utility.SPListItemWrapper;
import com.microsoft.services.sharepoint.SPListItem;
import org.json.JSONObject;

public class InspectionInspectorModel {
    public static final String[] SELECT = {
            "Id","sl_datetime","sl_finalized",
            "sl_inspector",
            "sl_emailaddress"
    };

    public static final String[] EXPAND = {

    };

    private final SPListItemWrapper mData;

    public InspectionInspectorModel() {
        this(new SPListItem());
    }

    public InspectionInspectorModel(SPListItem listItem) {
        mData = new SPListItemWrapper(listItem);
    }

    public int getId(){
        return mData.getInt("ID");
    }

    public String getDateTime(){
        return mData.getString("sl_datetime");
    }

    public String getFinalized(){
        return mData.getString("sl_finalized");
    }

    public String getInspector(){ return mData.getString("sl_inspector"); }

    public String getEmailAddress(){ return mData.getString("sl_emailaddress"); }
}
