package com.canviz.repairapp.utility;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.TimeZone;

public class Helper
{
    public static SimpleDateFormat mZuluFormat;
    public static SimpleDateFormat mAuthFormat;

    public static DateFormat getZuluFormat() {
        if (mZuluFormat == null) {
            //Format used by SharePoint for encoding datetimes
            mZuluFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
            mZuluFormat.setTimeZone(TimeZone.getTimeZone("GMT"));
        }
        return mZuluFormat;
    }

    public static DateFormat getAuthFormat() {
        if (mAuthFormat == null) {
            mAuthFormat = new SimpleDateFormat("EEE MMM dd HH:mm:ss 'EST' yyyy");
            mAuthFormat.setTimeZone(TimeZone.getTimeZone("GMT"));
        }
        return mAuthFormat;
    }

    public static Date getDate(String dataString) {
        try {
            if (dataString == null || dataString.isEmpty()) {
                return null;
            }
            return getZuluFormat().parse(dataString);
        }
        catch (Exception ex) {
            return null;
        }
    }

    public static Date getAuthDate(String dataString) {
        try {
            if (dataString == null || dataString.isEmpty()) {
                return null;
            }
            return getAuthFormat().parse(dataString);
        }
        catch (Exception ex) {
            return null;
        }
    }

    public static Date stringToDate(String dateString){
        try{
            SimpleDateFormat format = new SimpleDateFormat("MM/dd/yyyy");
            return format.parse(dateString);
        }catch(ParseException e){
            return null;
        }
    }

    public static String dateToString(Date date){
        try{
            return (new SimpleDateFormat("MM/dd/yyyy")).format(date);
        }catch(Exception ex){
            return null;
        }
    }

    public static String formatString(String dateString){
        try{
            return dateToString(getDate(dateString));
        }catch (Exception e) {
            return "";
        }
    }

    public static Boolean IsNullOrEmpty(String string){
        try{
            if(string == null || string.isEmpty()){
                return true;
            }
            else{
                return false;
            }
        }catch(Exception e){
            return true;
        }
    }

    public static  Boolean IsInt(String string){
        try{
            if(string == null || string.isEmpty()){
                return false;
            }
            else{
                return Integer.parseInt(string) > 0;
            }
        }catch(Exception e){
            return false;
        }
    }

    public static String getString(String string){
        if(string == null){
            return "";
        }
        return string;
    }

    public static String getFileName(){
        Date current = new Date();
        return (new SimpleDateFormat("yyMMddHHmmssSSS")).format(current) + ".jpg";
    }
}
