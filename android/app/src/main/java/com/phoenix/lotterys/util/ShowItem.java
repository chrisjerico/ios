package com.phoenix.lotterys.util;

import androidx.recyclerview.widget.RecyclerView;
import android.text.TextUtils;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;

import java.util.Stack;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class ShowItem {

    public static final String PK10 = "pk10";
    public static final String LHC = "lhc";
    public static final String CQSSC = "cqssc";
    public static final String BJKL8 = "bjkl8";
    public static final String QXC = "qxc";
    public static final String PK10NN = "pk10nn";
    public static final String XYFT = "xyft";
    public static final String PCDD = "pcdd";
    public static final String GDKL10 = "gdkl10";
    public static final String JSK3 = "jsk3";
    public static final String GD11X5 = "gd11x5";


    public static void ShowItem(String name, RecyclerView rvClass, TextView tvClassName, LinearLayout llMain, int position, String[] mPosition) {
        if (name.equals("正特") || name.equals("特码") || name.equals("连码") || name.equals("连肖") || name.equals("连尾") || name.equals("直选")) {
            for (String s : mPosition) {
                if (position == Integer.parseInt(s)) {
                    rvClass.setVisibility(View.VISIBLE);
                    tvClassName.setVisibility(View.VISIBLE);
                    llMain.setVisibility(View.VISIBLE);
                }
            }
        }
    }

    //显示多少item
    public static int RowItem(String rightTitle) {
        if (rightTitle == null) {
            return 1;
        }
        int row =rightTitle.equals("特码B") ? 3:rightTitle.equals("特码A") ? 3:rightTitle.equals("特码A色波") ? 3:rightTitle.equals("特码B色波") ? 3:rightTitle.equals("正码") ? 3:rightTitle.equals("正1特") ? 3:rightTitle.equals("正2特") ? 3:rightTitle.equals("正3特") ? 3:rightTitle.equals("正4特") ? 3:rightTitle.equals("正5特") ? 3:rightTitle.equals("正6特") ? 3:rightTitle.equals("三全中") ? 3:rightTitle.equals("二全中") ? 3:rightTitle.equals("四中特") ? 3:rightTitle.equals("特串") ? 3:
                rightTitle.equals("平特一肖") ? 1 : rightTitle.equals("平特尾数") ? 1 : rightTitle.equals("特码尾数") ? 1 : rightTitle.equals("特肖") ? 1 : rightTitle.equals("连肖") ?
                1 : rightTitle.equals("二连肖") ? 1 : rightTitle.equals("三连肖") ? 1 : rightTitle.equals("四连肖") ? 1 : rightTitle.equals("五连肖") ? 1 : rightTitle.equals("合肖") ? 1 : rightTitle.equals("二连尾")
                ? 1 : rightTitle.equals("三连尾") ? 1 : rightTitle.equals("四连尾") ? 1 : rightTitle.equals("五连尾") ? 1 : rightTitle.equals("正肖") ? 1 : rightTitle.equals("自选不中") ?
                4 : rightTitle.equals("万千1vs2") ? 3 : rightTitle.equals("万百1vs3") ? 3 : rightTitle.equals("万十1vs4") ? 3 : rightTitle.equals("万个1vs5") ? 3 : rightTitle.equals("千百2vs3") ? 3 : rightTitle.equals("千十2vs4") ?
                3 : rightTitle.equals("千个2vs5") ? 3 : rightTitle.equals("百十3vs4") ? 3 : rightTitle.equals("百个3vs5") ? 3 : rightTitle.equals("十个4vs5") ? 3 : rightTitle.equals("前二直选") ? 4 : rightTitle.equals("前三直选") ? 4
                : rightTitle.equals("任选二") ? 3 : rightTitle.equals("选二连组") ? 3 : rightTitle.equals("任选三") ? 3 : rightTitle.equals("选三前组") ? 3 : rightTitle.equals("任选四") ? 3 : rightTitle.equals("任选五") ? 3 :
                rightTitle.equals("二中二") ? 3 :rightTitle.equals("三中三") ? 3 :rightTitle.equals("四中四") ? 3 :rightTitle.equals("五中五") ? 3 :
                rightTitle.equals("六中五") ? 3 : rightTitle.equals("七中五") ? 3 : rightTitle.equals("八中五") ? 3 : rightTitle.equals("前二组选") ? 3 : rightTitle.equals("前三组选") ? 3 : 2;
        return row;
    }

    //            else if (name.equals("前二组选")) {
//                return 2;
//            } else if (name.equals("前三组选")) {
    //去掉龙虎斗
//    public static boolean lhPk(String lh) {
//        if (lh.equals("万千1vs2") || lh.equals("万百1vs3") || lh.equals("万十1vs4") || lh.equals("万个1vs5") || lh.equals("千百2vs3") || lh.equals("千十2vs4") || lh.equals("千个2vs5") || lh.equals("百十3vs4") || lh.equals("百个3vs5") || lh.equals("十个4vs5")) {
//            return true;
//        }
//        return false;
//    }

    //gai
    public static int selectNum(int i) {
        if (i == 5) {
            return 1;
        } else if (i == 6) {
            return 2;
        } else if (i == 7) {
            return 3;
        } else if (i == 8) {
            return 4;
        } else if (i == 9) {
            return 5;
        } else if (i == 10) {
            return 6;
        } else if (i == 11) {
            return 7;
        } else if (i == 12) {
            return 8;
        }
        return 0;
    }

    public static int selectZxNum(int i) {
        if (i == 2) {
            return 0;
        } else if (i == 3) {
            return 1;
        } else if (i == 4) {
            return 2;
        } else if (i == 5) {
            return 3;
        } else if (i == 6) {
            return 4;
        } else if (i == 7) {
            return 5;
        } else if (i == 8) {
            return 6;
        } else if (i == 9) {
            return 7;
        } else if (i == 10) {
            return 8;
        } else if (i == 11) {
            return 9;
        }
        return 0;
    }

    public static int ItemCount(String name, String type) {
        int i = 0;
        if (type.equals("lhc")) {
            if (name.equals("三中二") || name.equals("三全中")) {
                return 3;
            } else if (name.equals("二全中") || name.equals("二中特") || name.equals("特串")) {
                return 2;
            } else if (name.equals("自选不中")) {
                return 5;
            } else if (name.equals("四全中")) {
                return 4;
            } else if (name.equals("合肖")) {
                return 2;
            } else if (name.equals("二连肖")) {
                return 2;
            } else if (name.equals("三连肖")) {
                return 3;
            } else if (name.equals("四连肖")) {
                return 4;
            } else if (name.equals("五连肖")) {
                return 5;
            } else if (name.equals("二连尾")) {
                return 2;
            } else if (name.equals("三连尾")) {
                return 3;
            } else if (name.equals("四连尾")) {
                return 4;
            } else if (name.equals("五连尾")) {
                return 5;
            }
        } else if (type.equals("gd11x5")) {
            if (name.equals("二中二")) {
                return 2;
            } else if (name.equals("三中三")) {
                return 3;
            } else if (name.equals("四中四")) {
                return 4;
            } else if (name.equals("五中五")) {
                return 5;
            } else if (name.equals("六中五")) {
                return 6;
            } else if (name.equals("七中五")) {
                return 7;
            } else if (name.equals("八中五")) {
                return 8;
            }else if (name.equals("前二组选")) {
                return 2;
            } else if (name.equals("前三组选")) {
                return 3;
            }

        } else if (type.equals("gdkl10")||type.equals("xync")) {
            if (name.equals("任选二") || name.equals("选二连组")) {
                return 2;
            } else if (name.equals("任选三") || name.equals("选三前组")) {
                return 3;
            } else if (name.equals("任选四")) {
                return 4;
            } else if (name.equals("任选五")) {
                return 5;
            }
        }
        return i;
    }

    //6合彩最多选多少
    public static int selectMoreSix(String name) {
        int i = 0;
        if (name.equals("三全中")) {
            i = 10;
        } else if (name.equals("三中二") || name.equals("二全中") || name.equals("二中特") || name.equals("特串")) {
            i = 7;
        } else if (name.equals("四全中")) {
            i = 4;
        } else if (name.equals("自选不中")) {
            i = 12;
        } else if (name.equals("合肖")) {
            i = 11;
        }
        return i;
    }

    //6合彩最多选多少
    public static int selectMinSix(String name) {
        int i = 0;
        if (name.equals("三全中")) {
            i = 3;
        } else if (name.equals("三中二") ) {
            i = 3;
        } else if (name.equals("二全中")) {
            i = 2;
        } else if (name.equals("二中特")) {
            i = 2;
        } else if (name.equals("特串")) {
            i = 2;
        } else if (name.equals("四全中")) {
            i = 4;
        }
        return i;
    }

    //广东最多选多少
    public static int selectMoregd(String name) {
        int i = 0;
        if (name.equals("二中二")) {
            i = 2;
        } else if (name.equals("三中三")) {
            i = 3;
        } else if (name.equals("四中四")) {
            i = 4;
        } else if (name.equals("五中五")) {
            i = 5;
        } else if (name.equals("六中五")) {
            i = 6;
        } else if (name.equals("七中五")) {
            i = 7;
        } else if (name.equals("八中五")) {
            i = 8;
        } else if (name.equals("前二组选")) {
            i = 5;
        } else if (name.equals("前三组选")) {
            i = 5;
        } else if (name.equals("前二直选") || name.equals("前三直选")) {
            i = 10;
        }
        return i;
    }

    //快乐十分最多选多少
    public static int selectMoreHappy(String name) {
        int i = 0;
        if (name.equals("任选二") || name.equals("选二连组") || name.equals("任选三") || name.equals("选三前组")) {
            i = 7;
//        } else if (name.equals("选二连组")) {
//            i = 7;
//        }else if (name.equals("任选三")) {
//            i = 7;
//        }else if (name.equals("选三前组")) {
//            i = 7;
        } else if (name.equals("任选四") || name.equals("任选五")) {
            i = 5;
        }
//        else if (name.equals("任选五")) {
//            i = 5;
//        }
        return i;
    }


    String[] temp1;

    public ShowItem(String name, String gametype) {
        String mPosition = null;
        if (gametype.equals("lhc")) {
            mPosition = name.equals("特码A") ? "3,4,5" : name.equals("特码B") ? "0,1,2" : name.equals("正1特") ? "0,1" : name.equals("正2特") ? "2,3" :
                    name.equals("正3特") ? "4,5" : name.equals("正4特") ? "6,7" : name.equals("正5特") ? "8,9" : name.equals("正6特") ? "10,11" : name.equals("三中二") ? "0" :
                            name.equals("三全中") ? "1" : name.equals("二全中") ? "2" : name.equals("二中特") ? "3" : name.equals("特串") ? "4" : name.equals("四全中") ? "5" :
                                    name.equals("二连肖") ? "0" : name.equals("三连肖") ? "1" : name.equals("四连肖") ? "2" : name.equals("五连肖") ? "3" :
                                            name.equals("二连尾") ? "0" : name.equals("三连尾") ? "1" : name.equals("四连尾") ? "2" : name.equals("五连尾") ? "3" : "0";
        } else if (gametype.equals("gd11x5")) {
            mPosition = name.equals("二中二") ? "0" : name.equals("三中三") ? "1" : name.equals("四中四") ? "2" : name.equals("五中五") ? "3" :
                    name.equals("六中五") ? "4" : name.equals("七中五") ? "5" : name.equals("八中五") ? "6" : name.equals("前二组选") ?
                            "7" : name.equals("前三组选") ? "8" : name.equals("前二直选") ? "0,2" : name.equals("前三直选") ? "1,4,5" : "0";
        } else if (gametype.equals("gdkl10")||gametype.equals("xync")) {
            mPosition = name.equals("任选二") ? "0" : name.equals("选二连组") ? "1" : name.equals("任选三") ? "2" : name.equals("选三前组") ? "3" :
                    name.equals("任选四") ? "4" : name.equals("任选五") ? "5" : "0";
//        }
//        else if (gametype.equals("xync")) {
//            mPosition = name.equals("任选二") ? "0" : name.equals("选二连组") ? "1" : name.equals("任选三") ? "2" : name.equals("选三前组") ? "3" :
//                    name.equals("任选四") ? "4" : name.equals("任选五") ? "5" : "0";
        }

        temp1 = mPosition.split(",");
    }


    public String[] itemCount() {
        return temp1;
    }

    //是否数字
    public static boolean isNumeric(String str) {
        if(TextUtils.isEmpty(str))
            return false;
        Pattern pattern = Pattern.compile("[0-9]+.*[0-9]*");
        Matcher isNum = pattern.matcher(str);
        if (!isNum.matches()) {
            return false;
        }
        return true;
    }
    public static boolean isNum(String str) {
        if(TextUtils.isEmpty(str))
            return false;
        Pattern pattern = Pattern.compile("[0-9]*[0-9]*");
        Matcher isNum = pattern.matcher(str);
        if (!isNum.matches()) {
            return false;
        }
        return true;
    }
    public static String subZeroAndDot(String s) {
        if (s.indexOf(".") > 0) {
            s = s.replaceAll("0+?$", "");//去掉多余的0
            s = s.replaceAll("[.]$", "");//如最后一位是.则去掉
        }
        return s;
    }

    public static boolean checkStrIsNum(String str) {
        for (int i = 0; i < str.length(); i++) {
//            System.out.println(str.charAt(i));
            if (!Character.isDigit(str.charAt(i))) {
                return false;
            }
        }
        return true;
    }



    //连尾
    public static String[] tail(int i) {
        String[] tails = new String[]{};
        if (i == 0) {
            tails = new String[]{"10", "20", "30", "40"};
        } else if (i == 1) {
            tails = new String[]{"01", "11", "21", "31", "41"};
        } else if (i == 2) {
            tails = new String[]{"02", "12", "22", "32", "42"};
        } else if (i == 3) {
            tails = new String[]{"03", "13", "23", "33", "43"};
        } else if (i == 4) {
            tails = new String[]{"04", "14", "24", "34", "44"};
        } else if (i == 5) {
            tails = new String[]{"05", "15", "25", "35", "45"};
        } else if (i == 6) {
            tails = new String[]{"06", "16", "26", "36", "46"};
        } else if (i == 7) {
            tails = new String[]{"07", "17", "27", "37", "47"};
        } else if (i == 8) {
            tails = new String[]{"08", "18", "28", "38", "48"};
        } else if (i == 9) {
            tails = new String[]{"09", "19", "29", "39", "49"};
        }
        return tails;
    }

    public static Stack<Integer> stack = new Stack<Integer>();


    /**
     * @param shu  元素
     * @param targ  要选多少个元素
     * @param has   当前有多少个元素
     * @param cur   当前选到的下标
     * <p>
     * 1    2   3     //开始下标到2
     * 1    2   4     //然后从3开始
     */
    static int it = 0;

    public static void f(int[] shu, int targ, int has, int cur) {

        if (has == targ) {
            System.out.println(stack);
            it++;
            System.out.println(it + "");
            return;
        }
        for (int i = cur; i < shu.length; i++) {
            if (!stack.contains(shu[i])) {
                stack.add(shu[i]);
                f(shu, targ, has + 1, i);
                stack.pop();
            }
        }

    }


    public static void p(char[] array, int index) {
        char temp;
        if (index == array.length) {
            System.out.println(array);
            return;
        }
        if (array.length == 0 || index < 0 || index > array.length) {
            return;
        }
        for (int j = index; j < array.length; j++) {
            temp = array[j];
            array[j] = array[index];
            array[index] = temp;
            p(array, index + 1);
            temp = array[j];
            array[j] = array[index];
            array[index] = temp;
        }

    }


    //6合彩 连码下注数量
    public static int selectBetCount(String name) {
        int i = 0;
        if (name.equals("三全中") || name.equals("三中二")) {
            i = 3;
        } else if (name.equals("二全中") || name.equals("二中特") || name.equals("特串")) {
            i = 2;
        } else if (name.equals("四全中")) {
            i = 0;
        } else if (name.equals("五连肖") || name.equals("五连尾")) {
            i = 5;
        } else if (name.equals("四连肖") || name.equals("四连尾")) {
            i = 4;
        } else if (name.equals("三连肖") || name.equals("三连尾")) {
            i = 3;
        } else if (name.equals("二连肖") || name.equals("二连尾")) {
            i = 2;
        }
        return i;
    }


    public static int selectGdCount(String name, int count) {
        int i = 0;
        if (name.equals("二中二") && count >= 2) {
            return 1;
        } else if (name.equals("三中三") && count >= 3) {
            return 1;
        } else if (name.equals("四中四") && count >= 4) {
            return 1;
        } else if (name.equals("五中五") && count >= 5) {
            return 1;
        } else if (name.equals("六中五") && count >= 6) {
            return 1;
        } else if (name.equals("七中五") && count >= 7) {
            return 1;
        } else if (name.equals("八中五") && count >= 8) {
            return 1;
        } else if (name.equals("前二组选")&& count >= 2) {
            return 2;
        } else if (name.equals("前三组选")&& count >= 3) {
            return 3;
        }
        return i;
    }
    public static boolean ItemOdds(String name,String type) {
        if(type.equals("gdkl10")||type.equals("xync")){
            if (name.equals("任选二") ) {
                return true;
            } else if (name.equals("选二连组") ) {
                return true;
            } else if (name.equals("任选三") ) {
                return true;
            } else if (name.equals("选三前组") ) {
                return true;
            } else if (name.equals("任选四") ) {
                return true;
            } else if (name.equals("任选五")) {
                return true;
            }
        }else if(type.equals("gd11x5")){
            if (name.equals("二中二") ) {
                return true;
            } else if (name.equals("三中三") ) {
                return true;
            } else if (name.equals("四中四") ) {
                return true;
            } else if (name.equals("五中五") ) {
                return true;
            } else if (name.equals("六中五") ) {
                return true;
            } else if (name.equals("七中五")) {
                return true;
            } else if (name.equals("八中五")) {
                return true;
            } else if (name.equals("前二组选")) {
                return true;
            } else if (name.equals("前三组选")) {
                return true;
            }
        }
        return false;
    }


    public static int SelectCrap(String s) {
        int img = 0;
        switch (s) {
            case "1":
                img = R.mipmap.sz_1;
                break;
            case "2":
                img = R.mipmap.sz_2;
                break;
            case "3":
                img = R.mipmap.sz_3;
                break;
            case "4":
                img = R.mipmap.sz_4;
                break;
            case "5":
                img = R.mipmap.sz_5;
                break;
            case "6":
                img = R.mipmap.sz_6;
                break;

        }
        return img;
    }


    public static boolean isContainChinese(String str) {
        Pattern p = Pattern.compile("[\u4e00-\u9fa5]");
        Matcher m = p.matcher(str);
        if (m.find()) {
            return true;
        }
        return false;
    }


}
