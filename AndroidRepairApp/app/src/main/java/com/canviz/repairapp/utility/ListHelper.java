package com.canviz.repairapp.utility;

import com.canviz.repairapp.Constants;
import com.canviz.repairapp.data.IncidentModel;
import com.canviz.repairapp.data.IncidentWorkflowTaskModel;
import com.canviz.repairapp.data.InspectionInspectorModel;
import com.canviz.repairapp.data.RepairPhotoModel;
import com.microsoft.sharepointservices.Query;
import com.microsoft.sharepointservices.QueryOrder;
import com.microsoft.sharepointservices.SPList;
import com.microsoft.sharepointservices.SPListItem;
import com.microsoft.sharepointservices.ListClient;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutionException;

public class ListHelper {

    private final ListClient mClient;

    public ListHelper(ListClient client) {
        mClient = client;
    }

    public IncidentModel getIncidentId() throws ExecutionException, InterruptedException{
        Query query = new Query().select(IncidentModel.SELECT)
                .expand(IncidentModel.EXPAND)
                .top(1)
                .orderBy("ID", QueryOrder.Ascending)
                .field("sl_propertyIDId").gt(0)
                .and()
                .field("sl_inspectionIDId").gt(0)
                .and()
                .field("sl_roomIDId").gt(0);
        List<SPListItem> items = mClient.getListItems(Constants.LIST_NAME_INCIDENTS, query).get();
        if (items != null && items.size() > 0) {
            IncidentModel model = new IncidentModel(items.get(0));
            if(model.getPropertyId() > 0 && model.getInspectionId() > 0 && model.getRoomId() > 0)
            {
                return model;
            }
        }
        return null;
    }

    public IncidentModel getIncident(String incidentId) throws ExecutionException, InterruptedException{
        Query query = new Query().select(IncidentModel.SELECT)
                .expand(IncidentModel.EXPAND)
                .top(1)
                .orderBy("sl_date", QueryOrder.Descending)
                .field("ID").eq(incidentId)
                .and()
                .field("sl_propertyIDId").gt(0)
                .and()
                .field("sl_inspectionIDId").gt(0)
                .and()
                .field("sl_roomIDId").gt(0);
        List<SPListItem> items = mClient.getListItems(Constants.LIST_NAME_INCIDENTS, query).get();
        if (items != null && items.size() > 0) {
            IncidentModel model = new IncidentModel(items.get(0));
            if(model.getPropertyId() > 0 && model.getInspectionId() > 0 && model.getRoomId() > 0)
            {
                return model;
            }
        }
        return null;
    }

    public List<IncidentModel> getIncidents(String propertyId) throws ExecutionException, InterruptedException{
        Query query = new Query().select(IncidentModel.SELECT)
                .expand(IncidentModel.EXPAND)
                .orderBy("sl_date", QueryOrder.Descending)
                .field("sl_propertyIDId").eq(propertyId)
                .and()
                .field("sl_inspectionIDId").gt(0)
                .and()
                .field("sl_roomIDId").gt(0);
        List<SPListItem> items = mClient.getListItems(Constants.LIST_NAME_INCIDENTS, query).get();

        List<IncidentModel> models = new ArrayList<IncidentModel>();
        for (SPListItem item : items) {
            IncidentModel model = new IncidentModel(item);
            if(model.getPropertyId() > 0 && model.getInspectionId() > 0 && model.getRoomId() > 0)
            {
                models.add(new IncidentModel(item));
            }
        }
        return models;
    }

    public InspectionInspectorModel getInspection(int inspectionId) throws ExecutionException, InterruptedException {
        Query query = new Query().select(InspectionInspectorModel.SELECT)
                .field("Id").eq(inspectionId)
                .top(1)
                .orderBy("sl_datetime", QueryOrder.Descending);
        List<SPListItem> items = mClient.getListItems(Constants.LIST_NAME_INSPECTIONS, query).get();

        if(items!= null && items.size() > 0){
            return new InspectionInspectorModel(items.get(0));
        }
        return null;
    }

    public void updateIncidentRepairCompleted(IncidentModel incidentModel) throws ExecutionException, InterruptedException {
        SPList list = mClient.getList(Constants.LIST_NAME_INCIDENTS).get();
        mClient.updateListItem(incidentModel.getData(), list);
    }

    public void updateIncidentWorkflowTask(IncidentWorkflowTaskModel incidentWorkflowTaskModel) throws ExecutionException, InterruptedException {
        SPList list = mClient.getList(Constants.LIST_NAME_INCIDENTWORKFLOWTASKS).get();
        mClient.updateListItem(incidentWorkflowTaskModel.getData(), list);
    }

    public void updateIncidentRepairComments(IncidentModel incidentModel) throws ExecutionException, InterruptedException {
        SPList list = mClient.getList(Constants.LIST_NAME_INCIDENTS).get();
        mClient.updateListItem(incidentModel.getData(), list);
    }

    public int getPropertyPhotoId(int propertyId) throws ExecutionException, InterruptedException {
        String[] select = {"Id"};
        Query query = new Query().select(select)
                .field("sl_propertyIDId").eq(propertyId)
                .top(1)
                .orderBy("Modified", QueryOrder.Descending);
        List<SPListItem> items = mClient.getListItems(Constants.LIST_NAME_PROPERTYPHOTOS, query).get();
        if(items != null && items.size() > 0){
            return items.get(0).getId();
        }
        return 0;
    }

    public int getInspectionPhotoId(int incidentId,int roomId, int inspectionId,int top) throws ExecutionException, InterruptedException {
        String[] select = {"Id"};
        Query query = new Query().select(select)
                .field("sl_inspectionIDId").eq(inspectionId)
                .and()
                .field("sl_incidentIDId").eq(incidentId)
                .and()
                .field("sl_roomIDId").eq(roomId)
                .top(top)
                .orderBy("Modified", QueryOrder.Descending);
        List<SPListItem> items = mClient.getListItems(Constants.LIST_NAME_ROOMINSPECTIONPHOTOS, query).get();
        if(items != null && items.size() > 0){
            return items.get(0).getId();
        }

        return 0;
    }

    public List<Integer> getInspectionPhotoIds(int incidentId,int roomId, int inspectionId) throws ExecutionException, InterruptedException {
        List<Integer> results = new ArrayList<Integer>();
        String[] select = {"Id"};
        Query query = new Query().select(select)
                .field("sl_inspectionIDId").eq(inspectionId)
                .and()
                .field("sl_incidentIDId").eq(incidentId)
                .and()
                .field("sl_roomIDId").eq(roomId)
                .orderBy("Modified", QueryOrder.Descending);
        List<SPListItem> items = mClient.getListItems(Constants.LIST_NAME_ROOMINSPECTIONPHOTOS, query).get();
        if(items != null && items.size() > 0){
            for(int i =0; i < items.size(); i++){
                results.add(items.get(i).getId());
            }
        }
        return results;
    }

    public List<Integer> getRepairPhotoIds(int incidentId,int roomId, int inspectionId) throws ExecutionException, InterruptedException {
        List<Integer> results = new ArrayList<Integer>();
        String[] select = {"Id"};
        Query query = new Query().select(select)
                .field("sl_inspectionIDId").eq(inspectionId)
                .and()
                .field("sl_incidentIDId").eq(incidentId)
                .and()
                .field("sl_roomIDId").eq(roomId)
                .orderBy("Modified", QueryOrder.Descending);
        List<SPListItem> items = mClient.getListItems(Constants.LIST_NAME_REPAIRPHOTOS, query).get();
        if(items != null && items.size() > 0){
            for(int i =0; i < items.size(); i++){
                results.add(items.get(i).getId());
            }
        }

        return results;
    }

    public void updateRepairPhotoProperty(RepairPhotoModel repairPhotoModel) throws ExecutionException, InterruptedException {
        SPList list = mClient.getList(Constants.LIST_NAME_REPAIRPHOTOS).get();
        mClient.updateListItem(repairPhotoModel.getData(), list);
    }


}
