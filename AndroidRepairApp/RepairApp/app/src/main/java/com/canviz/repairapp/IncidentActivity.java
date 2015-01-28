package com.canviz.repairapp;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.canviz.repairapp.data.IncidentModel;
import com.canviz.repairapp.utility.FileHelper;
import com.canviz.repairapp.utility.IncidentAdapter;

import java.util.List;
import java.util.concurrent.ExecutionException;


public class IncidentActivity extends Activity {

    private final static String TAG = "IncidentActivity";
    private App mApp;
    private ProgressDialog process;
    private ListView listView;
    private IncidentAdapter adapter;
    private List<IncidentModel> incidentItems;
    private ImageView propertyLogo;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_incident);

        mApp = (App) getApplication();
        this.listView = (ListView)findViewById(R.id.incident_list);
        this.propertyLogo = (ImageView)findViewById(R.id.incident_propertyLogo);

        if(mApp.getIncidentId().equals("0")){
            process = ProgressDialog.show(this,"Loading","Loading data from SharePoint List...");
            loadFirstIncidentId();
        }
        else {
            process = ProgressDialog.show(this,"Loading","Loading data from SharePoint List...");
            loadPropertyId();
        }
    }

    private void loadFirstIncidentId(){
        final Handler loadFirstIncidentIdHandler = new Handler() {
            @Override
            public void handleMessage(Message msg) {
                if(msg.what == Constants.SUCCESS)
                {
                    mApp.setIncidentId(String.valueOf(msg.obj));
                    loadPropertyId();
                }
                else
                {
                    process.dismiss();
                    Toast.makeText(IncidentActivity.this, "There is no incident.", Toast.LENGTH_LONG).show();
                }
            }
        };

        new Thread(){
            @Override
            public void run() {
                try {
                    IncidentModel tempModel = mApp.getDataSource().getIncidentId();
                    if(tempModel != null){
                        Message message = new Message();
                        message.what = Constants.SUCCESS;
                        message.obj = tempModel.getId();
                        loadFirstIncidentIdHandler.sendMessage(message);
                    }
                    else{
                        throw new Exception();
                    }
                } catch (Exception e) {
                    Message message = new Message();
                    message.what = Constants.FAILED;
                    message.obj = e.getMessage();
                    loadFirstIncidentIdHandler.sendMessage(message);
                    e.printStackTrace();
                }
            }
        }.start();
    }

    private void loadPropertyId(){
        final Handler loadPropertyIdHandler = new Handler() {
            @Override
            public void handleMessage(Message msg) {
                if(msg.what == Constants.SUCCESS)
                {
                    mApp.setPropertyId(String.valueOf(msg.obj));
                    loadData();
                }
                else
                {
                    process.dismiss();
                    Toast.makeText(IncidentActivity.this, "The incident with ID "+ mApp.getIncidentId() +" was not found.", Toast.LENGTH_LONG).show();
                }
            }
        };

        new Thread(){
            @Override
            public void run() {
                try {
                    IncidentModel tempModel = mApp.getDataSource().getIncident(mApp.getIncidentId());
                    if(tempModel != null){
                        Message message = new Message();
                        message.what = Constants.SUCCESS;
                        message.obj = tempModel.getPropertyId();
                        loadPropertyIdHandler.sendMessage(message);
                    }
                    else{
                        throw new Exception();
                    }
                } catch (Exception e) {
                    Message message = new Message();
                    message.what = Constants.FAILED;
                    message.obj = e.getMessage();
                    loadPropertyIdHandler.sendMessage(message);
                    e.printStackTrace();
                }
            }
        }.start();
    }

    private void loadData()
    {
        new Thread(){
            @Override
            public void run() {
                try {
                    incidentItems = mApp.getDataSource().getIncidents(mApp.getPropertyId());
                    handler.sendEmptyMessage(Constants.SUCCESS);
                } catch (ExecutionException e) {
                    Message message = new Message();
                    message.what = Constants.FAILED;
                    message.obj = e.getMessage();
                    handler.sendMessage(message);
                    e.printStackTrace();
                } catch (InterruptedException e) {
                    Message message = new Message();
                    message.what = Constants.FAILED;
                    message.obj = e.getMessage();
                    handler.sendMessage(message);
                    e.printStackTrace();
                }
            }
        }.start();
    }

    private void bindData()
    {
        bindPropertyData();

        adapter = new IncidentAdapter(this,incidentItems);
        listView.setAdapter(adapter);

        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                IncidentModel incidentModel =  (IncidentModel)view.getTag();
                mApp.setSelectedIncidentModel(incidentModel);
                Intent intent = new Intent();
                intent.setClass(IncidentActivity.this,IncidentDetailActivity.class);
                startActivity(intent);
            }
        });

        getIncidentPhoto();
    }

    private void bindPropertyData(){
        if(incidentItems.size() > 0){
            getPropertyPhoto();

            ((TextView)findViewById(R.id.incident_propertyName)).setText("Property Name: " + incidentItems.get(0).getProperty().getTitle());
            ((TextView)findViewById(R.id.incident_propertyOwner)).setText("Owner: " + incidentItems.get(0).getProperty().getOwner());
            ((TextView)findViewById(R.id.incident_propertyAddress)).setText(incidentItems.get(0).getProperty().getAddress1());
            ((TextView)findViewById(R.id.incident_contactOwner)).setText(incidentItems.get(0).getProperty().getEmail());
            ((TextView)findViewById(R.id.incident_contactOffice)).setText(Constants.DISPATCHEREMAIL);

            final String owner = incidentItems.get(0).getProperty().getEmail();
            final String office = Constants.DISPATCHEREMAIL;
            ((TextView)findViewById(R.id.incident_contactOwner)).setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    sendEmail(owner);
                }
            });
            ((TextView)findViewById(R.id.incident_contactOffice)).setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    sendEmail(office);
                }
            });

        }
    }

    private void getPropertyPhoto(){
        final Handler loadPhotoHandler = new Handler() {
            @Override
            public void handleMessage(Message msg) {
                if(msg.what == Constants.SUCCESS)
                {
                    propertyLogo.setImageBitmap((Bitmap)msg.obj);
                    Log.d(TAG,"Load property photos success.");
                }
                else
                {
                    Log.d(TAG,"Load property photos failed.");
                }
            }
        };

        new Thread(){
            @Override
            public void run() {
                try {
                    int propertyPhotoId = mApp.getDataSource().getPropertyPhotoId(Integer.parseInt(mApp.getPropertyId()));
                    Bitmap image = FileHelper.getFile(mApp.getToken(), "Property%20Photos", propertyPhotoId);
                    Message message = new Message();
                    message.what = Constants.SUCCESS;
                    message.obj = image;
                    loadPhotoHandler.sendMessage(message);
                } catch (Exception e) {
                    Message message = new Message();
                    message.what = Constants.FAILED;
                    message.obj = e.getMessage();
                    loadPhotoHandler.sendMessage(message);
                    e.printStackTrace();
                }
            }
        }.start();
    }

    private void getIncidentPhoto(){
        final Handler loadPhotoHandler = new Handler() {
            @Override
            public void handleMessage(Message msg) {
                if(msg.what == Constants.SUCCESS)
                {
                    incidentItems.get(msg.arg1).setImage((Bitmap)msg.obj);
                    incidentItems.get(msg.arg1).setIsChanged(true);
                    adapter.notifyDataSetChanged();
                    Log.d(TAG,"Load incident photos success.");
                }
                else
                {
                    Log.d(TAG,"Load incident photos failed.");
                }
            }
        };

        for (int i = 0; i < incidentItems.size(); i++){
            final int index = i;
            new Thread(){
                @Override
                public void run() {
                    try {
                        int inspectionPhotoId = mApp.getDataSource().getInspectionPhotoId(incidentItems.get(index).getId(),
                                incidentItems.get(index).getRoomId(),incidentItems.get(index).getInspectionId(),1);
                        Log.d(TAG,"Photo ID:"+inspectionPhotoId+",incident id:"+incidentItems.get(index).getId()+"roomid:"+incidentItems.get(index).getRoomId() + "inspectionId:"+incidentItems.get(index).getInspectionId());
                        Bitmap image = FileHelper.getFile(mApp.getToken(), "Room%20Inspection%20Photos", inspectionPhotoId);
                        Message message = new Message();
                        message.what = Constants.SUCCESS;
                        message.obj = image;
                        message.arg1 = index;
                        loadPhotoHandler.sendMessage(message);
                    } catch (Exception e) {
                        Message message = new Message();
                        message.what = Constants.FAILED;
                        message.obj = e.getMessage();
                        loadPhotoHandler.sendMessage(message);
                        e.printStackTrace();
                    }
                }
            }.start();
        }
    }

    private Handler handler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            if(msg.what == Constants.SUCCESS)
            {
                bindData();
            }
            else
            {
                Toast.makeText(IncidentActivity.this, "Load incident data failed.", Toast.LENGTH_LONG).show();
            }
            process.dismiss();
        }
    };

    private void updateIncidentItems(){
        for(int i =0; i < incidentItems.size(); i++){
            if(incidentItems.get(i).getId() == mApp.getSelectedIncidentModel().getId()){
                incidentItems.get(i).setRepairComments(mApp.getSelectedIncidentModel().getRepairComments());
                incidentItems.get(i).setStatus(mApp.getSelectedIncidentModel().getStatus());
                incidentItems.get(i).setRepairCompleted(mApp.getSelectedIncidentModel().getRepairCompleted());
                incidentItems.get(i).setIsChanged(true);
                return;
            }
        }
    }

    private void sendEmail(String to){
        Intent intent = new Intent(android.content.Intent.ACTION_SEND);
        intent.setType("plain/text");
        intent.putExtra( android.content.Intent.EXTRA_EMAIL, new String[] {to} );
        intent.putExtra( android.content.Intent.EXTRA_SUBJECT, "");
        intent.putExtra(android.content.Intent.EXTRA_TEXT, "Sent from Android");
        Intent chooserIntent = Intent.createChooser(intent, "Send Email");
        startActivity(chooserIntent);
    }


    @Override
    protected void onResume() {
        super.onResume();
        if(mApp.getSelectedIncidentModel() != null) {
            updateIncidentItems();
            adapter.notifyDataSetChanged();
        }
    }
}
