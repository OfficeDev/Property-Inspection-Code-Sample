package com.canviz.repairapp;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.provider.MediaStore;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup.LayoutParams;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.canviz.repairapp.data.IncidentModel;
import com.canviz.repairapp.data.IncidentWorkflowTaskModel;
import com.canviz.repairapp.data.InspectionInspectorModel;
import com.canviz.repairapp.data.RepairPhotoModel;
import com.canviz.repairapp.utility.FileHelper;
import com.canviz.repairapp.utility.Helper;
import com.google.common.util.concurrent.FutureCallback;
import com.google.common.util.concurrent.Futures;
import com.google.common.util.concurrent.ListenableFuture;
import com.microsoft.outlookservices.EmailAddress;
import com.microsoft.outlookservices.ItemBody;
import com.microsoft.outlookservices.Recipient;
import com.microsoft.outlookservices.odata.OutlookClient;
import com.microsoft.services.odata.impl.ADALDependencyResolver;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.concurrent.ExecutionException;


public class IncidentDetailActivity extends Activity {

    private final static String TAG = "IncidentDetailActivity";
    private App mApp;
    private ImageView backBtn;
    private ProgressDialog process;
    private IncidentModel SelectedIncidentModel;
    private InspectionInspectorModel CurrentInspectionInspectorModel;

    private Button finalizeBtn;
    private Button doneBtn;
    private TextView repairComment;
    private EditText repairCommentEdit;
    private LinearLayout tabWrap1;
    private LinearLayout tabWrap2;
    private LinearLayout tabWrap3;
    private ImageView propertyLogo;
    private LinearLayout inspectionImages;
    private LinearLayout repairImages;
    private RelativeLayout largeLayout;
    private ImageView largeImage;
    private ImageView closeImage;
    private ImageView camera;
    private Boolean canEditComment = true;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_incident_detail);

        mApp = (App) getApplication();
        SelectedIncidentModel = mApp.getSelectedIncidentModel();
        backBtn = (ImageView)findViewById(R.id.detail_back);
        tabWrap1 = (LinearLayout)findViewById(R.id.detail_tab1);
        tabWrap2 = (LinearLayout)findViewById(R.id.detail_tab2);
        tabWrap3 = (LinearLayout)findViewById(R.id.detail_tab3);
        camera = (ImageView)findViewById(R.id.detail_camera);

        inspectionImages = (LinearLayout)findViewById(R.id.detail_inspectionImages);
        repairImages = (LinearLayout)findViewById(R.id.detail_repairImages);
        largeLayout= (RelativeLayout)findViewById(R.id.detail_largeLayout);
        largeImage = (ImageView)findViewById(R.id.detail_largeImage);
        closeImage = (ImageView)findViewById(R.id.detail_largeClose);

        propertyLogo = (ImageView)findViewById(R.id.detail_propertyPhoto);
        doneBtn = (Button)findViewById(R.id.detail_commentDone);
        repairComment = (TextView)findViewById(R.id.detail_incidentRepairComments);
        repairCommentEdit = (EditText)findViewById(R.id.detail_incidentRepairCommentsEdit);
        finalizeBtn = (Button)findViewById(R.id.detail_finalizeBtn);
        backBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });

        doneBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                updateRepairComments();
            }
        });

        ((Button)findViewById(R.id.detail_tabBtn1)).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                selectTab(1);
            }
        });

        ((Button)findViewById(R.id.detail_tabBtn2)).setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View v) {
                selectTab(2);
            }
        });

        ((Button)findViewById(R.id.detail_tabBtn3)).setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View v) {
                selectTab(3);
            }
        });

        closeImage.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                largeLayout.setVisibility(View.GONE);
            }
        });

        camera.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(canEditComment) {
                    openCamera();
                }
            }
        });

        largeLayout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

            }
        });

        selectTab(1);
        loadData();
        bindPropertyData();
        bindIncidentData();
        getInspectionPhotos();
        getRepairPhotos();
    }

    private void selectTab(int index){
        if(index == 1){
            tabWrap1.setVisibility(View.VISIBLE);
            tabWrap2.setVisibility(View.GONE);
            tabWrap3.setVisibility(View.GONE);
        }
        else if(index == 2){
            tabWrap1.setVisibility(View.GONE);
            tabWrap2.setVisibility(View.VISIBLE);
            tabWrap3.setVisibility(View.GONE);
        }
        else{
            tabWrap1.setVisibility(View.GONE);
            tabWrap2.setVisibility(View.GONE);
            tabWrap3.setVisibility(View.VISIBLE);
        }
    }

    private void loadData(){
        process = ProgressDialog.show(this,"Loading","Loading data from SharePoint List...");
        new Thread(){
            @Override
            public void run() {
                try {
                    CurrentInspectionInspectorModel = mApp.getDataSource().getInspection(SelectedIncidentModel.getInspectionId());
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

    private void bindPropertyData(){
        ((TextView)findViewById(R.id.detail_propertyName)).setText("Property Name: " + Helper.getString(SelectedIncidentModel.getProperty().getTitle()));
        ((TextView)findViewById(R.id.detail_propertyOwner)).setText("Owner: " + Helper.getString(SelectedIncidentModel.getProperty().getOwner()));
        ((TextView)findViewById(R.id.detail_propertyAddress)).setText(Helper.getString(SelectedIncidentModel.getProperty().getAddress1()));

        getPropertyPhoto();
    }

    private void bindIncidentData(){
        ((TextView)findViewById(R.id.detail_roomTitle)).setText("ROOM: " + Helper.getString(SelectedIncidentModel.getRoom().getTitle()));
        ((TextView)findViewById(R.id.detail_roomType)).setText("TYPE: " + Helper.getString(SelectedIncidentModel.getType()));
        ((TextView)findViewById(R.id.detail_incidentDispatcherComments)).setText(Helper.getString(SelectedIncidentModel.getDispatcherComments()));
        ((TextView)findViewById(R.id.detail_incidentInspectionComments)).setText(Helper.getString(SelectedIncidentModel.getInspectorIncidentComments()));
        ((TextView)findViewById(R.id.detail_incidentRepairComments)).setText(Helper.getString(SelectedIncidentModel.getRepairComments()));
        ((TextView)findViewById(R.id.detail_incidentRepairCommentsEdit)).setText(Helper.getString(SelectedIncidentModel.getRepairComments()));

        if(Helper.IsNullOrEmpty(SelectedIncidentModel.getRepairCompleted())){
            finalizeBtn.setVisibility(View.VISIBLE);
            finalizeBtn.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    updateIncidentRepairCompleted();
                }
            });
        }
        else {
            finalizeBtn.setVisibility(View.INVISIBLE);
        }

        String statusStr = SelectedIncidentModel.getStatus();
        if(!Helper.IsNullOrEmpty(SelectedIncidentModel.getRepairCompleted()) || (!Helper.IsNullOrEmpty(statusStr) && statusStr.equals("Repair Pending Approval")) || (!Helper.IsNullOrEmpty(statusStr) && statusStr.equals("Repair Approved"))){
            setBtnStatus(false);
        }
        else{
            setBtnStatus(true);
        }
    }

    private void bindInspectionData(){
        ((TextView)findViewById(R.id.detail_inspectionName)).setText(CurrentInspectionInspectorModel.getInspector());
        ((TextView)findViewById(R.id.detail_inspectionEmail)).setText(CurrentInspectionInspectorModel.getEmailAddress());
        ((TextView)findViewById(R.id.detail_inspectionDate)).setText(Helper.formatString(CurrentInspectionInspectorModel.getDateTime()));

        final String email = CurrentInspectionInspectorModel.getEmailAddress();
        ((TextView)findViewById(R.id.detail_inspectionEmail)).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                sendEmail(email);
            }
        });
    }

    private void sendEmail(String to){
        Intent intent = new Intent(android.content.Intent.ACTION_SEND);
        intent.setType("plain/text");
        intent.putExtra( android.content.Intent.EXTRA_EMAIL, new String[] {to} );
        intent.putExtra( android.content.Intent.EXTRA_SUBJECT, "");
        intent.putExtra(android.content.Intent.EXTRA_TEXT, "Sent from Android");
        Intent chooserIntent = Intent.createChooser(intent, "Send Email");
        startActivity( chooserIntent );
    }

    private void setBtnStatus(Boolean canEdit){
        if(!canEdit){
            doneBtn.setVisibility(View.GONE);
            repairCommentEdit.setVisibility(View.GONE);
            repairComment.setVisibility(View.VISIBLE);
        }
        else{
            doneBtn.setVisibility(View.VISIBLE);
            repairComment.setVisibility(View.GONE);
            repairCommentEdit.setVisibility(View.VISIBLE);
        }
        canEditComment = canEdit;
    }

    private void updateIncidentRepairCompleted(){
        process = ProgressDialog.show(this,"Processing","Sending data to SharePoint List...");
        new Thread(){
            @Override
            public void run() {
                try {
                    SelectedIncidentModel.setRepairCompleted(Helper.dateToString(new Date()));
                    SelectedIncidentModel.setStatus("Repair Pending Approval");
                    mApp.getDataSource().updateIncidentRepairCompleted(SelectedIncidentModel);
                    if(SelectedIncidentModel.getTaskId() > 0){
                        final int taskId = SelectedIncidentModel.getTaskId();
                        updateIncidentWorkflowTasks(taskId);
                    }
                    else {
                        updateHandler.sendEmptyMessage(Constants.SUCCESS);
                    }
                } catch (Exception e) {
                    Message message = new Message();
                    message.what = Constants.FAILED;
                    message.obj = e.getMessage();
                    updateHandler.sendMessage(message);
                    e.printStackTrace();
                }
            }
        }.start();
    }

    private void updateIncidentWorkflowTasks(final int id){
        new Thread(){
            @Override
            public void run() {
                try {
                    IncidentWorkflowTaskModel model = new IncidentWorkflowTaskModel();
                    model.setId(id);
                    model.setStatus("Completed");
                    model.setPercentComplete("1");
                    mApp.getDataSource().updateIncidentWorkflowTask(model);
                    updateHandler.sendEmptyMessage(Constants.SUCCESS);
                } catch (Exception e) {
                    Message message = new Message();
                    message.what = Constants.FAILED;
                    message.obj = e.getMessage();
                    updateHandler.sendMessage(message);
                    e.printStackTrace();
                }
            }
        }.start();
    }

    private void updateRepairComments(){
        process = ProgressDialog.show(this,"Processing","Sending data to SharePoint List...");
        new Thread(){
            @Override
            public void run() {
                try {
                    SelectedIncidentModel.setRepairComments(repairCommentEdit.getText().toString());
                    mApp.getDataSource().updateIncidentRepairComments(SelectedIncidentModel);
                    updateCommentHandler.sendEmptyMessage(Constants.SUCCESS);
                } catch (Exception e) {
                    Message message = new Message();
                    message.what = Constants.FAILED;
                    message.obj = e.getMessage();
                    updateCommentHandler.sendMessage(message);
                    e.printStackTrace();
                }
            }
        }.start();
    }

    private Handler handler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            if(msg.what == Constants.SUCCESS)
            {
                if(CurrentInspectionInspectorModel!=null){
                    bindInspectionData();
                }
                else{
                    Toast.makeText(IncidentDetailActivity.this, "Load inspection data failed.", Toast.LENGTH_LONG).show();
                }
            }
            else
            {
                Toast.makeText(IncidentDetailActivity.this, "Load inspection inspector data failed.", Toast.LENGTH_LONG).show();
            }
            process.dismiss();
        }
    };

    private Handler updateHandler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            if(msg.what == Constants.SUCCESS)
            {
                sendEmailAfterRepairCompleted();
                finalizeBtn.setVisibility(View.GONE);
                setBtnStatus(false);
                Toast.makeText(IncidentDetailActivity.this, "Finalized repair successfully.", Toast.LENGTH_LONG).show();
            }
            else
            {
                Toast.makeText(IncidentDetailActivity.this, "Finalizing repair failed.", Toast.LENGTH_LONG).show();
            }
            process.dismiss();
        }
    };

    private Handler updateCommentHandler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            if(msg.what == Constants.SUCCESS)
            {
                repairComment.setText(repairCommentEdit.getText().toString());
                Toast.makeText(IncidentDetailActivity.this, "Updated repair comments successfully.", Toast.LENGTH_LONG).show();
            }
            else
            {
                Toast.makeText(IncidentDetailActivity.this, "Updating repair comments failed.", Toast.LENGTH_LONG).show();
            }
            process.dismiss();
        }
    };

    private void sendEmailAfterRepairCompleted(){
        final Handler sendEmailHandler = new Handler() {
            @Override
            public void handleMessage(Message msg) {
                if(msg.what == Constants.SUCCESS)
                {
                    Log.d(TAG, "Send email success.");
                }
                else
                {
                    Log.d(TAG, "Send email failed.");
                }
            }
        };

        new Thread(){
            @Override
            public void run() {
                try {
                    ADALDependencyResolver adalDependencyResolver = new ADALDependencyResolver(mApp.getAuthenticationContext(),
                            Constants.EXCHANGE_RESOURCE_ID, Constants.AAD_CLIENT_ID);
                    OutlookClient outlookClient = new OutlookClient(Constants.ENDPOINT_ID,adalDependencyResolver);

                    EmailAddress toEmailAddress = new EmailAddress();
                    toEmailAddress.setAddress(SelectedIncidentModel.getProperty().getEmail());
                    Recipient toRecipient = new Recipient();
                    toRecipient.setEmailAddress(toEmailAddress);

                    EmailAddress ccEmailAddress = new EmailAddress();
                    ccEmailAddress.setAddress(Constants.DISPATCHEREMAIL);
                    Recipient ccRecipient = new Recipient();
                    ccRecipient.setEmailAddress(ccEmailAddress);

                    ArrayList<Recipient> toRecipients = new ArrayList<Recipient>();
                    toRecipients.add(toRecipient);

                    ArrayList<Recipient> ccRecipients = new ArrayList<Recipient>();
                    ccRecipients.add(ccRecipient);

                    String currentDateStr = Helper.dateToString(new Date());

                    ItemBody body = new ItemBody();
                    body.setContent(String.format("\r\nThe incident found during a recent inspection on you property has been repaired. Photographs taken during the inspection and after the repair are attached to this email." +
                                    "\r\n" +
                                    "\r\nProperty Name: %s" +
                                    "\r\nProperty Address:%s" +
                                    "\r\n" +
                                    "\r\nInspection Date: %s" +
                                    "\r\nIncident Type: %s" +
                                    "\r\nRoom: %s" +
                                    "\r\nComments from the inspector:\r\n%s" +
                                    "\r\n\r\nIncident reported: %s" +
                                    "\r\n" +
                                    "\r\nRepair Date: %s" +
                                    "\r\nComments from repair person:\r\n%s" +
                                    "\r\n" +
                                    "\r\nAttachments:(Inspection & Repair Photos) - Email attachments are not supported at this time in the O365 Android Exchange SDK, therefore no files are attached." +
                                    "\r\n" +
                                    "",
                            Helper.getString(SelectedIncidentModel.getProperty().getTitle()),
                            Helper.getString(SelectedIncidentModel.getProperty().getAddress1()),
                            Helper.formatString(SelectedIncidentModel.getInspection().getDateTime()),
                            Helper.getString(SelectedIncidentModel.getType()),
                            Helper.getString(SelectedIncidentModel.getRoom().getTitle()),
                            Helper.getString(SelectedIncidentModel.getInspectorIncidentComments()),
                            Helper.formatString(SelectedIncidentModel.getDate()),
                            currentDateStr,
                            Helper.getString(SelectedIncidentModel.getRepairComments())
                            ));

                    com.microsoft.outlookservices.Message m = new com.microsoft.outlookservices.Message();
                    m.setToRecipients(toRecipients);
                    m.setCcRecipients(ccRecipients);
                    m.setSubject(String.format("Repair Report - %s - %s",SelectedIncidentModel.getProperty().getTitle(),currentDateStr));
                    m.setBody(body);

                    // prepare message for sending, adding the message to the Drafts folder
                    // this operation is synchronous
                    com.microsoft.outlookservices.Message addedMessage = outlookClient.getMe().getMessages().add(m).get();

                    // send message asynchronously
                    ListenableFuture<Integer> sent = outlookClient.getMe()
                            .getMessages()
                            .getById(addedMessage.getId())
                            .getOperations().send();

                    // handle success and failure cases
                    Futures.addCallback(sent, new FutureCallback<Integer>() {
                        @Override
                        public void onSuccess(final Integer result) {
                            runOnUiThread(new Runnable() {
                                @Override
                                public void run() {
                                    Message message = new Message();
                                    message.what = Constants.SUCCESS;
                                    sendEmailHandler.sendMessage(message);
                                }
                            });
                        }

                        @Override
                        public void onFailure(final Throwable t) {
                            Message message = new Message();
                            message.what = Constants.FAILED;
                            sendEmailHandler.sendMessage(message);
                        }
                    });
                } catch (Exception e) {
                    Message message = new Message();
                    message.what = Constants.FAILED;
                    sendEmailHandler.sendMessage(message);
                    e.printStackTrace();
                }
            }
        }.start();
    }

    private void getPropertyPhoto(){
        final Handler loadPhotoHandler = new Handler() {
            @Override
            public void handleMessage(Message msg) {
                if(msg.what == Constants.SUCCESS)
                {
                    propertyLogo.setImageBitmap((Bitmap)msg.obj);
                    Log.d(TAG, "Load property photos success.");
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


    private void showLargeImage(Bitmap bitmap){
        largeImage.setImageBitmap(bitmap);
        LayoutParams params = largeImage.getLayoutParams();
        int width = bitmap.getWidth() > 1600 ? 1600 : bitmap.getWidth();
        int height = bitmap.getWidth() > 1600 ? bitmap.getHeight() / (bitmap.getWidth()/1600) : bitmap.getHeight();
        if(height > 800){
            width = width / (height / 800);
            height = 800;
        }
        params.width = width;
        params.height = height;
        largeLayout.setVisibility(View.VISIBLE);
    }

    private void getInspectionPhotos(){
        final Handler loadPhotoHandler = new Handler() {
            @Override
            public void handleMessage(Message msg) {
                if(msg.what == Constants.SUCCESS)
                {
                    ImageView imageView = new ImageView(IncidentDetailActivity.this);
                    final Bitmap bitmap = (Bitmap)msg.obj;
                    imageView.setImageBitmap(bitmap);
                    inspectionImages.addView(imageView);
                    LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT,LinearLayout.LayoutParams.WRAP_CONTENT);
                    params.height = 210;
                    params.width = 280;
                    params.setMargins(0,0,20,0);
                    imageView.setLayoutParams(params);
                    imageView.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            showLargeImage(bitmap);
                        }
                    });
                    Log.d(TAG, "Load inspection photos success.");
                }
                else
                {
                    Log.d(TAG,"Load inspection photos failed.");
                }
            }
        };

        new Thread(){
            @Override
            public void run() {
                try {
                    int incidentId = SelectedIncidentModel.getId();
                    int inspectionId = SelectedIncidentModel.getInspectionId();
                    int roomId = SelectedIncidentModel.getRoomId();
                    List<Integer> ids = mApp.getDataSource().getInspectionPhotoIds(incidentId,roomId,inspectionId);
                    if(ids!=null){
                        for (int i = 0;i<ids.size();i++){
                            Bitmap image = FileHelper.getFile(mApp.getToken(), "Room%20Inspection%20Photos", ids.get(i));
                            if(image != null){
                                Message message = new Message();
                                message.what = Constants.SUCCESS;
                                message.obj = image;
                                loadPhotoHandler.sendMessage(message);
                            }
                        }
                    }
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

    private void getRepairPhotos(){
        final Handler loadPhotoHandler = new Handler() {
            @Override
            public void handleMessage(Message msg) {
                if(msg.what == Constants.SUCCESS)
                {
                    ImageView imageView = new ImageView(IncidentDetailActivity.this);
                    final Bitmap bitmap = (Bitmap)msg.obj;
                    imageView.setImageBitmap(bitmap);
                    imageView.setScaleType(ImageView.ScaleType.FIT_XY);
                    repairImages.addView(imageView);
                    LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT,LinearLayout.LayoutParams.WRAP_CONTENT);
                    params.height = 210;
                    params.width = 280;
                    params.setMargins(0,0,20,0);
                    imageView.setLayoutParams(params);
                    imageView.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            showLargeImage(bitmap);
                        }
                    });
                    Log.d(TAG, "Load repair photos success.");
                }
                else
                {
                    Log.d(TAG,"Load repair photos failed.");
                }
            }
        };

        new Thread(){
            @Override
            public void run() {
                try {
                    int incidentId = SelectedIncidentModel.getId();
                    int inspectionId = SelectedIncidentModel.getInspectionId();
                    int roomId = SelectedIncidentModel.getRoomId();
                    List<Integer> ids = mApp.getDataSource().getRepairPhotoIds(incidentId, roomId, inspectionId);
                    if(ids!=null){
                        for (int i = 0;i<ids.size();i++){
                            Bitmap image = FileHelper.getFile(mApp.getToken(), "Repair%20Photos", ids.get(i));
                            if(image != null){
                                Message message = new Message();
                                message.what = Constants.SUCCESS;
                                message.obj = image;
                                loadPhotoHandler.sendMessage(message);
                            }
                        }
                    }
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

    private void uploadPhoto(final Bitmap bitmap){
        process = ProgressDialog.show(this,"Processing","Uploading photo to SharePoint Document Library...");
        final Handler uploadPhotoHandler = new Handler() {
            @Override
            public void handleMessage(Message msg) {
                if(msg.what == Constants.SUCCESS)
                {
                    ImageView imageView = new ImageView(IncidentDetailActivity.this);
                    imageView.setImageBitmap(bitmap);
                    imageView.setScaleType(ImageView.ScaleType.FIT_XY);
                    repairImages.addView(imageView);
                    LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT,LinearLayout.LayoutParams.WRAP_CONTENT);
                    params.height = 210;
                    params.width = 280;
                    params.setMargins(0,0,20,0);
                    imageView.setLayoutParams(params);
                    imageView.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            showLargeImage(bitmap);
                        }
                    });
                    Toast.makeText(IncidentDetailActivity.this, "Uploaded photos successfully.", Toast.LENGTH_LONG).show();
                }
                else
                {
                    Toast.makeText(IncidentDetailActivity.this, "Uploading photos failed.", Toast.LENGTH_LONG).show();
                }
                process.dismiss();
            }
        };

        new Thread(){
            @Override
            public void run() {
                try {
                    String imageName = Helper.getFileName();
                    FileHelper.saveToSDCard(bitmap,imageName);
                    FileHelper.uploadFile(mApp.getToken(), "RepairPhotos", imageName, bitmap);
                    int photoId = FileHelper.getFileId(mApp.getToken(),"RepairPhotos",imageName);
                    RepairPhotoModel repairPhotoModel = new RepairPhotoModel();
                    repairPhotoModel.setId(photoId);
                    repairPhotoModel.setIncidentIDId(SelectedIncidentModel.getId());
                    repairPhotoModel.setInspectionIDId(SelectedIncidentModel.getInspectionId());
                    repairPhotoModel.setRoomIDId(SelectedIncidentModel.getRoomId());
                    mApp.getDataSource().updateRepairPhotoProperty(repairPhotoModel);
                    Message message = new Message();
                    message.what = Constants.SUCCESS;
                    uploadPhotoHandler.sendMessage(message);
                } catch (Exception e) {
                    Message message = new Message();
                    message.what = Constants.FAILED;
                    message.obj = e.getMessage();
                    uploadPhotoHandler.sendMessage(message);
                    e.printStackTrace();
                }
            }
        }.start();
    }

    private void openCamera(){
        Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        startActivityForResult(intent,200);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if(resultCode == RESULT_OK){
            final Bitmap bitmap = (Bitmap)data.getExtras().get("data");
            uploadPhoto(bitmap);
        }
    }
}
