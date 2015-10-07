package com.canviz.repairapp.data;

import android.graphics.Bitmap;

public class UserModel {

    private String Name;
    private String Mail;
    private Bitmap Image;
    private Boolean IsChanged;

    public void setImage(Bitmap bitmap){
        Image = bitmap;
    }

    public Bitmap getImage(){
        return Image;
    }

    public String getName() {
        return Name;
    }

    public void setName(String name) {
        Name = name;
    }

    public String getMail() {
        return Mail;
    }

    public void setMail(String mail) {
        Mail = mail;
    }

    public void setIsChanged(Boolean value){
        IsChanged = value;
    }

    public Boolean getIsChanged(){
        return IsChanged;
    }
}
