package com.phoenix.lotterys.util;

import android.graphics.Color;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;

import java.util.Set;

/**
 * Created by Luke
 * on 2019/6/18
 */
public class NumUtil {
    public static int BackColor(String value) {
        int color = 0;
        switch (value) {
            case "blue":
                color = R.drawable.shape_bet_btn_bg;
                break;
            case "red":
                color = R.drawable.shape_reset_btn_bg;
                break;
            case "green":
                color = R.drawable.shape_chip_btn_bg;
                break;
            default:
                color = Color.WHITE;
                break;
        }
        return color;
    }
    public static int SixNumColor(int num) {
        int color = 0;
        for (int i : RedNum) {
            if (num == i) {
                color = R.drawable.hollow_yellow;
                break;
            }
        }
        for (int i : BlueNum) {
            if (num == i) {
                color = R.drawable.hollow_deepred;
                break;
            }
        }
        for (int i : GreenNum) {
            if (num == i) {
                color = R.drawable.hollow_azury;
                break;
            }
        }
        return color;
    }
    public static int SixNumImg(int num) {
        int color = 0;
        for (int i : RedNum) {
            if (num == i) {
                color = R.mipmap.ball_red;
                break;
            }
        }
        for (int i : BlueNum) {
            if (num == i) {
                color = R.mipmap.ball_blue;
                break;
            }
        }
        for (int i : GreenNum) {
            if (num == i) {
                color = R.mipmap.ball_green;
                break;
            }
        }
        return color;
    }
    static int[] BlueNum = {3, 4, 9, 10, 14, 15, 20, 25, 26, 31, 36, 37, 41, 42, 47, 48};
    static int[] RedNum = {1, 2, 7, 8, 12, 13, 18, 19, 23, 24, 29, 30, 34, 35, 40, 45, 46};
    static int[] GreenNum = {5, 6, 11, 16, 17, 21, 22, 27, 28, 32, 33, 38, 39, 43, 44, 49};

    public static int NumColor(int num) {
        int color = 0;
        for (int i : RedNum) {
            if (num == i) {
                color = R.drawable.hollow_red;
                break;
            }
        }
        for (int i : BlueNum) {
            if (num == i) {
                color = R.drawable.hollow_blue;
                break;
            }
        }
        for (int i : GreenNum) {
            if (num == i) {
                color = R.drawable.hollow_green;
                break;
            }
        }
        return color;
    }
    public static int NumColorSolid(int num) {
        int color = 0;
        for (int i : RedNum) {
            if (num == i) {
                color = R.drawable.hollow_red1;
                break;
            }
        }
        for (int i : BlueNum) {
            if (num == i) {
                color = R.drawable.hollow_blue1;
                break;
            }
        }
        for (int i : GreenNum) {
            if (num == i) {
                color = R.drawable.hollow_green1;
                break;
            }
        }
        return color;
    }

    public static int NumImg(int num) {
        int color = 0;
        for (int i : RedNum) {
            if (num == i) {
                color = R.mipmap.ball_red;
                break;
            }
        }
        for (int i : BlueNum) {
            if (num == i) {
                color = R.mipmap.ball_blue;
                break;
            }
        }
        for (int i : GreenNum) {
            if (num == i) {
                color = R.mipmap.ball_green;
                break;
            }
        }
        return color;
    }

    static int[] BlueNum1 = {3,6,9,12,15,18,21,24};
    static int[] RedNum1 = {1,4,7,10,16,19,22,25};
    static int[] GreenNum1 = {2,5,8,11,17,20,23,26};

    public static int NumColor1(int num) {
        int color = 0;
        for (int i : RedNum1) {
            if (num == i) {
                color = R.drawable.hollow_green1;
                break;
            }
        }
        for (int i : BlueNum1) {
            if (num == i) {
                color = R.drawable.hollow_red1;
                break;
            }
        }
        for (int i : GreenNum1) {
            if (num == i) {
                color = R.drawable.hollow_blue1;
                break;
            }
        }
        return color;
    }




    public static Set<Integer> NumRan(int num) {
        java.util.Random ran = new java.util.Random();
        java.util.Set<Integer> set = new java.util.HashSet<Integer>();//set中的元素是不能重复的
        while (set.size() < num) {
            int n = ran.nextInt(num);//产生0-9之间的随机数
            set.add(n);//添加到set中。set中元素不能重复，因此重复的元素添加不进去
        }
        for (int i : set) {//foreach循环取值
//            System.out.println(i);
            switch (num) {
                case 0:  //重庆时时彩

                    break;
            }
        }
        return set;
    }

    public static int RanColor(int num) {
        int color = 0;
        switch (num) {
            case 10:
                color = R.drawable.hollow_azury;
                break;
            case 1:
                color = R.drawable.shape_bet_btn_bg;
                break;
            case 2:
                color = R.drawable.hollow_deepred;
                break;
            case 3:
                color = R.drawable.hollow_gears;
                break;
            case 4:
                color = R.drawable.shape_chip_btn_bg;
                break;
            case 5:
                color = R.drawable.hollow_purple;
                break;
            case 6:
                color = R.drawable.shape_reset_btn_bg;
                break;
            case 7:
                color = R.drawable.hollow_swart;
                break;
            case 8:
                color = R.drawable.hollow_yellow;
                break;
            case 9:
                color = R.drawable.hollow_deep;
                break;
        }
        return color;
    }
    public static int circleColor(int num) {
        if(num==0||num==13||num==14||num==27){
            num=0;
        }else if(num==3||num==6||num==9||num==12||num==15||num==18||num==21||num==24){
            num=3;
        }else if(num==1||num==4||num==7||num==10||num==16||num==19||num==22||num==25){
            num=2;
        }else if(num==2||num==5||num==8||num==11||num==17||num==20||num==23||num==26){
            num=1;
        }

        int color = 0;
        switch (num) {
            case 0:
                color = R.drawable.circle_gray;
                break;
            case 1:
                color = R.drawable.circle_blue;
                break;
            case 2:
                color = R.drawable.circle_green;
                break;
            case 3:
                color = R.drawable.circle_red;
                break;
        }
        return color;
    }


    public static boolean isContain(String s1, String s2) {
        return s1.contains(s2);
    }
}
