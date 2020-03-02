package com.phoenix.lotterys.util;

import android.text.TextUtils;

/**
 * @author : Wu
 * @e-mail : wu_developer@outlook.com
 * @date : 2019/12/13 17:05
 * @description :
 */
public class FormatUtils {
    public static int formatInt(String str, int defaultValue) {
        if (TextUtils.isEmpty(str)) {
            return defaultValue;
        }
        try {
            return Integer.valueOf(str);
        } catch (NumberFormatException e) {
            e.printStackTrace();
            return defaultValue;
        }
    }

    public static double formatDouble(String str, double defaultValue) {
        if (TextUtils.isEmpty(str)) {
            return defaultValue;
        }
        try {
            return Double.valueOf(str);
        } catch (NumberFormatException e) {
            e.printStackTrace();
            return defaultValue;
        }
    }

    public static void main(String[] args) {
        System.out.println(formatDouble("1.00", 0.0));
    }
}
