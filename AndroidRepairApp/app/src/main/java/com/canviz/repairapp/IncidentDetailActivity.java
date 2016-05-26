package com.canviz.repairapp;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.provider.MediaStore;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup.LayoutParams;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.canviz.repairapp.data.GroupConversationModel;
import com.canviz.repairapp.data.GroupFileModel;
import com.canviz.repairapp.data.GroupNoteBookModel;
import com.canviz.repairapp.data.GroupVideoModel;
import com.canviz.repairapp.data.IncidentModel;
import com.canviz.repairapp.data.TaskModel;
import com.canviz.repairapp.data.UserModel;
import com.canviz.repairapp.data.IncidentWorkflowTaskModel;
import com.canviz.repairapp.data.InspectionInspectorModel;
import com.canviz.repairapp.data.RepairPhotoModel;
import com.canviz.repairapp.utility.AuthenticationHelper;
import com.canviz.repairapp.utility.FileHelper;
import com.canviz.repairapp.utility.GroupConversationAdapter;
import com.canviz.repairapp.utility.GroupFileAdapter;
import com.canviz.repairapp.utility.GroupMemberAdapter;
import com.canviz.repairapp.utility.GroupNoteAdapter;
import com.canviz.repairapp.utility.Helper;
import com.google.android.gms.appindexing.Action;
import com.google.android.gms.appindexing.AppIndex;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.common.util.concurrent.FutureCallback;
import com.google.common.util.concurrent.Futures;
import com.microsoft.graph.authentication.MSAAuthAndroidAdapter;
import com.microsoft.graph.concurrency.ICallback;
import com.microsoft.graph.core.ClientException;
import com.microsoft.graph.extensions.DirectoryObject;
import com.microsoft.graph.extensions.DriveItem;
import com.microsoft.graph.extensions.Group;
import com.microsoft.graph.extensions.IConversationCollectionPage;
import com.microsoft.graph.extensions.IDirectoryObjectCollectionWithReferencesPage;
import com.microsoft.graph.extensions.IDriveItemCollectionPage;
import com.microsoft.graph.extensions.IDriveRequestBuilder;
import com.microsoft.graph.extensions.IGroupRequestBuilder;
import com.microsoft.graph.extensions.IDirectoryObjectCollectionWithReferencesRequestBuilder;
import com.microsoft.graph.options.HeaderOption;
import com.microsoft.graph.options.Option;
import com.microsoft.services.onenote.Notebook;
import com.microsoft.services.onenote.Page;
import com.microsoft.services.onenote.Section;
import com.microsoft.graph.extensions.EmailAddress;
import com.microsoft.graph.extensions.ItemBody;
import com.microsoft.graph.extensions.Recipient;
import com.microsoft.graph.extensions.User;
import com.microsoft.graph.extensions.IGraphServiceClient;
import com.microsoft.services.orc.serialization.impl.GsonSerializer;

import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

import android.net.Uri;

import org.json.JSONArray;
import org.json.JSONObject;

import java.text.SimpleDateFormat;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.concurrent.ExecutionException;

import java.io.InputStream;


public class IncidentDetailActivity extends Activity {

    private final static String TAG = "IncidentDetailActivity";
    private App mApp;
    GsonSerializer gsonSerializer = new GsonSerializer();
    private ImageView backBtn;
    private ProgressDialog process;
    private IncidentModel SelectedIncidentModel;
    private InspectionInspectorModel CurrentInspectionInspectorModel;
    private Group group;
    private List<UserModel> groupMember = new ArrayList<>();
    private List<GroupFileModel> groupFile = new ArrayList<>();
    private List<GroupFileModel> groupDocument = new ArrayList<>();
    private List<GroupConversationModel> groupConversation = new ArrayList<>();
    private List<GroupNoteBookModel> groupNoteBook = new ArrayList<>();
    private List<GroupVideoModel> groupVideo = new ArrayList<>();
    private GroupMemberAdapter groupMemberAdapter;
    private GroupConversationAdapter groupConversationAdapter;
    private GroupFileAdapter groupDocumentAdapter;
    private GroupFileAdapter groupFileAdapter;
    private GroupNoteAdapter groupNoteAdapter;
    private ListView groupMemberListView;
    private ListView groupConversationListView;
    private ListView groupDocumentListView;
    private ListView groupNoteListView;
    private ListView groupFileListView;
    private static String videoPath;

    private int selectedTabIndex = 1;
    private LinearLayout actionIncidentDetail;
    private LinearLayout actionGroupMember;
    private LinearLayout actionGroupConversation;
    private LinearLayout actionGroupDocument;
    private LinearLayout actionGroupNote;
    private LinearLayout actionGroupDispatcherEmail;
    private LinearLayout actionGroupFile;
    private LinearLayout tabIncidentDetail;
    private LinearLayout tabGroupInfo;
    private LinearLayout tabGroupMember;
    private LinearLayout tabGroupConversation;
    private LinearLayout tabGroupDocument;
    private LinearLayout tabGroupNote;
    private LinearLayout tabGroupFile;

    private String graphToken;
    private IGraphServiceClient graphServiceClient;
    private IGroupRequestBuilder groupRequestBuilder;
    private IDirectoryObjectCollectionWithReferencesRequestBuilder groupMembersBuilder;
    private IDriveRequestBuilder driveRequestBuilder;

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

    private String notebookUrl;
    /**
     * ATTENTION: This was auto-generated to implement the App Indexing API.
     * See https://g.co/AppIndexing/AndroidStudio for more information.
     */
    private GoogleApiClient client;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_incident_detail);

        mApp = (App) getApplication();
        SelectedIncidentModel = mApp.getSelectedIncidentModel();
        backBtn = (ImageView) findViewById(R.id.detail_back);
        tabWrap1 = (LinearLayout) findViewById(R.id.detail_tab1);
        tabWrap2 = (LinearLayout) findViewById(R.id.detail_tab2);
        tabWrap3 = (LinearLayout) findViewById(R.id.detail_tab3);
        camera = (ImageView) findViewById(R.id.detail_camera);

        inspectionImages = (LinearLayout) findViewById(R.id.detail_inspectionImages);
        repairImages = (LinearLayout) findViewById(R.id.detail_repairImages);
        largeLayout = (RelativeLayout) findViewById(R.id.detail_largeLayout);
        largeImage = (ImageView) findViewById(R.id.detail_largeImage);
        closeImage = (ImageView) findViewById(R.id.detail_largeClose);

        propertyLogo = (ImageView) findViewById(R.id.detail_propertyPhoto);
        doneBtn = (Button) findViewById(R.id.detail_commentDone);
        repairComment = (TextView) findViewById(R.id.detail_incidentRepairComments);
        repairCommentEdit = (EditText) findViewById(R.id.detail_incidentRepairCommentsEdit);
        finalizeBtn = (Button) findViewById(R.id.detail_finalizeBtn);
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

        this.groupMemberListView = (ListView) findViewById(R.id.group_member_list);
        this.groupConversationListView = (ListView) findViewById(R.id.group_conversation_list);
        this.groupDocumentListView = (ListView) findViewById(R.id.group_document_list);
        this.groupNoteListView = (ListView) findViewById(R.id.group_note_list);
        this.groupFileListView = (ListView) findViewById(R.id.group_file_list);

        this.actionIncidentDetail = (LinearLayout) findViewById(R.id.incident_details_action);
        this.actionGroupMember = (LinearLayout) findViewById(R.id.group_members_action);
        this.actionGroupConversation = (LinearLayout) findViewById(R.id.group_conversations_action);
        this.actionGroupDocument = (LinearLayout) findViewById(R.id.group_documents_action);
        this.actionGroupNote = (LinearLayout) findViewById(R.id.group_notes_action);
        this.actionGroupDispatcherEmail = (LinearLayout) findViewById(R.id.group_dispatcher_email_action);
        this.actionGroupFile = (LinearLayout) findViewById(R.id.group_files_action);

        this.tabIncidentDetail = (LinearLayout) findViewById(R.id.tab_incident_details);
        this.tabGroupInfo = (LinearLayout) findViewById(R.id.tab_group_info);
        this.tabGroupMember = (LinearLayout) findViewById(R.id.tab_group_members);
        this.tabGroupConversation = (LinearLayout) findViewById(R.id.tab_group_conversations);
        this.tabGroupDocument = (LinearLayout) findViewById(R.id.tab_group_document);
        this.tabGroupNote = (LinearLayout) findViewById(R.id.tab_group_note);
        this.tabGroupFile = (LinearLayout) findViewById(R.id.tab_group_files);

        ((Button) findViewById(R.id.detail_tabBtn1)).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                selectTab(1);
            }
        });

        ((Button) findViewById(R.id.detail_tabBtn2)).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                selectTab(2);
            }
        });

        ((Button) findViewById(R.id.detail_tabBtn3)).setOnClickListener(new View.OnClickListener() {
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
                if (canEditComment) {
                    openCamera();
                }
            }
        });

        largeLayout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

            }
        });

        actionIncidentDetail.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                leftNavAction(1);
            }
        });
        actionGroupMember.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                leftNavAction(2);
            }
        });
        actionGroupConversation.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                leftNavAction(3);
            }
        });
        actionGroupDocument.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                leftNavAction(4);
            }
        });
        actionGroupNote.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                leftNavAction(5);
            }
        });
        actionGroupDispatcherEmail.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                leftNavAction(6);
            }
        });
        actionGroupFile.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                leftNavAction(7);
            }
        });

        leftNavAction(1);
        selectTab(1);
        loadData();
        bindPropertyData();
        bindIncidentData();
        getInspectionPhotos();
        getRepairPhotos();
        getVideo();
        // ATTENTION: This was auto-generated to implement the App Indexing API.
        // See https://g.co/AppIndexing/AndroidStudio for more information.
        client = new GoogleApiClient.Builder(this).addApi(AppIndex.API).build();
    }

    private void selectTab(int index) {
        if (index == 1) {
            tabWrap1.setVisibility(View.VISIBLE);
            tabWrap2.setVisibility(View.GONE);
            tabWrap3.setVisibility(View.GONE);
        } else if (index == 2) {
            tabWrap1.setVisibility(View.GONE);
            tabWrap2.setVisibility(View.VISIBLE);
            tabWrap3.setVisibility(View.GONE);
        } else {
            tabWrap1.setVisibility(View.GONE);
            tabWrap2.setVisibility(View.GONE);
            tabWrap3.setVisibility(View.VISIBLE);
        }
    }

    private void leftNavAction(int index) {
        if (this.selectedTabIndex != index) {
            this.selectedTabIndex = index;
            // show incident details
            if (index == 1) {
                this.tabIncidentDetail.setVisibility(View.VISIBLE);
                this.tabGroupInfo.setVisibility(View.GONE);
            } else {
                this.tabIncidentDetail.setVisibility(View.GONE);
                this.tabGroupInfo.setVisibility(View.VISIBLE);
                if (index == 2) {// group member
                    this.tabGroupMember.setVisibility(View.VISIBLE);
                    this.tabGroupConversation.setVisibility(View.GONE);
                    this.tabGroupDocument.setVisibility(View.GONE);
                    this.tabGroupNote.setVisibility(View.GONE);
                    this.tabGroupFile.setVisibility(View.GONE);
                    loadGroupData(index);
                } else if (index == 3) {// group conversation
                    this.tabGroupMember.setVisibility(View.GONE);
                    this.tabGroupConversation.setVisibility(View.VISIBLE);
                    this.tabGroupDocument.setVisibility(View.GONE);
                    this.tabGroupNote.setVisibility(View.GONE);
                    this.tabGroupFile.setVisibility(View.GONE);
                    loadGroupData(index);
                } else if (index == 4) {// group document
                    this.tabGroupMember.setVisibility(View.GONE);
                    this.tabGroupConversation.setVisibility(View.GONE);
                    this.tabGroupDocument.setVisibility(View.VISIBLE);
                    this.tabGroupNote.setVisibility(View.GONE);
                    this.tabGroupFile.setVisibility(View.GONE);
                    loadGroupData(index);
                } else if (index == 5) {// group note
                    this.tabGroupMember.setVisibility(View.GONE);
                    this.tabGroupConversation.setVisibility(View.GONE);
                    this.tabGroupDocument.setVisibility(View.GONE);
                    this.tabGroupNote.setVisibility(View.VISIBLE);
                    this.tabGroupFile.setVisibility(View.GONE);
                    loadGroupData(index);
                } else if (index == 6) { // dispatcher email
                    sendEmail(Constants.DISPATCHEREMAIL);
                } else if (index == 7) { // group file
                    this.tabGroupMember.setVisibility(View.GONE);
                    this.tabGroupConversation.setVisibility(View.GONE);
                    this.tabGroupDocument.setVisibility(View.GONE);
                    this.tabGroupNote.setVisibility(View.GONE);
                    this.tabGroupFile.setVisibility(View.VISIBLE);
                    loadGroupData(index);
                }
            }
            setLeftNavStyle(index);
        }
    }

    private void setLeftNavStyle(int index) {
        if (index == 1) {
            actionIncidentDetail.setBackgroundColor(getResources().getColor(R.color.white));
            ((ImageView) actionIncidentDetail.findViewWithTag("nav_icon")).setImageDrawable(getResources().getDrawable(R.drawable.left_nav_selected1));
            ((TextView) actionIncidentDetail.findViewWithTag("nav_text")).setTextColor(getResources().getColor(R.color.selected));
        } else {
            actionIncidentDetail.setBackgroundColor(getResources().getColor(R.color.leftBg));
            ((ImageView) actionIncidentDetail.findViewWithTag("nav_icon")).setImageDrawable(getResources().getDrawable(R.drawable.left_nav1));
            ((TextView) actionIncidentDetail.findViewWithTag("nav_text")).setTextColor(getResources().getColor(R.color.blue2));
        }
        if (index == 2) {
            actionGroupMember.setBackgroundColor(getResources().getColor(R.color.white));
            ((ImageView) actionGroupMember.findViewWithTag("nav_icon")).setImageDrawable(getResources().getDrawable(R.drawable.left_nav_selected2));
            ((TextView) actionGroupMember.findViewWithTag("nav_text")).setTextColor(getResources().getColor(R.color.selected));
        } else {
            actionGroupMember.setBackgroundColor(getResources().getColor(R.color.leftBg));
            ((ImageView) actionGroupMember.findViewWithTag("nav_icon")).setImageDrawable(getResources().getDrawable(R.drawable.left_nav2));
            ((TextView) actionGroupMember.findViewWithTag("nav_text")).setTextColor(getResources().getColor(R.color.blue2));
        }
        if (index == 3) {
            actionGroupConversation.setBackgroundColor(getResources().getColor(R.color.white));
            ((ImageView) actionGroupConversation.findViewWithTag("nav_icon")).setImageDrawable(getResources().getDrawable(R.drawable.left_nav_selected3));
            ((TextView) actionGroupConversation.findViewWithTag("nav_text")).setTextColor(getResources().getColor(R.color.selected));
        } else {
            actionGroupConversation.setBackgroundColor(getResources().getColor(R.color.leftBg));
            ((ImageView) actionGroupConversation.findViewWithTag("nav_icon")).setImageDrawable(getResources().getDrawable(R.drawable.left_nav3));
            ((TextView) actionGroupConversation.findViewWithTag("nav_text")).setTextColor(getResources().getColor(R.color.blue2));
        }
        if (index == 4) {
            actionGroupDocument.setBackgroundColor(getResources().getColor(R.color.white));
            ((ImageView) actionGroupDocument.findViewWithTag("nav_icon")).setImageDrawable(getResources().getDrawable(R.drawable.left_nav_selected4));
            ((TextView) actionGroupDocument.findViewWithTag("nav_text")).setTextColor(getResources().getColor(R.color.selected));
        } else {
            actionGroupDocument.setBackgroundColor(getResources().getColor(R.color.leftBg));
            ((ImageView) actionGroupDocument.findViewWithTag("nav_icon")).setImageDrawable(getResources().getDrawable(R.drawable.left_nav4));
            ((TextView) actionGroupDocument.findViewWithTag("nav_text")).setTextColor(getResources().getColor(R.color.blue2));
        }
        if (index == 5) {
            actionGroupNote.setBackgroundColor(getResources().getColor(R.color.white));
            ((ImageView) actionGroupNote.findViewWithTag("nav_icon")).setImageDrawable(getResources().getDrawable(R.drawable.left_nav_selected5));
            ((TextView) actionGroupNote.findViewWithTag("nav_text")).setTextColor(getResources().getColor(R.color.selected));
        } else {
            actionGroupNote.setBackgroundColor(getResources().getColor(R.color.leftBg));
            ((ImageView) actionGroupNote.findViewWithTag("nav_icon")).setImageDrawable(getResources().getDrawable(R.drawable.left_nav5));
            ((TextView) actionGroupNote.findViewWithTag("nav_text")).setTextColor(getResources().getColor(R.color.blue2));
        }
        if (index == 6) {
            actionGroupDispatcherEmail.setBackgroundColor(getResources().getColor(R.color.white));
            ((ImageView) actionGroupDispatcherEmail.findViewWithTag("nav_icon")).setImageDrawable(getResources().getDrawable(R.drawable.left_nav_selected6));
            ((TextView) actionGroupDispatcherEmail.findViewWithTag("nav_text")).setTextColor(getResources().getColor(R.color.selected));
        } else {
            actionGroupDispatcherEmail.setBackgroundColor(getResources().getColor(R.color.leftBg));
            ((ImageView) actionGroupDispatcherEmail.findViewWithTag("nav_icon")).setImageDrawable(getResources().getDrawable(R.drawable.left_nav6));
            ((TextView) actionGroupDispatcherEmail.findViewWithTag("nav_text")).setTextColor(getResources().getColor(R.color.blue2));
        }
        if (index == 7) {
            actionGroupFile.setBackgroundColor(getResources().getColor(R.color.white));
            ((ImageView) actionGroupFile.findViewWithTag("nav_icon")).setImageDrawable(getResources().getDrawable(R.drawable.left_nav_selected7));
            ((TextView) actionGroupFile.findViewWithTag("nav_text")).setTextColor(getResources().getColor(R.color.selected));
        } else {
            actionGroupFile.setBackgroundColor(getResources().getColor(R.color.leftBg));
            ((ImageView) actionGroupFile.findViewWithTag("nav_icon")).setImageDrawable(getResources().getDrawable(R.drawable.left_nav7));
            ((TextView) actionGroupFile.findViewWithTag("nav_text")).setTextColor(getResources().getColor(R.color.blue2));
        }
    }

    private void showMessage(String message, boolean hideProcess) {
        if (message != null) {
            Toast.makeText(IncidentDetailActivity.this, message, Toast.LENGTH_SHORT).show();
        }
        if (hideProcess) {
            process.dismiss();
        }
    }

    private void loadData() {
        process = ProgressDialog.show(this, "Loading", "Loading data from SharePoint List...");
        new Thread() {
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

    private void bindPropertyData() {
        ((TextView) findViewById(R.id.detail_propertyName)).setText("Property Name: " + Helper.getString(SelectedIncidentModel.getProperty().getTitle()));
        ((TextView) findViewById(R.id.detail_propertyOwner)).setText("Owner: " + Helper.getString(SelectedIncidentModel.getProperty().getOwner()));
        ((TextView) findViewById(R.id.detail_propertyAddress)).setText(Helper.getString(SelectedIncidentModel.getProperty().getAddress1()));

        getPropertyPhoto();
    }

    private void bindIncidentData() {
        ((TextView) findViewById(R.id.detail_roomTitle)).setText("ROOM: " + Helper.getString(SelectedIncidentModel.getRoom().getTitle()));
        ((TextView) findViewById(R.id.detail_roomType)).setText("TYPE: " + Helper.getString(SelectedIncidentModel.getType()));
        ((TextView) findViewById(R.id.detail_incidentDispatcherComments)).setText(Helper.getString(SelectedIncidentModel.getDispatcherComments()));
        ((TextView) findViewById(R.id.detail_incidentInspectionComments)).setText(Helper.getString(SelectedIncidentModel.getInspectorIncidentComments()));
        ((TextView) findViewById(R.id.detail_incidentRepairComments)).setText(Helper.getString(SelectedIncidentModel.getRepairComments()));
        ((TextView) findViewById(R.id.detail_incidentRepairCommentsEdit)).setText(Helper.getString(SelectedIncidentModel.getRepairComments()));

        if (Helper.IsNullOrEmpty(SelectedIncidentModel.getRepairCompleted())) {
            finalizeBtn.setVisibility(View.VISIBLE);
            finalizeBtn.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    updateIncidentRepairCompleted();
                }
            });
        } else {
            finalizeBtn.setVisibility(View.INVISIBLE);
        }

        String statusStr = SelectedIncidentModel.getStatus();
        if (!Helper.IsNullOrEmpty(SelectedIncidentModel.getRepairCompleted()) || (!Helper.IsNullOrEmpty(statusStr) && statusStr.equals("Repair Pending Approval")) || (!Helper.IsNullOrEmpty(statusStr) && statusStr.equals("Repair Approved"))) {
            setBtnStatus(false);
        } else {
            setBtnStatus(true);
        }
    }

    private void bindInspectionData() {
        ((TextView) findViewById(R.id.detail_inspectionName)).setText(CurrentInspectionInspectorModel.getInspector());
        ((TextView) findViewById(R.id.detail_inspectionEmail)).setText(CurrentInspectionInspectorModel.getEmailAddress());
        ((TextView) findViewById(R.id.detail_inspectionDate)).setText(Helper.formatString(CurrentInspectionInspectorModel.getDateTime()));

        final String email = CurrentInspectionInspectorModel.getEmailAddress();
        ((TextView) findViewById(R.id.detail_inspectionEmail)).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                sendEmail(email);
            }
        });
    }

    private void sendEmail(String to) {
        Intent intent = new Intent(Intent.ACTION_SEND);
        intent.setType("plain/text");
        intent.putExtra(Intent.EXTRA_EMAIL, new String[]{to});
        intent.putExtra(Intent.EXTRA_SUBJECT, "");
        intent.putExtra(Intent.EXTRA_TEXT, "Sent from Android");
        Intent chooserIntent = Intent.createChooser(intent, "Send Email");
        startActivity(chooserIntent);
    }

    private void setBtnStatus(Boolean canEdit) {
        if (!canEdit) {
            doneBtn.setVisibility(View.GONE);
            repairCommentEdit.setVisibility(View.GONE);
            repairComment.setVisibility(View.VISIBLE);
        } else {
            doneBtn.setVisibility(View.VISIBLE);
            repairComment.setVisibility(View.GONE);
            repairCommentEdit.setVisibility(View.VISIBLE);
        }
        canEditComment = canEdit;
    }

    private void updateIncidentRepairCompleted() {
        process = ProgressDialog.show(this, "Processing", "Sending data to SharePoint List...");
        new Thread() {
            @Override
            public void run() {
                try {
                    SelectedIncidentModel.setRepairCompleted(Helper.dateToString(new Date()));
                    SelectedIncidentModel.setStatus("Repair Pending Approval");
                    mApp.getDataSource().updateIncidentRepairCompleted(SelectedIncidentModel);
                    if (SelectedIncidentModel.getTaskId() > 0) {
                        final int taskId = SelectedIncidentModel.getTaskId();
                        updateIncidentWorkflowTasks(taskId);
                    } else {
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

    private void updateIncidentWorkflowTasks(final int id) {
        new Thread() {
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

    private void updateRepairComments() {
        process = ProgressDialog.show(this, "Processing", "Sending data to SharePoint List...");
        new Thread() {
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
            if (msg.what == Constants.SUCCESS) {
                if (CurrentInspectionInspectorModel != null) {
                    bindInspectionData();
                } else {
                    Toast.makeText(IncidentDetailActivity.this, "Loading inspection data failed.", Toast.LENGTH_LONG).show();
                }
            } else {
                Toast.makeText(IncidentDetailActivity.this, "Loading inspection inspector data failed.", Toast.LENGTH_LONG).show();
            }
            process.dismiss();
        }
    };

    private Handler updateHandler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            if (msg.what == Constants.SUCCESS) {
                sendEmailAfterRepairCompleted();
                finalizeBtn.setVisibility(View.GONE);
                setBtnStatus(false);
                updateTasks();
            } else {
                Toast.makeText(IncidentDetailActivity.this, "Finalizing repair failed.", Toast.LENGTH_LONG).show();
                process.dismiss();
            }

        }
    };

    private void updateTasks() {
        final Handler updateTasksHandler = new Handler() {
            @Override
            public void handleMessage(Message msg) {
                Toast.makeText(IncidentDetailActivity.this, "Finalized repair successfully.", Toast.LENGTH_LONG).show();
                process.dismiss();
            }
        };

        final MediaType JSON = MediaType.parse("application/json; charset=utf-8");
        try {
            Futures.addCallback(AuthenticationHelper.getGraphAccessToken(), new FutureCallback<String>() {
                @Override
                public void onSuccess(final String token) {
                    new Thread() {
                        @Override
                        public void run() {
                            try {
                                String planId = getPlanId(token, SelectedIncidentModel.getProperty().getGroup());
                                if (planId != null) {
                                    String bucketId = getBucketId(token, planId, String.format("Incident [%d]", SelectedIncidentModel.getId()));
                                    if (bucketId != null) {
                                        List<TaskModel> tasks = getTasks(token, bucketId);
                                        if (tasks.size() > 0) {
                                            RequestBody body = RequestBody.create(JSON, "{'percentComplete': 100}");
                                            for (int i = 0; i < tasks.size(); i++) {
                                                String requestUrl = String.format("%sTasks/%s", Constants.GRAPH_BETA_RESOURCE_URL, tasks.get(i).getTaskID());
                                                OkHttpClient client = new OkHttpClient();
                                                Request request = new Request.Builder()
                                                        .url(requestUrl)
                                                        .addHeader("accept", "application/json")
                                                        .addHeader("ContentType", "application/json")
                                                        .addHeader("If-Match", tasks.get(i).getEtag())
                                                        .addHeader("Authorization", MSAAuthAndroidAdapter.OAUTH_BEARER_PREFIX + token)
                                                        .patch(body)
                                                        .build();
                                                Response response = client.newCall(request).execute();
                                                if (response.code() == 204) {
                                                    Log.d(TAG, "Update task width id: " + tasks.get(i).getTaskID() + " successfully.");
                                                }
                                            }
                                            updateTasksHandler.sendEmptyMessage(0);
                                        } else {
                                            updateTasksHandler.sendEmptyMessage(0);
                                        }
                                    } else {
                                        updateTasksHandler.sendEmptyMessage(0);
                                    }
                                } else {
                                    updateTasksHandler.sendEmptyMessage(0);
                                }
                            } catch (Throwable t) {
                                updateTasksHandler.sendEmptyMessage(0);
                            }
                        }

                    }.start();
                }

                @Override
                public void onFailure(Throwable t) {
                    Log.d(TAG, "Get graph access token failed.");
                    updateTasksHandler.sendEmptyMessage(0);
                }
            });
        } catch (Throwable t) {
            Log.d(TAG, "Update tasks failed.");
            updateTasksHandler.sendEmptyMessage(0);
        }
    }

    private List<TaskModel> getTasks(String token, String bucketId) throws Exception {
        List<TaskModel> list = new ArrayList<TaskModel>();
        String requestUrl = String.format("%sbuckets/%s/Tasks", Constants.GRAPH_BETA_RESOURCE_URL, bucketId);
        OkHttpClient okHttpClient = new OkHttpClient();
        Request request = new Request.Builder()
                .url(requestUrl)
                .addHeader("Authorization ", "Bearer " + token)
                .addHeader("accept", "application/json")
                .get()
                .build();
        Response response = okHttpClient.newCall(request).execute();
        if (response.code() == 200) {
            JSONObject jsonObject = new JSONObject(response.body().string());
            JSONArray jsonArray = jsonObject.getJSONArray("value");
            for (int i = 0; i < jsonArray.length(); i++) {
                TaskModel model = new TaskModel();
                model.setTaskID(jsonArray.getJSONObject(i).getString("id"));
                model.setEtag(jsonArray.getJSONObject(i).getString("@odata.etag"));
                list.add(model);
            }
        }
        return list;
    }

    private String getPlanId(String token, String groupId) throws Exception {
        String requestUrl = String.format("%sgroups/%s/plans", Constants.GRAPH_BETA_RESOURCE_URL, groupId);
        OkHttpClient okHttpClient = new OkHttpClient();
        Request request = new Request.Builder()
                .url(requestUrl)
                .addHeader("Authorization ", "Bearer " + token)
                .addHeader("accept", "application/json")
                .get()
                .build();
        Response response = okHttpClient.newCall(request).execute();
        if (response.code() == 200) {
            JSONObject jsonObject = new JSONObject(response.body().string());
            JSONArray jsonArray = jsonObject.getJSONArray("value");
            return jsonArray.getJSONObject(0).getString("id");
        }
        return null;
    }

    private String getBucketId(String token, String planId, String bucketName) throws Exception {
        String requestUrl = String.format("%splans/%s/Buckets", Constants.GRAPH_BETA_RESOURCE_URL, planId);
        OkHttpClient okHttpClient = new OkHttpClient();
        Request request = new Request.Builder()
                .url(requestUrl)
                .addHeader("Authorization ", "Bearer " + token)
                .addHeader("accept", "application/json")
                .get()
                .build();
        Response response = okHttpClient.newCall(request).execute();
        if (response.code() == 200) {
            JSONObject jsonObject = new JSONObject(response.body().string());
            JSONArray jsonArray = jsonObject.getJSONArray("value");
            for (int i = 0; i < jsonArray.length(); i++) {
                if (jsonArray.getJSONObject(i).getString("name").equals(bucketName)) {
                    return jsonArray.getJSONObject(i).getString("id");
                }
            }
        }
        return null;
    }

    private Notebook getNotebook(String token, String groupId, String notebookName) throws Exception {
        String requestUrl = String.format("%sgroups/%s/notes/notebooks?$filter=name eq '%s'&$top=1", Constants.GRAPH_BETA_RESOURCE_URL, groupId, notebookName);
        OkHttpClient okHttpClient = new OkHttpClient();
        Request request = new Request.Builder()
                .url(requestUrl)
                .addHeader("Authorization ", "Bearer " + token)
                .addHeader("accept", "application/json")
                .get()
                .build();
        Response response = okHttpClient.newCall(request).execute();
        if (response.code() == 200) {
            JSONObject jsonObject = new JSONObject(response.body().string());
            JSONArray jsonArray = jsonObject.getJSONArray("value");
            if (jsonArray.length() == 1){
                Notebook notebook = gsonSerializer.deserialize(jsonArray.getString(0), Notebook.class);
                return notebook;
            }
        }
        return null;
    }

    private Section getNotebookSection(String token, String groupId, String sectionName) throws Exception {
        String requestUrl = String.format("%sgroups/%s/notes/sections?$filter=name eq '%s'&$top=1", Constants.GRAPH_BETA_RESOURCE_URL, groupId, sectionName);
        OkHttpClient okHttpClient = new OkHttpClient();
        Request request = new Request.Builder()
                .url(requestUrl)
                .addHeader("Authorization ", "Bearer " + token)
                .addHeader("accept", "application/json")
                .get()
                .build();
        Response response = okHttpClient.newCall(request).execute();
        if (response.code() == 200) {
            JSONObject jsonObject = new JSONObject(response.body().string());
            JSONArray jsonArray = jsonObject.getJSONArray("value");
            if (jsonArray.length() == 1){
                Section section = gsonSerializer.deserialize(jsonArray.getString(0), Section.class);
                return section;
            }
        }
        return null;
    }

    private List<Page> getNotebookPages(String token, String groupId, String sectionId, int incidentId) throws Exception {
        String requestUrl = String.format("%sgroups/%s/notes/sections/%s/pages?$filter=title eq 'Incident[%s]'", Constants.GRAPH_BETA_RESOURCE_URL, groupId, sectionId, incidentId);
        OkHttpClient okHttpClient = new OkHttpClient();
        Request request = new Request.Builder()
                .url(requestUrl)
                .addHeader("Authorization ", "Bearer " + token)
                .addHeader("accept", "application/json")
                .get()
                .build();
        Response response = okHttpClient.newCall(request).execute();
        if (response.code() == 200) {
            JSONObject jsonObject = new JSONObject(response.body().string());
            JSONArray jsonArray = jsonObject.getJSONArray("value");
            List<Page> pages = new ArrayList();
            for (int i = 0; i < jsonArray.length(); i++) {
                Page page = gsonSerializer.deserialize(jsonArray.getString(i), Page.class);
                pages.add(page);
            }
            return pages;
        }
        return null;
    }

    private Handler updateCommentHandler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            if (msg.what == Constants.SUCCESS) {
                repairComment.setText(repairCommentEdit.getText().toString());
                Toast.makeText(IncidentDetailActivity.this, "Updated repair comments successfully.", Toast.LENGTH_LONG).show();
            } else {
                Toast.makeText(IncidentDetailActivity.this, "Updating repair comments failed.", Toast.LENGTH_LONG).show();
            }
            process.dismiss();
        }
    };

    private void sendEmailAfterRepairCompleted() {
        final Handler sendEmailHandler = new Handler() {
            @Override
            public void handleMessage(Message msg) {
                if (msg.what == Constants.SUCCESS) {
                    Log.d(TAG, "Sent email successfully.");
                } else {
                    Log.d(TAG, "Sending email failed.");
                }
            }
        };

        new Thread() {
            @Override
            public void run() {
                EmailAddress toEmailAddress = new EmailAddress();
                toEmailAddress.address = SelectedIncidentModel.getProperty().getEmail();
                Recipient toRecipient = new Recipient();
                toRecipient.emailAddress = toEmailAddress;

                EmailAddress ccEmailAddress = new EmailAddress();
                ccEmailAddress.address = Constants.DISPATCHEREMAIL;
                Recipient ccRecipient = new Recipient();
                ccRecipient.emailAddress = ccEmailAddress;

                ArrayList<Recipient> toRecipients = new ArrayList<>();
                toRecipients.add(toRecipient);

                ArrayList<Recipient> ccRecipients = new ArrayList<>();
                ccRecipients.add(ccRecipient);

                String currentDateStr = Helper.dateToString(new Date());

                ItemBody body = new ItemBody();
                body.content = String.format("\r\nThe incident found during a recent inspection on you property has been repaired. Photographs taken during the inspection and after the repair are attached to this email." +
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
                                "\r\nAttachments:(Inspection & Repair Photos) - Email attachments are not supported at this time in the O365 Android Graph SDK, therefore no files are attached." +
                                "\r\n\r\n\r\nIncident ID: %s" +
                                "\r\nProperty ID: %s",
                        Helper.getString(SelectedIncidentModel.getProperty().getTitle()),
                        Helper.getString(SelectedIncidentModel.getProperty().getAddress1()),
                        Helper.formatString(SelectedIncidentModel.getInspection().getDateTime()),
                        Helper.getString(SelectedIncidentModel.getType()),
                        Helper.getString(SelectedIncidentModel.getRoom().getTitle()),
                        Helper.getString(SelectedIncidentModel.getInspectorIncidentComments()),
                        Helper.formatString(SelectedIncidentModel.getDate()),
                        currentDateStr,
                        Helper.getString(SelectedIncidentModel.getRepairComments()),
                        SelectedIncidentModel.getId(),
                        SelectedIncidentModel.getPropertyId()
                );

                final com.microsoft.graph.extensions.Message message = new com.microsoft.graph.extensions.Message();
                message.toRecipients = toRecipients;
                message.ccRecipients = ccRecipients;
                message.subject = String.format("Repair Report - %s - %s", SelectedIncidentModel.getProperty().getTitle(), currentDateStr);
                message.body = body;

                // Send Email with GraphServiceClient
                Futures.addCallback(AuthenticationHelper.getGraphAccessToken(), new FutureCallback<String>() {
                    @Override
                    public void onSuccess(final String token) {
                        graphToken = token;
                        if (graphServiceClient == null) {
                            graphServiceClient = getGraphServiceClient();
                        }
                        graphServiceClient
                                .getMe()
                                .getSendMail(message, true)
                                .buildRequest()
                                .post(new ICallback<Void>() {
                                    @Override
                                    public void success(Void aVoid) {
                                        Message m = new Message();
                                        m.what = Constants.SUCCESS;
                                        sendEmailHandler.sendMessage(m);
                                    }

                                    @Override
                                    public void failure(ClientException ex) {
                                        Message m = new Message();
                                        m.what = Constants.FAILED;
                                        sendEmailHandler.sendMessage(m);
                                        ex.printStackTrace();
                                    }
                                });
                    }

                    @Override
                    public void onFailure(Throwable t) {
                        Message m = new Message();
                        m.what = Constants.FAILED;
                        sendEmailHandler.sendMessage(m);
                        t.printStackTrace();
                    }
                });
            }
        }.start();
    }

    private void getPropertyPhoto() {
        final Handler loadPhotoHandler = new Handler() {
            @Override
            public void handleMessage(Message msg) {
                if (msg.what == Constants.SUCCESS) {
                    propertyLogo.setImageBitmap((Bitmap) msg.obj);
                    Log.d(TAG, "Loaded property photos successfully.");
                } else {
                    Log.d(TAG, "Loading property photos failed.");
                }
            }
        };

        new Thread() {
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


    private void showLargeImage(Bitmap bitmap) {
        largeImage.setImageBitmap(bitmap);
        LayoutParams params = largeImage.getLayoutParams();
        int width = bitmap.getWidth() > 1600 ? 1600 : bitmap.getWidth();
        int height = bitmap.getWidth() > 1600 ? bitmap.getHeight() / (bitmap.getWidth() / 1600) : bitmap.getHeight();
        if (height > 800) {
            width = width / (height / 800);
            height = 800;
        }
        params.width = width;
        params.height = height;
        largeLayout.setVisibility(View.VISIBLE);
    }

    private void getInspectionPhotos() {
        final Handler loadPhotoHandler = new Handler() {
            @Override
            public void handleMessage(Message msg) {
                if (msg.what == Constants.SUCCESS) {
                    ImageView imageView = new ImageView(IncidentDetailActivity.this);
                    final Bitmap bitmap = (Bitmap) msg.obj;
                    imageView.setImageBitmap(bitmap);
                    inspectionImages.addView(imageView);
                    LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
                    params.height = 210;
                    params.width = 280;
                    params.setMargins(0, 0, 20, 0);
                    imageView.setLayoutParams(params);
                    imageView.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            showLargeImage(bitmap);
                        }
                    });
                    Log.d(TAG, "Loaded inspection photos successfully.");
                } else {
                    Log.d(TAG, "Loading inspection photos failed.");
                }
            }
        };

        new Thread() {
            @Override
            public void run() {
                try {
                    int incidentId = SelectedIncidentModel.getId();
                    int inspectionId = SelectedIncidentModel.getInspectionId();
                    int roomId = SelectedIncidentModel.getRoomId();
                    List<Integer> ids = mApp.getDataSource().getInspectionPhotoIds(incidentId, roomId, inspectionId);
                    if (ids != null) {
                        for (int i = 0; i < ids.size(); i++) {
                            Bitmap image = FileHelper.getFile(mApp.getToken(), "Room%20Inspection%20Photos", ids.get(i));
                            if (image != null) {
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

    private void getRepairPhotos() {
        final Handler loadPhotoHandler = new Handler() {
            @Override
            public void handleMessage(Message msg) {
                if (msg.what == Constants.SUCCESS) {
                    ImageView imageView = new ImageView(IncidentDetailActivity.this);
                    final Bitmap bitmap = (Bitmap) msg.obj;
                    imageView.setImageBitmap(bitmap);
                    imageView.setScaleType(ImageView.ScaleType.FIT_XY);
                    repairImages.addView(imageView);
                    LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
                    params.height = 210;
                    params.width = 280;
                    params.setMargins(0, 0, 20, 0);
                    imageView.setLayoutParams(params);
                    imageView.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            showLargeImage(bitmap);
                        }
                    });
                    Log.d(TAG, "Loaded repair photos successfully.");
                } else {
                    Log.d(TAG, "Loading repair photos failed.");
                }
            }
        };

        new Thread() {
            @Override
            public void run() {
                try {
                    int incidentId = SelectedIncidentModel.getId();
                    int inspectionId = SelectedIncidentModel.getInspectionId();
                    int roomId = SelectedIncidentModel.getRoomId();
                    List<Integer> ids = mApp.getDataSource().getRepairPhotoIds(incidentId, roomId, inspectionId);
                    if (ids != null) {
                        for (int i = 0; i < ids.size(); i++) {
                            Bitmap image = FileHelper.getFile(mApp.getToken(), "Repair%20Photos", ids.get(i));
                            if (image != null) {
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

    private void uploadPhoto(final Bitmap bitmap) {
        process = ProgressDialog.show(this, "Processing", "Uploading photo to SharePoint Document Library...");
        final Handler uploadPhotoHandler = new Handler() {
            @Override
            public void handleMessage(Message msg) {
                if (msg.what == Constants.SUCCESS) {
                    ImageView imageView = new ImageView(IncidentDetailActivity.this);
                    imageView.setImageBitmap(bitmap);
                    imageView.setScaleType(ImageView.ScaleType.FIT_XY);
                    repairImages.addView(imageView);
                    LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
                    params.height = 210;
                    params.width = 280;
                    params.setMargins(0, 0, 20, 0);
                    imageView.setLayoutParams(params);
                    imageView.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            showLargeImage(bitmap);
                        }
                    });
                    Toast.makeText(IncidentDetailActivity.this, "Uploaded photos successfully.", Toast.LENGTH_LONG).show();
                } else {
                    Toast.makeText(IncidentDetailActivity.this, "Uploading photos failed.", Toast.LENGTH_LONG).show();
                }
                process.dismiss();
            }
        };

        new Thread() {
            @Override
            public void run() {
                try {
                    String imageName = Helper.getFileName();
                    FileHelper.saveToSDCard(bitmap, imageName);
                    FileHelper.uploadFile(mApp.getToken(), "RepairPhotos", imageName, bitmap);
                    int photoId = FileHelper.getFileId(mApp.getToken(), "RepairPhotos", imageName);
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

    /* Load group member/files/conversation/notebook/video */
    private void loadGroupData(final int type) {
        final Handler handler = new Handler() {
            @Override
            public void handleMessage(Message msg) {
                if (msg.what == Constants.SUCCESS) {
                    if (type == 2) {
                        if (groupMember.size() == 0) {
                            process = ProgressDialog.show(IncidentDetailActivity.this, "Loading", "Loading group members...");
                            getGroupMembers();
                        }
                    } else if (type == 3) {
                        if (groupConversation.size() == 0) {
                            process = ProgressDialog.show(IncidentDetailActivity.this, "Loading", "Loading group conversations...");
                            getGroupConversation();
                        }
                    } else if (type == 4) {
                        if (groupFile.size() == 0) {
                            process = ProgressDialog.show(IncidentDetailActivity.this, "Loading", "Loading group documents...");
                            getGroupFiles("document");
                        } else {
                            bindGroupDocument();
                        }
                    } else if (type == 5) {
                        if (groupNoteBook.size() == 0) {
                            process = ProgressDialog.show(IncidentDetailActivity.this, "Loading", "Loading group notebooks...");
                            getGroupNoteBooks();
                        } else {
                            bindGroupNote(notebookUrl);
                        }
                    } else if (type == 7) {
                        if (groupFile.size() == 0) {
                            process = ProgressDialog.show(IncidentDetailActivity.this, "Loading", "Loading group files...");
                            getGroupFiles("file");
                        } else {
                            bindGroupFile();
                        }
                    }
                } else {
                    showMessage("Get group data failed", true);
                }
            }
        };

        new Thread() {
            @Override
            public void run() {
                try {
                    if (type == 2 || type == 3 || type == 4 || type == 5 || type == 7) { // group member/conversation/file/document
                        if (groupRequestBuilder == null) {
                            Futures.addCallback(AuthenticationHelper.getGraphAccessToken(), new FutureCallback<String>() {
                                @Override
                                public void onSuccess(final String token) {
                                    graphToken = token;
                                    groupRequestBuilder = getGroupRequestBuilder();
                                    groupRequestBuilder
                                            .buildRequest()
                                            .get(new ICallback<Group>() {
                                                @Override
                                                public void success(Group result) {
                                                    if (result != null) {
                                                        group = result;
                                                        Message m = new Message();
                                                        m.what = Constants.SUCCESS;
                                                        handler.sendMessage(m);
                                                    } else {
                                                        new Exception("Group does not exist.");
                                                    }
                                                }

                                                @Override
                                                public void failure(ClientException ex) {
                                                    new Exception("Group does not exist.");
                                                }
                                            });
                                }

                                @Override
                                public void onFailure(Throwable t) {
                                    Message m = new Message();
                                    m.what = Constants.FAILED;
                                    handler.sendMessage(m);
                                    t.printStackTrace();
                                }
                            });
                        } else {
                            Message m = new Message();
                            m.what = Constants.SUCCESS;
                            handler.sendMessage(m);
                        }
                    } else {
                        Message m = new Message();
                        m.what = Constants.SUCCESS;
                        handler.sendMessage(m);
                    }
                } catch (Exception e) {
                    Message m = new Message();
                    m.what = Constants.FAILED;
                    handler.sendMessage(m);
                    e.printStackTrace();
                }
            }
        }.start();
    }

    /* Group members */
    private void getGroupMembers() {
        try {
            if (groupMembersBuilder == null) {
                groupMembersBuilder = getGroupMembersRequestBuilder();
                groupMembersBuilder
                        .buildRequest()
                        .get(new ICallback<IDirectoryObjectCollectionWithReferencesPage>() {
                                @Override
                                public void success(IDirectoryObjectCollectionWithReferencesPage page) {
                                    final List<DirectoryObject> members = page.getCurrentPage();
                                    for (DirectoryObject member : members) {
                                        graphServiceClient
                                                .getUsers(member.id)
                                                .buildRequest()
                                                .get(new ICallback<User>(){
                                                        @Override
                                                        public void success(User user) {
                                                            UserModel model = new UserModel();
                                                            model.setId(user.id);
                                                            model.setName(user.displayName);
                                                            model.setMail(user.mail);
                                                            groupMember.add(model);
                                                            if (groupMember.size() == members.size()){
                                                                runOnUiThread(new Runnable() {
                                                                    @Override
                                                                    public void run() {
                                                                        showMessage("Loaded group members successfully.", true);
                                                                        bindGroupMember();
                                                                    }
                                                                });
                                                            }
                                                        }

                                                        @Override
                                                        public void failure(ClientException ex) {
                                                            runOnUiThread(new Runnable() {
                                                                @Override
                                                                public void run() {
                                                                    showMessage("Loading group members failed.", true);
                                                                }
                                                            });
                                                        }
                                                    });
                                    }
                                }

                                @Override
                                public void failure(ClientException ex) {
                                    runOnUiThread(new Runnable() {
                                        @Override
                                        public void run() {
                                            showMessage("Loading group members failed.", true);
                                        }
                                    });
                                }
                            });
            }
        } catch (Exception e) {
            showMessage("Loading group members failed.", true);
            e.printStackTrace();
        }
    }

    /* Group files */
    private void getGroupFiles(final String name) {
        try {
            if (groupRequestBuilder == null){
                groupRequestBuilder = getGroupRequestBuilder();
            }
            groupRequestBuilder
                    .getDrive()
                    .getRoot()
                    .getChildren()
                    .buildRequest()
                    .get(new ICallback<IDriveItemCollectionPage>() {
                            @Override
                            public void success(IDriveItemCollectionPage page) {
                                List<DriveItem> items = page.getCurrentPage();
                                for (com.microsoft.graph.extensions.DriveItem file : items) {
                                    GroupFileModel model = new GroupFileModel();
                                    model.setTitle(file.name);
                                    model.setUrl(file.webUrl);
                                    model.setOWAUrl(file.webUrl, file.name, file.eTag);
                                    model.setLastModified(file.lastModifiedDateTime);
                                    model.setLastModifiedBy(file.lastModifiedBy.user.displayName);
                                    model.setSize(file.size);
                                    groupFile.add(model);
                                }
                                runOnUiThread(new Runnable() {
                                    @Override
                                    public void run() {
                                        showMessage("Loaded group " + name + " successfully.", true);
                                        if (name == "file") {
                                            bindGroupFile();
                                        } else {
                                            bindGroupDocument();
                                        }
                                    }
                                });
                            }

                            @Override
                            public void failure(ClientException ex) {
                                runOnUiThread(new Runnable() {
                                    @Override
                                    public void run() {
                                        showMessage("Loading group " + name + " failed.", true);
                                    }
                                });
                            }
                        });
        } catch (Exception e) {
            showMessage("Loading group " + name + " failed.", true);
            e.printStackTrace();
        }
    }

    /* Group conversation */
    private void getGroupConversation() {
        try {
            if (groupRequestBuilder == null) {
                groupRequestBuilder = getGroupRequestBuilder();
            }
            groupRequestBuilder
                    .getConversations()
                    .buildRequest()
                    .get(new ICallback<IConversationCollectionPage>() {
                            @Override
                            public void success(IConversationCollectionPage page) {
                                List<com.microsoft.graph.extensions.Conversation> conversations = page.getCurrentPage();
                                for (com.microsoft.graph.extensions.Conversation item : conversations) {
                                    GroupConversationModel model = new GroupConversationModel();
                                    model.setTitle(item.topic);
                                    model.setPreview(item.preview);
                                    model.setUrl(Constants.OUTLOOK_RESOURCE_ID + "owa/#path=/group/" + group.mail + "/mail");
                                    groupConversation.add(model);
                                }
                                runOnUiThread(new Runnable() {
                                    @Override
                                    public void run() {
                                        showMessage("Loaded group conversations successfully.", true);
                                        bindGroupConversation();
                                    }
                                });
                            }

                            @Override
                            public void failure(ClientException ex) {
                                runOnUiThread(new Runnable() {
                                    @Override
                                    public void run() {
                                        showMessage("Loading group conversations failed.", true);
                                    }
                                });
                            }
                        });
        } catch (Exception e) {
            showMessage("Loading group conversations failed.", true);
            e.printStackTrace();
        }
    }

    /* Group notebooks */
    private void getGroupNoteBooks() {
        new Thread() {
            @Override
            public void run() {
                try {
                    String groupId = group.id;
                    String groupNotebookName = (group.displayName + " Notebook").replace(" ", "%20");
                    Notebook notebook = getNotebook(graphToken, groupId, groupNotebookName);
                    if (notebook == null){
                        runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                showMessage("No notebook found.", true);
                            }
                        });
                        return;
                    }
                    notebookUrl = notebook.getLinks().getOneNoteWebUrl().getHref();
                    Section section = getNotebookSection(graphToken, groupId, group.displayName);
                    if (section == null){
                        runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                showMessage("Loaded group notebooks successfully, but no sections were found.", true);
                                bindGroupNote(notebookUrl);
                            }
                        });
                        return;
                    }
                    List<Page> pages = getNotebookPages(graphToken, groupId, section.getId(), SelectedIncidentModel.getId());
                    if (pages == null){
                        runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                showMessage("Loaded group notebook sections successfully, but no pages were found.", true);
                                bindGroupNote(notebookUrl);
                            }
                        });
                        return;
                    }
                    for (Page page : pages) {
                        GroupNoteBookModel model = new GroupNoteBookModel();
                        model.setTitle(page.getTitle());
                        model.setUrl(page.getLinks().getOneNoteWebUrl().getHref());
                        groupNoteBook.add(model);
                    }
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            showMessage("Loaded group notebooks successfully.", true);
                            bindGroupNote(notebookUrl);
                        }
                    });
                }
                catch(Throwable t) {
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            showMessage("Loading group notebooks failed.", true);
                        }
                    });
                }
            }
        }.start();
    }

    /* Group video */
    private void getVideo() {
        final Handler handler = new Handler() {
            @Override
            public void handleMessage(Message msg) {
                if (msg.what == Constants.SUCCESS) {
                    Log.d(TAG, "Loaded group video list successfully.");
                    bindGroupVideo();
                } else {
                    Log.d(TAG, "Loading group video list failed.");
                }
            }
        };

        new Thread() {
            @Override
            public void run() {
                try {
                    groupVideo = FileHelper.getChannelVideos(mApp.getToken(), SelectedIncidentModel.getId());
                    Message m = new Message();
                    m.what = Constants.SUCCESS;
                    handler.sendMessage(m);
                } catch (Exception e) {
                    Message m = new Message();
                    m.what = Constants.FAILED;
                    handler.sendMessage(m);
                    e.printStackTrace();
                }
            }
        }.start();
    }

    /* Bind group member */
    private void bindGroupMember() {
        View footView = getLayoutInflater().inflate(R.layout.footview, null);
        this.groupMemberListView.addFooterView(footView);
        ((Button) footView.findViewById(R.id.foot_view_more)).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                openBrowser(Constants.OUTLOOK_RESOURCE_ID + "owa/#path=/group/" + group.mail + "/people");
            }
        });

        this.groupMemberAdapter = new GroupMemberAdapter(this, this.groupMember);
        this.groupMemberListView.setAdapter(this.groupMemberAdapter);

        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                getGroupMemberPhoto();
            }
        });
    }

    /* Load group member photo */
    private void getGroupMemberPhoto() {
        final Handler loadPhotoHandler = new Handler() {
            @Override
            public void handleMessage(Message msg) {
                if (msg.what == Constants.SUCCESS) {
                    groupMember.get(msg.arg1).setImage((Bitmap) msg.obj);
                    groupMember.get(msg.arg1).setIsChanged(true);
                    groupMemberAdapter.notifyDataSetChanged();
                    Log.d(TAG, "Loaded group member photos successfully.");
                } else {
                    Log.d(TAG, "Loading group member photo failed.");
                }
            }
        };

        for (int i = 0; i < this.groupMember.size(); i++) {
            final int index = i;
            new Thread() {
                @Override
                public void run() {
                    try {
                        String id = groupMember.get(index).getId();
                        InputStream inputStream = graphServiceClient
                                .getUsers(id)
                                .getPhoto()
                                .getContent()
                                .buildRequest()
                                .get();
                        Bitmap bitmap = BitmapFactory.decodeStream(inputStream);
                        Message message = new Message();
                        message.what = Constants.SUCCESS;
                        message.obj = bitmap;
                        message.arg1 = index;
                        loadPhotoHandler.sendMessage(message);
                    } catch (Exception ex) {
                        Message message = new Message();
                        message.what = Constants.FAILED;
                        message.obj = ex.getMessage();
                        loadPhotoHandler.sendMessage(message);
                        ex.printStackTrace();
                    }
                }
            }.start();
        }
    }

    /* Bind group conversation */
    private void bindGroupConversation() {
        View footView = getLayoutInflater().inflate(R.layout.footview, null);
        this.groupConversationListView.addFooterView(footView);
        ((Button) footView.findViewById(R.id.foot_view_more)).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                openBrowser(Constants.OUTLOOK_RESOURCE_ID + "owa/#path=/group/" + group.mail + "/mail");
            }
        });

        this.groupConversationAdapter = new GroupConversationAdapter(this, this.groupConversation);
        this.groupConversationListView.setAdapter(this.groupConversationAdapter);

        this.groupConversationListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                openBrowser(groupConversation.get(position).getUrl());
            }
        });
    }

    /* Bind group files */
    private void bindGroupFile() {
        if (this.groupFileAdapter == null) {
            View footView = getLayoutInflater().inflate(R.layout.footview, null);
            this.groupFileListView.addFooterView(footView);
            ((Button) footView.findViewById(R.id.foot_view_more)).setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    openBrowser(Constants.SHAREPOINT_URL + "/sites/" + group.mailNickname + "/_layouts/15/GroupsDocuments.aspx");
                }
            });

            this.groupFileAdapter = new GroupFileAdapter(this, this.groupFile);
            this.groupFileListView.setAdapter(this.groupFileAdapter);

            groupFileListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                    openBrowser(groupFile.get(position).getOWAUrl());
                }
            });
        }
    }

    /* Bind group recent document */
    private void bindGroupDocument() {
        this.groupDocument = new ArrayList<GroupFileModel>();
        Calendar calendar = Calendar.getInstance();
        int day = calendar.get(Calendar.DAY_OF_YEAR);
        calendar.set(Calendar.DAY_OF_YEAR, day - 7);
        for (GroupFileModel item : groupFile) {
            if (item.getLastModified().after(calendar)) {
                this.groupDocument.add(item);
            }
        }
        if (this.groupDocumentAdapter == null) {
            View footView = getLayoutInflater().inflate(R.layout.footview, null);
            this.groupDocumentListView.addFooterView(footView);
            ((Button) footView.findViewById(R.id.foot_view_more)).setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    openBrowser(Constants.SHAREPOINT_URL + "/sites/" + group.mailNickname + "/_layouts/15/GroupsDocuments.aspx");
                }
            });
            this.groupDocumentAdapter = new GroupFileAdapter(this, this.groupDocument);
            this.groupDocumentListView.setAdapter(this.groupDocumentAdapter);
            groupDocumentListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                    openBrowser(groupDocument.get(position).getOWAUrl());
                }
            });
        }
    }

    /* Bind group note */
    private void bindGroupNote(final String notebookUrl) {
        if (this.groupNoteListView.getFooterViewsCount() == 0) {
            View footView = getLayoutInflater().inflate(R.layout.footview, null);
            this.groupNoteListView.addFooterView(footView);
            ((Button) footView.findViewById(R.id.foot_view_more)).setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    openBrowser(notebookUrl);
                }
            });
        }
        this.groupNoteAdapter = new GroupNoteAdapter(this, this.groupNoteBook);
        this.groupNoteListView.setAdapter(this.groupNoteAdapter);
        this.groupNoteListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                openBrowser(groupNoteBook.get(position).getUrl());
            }
        });
    }

    /* Bind group video */
    private void bindGroupVideo() {
        try {
            for (int i = 0; i < groupVideo.size(); i++) {
                final String videoUrl = groupVideo.get(i).getUrl();
                ImageView imageView = new ImageView(IncidentDetailActivity.this);
                imageView.setImageDrawable(getResources().getDrawable(R.drawable.video));
                imageView.setScaleType(ImageView.ScaleType.FIT_XY);
                repairImages.addView(imageView, 0);
                LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
                params.height = 210;
                params.width = 280;
                params.setMargins(0, 0, 20, 0);
                imageView.setLayoutParams(params);
                imageView.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        openBrowser(videoUrl);
                    }
                });
            }
        } catch (Exception e) {

            e.printStackTrace();
        }
    }

    private void uploadVideo(final String videoName, final byte[] bytes) {
        process = ProgressDialog.show(this, "Processing", "Uploading video...");
        final Handler handler = new Handler() {
            @Override
            public void handleMessage(Message msg) {
                if (msg.what == Constants.SUCCESS) {
                    Toast.makeText(IncidentDetailActivity.this, "Uploaded video successfully.", Toast.LENGTH_SHORT).show();
                } else {
                    Toast.makeText(IncidentDetailActivity.this, "Uploading video failed.", Toast.LENGTH_SHORT).show();
                }
                process.dismiss();
            }
        };

        new Thread() {
            @Override
            public void run() {
                try {
                    if (FileHelper.uploadVideo(mApp.getToken(), SelectedIncidentModel.getId(), videoName, bytes)) {
                        Message message = new Message();
                        message.what = Constants.SUCCESS;
                        handler.sendMessage(message);
                    } else {
                        Message message = new Message();
                        message.what = Constants.FAILED;
                        handler.sendMessage(message);
                    }
                } catch (Exception e) {
                    Message message = new Message();
                    message.what = Constants.FAILED;
                    message.obj = e.getMessage();
                    handler.sendMessage(message);
                    e.printStackTrace();
                }
            }
        }.start();
    }

    private void openBrowser(String url) {
        Log.d(TAG, "Open URL:" + url);
        Uri uri = Uri.parse(url);
        Intent intent = new Intent(Intent.ACTION_VIEW, uri);
        startActivity(intent);
    }

    private void openCamera() {
        AlertDialog.Builder build = new AlertDialog.Builder(IncidentDetailActivity.this);
        build.setTitle("Select");
        final String[] items = {"Take Picture", "Take Video"};
        build.setItems(items, new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                if (which == 0) {
                    takePicture();
                } else if (which == 1) {
                    takeVideo();
                }
            }
        });
        build.show();
    }

    private void takePicture() {
        Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        startActivityForResult(intent, 200);
    }

    private void takeVideo() {
        Intent intent = new Intent(MediaStore.ACTION_VIDEO_CAPTURE);
        startActivityForResult(intent, 100);
    }

    private static String getVideoName() {
        String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
        return "VIDEO_" + timeStamp + ".mp4";
    }

    private IGraphServiceClient getGraphServiceClient() {
        if (graphServiceClient == null) {
            return AuthenticationHelper.getGraphServiceClient(getApplication(), graphToken);
        }
        return graphServiceClient;
    }

    private IGroupRequestBuilder getGroupRequestBuilder() {
        if (groupRequestBuilder == null) {
            if (graphServiceClient == null) {
                graphServiceClient = getGraphServiceClient();
            }
            return graphServiceClient.getGroups(SelectedIncidentModel.getProperty().getGroup());
        }
        return groupRequestBuilder;
    }

    private IDirectoryObjectCollectionWithReferencesRequestBuilder getGroupMembersRequestBuilder() {
        if (groupMembersBuilder == null) {
            if (groupRequestBuilder == null) {
                groupRequestBuilder = getGroupRequestBuilder();
            }
            return groupRequestBuilder.getMembers();
        }
        return groupMembersBuilder;
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if (resultCode == RESULT_OK) {
            if (requestCode == 200) {
                final Bitmap bitmap = (Bitmap) data.getExtras().get("data");
                uploadPhoto(bitmap);
            } else if (requestCode == 100) {
                Uri uri = data.getData();
                try {
                    InputStream stream = getContentResolver().openInputStream(uri);
                    byte[] bytes = FileHelper.getBytes(stream);
                    String videoName = getVideoName();
                    uploadVideo(videoName, bytes);
                } catch (Exception ex) {

                }
            }
        }
    }

    @Override
    public void onStart() {
        super.onStart();

        // ATTENTION: This was auto-generated to implement the App Indexing API.
        // See https://g.co/AppIndexing/AndroidStudio for more information.
        client.connect();
        Action viewAction = Action.newAction(
                Action.TYPE_VIEW, // TODO: choose an action type.
                "IncidentDetail Page", // TODO: Define a title for the content shown.
                // TODO: If you have web page content that matches this app activity's content,
                // make sure this auto-generated web page URL is correct.
                // Otherwise, set the URL to null.
                Uri.parse("http://host/path"),
                // TODO: Make sure this auto-generated app URL is correct.
                Uri.parse("android-app://com.canviz.repairapp/http/host/path")
        );
        AppIndex.AppIndexApi.start(client, viewAction);
    }

    @Override
    public void onStop() {
        super.onStop();

        // ATTENTION: This was auto-generated to implement the App Indexing API.
        // See https://g.co/AppIndexing/AndroidStudio for more information.
        Action viewAction = Action.newAction(
                Action.TYPE_VIEW, // TODO: choose an action type.
                "IncidentDetail Page", // TODO: Define a title for the content shown.
                // TODO: If you have web page content that matches this app activity's content,
                // make sure this auto-generated web page URL is correct.
                // Otherwise, set the URL to null.
                Uri.parse("http://host/path"),
                // TODO: Make sure this auto-generated app URL is correct.
                Uri.parse("android-app://com.canviz.repairapp/http/host/path")
        );
        AppIndex.AppIndexApi.end(client, viewAction);
        client.disconnect();
    }
}
