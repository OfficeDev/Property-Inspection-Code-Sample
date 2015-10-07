package com.canviz.repairapp.data;

import android.graphics.Bitmap;

public class GroupVideoModel {
    private String Title;
    private String Url;
    private String ImageUrl;
    private Bitmap Image;
    private Boolean IsChanged;

    public String getTitle() {
        return Title;
    }

    public void setTitle(String title) {
        Title = title;
    }

    public String getUrl() {
        return Url;
    }

    public void setUrl(String url) {
        Url = url;
    }

    public Bitmap getImage() {
        return Image;
    }

    public void setImage(Bitmap image) {
        Image = image;
    }

    public Boolean getIsChanged() {
        return IsChanged;
    }

    public void setIsChanged(Boolean isChanged) {
        IsChanged = isChanged;
    }

    public String getImageUrl() {
        return ImageUrl;
    }

    public void setImageUrl(String imageUrl) {
        ImageUrl = imageUrl;
    }
}
