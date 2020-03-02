package com.phoenix.lotterys.util;

import com.phoenix.lotterys.buyhall.bean.Zodiac;

import java.util.ArrayList;
import java.util.List;

/**
 * Greated by Luke
 * on 2019/8/9
 */
public class ZodiacUtil {
    List<Zodiac> aodi = new ArrayList();
    public ZodiacUtil(){
        aodi.add(new Zodiac("鼠",false));
        aodi.add(new Zodiac("牛",false));
        aodi.add(new Zodiac("虎",false));
        aodi.add(new Zodiac("兔",false));
        aodi.add(new Zodiac("龙",false));
        aodi.add(new Zodiac("蛇",false));
        aodi.add(new Zodiac("马",false));
        aodi.add(new Zodiac("羊",false));
        aodi.add(new Zodiac("猴",false));
        aodi.add(new Zodiac("鸡",false));
        aodi.add(new Zodiac("狗",false));
        aodi.add(new Zodiac("猪",false));
//        return aodi;
    }
    public List<Zodiac> aodiac() {
        return aodi;
    }
}
