package com.canviz.repairapp.data;

import java.util.Calendar;

public class GroupFileModel {
    private String Title;
    private String Url;
    private String OWAUrl;
    private Calendar LastModified;
    private String LastModifiedBy;
    private Long Size;

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

    public String getOWAUrl() {
        return OWAUrl;
    }

    public void setOWAUrl(String webUrl, String name, String eTag) {
        if (webUrl.endsWith("docx") || webUrl.endsWith("xlsx") || webUrl.endsWith("pptx"))
        {
            OWAUrl = webUrl.substring(0,webUrl.lastIndexOf("Shared")) + "_layouts/15/WopiFrame.aspx?sourcedoc=" + eTag.substring(1,39) + "&file=" + name + "&action=default";
        }
        else {
            OWAUrl = webUrl;
        }
    }

    public Calendar getLastModified() {
        return LastModified;
    }

    public void setLastModified(Calendar lastModified) {
        LastModified = lastModified;
    }

    public String getLastModifiedBy() {
        return LastModifiedBy;
    }

    public void setLastModifiedBy(String lastModifiedBy) {
        LastModifiedBy = lastModifiedBy;
    }

    public Long getSize() {
        return Size;
    }

    public void setSize(Long size) {
        Size = size;
    }
}
