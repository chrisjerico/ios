package com.phoenix.lotterys.view.tddialog;

import androidx.annotation.AnimRes;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;


public class AnimUtil {
    @AnimRes
    public static int getAnimRes(TDialog.Style style, boolean inAnimation){
        int ret=-1;
        switch (style) {
            case Center:
                ret=inAnimation? R.anim.fade_in_center: R.anim.fade_out_center;
                break;
            case DownSheet:
                ret=inAnimation? R.anim.slide_in_bottom: R.anim.slide_out_bottom;
                break;
        }
        return ret;
    }
}
