package com.canviz.repairapp.utility;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;

import com.canviz.repairapp.Constants;
import com.canviz.repairapp.data.GroupVideoModel;
import com.squareup.okhttp.MediaType;
import com.squareup.okhttp.OkHttpClient;
import com.squareup.okhttp.Request;
import com.squareup.okhttp.RequestBody;
import com.squareup.okhttp.Response;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import android.util.Base64;

public class FileHelper {

    private final static String TAG = "FileHelper";

    public static String getFileServerRelativeUrlUrl(String token,String listName, int itemId) throws IOException, JSONException {
        String listNamePart = String.format("/_api/web/lists/GetByTitle('%s')/Items(%s)/File?$select=ServerRelativeUrl", listName,itemId);
        String getFileUrl = Constants.SHAREPOINT_URL + Constants.SHAREPOINT_SITE_PATH + listNamePart;

        OkHttpClient okHttpClient = new OkHttpClient();
        Request request = new Request.Builder()
                .url(getFileUrl)
                .addHeader("Authorization ", "Bearer " + token)
                .addHeader("accept", "application/json;odata=verbose")
                .get()
                .build();
        Response response = okHttpClient.newCall(request).execute();
        if(response.code() == 200) {
            JSONObject jsonObject = new JSONObject(response.body().string());
            String serverRelativeUrl = (new JSONObject(jsonObject.getString("d"))).getString("ServerRelativeUrl");
            if(serverRelativeUrl != null){
                return serverRelativeUrl;
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

        OkHttpClient okHttpClient = new OkHttpClient();
        Request request = new Request.Builder()
                .url(getFileUrl)
                .addHeader("Authorization ","Bearer " + token)
                .get()
                .build();
        Response response = okHttpClient.newCall(request).execute();
        if(response.code() == 200){
            Bitmap spBitmap = BitmapFactory.decodeStream(response.body().byteStream());
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
        String listNamePart = String.format("/_api/web/GetFolderByServerRelativeUrl('%s')/Files/add(url='%s',overwrite=true)", listName, imageName);
        String postFileUrl = Constants.SHAREPOINT_URL + Constants.SHAREPOINT_SITE_PATH + listNamePart;

        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        bitmap.compress(Bitmap.CompressFormat.JPEG, 100, byteArrayOutputStream);
        byte[] bytes = byteArrayOutputStream.toByteArray();

        OkHttpClient okHttpClient = new OkHttpClient();
        RequestBody body = RequestBody.create(MediaType.parse("application/octet-stream"), bytes);
        Request request = new Request.Builder()
                .url(postFileUrl)
                .addHeader("Authorization ","Bearer " + token)
                .addHeader("Accept", "image/png, image/svg+xml, image/*;q=0.8, */*;q=0.5")
                .post(body)
                .build();
        Response response = okHttpClient.newCall(request).execute();
        if(response.code() == 200)
        {

        }

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
    }

    public static int getFileId(String token,String listName, String fileName) throws IOException, JSONException {
        String listNamePart = String.format("/_api/web/GetFolderByServerRelativeUrl('%s')/Files('%s')/ListItemAllFields", listName,fileName);
        String getFileUrl = Constants.SHAREPOINT_URL + Constants.SHAREPOINT_SITE_PATH + listNamePart;

        OkHttpClient okHttpClient = new OkHttpClient();
        Request request = new Request.Builder()
                .url(getFileUrl)
                .addHeader("Authorization ", "Bearer " + token)
                .addHeader("accept", "application/json;odata=verbose")
                .get()
                .build();
        Response response = okHttpClient.newCall(request).execute();
        if(response.code() == 200){
            JSONObject jsonObject = new JSONObject(response.body().string());
            int id = (new JSONObject(jsonObject.getString("d"))).getInt("Id");
            if(id > 0){
                return id;
            }
        }

        return 0;
    }

    public static Bitmap getUserPhoto(String token,String mail) throws Exception{
        String url = String.format("api/beta/Users('%s')/UserPhotos('48X48')/$Value", mail);
        String getFileUrl = Constants.OUTLOOK_RESOURCE_ID + url;

        OkHttpClient okHttpClient = new OkHttpClient();
        Request request = new Request.Builder()
                .url(getFileUrl)
                .addHeader("Authorization ", "Bearer " + token)
                .get()
                .build();
        Response response = okHttpClient.newCall(request).execute();
        if(response.code() == 200){
            return BitmapFactory.decodeStream(response.body().byteStream());
        }

        return null;
    }

    public static String getChannelUrl(String token) throws IOException, JSONException {
        String url = Constants.VIDEO_RESOURCE_URL + "/_api/VideoService/Channels?$filter=Title%20eq%20%27" + Constants.VIDEO_CHANNEL_NAME + "%27";
        String channelUrl = null;

        OkHttpClient okHttpClient = new OkHttpClient();
        Request request = new Request.Builder()
                .url(url)
                .addHeader("Authorization ", "Bearer " + token)
                .addHeader("accept", "application/json;odata=verbose")
                .get()
                .build();
        Response response = okHttpClient.newCall(request).execute();
        if(response.code() == 200){
            JSONObject jsonObject = new JSONObject(response.body().string());
            JSONArray jsonArray = jsonObject.getJSONObject("d").getJSONArray("results");
            channelUrl = jsonArray.getJSONObject(0).getJSONObject("__metadata").getString("id");
        }

        return channelUrl;
    }

    public static List<GroupVideoModel> getChannelVideos(String token,int incidentId) throws IOException, JSONException {
        List<GroupVideoModel> list = new ArrayList<GroupVideoModel>();
        String channelUrl =  getChannelUrl(token);
        String url = channelUrl + "/Videos";

        OkHttpClient okHttpClient = new OkHttpClient();
        Request request = new Request.Builder()
                .url(url)
                .addHeader("Authorization ", "Bearer " + token)
                .addHeader("accept", "application/json;odata=verbose")
                .get()
                .build();
        Response response = okHttpClient.newCall(request).execute();
        if(response.code() == 200){
            JSONObject jsonObject = new JSONObject(response.body().string());
            JSONArray jsonArray = jsonObject.getJSONObject("d").getJSONArray("results");
            for(int i = 0; i<jsonArray.length();i++){
                GroupVideoModel model = new GroupVideoModel();
                String title = jsonArray.getJSONObject(i).getString("Title");
                if(title.contains("["+ incidentId +"]")){
                    model.setTitle(title);
                    model.setUrl(jsonArray.getJSONObject(i).getString("YammerObjectUrl"));
                    model.setImageUrl(jsonArray.getJSONObject(i).getString("ThumbnailUrl"));
                    list.add(model);
                }
            }
        }

        return list;
    }

    public static String createVideoPlaceHolder(String token, int incidentId, String videoName, String channelUrl) {
        String videoId = null;
        try {
            String url = channelUrl + "/Videos";

            JSONObject json = new JSONObject();
            json.put("odata.type","SP.Publishing.VideoItem");
            json.put("Description","");
            json.put("Title","IncidentRepairVideo_["+ incidentId +"]");
            json.put("FileName",videoName);
            String jsonStr = json.toString();

            OkHttpClient okHttpClient = new OkHttpClient();
            RequestBody body = RequestBody.create(MediaType.parse("application/json"),jsonStr);
            Request request = new Request.Builder()
                    .url(url)
                    .addHeader("Authorization ", "Bearer " + token)
                    .addHeader("Accept","application/json")
                    .addHeader("Content-Type","application/json")
                    .post(body)
                    .build();
            Response response = okHttpClient.newCall(request).execute();
            if(response.code() == 201){
                JSONObject jsonObject = new JSONObject(response.body().string());
                videoId = jsonObject.getString("odata.id");
            }
        }
        catch (Exception ex){
            videoId = null;
        }
        return videoId;
    }

    public static Boolean uploadVideo(String token, int incidentId, String videoName, byte[] bytes) throws Exception{
        String channelUrl = getChannelUrl(token);
        if(channelUrl==null){
            return false;
        }
        String videoId = createVideoPlaceHolder(token, incidentId, videoName, channelUrl);
        if(videoId == null){
            return false;
        }
        String urlStr = videoId + "/GetFile()/SaveBinaryStream";

        OkHttpClient client = new OkHttpClient();
        RequestBody body = RequestBody.create(MediaType.parse("video/mp4"), bytes);
        Request request = new Request.Builder()
                .url(urlStr)
                .addHeader("Authorization","Bearer " + token)
                .post(body)
                .build();
        Response response = client.newCall(request).execute();
        return response.code() == 200;
    }

    public static byte[] getBytes(InputStream inputStream) throws IOException {
        ByteArrayOutputStream byteBuffer = new ByteArrayOutputStream();
        int bufferSize = 1024;
        byte[] buffer = new byte[bufferSize];

        int len = 0;
        while ((len = inputStream.read(buffer)) != -1) {
            byteBuffer.write(buffer, 0, len);
        }
        return byteBuffer.toByteArray();
    }

    public static JSONObject getGroupNoteBookSiteCollection(String token, String nickName) {
        try{
            String groupSiteUrl = Constants.SHAREPOINT_URL + "/sites/" + nickName;
            String url = Constants.ONENOTE_RESOURCE_URL + "myOrganization/siteCollections/FromUrl(url='" + groupSiteUrl + "')";

            OkHttpClient okHttpClient = new OkHttpClient();
            Request request = new Request.Builder()
                    .url(url)
                    .addHeader("Authorization ","Bearer " + token)
                    .addHeader("accept", "application/json;odata=verbose")
                    .get()
                    .build();
            Response response = okHttpClient.newCall(request).execute();
            if(response.code() == 200){
                return new JSONObject(response.body().string());
            }
        }catch (Throwable t){
            return null;
        }
        return null;
    }

    public static String getGroupNoteBookId(String token, String collectionId, String siteId, String displayName) {
        try {
            String groupNoteBookName = (displayName + " Notebook").replace(" ", "%20");
            String url = Constants.ONENOTE_RESOURCE_URL + "myOrganization/siteCollections/" + collectionId + "/sites/"+ siteId + "/notes/notebooks?$filter=name%20eq%20'"+ groupNoteBookName +"'&$top=1";

            OkHttpClient okHttpClient = new OkHttpClient();
            Request request = new Request.Builder()
                    .url(url)
                    .addHeader("Authorization ", "Bearer " + token)
                    .addHeader("accept", "application/json;odata=verbose")
                    .get()
                    .build();
            Response response = okHttpClient.newCall(request).execute();
            if(response.code() == 200){
                JSONObject jsonObject = new JSONObject(response.body().string());
                JSONArray jsonArray = jsonObject.getJSONArray("value");
                if(jsonArray.length() == 1){
                    return jsonArray.getJSONObject(0).getString("id");
                }
            }
        }catch (Throwable t){
            return null;
        }
        return null;
    }

}
