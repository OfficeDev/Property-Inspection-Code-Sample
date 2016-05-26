package com.canviz.repairapp.utility;

import android.app.Application;

import com.canviz.repairapp.Constants;
import com.microsoft.graph.authentication.MSAAuthAndroidAdapter;
import com.microsoft.graph.http.IHttpRequest;
import com.microsoft.graph.logger.ILogger;
import com.microsoft.graph.options.HeaderOption;

/**
 * Created by Luis Lu on 5/12/2016.
 */
public class GraphAuthenticationProvider extends MSAAuthAndroidAdapter{
    /**
     * The logger instance.
     */
    private String mToken;

    /**
     * Create a new instance of the provider
     *
     * @param application the application instance
     */
    public GraphAuthenticationProvider(Application application, String token) {
        super(application);
        mToken = token;
    }

    @Override
    public String getClientId() {
        return Constants.AAD_CLIENT_ID;
    }

    @Override
    public String[] getScopes() {
        return new String[] {
                "https://graph.microsoft.com/Calendars.ReadWrite",
                "https://graph.microsoft.com/Contacts.ReadWrite",
                "https://graph.microsoft.com/Files.ReadWrite",
                "https://graph.microsoft.com/Mail.ReadWrite",
                "https://graph.microsoft.com/Mail.Send",
                "https://graph.microsoft.com/User.ReadBasic.All",
                "https://graph.microsoft.com/User.ReadWrite",
                "offline_access",
                "openid"
        };
    }

    @Override
    public void authenticateRequest(final IHttpRequest request) {
        for (final HeaderOption option : request.getHeaders()) {
            if (option.getName().equals(AUTHORIZATION_HEADER_NAME)) {
                return;
            }
        }
        if (mToken != null && mToken.length() > 0){
            request.addHeader(AUTHORIZATION_HEADER_NAME, OAUTH_BEARER_PREFIX + mToken);
            return;
        }
        super.authenticateRequest(request);
    }
}
