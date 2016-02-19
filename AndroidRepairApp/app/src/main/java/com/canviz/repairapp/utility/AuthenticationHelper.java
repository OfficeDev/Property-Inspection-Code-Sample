package com.canviz.repairapp.utility;

import android.app.Activity;
import android.util.Log;

import com.canviz.repairapp.Constants;
import com.google.common.util.concurrent.SettableFuture;
import com.microsoft.aad.adal.AuthenticationCallback;
import com.microsoft.aad.adal.AuthenticationContext;
import com.microsoft.aad.adal.AuthenticationResult;
import com.microsoft.aad.adal.PromptBehavior;
import com.microsoft.services.onenote.fetchers.OneNoteApiClient;
import com.microsoft.services.graph.fetchers.GraphServiceClient;
import com.microsoft.services.orc.resolvers.DefaultDependencyResolver;
import com.microsoft.services.orc.core.DependencyResolver;
import com.microsoft.services.orc.log.LogLevel;
import com.microsoft.services.sharepoint.ListClient;
import com.microsoft.services.sharepoint.http.OAuthCredentials;

import java.security.NoSuchAlgorithmException;

import javax.crypto.NoSuchPaddingException;

/**
 * Created by Tyler on 5/13/15.
 */
public class AuthenticationHelper {

    private static Activity mActivity;
    public static AuthenticationContext mAADAuthContext = null;

    final static String TAG = "AuthenticationHelper";

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

    public static  void acquireTokenSilent(String resource, String userId,AuthenticationCallback<AuthenticationResult> callback){
        getAuthenticationContext().acquireTokenSilent(
                resource,
                Constants.AAD_CLIENT_ID,
                userId,
                callback);
    }

    public static SettableFuture<String> acquireToken(String resource){
        final SettableFuture<String> future = SettableFuture.create();
        try {
            getAuthenticationContext().acquireToken(
                    mActivity,
                    resource,
                    Constants.AAD_CLIENT_ID,
                    Constants.AAD_REDIRECT_URL,
                    PromptBehavior.Auto,
                    new AuthenticationCallback<AuthenticationResult>() {
                        @Override
                        public void onSuccess(AuthenticationResult authenticationResult) {
                            future.set(authenticationResult.getAccessToken());
                        }

                        @Override
                        public void onError(Exception e) {
                            future.setException(e);
                        }
                    });
        } catch (Throwable t) {
            future.setException(t);
        }

        return future;
    }

    public static ListClient getSharePointListClient(String accessToken) {
        OAuthCredentials credentials = new OAuthCredentials(accessToken);
        return new ListClient(Constants.SHAREPOINT_URL, Constants.SHAREPOINT_SITE_PATH, credentials);
    }

    private static <TClient> TClient getTClientAAD(String serverUrl, final String endpointUrl, final Class<TClient> clientClass) {
        final SettableFuture<TClient> future = SettableFuture.create();

        try {
            getAuthenticationContext().acquireToken(
                    mActivity, serverUrl,
                    Constants.AAD_CLIENT_ID, Constants.AAD_REDIRECT_URL, PromptBehavior.Auto,
                    new AuthenticationCallback<AuthenticationResult>() {


                        public void onError(Exception exc) {
                            future.setException(exc);
                        }


                        public void onSuccess(AuthenticationResult result) {
                            TClient client;
                            try {
                                client = clientClass.getDeclaredConstructor(String.class, DependencyResolver.class)
                                        .newInstance(endpointUrl, getDependencyResolver(result.getAccessToken()));
                                future.set(client);
                            } catch (Throwable t) {
                                onError(new Exception(t));
                            }
                        }
                    });


        } catch (Throwable t) {
            future.setException(t);
        }
        try {
            return future.get();
        } catch (Throwable t) {
            Log.e(TAG, t.getMessage());
            return null;
        }
    }

    private static DependencyResolver getDependencyResolver(final String token) {
        DefaultDependencyResolver dependencyResolver = new DefaultDependencyResolver(token);
        dependencyResolver.getLogger().setEnabled(true);
        dependencyResolver.getLogger().setLogLevel(LogLevel.VERBOSE);
        return dependencyResolver;
    }

    public static GraphServiceClient getGraphServiceClient(){
        return getTClientAAD(Constants.GRAPH_RESOURCE_ID, Constants.GRAPH_RESOURCE_URL + Constants.AAD_CLIENT_ID, GraphServiceClient.class);
    }

    public static SettableFuture<String> getGraphAccessToken(){
        final SettableFuture<String> future = SettableFuture.create();
        try {
            getAuthenticationContext().acquireToken(
                    mActivity,
                    Constants.GRAPH_RESOURCE_ID,
                    Constants.AAD_CLIENT_ID,
                    Constants.AAD_REDIRECT_URL,
                    PromptBehavior.Auto,
                    new AuthenticationCallback<AuthenticationResult>() {
                        @Override
                        public void onSuccess(AuthenticationResult authenticationResult) {
                            future.set(authenticationResult.getAccessToken());
                        }

                        @Override
                        public void onError(Exception e) {
                            future.setException(e);
                        }
                    });
        } catch (Throwable t) {
            future.setException(t);
        }
        return future;
    }

    public static OneNoteApiClient getOneNoteClient(String token) {
        return new OneNoteApiClient(Constants.ONENOTE_RESOURCE_URL, getDependencyResolver(token));
    }
}
