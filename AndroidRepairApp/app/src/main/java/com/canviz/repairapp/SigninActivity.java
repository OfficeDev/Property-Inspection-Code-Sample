package com.canviz.repairapp;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Intent;
import android.content.Context;
import android.net.Uri;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import java.security.NoSuchAlgorithmException;
import javax.crypto.NoSuchPaddingException;

import com.canviz.repairapp.utility.AuthenticationHelper;
import com.canviz.repairapp.utility.Helper;
import com.microsoft.aad.adal.AuthenticationCallback;
import com.microsoft.aad.adal.AuthenticationContext;
import com.microsoft.aad.adal.AuthenticationResult;
import com.microsoft.aad.adal.PromptBehavior;
import com.microsoft.sharepointservices.ListClient;

public class SigninActivity extends Activity {
    private App mApp;
    private Button signInBtn;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_signin);

        mApp = (App) getApplication();

        setIncidentId();

        try {
            AuthenticationHelper.initialize(this);
        }
        catch (NoSuchAlgorithmException e) {
            //This error should not occur in normal operation, but we cannot continue if it does
            throw new RuntimeException("Error creating authentication context", e);
        }
        catch (NoSuchPaddingException e) {
            //This error should not occur in normal operation, but we cannot continue if it does
            throw new RuntimeException("Error creating authentication context", e);
        }

        signInBtn = (Button) findViewById(R.id.signIn_btn);
        signInBtn.setOnClickListener(new View.OnClickListener() {
            public void onClick(View view) {
                startAuthentication();
            }
        });
    }

    private void setIncidentId(){
        String incidentId = "0";
        try{
            Intent intent = this.getIntent();
            Uri uri = intent.getData();
            if(uri != null){
                String urlStr = uri.toString();
                int lastIndex = urlStr.lastIndexOf("/");
                String id = urlStr.substring(lastIndex + 1);
                if(Helper.IsInt(id)){
                    incidentId = id;
                }
            }
        }catch(Exception e){
            incidentId = "0";
        }
        mApp.setIncidentId(incidentId);
    }

    private void startAuthentication() {

        AuthenticationHelper.acquireToken(
                Constants.SHAREPOINT_RESOURCE_ID,
                new AuthenticationCallback<AuthenticationResult>() {
                    public void onSuccess(AuthenticationResult authenticationResult) {
                        handleSuccess(authenticationResult);
                    }
                    public void onError(Exception e) {
                        handleError(e.toString());
                    }
                });
    }

    private void handleSuccess(AuthenticationResult authenticationResult) {
        /*
        String message = String.format(
                "User Id: %1$s\nExpires on: %2$s\nAccess Token: %3$s...\nRefresh Token: %4$s...",
                authenticationResult.getUserInfo().getUserId(),
                authenticationResult.getExpiresOn().toString(),
                authenticationResult.getAccessToken(),
                authenticationResult.getRefreshToken()
        );
        */

        mApp.setUserId(authenticationResult.getUserInfo().getUserId());
        mApp.setToken(authenticationResult.getAccessToken());

        signComplete();
    }

    private void handleError(String errorMessage) {
        new AlertDialog.Builder(this)
                .setTitle("Whoops!")
                .setMessage("Something went wrong: " + errorMessage)
                .setPositiveButton("Ok", null)
                .show();
    }

    private void signComplete(){
        mApp.setSelectedIncidentModel(null);

        Intent incident = new Intent();
        incident.setClass(SigninActivity.this,IncidentActivity.class);
        startActivity(incident);
        finish();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        AuthenticationHelper.getAuthenticationContext().onActivityResult(requestCode, resultCode, data);
    }
}
