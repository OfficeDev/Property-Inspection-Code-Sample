package com.canviz.repairapp.utility;

import android.app.Activity;
import android.util.Log;

import com.canviz.repairapp.Constants;
import com.google.common.util.concurrent.SettableFuture;
import com.microsoft.aad.adal.AuthenticationCallback;
import com.microsoft.aad.adal.AuthenticationContext;
import com.microsoft.aad.adal.AuthenticationResult;
import com.microsoft.aad.adal.PromptBehavior;
import com.microsoft.graph.odata.GraphServiceClient;
import com.microsoft.services.odata.impl.DefaultDependencyResolver;
import com.microsoft.services.odata.interfaces.DependencyResolver;
import com.microsoft.services.odata.interfaces.LogLevel;
import com.microsoft.sharepointservices.ListClient;
import com.microsoft.sharepointservices.http.OAuthCredentials;

import java.security.NoSuchAlgorithmException;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;

import javax.crypto.NoSuchPaddingException;

/**
 * Created by Tyler on 5/13/15.
 */
public class AuthenticationHelper {

    private static Activity mActivity;
    public static AuthenticationContext mAADAuthContext = null;

    public static void initialize(Activity activity) throws NoSuchPaddingException, NoSuchAlgorithmException {
        mActivity = activity;
        mAADAuthContext = new AuthenticationContext(
                mActivity.getApplicationContext(),
                Constants.AAD_AUTHORITY,
                false);
    }

    public static AuthenticationContext getAuthenticationContext() {
        return mAADAuthContext;
    }

    public static void acquireToken(String serverUrl, AuthenticationCallback<AuthenticationResult> callback) {
        getAuthenticationContext().acquireToken(
                mActivity,
                serverUrl,
                Constants.AAD_CLIENT_ID,
                Constants.AAD_REDIRECT_URL,
                PromptBehavior.Auto,
                callback);
    }

    public static AuthenticationResult acquireToken(String serverUrl) throws ExecutionException, InterruptedException {
        final SettableFuture<AuthenticationResult> future = SettableFuture.create();

        acquireToken(serverUrl, new AuthenticationCallback<AuthenticationResult>() {
            public void onError(Exception exc) {
                future.setException(exc);
            }

            public void onSuccess(AuthenticationResult result) {
                future.set(result);
            }
        });
        return future.get();
    }

    public static ListClient getSharePointListClient(String accessToken) {
        OAuthCredentials credentials = new OAuthCredentials(accessToken);
        return new ListClient(Constants.SHAREPOINT_URL, Constants.SHAREPOINT_SITE_PATH, credentials);
    }
}
