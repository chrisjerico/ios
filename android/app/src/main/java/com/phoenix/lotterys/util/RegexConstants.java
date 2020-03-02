package com.phoenix.lotterys.util;

import java.util.Random;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class RegexConstants {
    public static final String PHONE_CODE_REGEX = "^((13[0-9])|(14[5,7])|(15[0-3,5-9])|(17[0,3,5-8])|(18[0-9])|166|198|199|(147))\\d{8}$"; // 中國電話號碼的Regex
    public static final String ACCOUNT_REGEX = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$"; //用戶名Regex
    public static final String EMAIL_REGEX = "[\\w\\.\\-]+@([\\w\\-]+\\.)+[\\w\\-]+";
    public static final String LOGIN_PASSWORD_REGEX = "[a-zA-Z0-9]{6,12}";
    public static final String MONEY_PASSWORD_REGEX = "[a-zA-Z0-9]{4,6}";
    public static final String PASSWORD_REGEX = "^(?:(?=.*[0-9].*)(?=.*[A-Za-z].*)(?=.*[,\\.#%'\\+\\*\\-:;^_`].*))[,\\.#%'\\+\\*\\-:;^_`0-9A-Za-z]{8,10}$";
//    public static final String REGX = "^(?!(?:[^a-zA-Z]|\\D|[a-zA-Z0-9])$).{8,}$";
    public static final String REGX = "[^\\da-zA-Z\\s] ";
//    public static final String REGEX="[`~!@#$%^&*()+=|{}':;',\\[\\].<>/?~！@#￥%……&*（）——+|{}【】‘；：”“’。，、？]";
    public static final String REGEX="^(?![0-9]+$)(?![^0-9]+$)(?![a-zA-Z]+$)(?![^a-zA-Z]+$)(?![a-zA-Z0-9]+$)[a-zA-Z0-9\\S]+$";
    public static final String IMGCODE="523t2H6Jt1BT6ARh2y526JR6";


    public static boolean isMatcherFinded(String patternStr, CharSequence input) {
        Pattern pattern = Pattern.compile(patternStr);
        Matcher matcher = pattern.matcher(input);
        if (matcher.find()) {
            return true;
        }
        return false;
    }

    public static String getRandomString(int length){
        String str="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        Random random=new Random();
        StringBuffer sb=new StringBuffer();
        for(int i=0;i<length;i++){
            int number=random.nextInt(62);
            sb.append(str.charAt(number));
        }
        return sb.toString();
    }
}
