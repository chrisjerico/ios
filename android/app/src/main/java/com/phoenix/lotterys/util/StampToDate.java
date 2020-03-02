package com.phoenix.lotterys.util;

import android.util.Log;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Created by Luke
 * on 2019/6/13
 */
public class StampToDate {

    public static String stampToDate(long time) {
        String res;
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
        Date date = new Date(time);
        res = simpleDateFormat.format(date);
        return res;
    }

    public static String stampToDate2(long time) {
        String res;
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd\nHH:mm:ss");
        Date date = new Date(time);
        res = simpleDateFormat.format(date);
        return res;
    }

    public static String stampToDates(long time,int type) {
        String res;
        SimpleDateFormat simpleDateFormat =null;
        switch (type){
            case 1: simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); break;
            case 2: simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm"); break;
            case 3: simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd"); break;
        }

        Date date = new Date(time);
        res = simpleDateFormat.format(date);
        return res;
    }

    public static Long dateToStamp(String s) throws ParseException {
        if (s != null) {
            SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            Date date = simpleDateFormat.parse(s.trim());
            long ts = date.getTime();
            return ts;
        }
        return Long.valueOf(0);
    }

    public static Long dateToStamp(String s,int type) throws ParseException {
        if (s != null) {
            SimpleDateFormat simpleDateFormat = null;

            if (type==1){
                simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            }else if (type==2){
                simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
            }

            Date date = simpleDateFormat.parse(s.trim());
            long ts = date.getTime();
            return ts;
        }
        return Long.valueOf(0);
    }

    public  Long StampToDate(String end, String server,long timeSys) {
        long serverTime = 0;
        try {
            if(server.equals("0")){
                serverTime = 0;
            }else {
                serverTime = timeSys - Long.parseLong(server);
            }
//            long serverTime = timeSys - dateToStamp(server);
//            Log.e("xxxtimeSys",""+timeSys);
            long lastClickTime = dateToStamp(end) - timeSys +serverTime;
            return lastClickTime;
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return 0L;
    }

    public  Long StampToDate(long timeSys,String end, String server) {
//        long serverTime = 0;
        try {
            long serverTime = timeSys - dateToStamp(server);
//            Log.e("xxxtimeSys",""+timeSys);
            long lastClickTime = dateToStamp(end) - timeSys +serverTime;
            return lastClickTime;
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return 0L;
    }


    public  Long StampToDate(String end,long timeSys) {
        try {
            long lastClickTime = dateToStamp(end) - timeSys ;
            return lastClickTime;
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return 0L;
    }

    /**
     * 将毫秒数换算成 00:00 形式
     */
    public static String getMinuteSecond(long time) {
        long days = time / (1000 * 60 * 60 * 24);
        long hours = (time % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60);
        long minutes = (time % (1000 * 60 * 60)) / (1000 * 60);
        long seconds = (time % (1000 * 60)) / 1000;
        String strMinute = minutes < 10 ? "0" + minutes : "" + minutes;
        String strSecond = seconds < 10 ? "0" + seconds : "" + seconds;
        String strHour = hours < 10 ? "0" + hours : "" + hours;
        if (days == 0) {
            return strHour + ":" + strMinute + ":"
                    + strSecond;
        }
        return days + "天" + strHour + ":" + strMinute + ":"
                + strSecond;
    }


    private static final int SECOND_MILLIS = 1000;
    private static final int MINUTE_MILLIS = 60 * SECOND_MILLIS;
    private static final int HOUR_MILLIS = 60 * MINUTE_MILLIS;
    private static final int DAY_MILLIS = 24 * HOUR_MILLIS;
    /**
     * 按照毫秒来存储
     *
     * @param time
     * @return
     */
    public static String getTimeAgo(long time) {
        if (time < 1000000000000L) {
            // if timestamp given in seconds, convert to millis
            time *= 1000;
        }

        long now = System.currentTimeMillis();
        if (time > now || time <= 0) {
            return "未知时间";
        }

        final long diff = now - time;

        if (diff < MINUTE_MILLIS) {
            return "刚刚";
        } else if (diff < 2 * MINUTE_MILLIS) {
            return "1分钟前";
        } else if (diff < 50 * MINUTE_MILLIS) {
            return diff / MINUTE_MILLIS + "分钟前";
        } else if (diff < 90 * MINUTE_MILLIS) {
            return "1小时前";
        } else if (diff < 24 * HOUR_MILLIS) {
            return diff / HOUR_MILLIS + "小时前";
        } else if (diff < 48 * HOUR_MILLIS) {
            return "昨天";
        } else {
//            return diff / DAY_MILLIS + "天前";
            return "";
        }
    }



    public static String getlatelyTime(String time) {
        long timeStamp = 0;
        try {
            timeStamp =  StampToDate.dateToStamp(time);
            return  getTimeAgo(timeStamp);
        } catch (ParseException e) {
            e.printStackTrace();
        }

        return "";
    }

}
