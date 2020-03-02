package com.phoenix.lotterys.util;

import android.text.TextUtils;

import java.math.BigDecimal;
import java.text.DecimalFormat;

/**
 * Date:2019/4/19
 * TIME:23:06
 * author：Luke
 */
public class FormatNum {
    public static double formatCenterMoney(String value) {
        final DecimalFormat formater = new DecimalFormat("######0.00");
        double v = Double.parseDouble(value);
//        formater.setRoundingMode(RoundingMode.FLOOR);
        double result = Double.parseDouble(formater.format(v));
        return result;
    }

    public static double formatCenterMoney2(String value) {
        final DecimalFormat formater = new DecimalFormat("######0.00");
        double v = Double.parseDouble(value);
//        formater.setRoundingMode(RoundingMode.FLOOR);
        double result = Double.parseDouble(formater.format(v));
        return result;
    }

    public static String formatCenterMoney3(String value) {
        final DecimalFormat formater = new DecimalFormat("######0.00");
        double v = Double.parseDouble(value);
//        formater.setRoundingMode(RoundingMode.FLOOR);
        String result = formater.format(value);
        return result;
    }

    public static String formatCenterMoney4(String value) {
        final DecimalFormat formater = new DecimalFormat("######0.00");
//        formater.setRoundingMode(RoundingMode.FLOOR);
        String result = formater.format(value);
        return result;
    }

    public static String formatCenterMoney1(double value) {
        final DecimalFormat formater = new DecimalFormat("######0.00");
//        formater.setRoundingMode(RoundingMode.FLOOR);
        String result = formater.format(value);
        return result;
    }


    public static String format1(String pattern, double value) {
        DecimalFormat df = null;
        df = new DecimalFormat(pattern);
//        df.setRoundingMode(RoundingMode.FLOOR);
        String str = df.format(value);
        return str;
    }

    public static String amountFormat(String number, int len) {
        // 判空
        if (number == null) {
            return "";
        }
        StringBuilder sb = new StringBuilder();
        // 判小数位
        if (len > 0) {
            sb.append(".");
            for (int i = 0; i < len; i++) {
                sb.append("0");
            }
        }
        // 模板
        String format = "###,###,###,###,##0" + sb.toString();
        DecimalFormat df = new DecimalFormat(format);
        try {
            return df.format(new BigDecimal(number));
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }

    public static String amountFormat1(String number, int len, boolean b) {
        // 判空
        if (number == null) {
            return "";
        }
        StringBuilder sb = new StringBuilder();
        // 判小数位
        if (len > 0) {
            sb.append(".");
            for (int i = 0; i < len; i++) {
                sb.append("0");
            }
        }
        // 模板
        String format = "###,###,###,###,##0" + sb.toString();
        DecimalFormat df = new DecimalFormat(format);
        try {
            return b ? df.format(new BigDecimal(number)) : df.format(new BigDecimal(number)).replaceAll(",", "");
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }

    public static String numUtils(String s) {
        if(TextUtils.isEmpty(s))
            return "";
        if(s.indexOf(".") > 0){
            //正则表达
            s = s.replaceAll("0+?$", "");//去掉后面无用的零
            s = s.replaceAll("[.]$", "");//如小数点后面全是零则去掉小数点
        }
        return s;
    }


    public static String bigAmountFormat(String number, int len) {

        // 判空
        if (number == null) {
            return "";
        }
        // 科学计数法显示出全部数字
        String num = (new BigDecimal(number)).toPlainString();
        // 切割
        String[] sp = num.split("\\.");
        String prefix = sp[0]; //整数部分
        String suffix = ""; //小数部分
        // 处理小数部分
        String[] sp2 = null;
        String temp = "0";
        if (sp.length > 1) {
            temp += "." + sp[1];
        }
        String s = amountFormat(temp, len);
        sp2 = s.split("\\.");
        if (sp2 != null && sp2.length > 1) {
            suffix = "." + sp2[1];
        }
        if (sp2 != null && "1".equals(sp2[0])) {
            prefix = (new BigDecimal(prefix)).add(new BigDecimal(1)).toString();
        }
        // 处理整数部分
        char[] chars = (new StringBuffer(prefix)).reverse().toString().toCharArray();
        temp = "";
        for (int i = 0; i < chars.length; i++) {
            if (i % 3 == 0 && i != 0) {
                temp += ",";
            }
            temp += chars[i];
        }
        prefix = (new StringBuffer(temp)).reverse().toString();

        return prefix + suffix;
    }


}
