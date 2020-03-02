package com.phoenix.lotterys.util;

/**
 * Created by Luke
 * on 2019/6/27
 */
public class ImgType {
    public static String GameImgType(String value) {
        String type = null;
        switch (value) {
            case "MG3"://MG电子  36
                type = "mg";
                break;
            case "fg"://FG电子   52
                type = "fg";
                break;
            case "PT3"://PT电子   37
                type = "pt";
                break;
            case "dt"://DT电子   40
                type = "dt";
                break;
//            case "fg"://FG捕鱼   54
//                type = "fg";
//                break;

            default:
                type = "mg";
                break;
        }
        return type;
    }

    public static String CardImgType(String value) {
        String type = null;
        switch (value) {
            case "fg":  //FG棋牌   55
                type = "kyqp";
                break;
            case "kyqp2"://开元棋牌(新线路)  //没有cdn   23
                type = "kyqp";
                break;
            case "leyou"://乐游棋牌  //没有cdn   19
                type = "kyqp";
                break;
            case "kxqp2"://开心棋牌(新线路) //没有cdn   26
                type = "kyqp";
                break;
            case "thqp2"://天豪棋牌 //没有cdn   44
                type = "kyqp";
                break;
            default:
                type = "kyqp";
                break;
        }
        return type;
    }
}
