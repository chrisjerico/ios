package com.phoenix.lotterys.util;

/**
 * Created by Luke
 * on 2019/6/23
 */
//<p><img src="https://cdn01.qdyoukang.cn/upload/c018/customise/ueditor/php/upload/20190622/15611965549989.png"/></p>
public class ReplaceUtil {
    public static String HtnlImg(String s) {
        try {
            s = s.replace("<p><img src=\"", "&").replace("\"/></p>", "&");
            String[] arr = s.split("&");
//            for (int i = 0; i < arr.length; i++) {
//                System.out.println(arr[i]);
//            }
            return arr[1];
        }catch (Exception e){
            e.printStackTrace();
        }
        return "";
    }
    public final static String CSS_STYLE ="<style>* {font-size:15px;line-height:30px;line-width:200px;}p {color:#FFFFFF;}</style>";    //白色背景
    public final static String CSS_STYLE1 ="<style>* {font-size:15px;line-height:23px;line-width:200px;text-align: center;word-break:break-all;word-wrap:break-word;}p   img{max-width: 100%; width:14px; height:14px;} </style>";    //白色背景
    public final static String CSS_STYLE2 ="<style>* {font-size:15px;line-height:23px;line-width:200px;text-align: center;word-break:break-all;word-wrap:break-word;}p   img{max-width: 100%; width:auto; height:auto;} </style>";    //白色背景

    public static String getHtmlData(String bodyHTML) {
        String head = "<head>"
                + "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=no\"> "
                + "<style>img{max-width: 100%; width:auto; height:auto;}</style>"
                + "</head>";
        return "<html>" + head + "<body>" + bodyHTML + "</body></html>";
    }

    public static String getHtmlDataNoSpacing(String bodyHTML) {
        String head = "<head>"
                + "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=no\"> "
                + "<style>img{max-width: 100%; width:auto; height:auto;margin: 0;padding: 0}" +
                "p{margin: 0;padding: 0}" +
                "body{width:100%;word-break: break-all;word-wrap: break-word;vertical-align: middle;overflow: hidden;margin: 0;padding: 0}</style>"
                + "</head>";
        return "<html>" + head + "<body>" + bodyHTML + "</body></html>";
    }

    public static String getHtmlFormat(String bodyHTML,String head1,String footer,String payTip) {
        String head = "<head>"
                + "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=no\"> "
                + "<style>img{max-width: 100%; width:auto; height:auto;}</style>"
                +head1
                + "</head>";
        return "<html>" + head + "<body>" + bodyHTML + "</body>"+footer+payTip+"</html>";
    }

    public static String getHtmlFormat(String body) {
        return "<!DOCTYPE html><html lang='zh-CN'><head><meta name='viewport' content='initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'>" +
                "<style>img{width:100%!important;max-width:100%;height:auto !important}</style>" +
                "<style>body{width:100%;word-break: break-all;word-wrap: break-word;vertical-align: middle;overflow: hidden;margin: 0;padding: 0}" +
                "</style></head><body>" +
                body +
                "</body></html>";
    }

    public static String getHtmlFormat0(String bodyHTML,String head1,String footer,String payTip) {
        String head = "<head>"
                + "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=no\"> "
                + "<style>img{max-width: 100%; width:auto; height:auto;}</style>"
                + "<style>p{ margin:0px;}</style>"
                +head1
                + "</head>";
        return "<html>" + head + "<body>" + bodyHTML + "</body>"+footer+payTip+"</html>";
    }

    public static String getHtmlFormat1(String bodyHTML,String head1,String footer,String payTip) {
        String head = "<head>"
                + "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=no\"> "
                + "<style>img{max-width: 100%; width:auto; height:auto;}</style>"
                +"<style>* {font-size:11px !important}</style>"
                +head1
                + "</head>";
        return "<html>" + head + "<body>" + bodyHTML + "</body>"+footer+payTip+"</html>";
    }

    public static String css = "<style type=\"text/css\"> img {" +
            "width:auto;" +//限定图片宽度填充屏幕
            "height:auto;" +//限定图片高度自动
            "}" +
            "body {" +
            "margin-right:15px;" +//限定网页中的文字右边距为15px(可根据实际需要进行行管屏幕适配操作)
            "margin-left:15px;" +//限定网页中的文字左边距为15px(可根据实际需要进行行管屏幕适配操作)
            "margin-top:5px;" +//限定网页中的文字上边距为15px(可根据实际需要进行行管屏幕适配操作)
            "font-size:40px;" +//限定网页中文字的大小为40px,请务必根据各种屏幕分辨率进行适配更改
//            "width:auto;" +//限定网页中文字的大小为40px,请务必根据各种屏幕分辨率进行适配更改
//            "wrap{word-break:break-all; width:200px;"+
            "word-wrap:break-word;"+//允许自动换行(汉字网页应该不需要这一属性,这个用来强制英文单词换行,类似于word/wps中的西文换行)
            "}" +
            "</style>";

}
