package com.example.o365testapp;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.view.View;
import android.widget.EditText;

import com.google.common.util.concurrent.FutureCallback;
import com.google.common.util.concurrent.Futures;
import com.google.common.util.concurrent.ListenableFuture;
import com.microsoft.outlookservices.BodyType;
import com.microsoft.outlookservices.EmailAddress;
import com.microsoft.outlookservices.Folder;
import com.microsoft.outlookservices.ItemBody;
import com.microsoft.outlookservices.Message;
import com.microsoft.outlookservices.Recipient;
import com.microsoft.outlookservices.odata.FolderFetcher;
import com.microsoft.outlookservices.odata.OutlookClient;
import com.microsoft.services.odata.impl.DefaultDependencyResolver;
import com.microsoft.services.odata.interfaces.Credentials;
import com.microsoft.services.odata.interfaces.CredentialsFactory;
import com.microsoft.services.odata.interfaces.Request;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Calendar;
import java.util.List;
import java.util.TimeZone;

public class MainActivity extends Activity {

    private DefaultDependencyResolver mDependencyResolver;
    private OutlookClient mOutlookClient;

    public static final String PARAM_ACCESS_TOKEN = "param_access_token";

    /**
     * The OAuth Access Token provided by LaunchActivity.
     */
    private String mAccessToken;

    private void showErrorDialog(Throwable t) {
        new AlertDialog.Builder(this)
                .setTitle("Whoops!")
                .setMessage(t.toString())
                .setPositiveButton("OK", null)
                .show();
    }

    private void startRetrieveFolders() {

        //Show a "work-in-progress" dialog
        final ProgressDialog progress = ProgressDialog.show(
                this, "Working", "Retrieving Folders"
        );

        //Retrieve the top-level folders
        ListenableFuture<List<Folder>> foldersFuture =
                mOutlookClient.getMe()
                        .getFolders()
                        .read();

        //Attach a callback to handle the eventual result
        Futures.addCallback(foldersFuture,new FutureCallback<List<Folder>>() {
            @Override
            public void onSuccess(List<Folder> result) {
                //Transform the results into a collection of strings
                final String[] items = new String[result.size()];
                for (int i = 0; i < result.size(); i++) {
                    items[i] = result.get(i).getDisplayName();
                }
                //Launch a dialog to show the results to the user
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        progress.dismiss();
                        new AlertDialog.Builder(MainActivity.this)
                                .setTitle("Folders")
                                .setPositiveButton("OK", null)
                                .setItems(items, null)
                                .show();
                    }
                });
            }
            @Override
            public void onFailure(final Throwable t) {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        progress.dismiss();
                        showErrorDialog(t);
                    }
                });
            }
        });
    }

    private void startRetrieveInbox() {

        //Show a "work-in-progress" dialog
        final ProgressDialog progress = ProgressDialog.show(
                this, "Working", "Retrieving Inbox"
        );

        //Get a reference to the users Inbox
        FolderFetcher inboxFetcher = mOutlookClient.getMe().getFolders()
                .getById("Inbox");

        //Retrieve the messages from the inbox
        //ListenableFuture<List<Message>> messagesFuture =
                //inboxFetcher.getMessages()
                        //.read();

        //Get a timestamp for today at midnight
        Calendar calendar = Calendar.getInstance();
        calendar.set(Calendar.HOUR_OF_DAY, 0);
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        calendar.set(Calendar.MILLISECOND, 0);

//Create a filter string
        DateFormat iso8601 = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
        iso8601.setTimeZone(TimeZone.getTimeZone("UTC"));
        String odataFilter = String.format(
                "DateTimeReceived gt %s",
                iso8601.format(calendar.getTime())
        );

//Retrieve the messages in the inbox
        ListenableFuture<List<Message>> messagesFuture =
                inboxFetcher.getMessages()
                        .filter(odataFilter)
                        .read();

        //Attach a callback to handle the eventual result
        Futures.addCallback(messagesFuture,new FutureCallback<List<Message>>() {
            @Override
            public void onSuccess(List<Message> result) {
                //Transform the results into a collection of strings
                final String[] items = new String[result.size()];
                for (int i = 0; i < result.size(); i++) {
                    items[i] = result.get(i).getSubject();
                }
                //Launch a dialog to show the results to the user
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        progress.dismiss();
                        new AlertDialog.Builder(MainActivity.this)
                                .setTitle("Inbox")
                                .setPositiveButton("OK", null)
                                .setItems(items, null)
                                .show();
                    }
                });

                findViewById(R.id.retrieve_folders_button).setOnClickListener(
                        new View.OnClickListener() {
                            @Override
                            public void onClick(View view) {
                                startRetrieveFolders();
                            }
                        }
                );
            }

            @Override
            public void onFailure(final Throwable t) {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        progress.dismiss();
                        showErrorDialog(t);
                    }
                });
            }
        });
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        //Access token obtained by LaunchActivity using the Active Directory Authentication Library
        mAccessToken = getIntent().getStringExtra(PARAM_ACCESS_TOKEN);

        //Configure the depencency resolver
        mDependencyResolver = new DefaultDependencyResolver();
        mDependencyResolver.setCredentialsFactory(new CredentialsFactory() {
            @Override
            public Credentials getCredentials() {
                return new Credentials() {
                    /**
                     * Adds the access token to each request made by the client
                     */
                    public void prepareRequest(Request request) {
                        request.addHeader("Authorization", "Bearer " + mAccessToken);
                    }
                };
            }
        });

        //Create the client
        mOutlookClient = new OutlookClient(
                "https://outlook.office365.com/api/v1.0",
                mDependencyResolver
        );

        findViewById(R.id.retrieve_inbox_button).setOnClickListener(
                new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        startRetrieveInbox();
                    }
                }
        );

        findViewById(R.id.send_message_button).setOnClickListener(
                new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        startSendMessage();
                    }
                }
        );

        findViewById(R.id.create_folder_button).setOnClickListener(
                new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        promptUserForFolderName();
                    }
                }
        );

    }

    private void startSendMessage() {

        //Show a "work-in-progress" dialog
        final ProgressDialog progress = ProgressDialog.show(
                this, "Working", "Sending a Message"
        );

        //Create an example message
        ItemBody body = new ItemBody();
        body.setContentType(BodyType.Text);
        body.setContent("This is a message body");

        EmailAddress recipientAddress = new EmailAddress();
        recipientAddress.setAddress("admin@teeudev3.onmicrosoft.com");
        recipientAddress.setName("Administrator");

        Recipient recipient = new Recipient();
        recipient.setEmailAddress(recipientAddress);

        Message message = new Message();
        message.setToRecipients(Arrays.asList(recipient));
        message.setSubject("This is a test message");
        message.setBody(body);

        //Send the message through the API
        boolean saveToSentItems = true;
        ListenableFuture future =
                mOutlookClient.getMe()
                        .getOperations()
                        .sendMail(message, saveToSentItems);

        Futures.addCallback(future, new FutureCallback() {
            @Override
            public void onSuccess(Object result) {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        progress.dismiss();
                        new AlertDialog.Builder(MainActivity.this)
                                .setTitle("Success")
                                .setMessage("The message was sent")
                                .setPositiveButton("OK", null)
                                .show();
                    }
                });
            }

            @Override
            public void onFailure(final Throwable t) {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        progress.dismiss();
                        showErrorDialog(t);
                    }
                });
            }
        });
    }

    private void promptUserForFolderName() {

        final EditText input = new EditText(this);

        //Prompt the user for a new folder name
        new AlertDialog.Builder(this)
                .setTitle("Create a Folder")
                .setMessage("Please enter a folder name")
                .setView(input)
                .setPositiveButton("OK", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {
                        String newFolderName = input.getText().toString();
                        startCreateFolder(newFolderName);
                    }
                })
                .setNegativeButton("Cancel", null)
                .show();

    }

    private void startCreateFolder(String newFolderName) {

        //Show a "work-in-progress" dialog
        final ProgressDialog progress = ProgressDialog.show(
                this, "Working", "Creating Folder"
        );

        Folder newFolder = new Folder();
        newFolder.setDisplayName(newFolderName);

        //Create the folder via the API
        ListenableFuture<Folder> newFolderFuture =
                mOutlookClient.getMe()
                        .getFolders()
                        .getById("Inbox")
                        .getChildFolders()
                        .add(newFolder);

        Futures.addCallback(newFolderFuture, new FutureCallback<Folder>() {
            @Override
            public void onSuccess(final Folder result) {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        progress.dismiss();
                        new AlertDialog.Builder(MainActivity.this)
                                .setTitle("Success")
                                .setMessage("Created folder " + result.getDisplayName())
                                .setPositiveButton("OK", null)
                                .show();
                    }
                });
            }

            @Override
            public void onFailure(final Throwable t) {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        progress.dismiss();
                        showErrorDialog(t);
                    }
                });
            }
        });
    }
}
