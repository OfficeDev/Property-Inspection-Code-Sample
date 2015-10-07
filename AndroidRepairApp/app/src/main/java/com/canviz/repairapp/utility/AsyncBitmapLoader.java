package com.canviz.repairapp.utility;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.lang.ref.SoftReference;
import java.net.URL;
import java.util.HashMap;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.widget.ImageView;

import com.canviz.repairapp.Constants;

public class AsyncBitmapLoader {
    private static final String TAG="AsyncBitmapLoader";

    private static HashMap<String, SoftReference<Bitmap>> imageCache = new HashMap<String, SoftReference<Bitmap>>();

    public static void saveBitmapToCache(String imageURL,Bitmap bitmap){
        try {
            if(imageCache.containsKey(imageURL)) {
                return;
            }
            else
            {
                imageCache.put(imageURL, new SoftReference<Bitmap>(bitmap));
            }

            File dir = new File(Constants.LOCALIMAGE_SAVEPATH);
            if (!dir.exists()) {
                dir.mkdirs();
            }

            File bitmapFile = new File(Constants.LOCALIMAGE_SAVEPATH + imageURL.substring(imageURL.lastIndexOf("/") + 1));
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
        } catch (Exception e) {
        }
    }

    public static Bitmap loadBitmap(String imageURL) {
        try {
            if (imageCache.containsKey(imageURL)) {
                SoftReference<Bitmap> reference = imageCache.get(imageURL);
                Bitmap bitmap = reference.get();
                if (bitmap != null) {
                    return bitmap;
                }
            } else {
                String bitmapName = imageURL.substring(imageURL.lastIndexOf("/") + 1);
                File cacheDir = new File(Constants.LOCALIMAGE_SAVEPATH);
                if (!cacheDir.exists()) {
                    cacheDir.mkdirs();
                }
                File[] cacheFiles = cacheDir.listFiles();
                int i = 0;
                if (cacheFiles != null) {
                    for (; i < cacheFiles.length; i++) {
                        if (bitmapName
                                .substring(0, bitmapName.lastIndexOf("."))
                                .equals(cacheFiles[i].getName().substring(
                                        0,
                                        cacheFiles[i].getName()
                                                .lastIndexOf(".")))) {
                            break;
                        }
                    }

                    if (i < cacheFiles.length) {
                        return BitmapFactory
                                .decodeFile(Constants.LOCALIMAGE_SAVEPATH
                                        + bitmapName);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            Log.w(TAG, e.getMessage());
        }
        return null;
    }
}
