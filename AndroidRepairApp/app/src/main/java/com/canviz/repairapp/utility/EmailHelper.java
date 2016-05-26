package com.canviz.repairapp.utility;

import com.canviz.repairapp.Constants;
import com.microsoft.aad.adal.AuthenticationContext;
import com.microsoft.aad.adal.AuthenticationResult;
import com.microsoft.services.odata.impl.GsonSerializer;
import com.microsoft.services.odata.interfaces.JsonSerializer;

import java.io.BufferedOutputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

/**
 * Created by Tyler on 5/19/15.
 */
public class EmailHelper {

    public static void sendMail(String userId, com.microsoft.graph.extensions.Message message, Boolean saveToSentItems) throws Exception {
        JsonSerializer serializer = new GsonSerializer();
        java.util.Map<String, String> map = new java.util.HashMap<String, String>();
        map.put("Message", serializer.serialize(message));
        map.put("SaveToSentItems", serializer.serialize(saveToSentItems));
        String content = serializer.jsonObjectFromJsonMap(map);
        byte[] data = content.getBytes(com.microsoft.services.odata.Constants.UTF8);

        String sendMailUrl = String.format("%s%s/Users('%s')/SendMail", Constants.GRAPH_RESOURCE_URL, Constants.AAD_CLIENT_ID, userId);

        AuthenticationContext authContext = AuthenticationHelper.getAuthenticationContext();
        AuthenticationResult authResult = authContext.acquireTokenSilentSync(Constants.GRAPH_RESOURCE_ID, Constants.AAD_CLIENT_ID, null);

        URL url = new URL(sendMailUrl);
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();

        int responseCode = 0;
        try {
            connection.setRequestMethod("POST");
            connection.setRequestProperty("Authorization", "Bearer ".concat(authResult.getAccessToken()));
            connection.setRequestProperty("Content-Type", "application/json");
            connection.setRequestProperty("Accept", "application/json");

            OutputStream out = new BufferedOutputStream(connection.getOutputStream());
            out.write(data);
            out.close();

            responseCode = connection.getResponseCode();
        }
        catch (Exception ex) {
            connection.disconnect();
        }

        if(responseCode != HttpURLConnection.HTTP_ACCEPTED) {
            throw new Exception("SendMail faild: Error response code ".concat(Integer.toString(responseCode)));
        }
    }
}
