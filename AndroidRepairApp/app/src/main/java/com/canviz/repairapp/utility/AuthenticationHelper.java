package com.canviz.repairapp.utility;

import android.app.Activity;
import android.app.Application;
import android.util.Log;

import com.canviz.repairapp.Constants;
import com.google.common.util.concurrent.SettableFuture;
import com.microsoft.aad.adal.AuthenticationCallback;
import com.microsoft.aad.adal.AuthenticationContext;
import com.microsoft.aad.adal.AuthenticationResult;
import com.microsoft.aad.adal.PromptBehavior;
import com.microsoft.graph.authentication.IAuthenticationProvider;
import com.microsoft.graph.core.DefaultClientConfig;
import com.microsoft.graph.core.IClientConfig;
import com.microsoft.graph.authentication.IAuthenticationAdapter;
import com.microsoft.graph.authentication.MSAAuthAndroidAdapter;
import com.microsoft.graph.extensions.GraphServiceClient;
import com.microsoft.graph.extensions.IGraphServiceClient;
import com.microsoft.services.onenote.fetchers.OneNoteApiClient;
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

    private static DependencyResolver getDependencyResolver(final String token) {
        DefaultDependencyResolver dependencyResolver = new DefaultDependencyResolver(token);
        dependencyResolver.getLogger().setEnabled(true);
        dependencyResolver.getLogger().setLogLevel(LogLevel.VERBOSE);
        return dependencyResolver;
    }

    public static IGraphServiceClient getGraphServiceClient(Application app, String token){
        return new GraphServiceClient
                .Builder()
                .fromConfig(DefaultClientConfig.createWithAuthenticationProvider(new GraphAuthenticationProvider(app, token)))
                .buildClient();
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
}
