package com.canviz.repairapp.utility;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;

import com.canviz.repairapp.Constants;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.ByteArrayEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

public class FileHelper {

    private final static String TAG = "FileHelper";

    public static String getFileServerRelativeUrlUrl(String token,String listName, int itemId) throws IOException, JSONException {
        String listNamePart = String.format("/_api/web/lists/GetByTitle('%s')/Items(%s)/File?$select=ServerRelativeUrl", listName,itemId);
        String getFileUrl = Constants.SHAREPOINT_URL + Constants.SHAREPOINT_SITE_PATH + listNamePart;

        HttpClient httpClient = new DefaultHttpClient();
        HttpGet httpGet = new HttpGet(getFileUrl);
        httpGet.addHeader("Authorization ","Bearer " + token);
        httpGet.addHeader("accept", "application/json;odata=verbose");

        HttpResponse httpResponse = httpClient.execute(httpGet);

        if(httpResponse.getStatusLine().getStatusCode() == 200){
            String jsonStr = EntityUtils.toString(httpResponse.getEntity());
            JSONObject jsonObject = new JSONObject(jsonStr);
            if(jsonObject != null){
                String serverRelativeUrl = (new JSONObject(jsonObject.getString("d"))).getString("ServerRelativeUrl");
                if(serverRelativeUrl != null){
                    return serverRelativeUrl;
                }
            }
        }
        return null;
    }

    public static Bitmap getFile(String token,String listName, int itemId) throws Exception{
        String serverRelativeUrl = getFileServerRelativeUrlUrl(token,listName,itemId);
        if(serverRelativeUrl == null){
            return null;
        }

        Bitmap bitmap = AsyncBitmapLoader.loadBitmap(serverRelativeUrl);
        if(bitmap != null){
            return bitmap;
        }

        String listNamePart = String.format("/_api/web/GetFileByServerRelativeUrl('%s')/$value", serverRelativeUrl);
        String getFileUrl = Constants.SHAREPOINT_URL + Constants.SHAREPOINT_SITE_PATH + listNamePart;
        HttpClient httpClient = new DefaultHttpClient();
        HttpGet httpGet = new HttpGet(getFileUrl);
        httpGet.addHeader("Authorization ","Bearer " + token);
        HttpResponse httpResponse = httpClient.execute(httpGet);

        if(httpResponse.getStatusLine().getStatusCode() == 200){
            HttpEntity httpEntity = httpResponse.getEntity();
            Bitmap spBitmap = BitmapFactory.decodeStream(httpEntity.getContent());
            if(spBitmap != null){
                AsyncBitmapLoader.saveBitmapToCache(serverRelativeUrl,spBitmap);
            }
            return spBitmap;
        }
        return null;
    }

    public static void saveToSDCard(Bitmap bitmap,String imageName){
        try{
            File dir = new File(Constants.LOCALIMAGE_SAVEPATH);
            if (!dir.exists()) {
                dir.mkdirs();
            }
            File bitmapFile = new File(Constants.LOCALIMAGE_SAVEPATH + imageName);
            if (!bitmapFile.exists()) {
                try {
                    bitmapFile.createNewFile();
                } catch (IOException e) {
                    // TODO Auto-generated catch block
                    e.printStackTrace();
                }
            }
            FileOutputStream fos;
            try {
                fos = new FileOutputStream(bitmapFile);
                bitmap.compress(Bitmap.CompressFormat.JPEG, 100, fos);
                fos.close();
            } catch (FileNotFoundException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }catch (Exception e){

        }
    }

    public static void uploadFile(String token,String listName,String imageName,Bitmap bitmap) throws Exception{
        String listNamePart = String.format("/_api/web/GetFolderByServerRelativeUrl('%s')/Files/add(url='%s',overwrite=true)", listName,imageName);
        String postFileUrl = Constants.SHAREPOINT_URL + Constants.SHAREPOINT_SITE_PATH + listNamePart;
        HttpClient httpClient = new DefaultHttpClient();
        HttpPost httpPost = new HttpPost(postFileUrl);
        httpPost.addHeader("Authorization ","Bearer " + token);
        //This header is crucial to ensuring the image is rendered properly when requested from the SP document library.
        httpPost.setHeader("Accept", "image/png, image/svg+xml, image/*;q=0.8, */*;q=0.5");

        //ByteArrayEntity is required for successful file upload and rendering.
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        bitmap.compress(Bitmap.CompressFormat.JPEG,100,byteArrayOutputStream);
        byte[] bytes = byteArrayOutputStream.toByteArray();
        ByteArrayEntity byteArrayEntity = new ByteArrayEntity(bytes);
        byteArrayEntity.setContentType("application/octet-stream");
        httpPost.setEntity(byteArrayEntity);

        /*
        //If the ByeArrayEntity is not used and you attempt to use a MultiPartEntityBuilder to make an HttpEntity
        //to attach to the HttpPost the file will upload successfully.  However, when you you request the image
        //from the SP document library it will not render correctly.  An interesting thing to point out is if you
        //download the file from SP then open it on your local machine it will display OK with this approach.
        //This commented out code approach is recommended in numerous examples available on the Internet, however
        //it is not suitable for images.  This approach is best suited for documents.
        File file = new File(Constants.LOCALIMAGE_SAVEPATH + imageName);
        MultipartEntityBuilder builder = MultipartEntityBuilder.create();
        builder.setMode(HttpMultipartMode.BROWSER_COMPATIBLE);
        ContentBody fileBody = new FileBody(file);
        builder.addPart(imageName,fileBody);
        //builder.addBinaryBody("file",file,ContentType.DEFAULT_BINARY,imageName);
        HttpEntity fileEntity = builder.build();
        httpPost.setEntity(fileEntity);
        */

        HttpResponse httpResponse = httpClient.execute(httpPost);
        if(httpResponse.getStatusLine().getStatusCode() == 200){
            int code = httpResponse.getStatusLine().getStatusCode();
        }
    }

    public static int getFileId(String token,String listName, String fileName) throws IOException, JSONException {
        String listNamePart = String.format("/_api/web/GetFolderByServerRelativeUrl('%s')/Files('%s')/ListItemAllFields", listName,fileName);
        String getFileUrl = Constants.SHAREPOINT_URL + Constants.SHAREPOINT_SITE_PATH + listNamePart;

        HttpClient httpClient = new DefaultHttpClient();
        HttpGet httpGet = new HttpGet(getFileUrl);
        httpGet.addHeader("Authorization ","Bearer " + token);
        httpGet.addHeader("accept", "application/json;odata=verbose");

        HttpResponse httpResponse = httpClient.execute(httpGet);

        if(httpResponse.getStatusLine().getStatusCode() == 200){
            String jsonStr = EntityUtils.toString(httpResponse.getEntity());
            JSONObject jsonObject = new JSONObject(jsonStr);
            int id = (new JSONObject(jsonObject.getString("d"))).getInt("Id");
            if(id > 0){
                return id;
            }
        }
        return 0;
    }
}
