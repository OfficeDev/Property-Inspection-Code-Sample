package com.example.o365testapp;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.view.View;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

import com.google.common.util.concurrent.FutureCallback;
import com.google.common.util.concurrent.Futures;
import com.google.common.util.concurrent.ListenableFuture;
import com.microsoft.fileservices.File;
import com.microsoft.fileservices.Folder;
import com.microsoft.fileservices.Item;
import com.microsoft.services.odata.impl.DefaultDependencyResolver;
import com.microsoft.services.odata.interfaces.Credentials;
import com.microsoft.services.odata.interfaces.CredentialsFactory;
import com.microsoft.services.odata.interfaces.Request;
import com.microsoft.sharepointservices.odata.SharePointClient;

import java.io.UnsupportedEncodingException;
import java.util.List;

public class MainActivity extends Activity {

    public static final String PARAM_ACCESS_TOKEN = "param_access_token";

    /**
     * The OAuth Access Token provided by LaunchActivity.
     */
    private String mAccessToken;

    private DefaultDependencyResolver mDependencyResolver;
    private SharePointClient mSharePointClient;

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
        mSharePointClient = new SharePointClient(Constants.API_ENDPOINT, mDependencyResolver);

        findViewById(R.id.retrieve_files_button).setOnClickListener(
                new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        startRetrieveFiles(null);
                    }
                }
        );

        findViewById(R.id.create_folder_button).setOnClickListener(
                new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        showCreateFolderDialog();
                    }
                }
        );

        findViewById(R.id.create_file_button).setOnClickListener(
                new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        showCreateFileDialog();
                    }
                }
        );
    }

    private void showErrorDialog(Throwable t) {
        new AlertDialog.Builder(this)
                .setTitle("Whoops!")
                .setMessage(t.toString())
                .setPositiveButton("OK", null)
                .show();
    }

    private void startRetrieveFiles(final Item folder) {

        //Show a "work-in-progress" dialog
        final ProgressDialog progress = ProgressDialog.show(
                this, "Working", "Retrieving Files"
        );

        ListenableFuture<List<Item>> itemsFuture;

        if (folder == null) {
            //Get the files in the root folder
            itemsFuture = mSharePointClient.getfiles()
                    .read();
        }
        else {
            //Get the files in this folder
            itemsFuture = mSharePointClient.getfiles()
                    .getById(folder.getid())
                    .asFolder()
                    .getchildren()
                    .read();
        }

        Futures.addCallback(itemsFuture, new FutureCallback<List<Item>>() {
            @Override
            public void onSuccess(final List<Item> result) {
                //Transform the results into a collection of strings
                final String[] items = new String[result.size()];
                for (int i = 0; i < result.size(); i++) {
                    Item item = result.get(i);
                    items[i] = "(" + item.gettype() + ") " + item.getname();
                }
                //Launch a dialog to show the results to the user
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        progress.dismiss();
                        new AlertDialog.Builder(MainActivity.this)
                                .setTitle("Files")
                                .setItems(items, new DialogInterface.OnClickListener() {
                                    @Override
                                    public void onClick(DialogInterface dialogInterface, int i) {
                                        //The user picked a file - figure out if it is a file or folder
                                        Item item = result.get(i);
                                        if (item.gettype().equals("File")) {
                                            //download the file contents
                                            startDownloadFile(item);
                                        } else {
                                            //download the child files
                                            startRetrieveFiles(item);
                                        }
                                    }
                                })
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

    private void startDownloadFile(final Item file) {

        //Show a "work-in-progress" dialog
        final ProgressDialog progress = ProgressDialog.show(
                this, "Working", "Retrieving File Contents"
        );

        //Get the contents of the file
        ListenableFuture<byte[]> resultFuture = mSharePointClient.getfiles()
                .getById(file.getid())
                .asFile()
                .getContent();

        Futures.addCallback(resultFuture, new FutureCallback<byte[]>() {
            @Override
            public void onSuccess(final byte[] result) {

                //Try and parse this data as an image or plain text
                final View view = getFileView(result);

                //Launch a dialog to show the results to the user
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        progress.dismiss();
                        new AlertDialog.Builder(MainActivity.this)
                                .setTitle("File Contents")
                                .setView(view)
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

    private View getFileView(byte[] result) {

        Bitmap bitmap = BitmapFactory.decodeByteArray(result, 0, result.length);

        if (bitmap != null) {
            ImageView imageView = new ImageView(this);
            imageView.setImageBitmap(bitmap);
            return imageView;
        }

        String utf8String = null;
        try {
            utf8String = new String(result, "UTF-8");
        }
        catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }

        TextView textView = new TextView(this);
        textView.setText(utf8String);

        return textView;
    }

    private void showCreateFolderDialog() {

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

        Folder item = new Folder();
        item.setname(newFolderName);

        //Create the folder via the API
        ListenableFuture<Item> newFolderFuture =
                mSharePointClient.getfiles()
                        .getById("root")
                        .asFolder()
                        .getchildren()
                        .add(item);

        Futures.addCallback(newFolderFuture, new FutureCallback<Item>() {
            @Override
            public void onSuccess(final Item result) {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        progress.dismiss();
                        new AlertDialog.Builder(MainActivity.this)
                                .setTitle("Success")
                                .setMessage("Created folder " + result.getname())
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

    private void showCreateFileDialog() {

        final EditText input = new EditText(this);

//Prompt the user for a new folder name
        new AlertDialog.Builder(this)
                .setTitle("Create a File")
                .setMessage("Please enter a file name")
                .setView(input)
                .setPositiveButton("OK", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {
                        String newFileName = input.getText().toString();
                        startCreateFile(newFileName);
                    }
                })
                .setNegativeButton("Cancel", null)
                .show();
    }

    private void startCreateFile(String newFileName) {

//Show a "work-in-progress" dialog
        final ProgressDialog progress = ProgressDialog.show(
                this, "Working", "Creating File"
        );

        File item = new File();
        item.setname(newFileName);

//Create the folder via the API
        ListenableFuture<Item> newFolderFuture =
                mSharePointClient.getfiles()
                        .getById("root")
                        .asFolder()
                        .getchildren()
                        .add(item);

        Futures.addCallback(newFolderFuture, new FutureCallback<Item>() {
            @Override
            public void onSuccess(final Item result) {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        progress.dismiss();
                        uploadFileContent(result);
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

    private void uploadFileContent(final Item file) {

//Show a "work-in-progress" dialog
        final ProgressDialog progress = ProgressDialog.show(
                this, "Working", "Uploading Data"
        );

//Upload some file content
        String content = "This is some file content!";

        byte[] bytes = new byte[0];
        try {
            bytes = content.getBytes("UTF-8");
        }
        catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }

//Upload the file content
        ListenableFuture<Void> future = mSharePointClient.getfiles()
                .getById(file.getid())
                .asFile()
                .putContent(bytes);
        Futures.addCallback(future, new FutureCallback<Void>() {
            @Override
            public void onSuccess(final Void result) {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                progress.dismiss();
                                new AlertDialog.Builder(MainActivity.this)
                                        .setTitle("Success")
                                        .setMessage("Created file " + file.getname())
                                        .setPositiveButton("OK", null)
                                        .show();
                            }
                        });
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
