package com.phoenix.lotterys.util;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;

/**
 * Created by Luke
 * on 2019/6/9
 */
public class ConstantsData {

    public static int[] CHESSIMG = new int[]{R.mipmap.kyqpicon_qp, R.mipmap.kxqp_qp, R.mipmap.lyqp_qp, R.mipmap.th_qp,
            R.mipmap.kx_qp, R.mipmap.jb_qp, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
    //体育
    public static int[] SPOTRSIMG = new int[]{R.mipmap.bstyicon_ty, R.mipmap.agicon_ty, 0, 0, 0, 0, 0, 0, 0};
    //真人
    public static int[] REALPERSONIMG = new int[]{R.mipmap.agicon_zr, R.mipmap.agicon_zr, R.mipmap.hj_zr, R.mipmap.maya_zr,
            R.mipmap.bbinicon_zr, R.mipmap.bg_zr, R.mipmap.vlzbicon, R.mipmap.ogicon_zr, R.mipmap.hgicon_zr, 0, 0, 0, 0, 0, 0, 0,};

    //电子
    public static int[] GAMEIMG = new int[]{R.mipmap.agicon_ty, R.mipmap.agicon_ty, R.mipmap.fgicon_dz, R.mipmap.bbinicon_dz,
            R.mipmap.mgicon_dz, R.mipmap.pticon_dz, R.mipmap.jdbicon_dz, R.mipmap.cq9icon_dz, R.mipmap.dticon_dz, R.mipmap.bg_zr, R.mipmap.fg_dz, R.mipmap.bb_dz, 0, 0, 0, 0, 0, 0, 0, 0, 0};

    public static String[] PWDS = new String[]{"111111", "222222", "333333", "444444", "555555", "666666", "777777", "888888", "999999", "123456", "654321", "abcdef", "aaaaaa", "qwe123"};

    public static Boolean passwod(String pwd) {
        for (int i = 0; i < PWDS.length; i++) {
            if (PWDS[i].equals(pwd)) {
                return true;
            }
        }
        return false;
    }
}
