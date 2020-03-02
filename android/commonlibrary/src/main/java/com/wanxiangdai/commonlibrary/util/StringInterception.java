package com.wanxiangdai.commonlibrary.util;

import android.content.Context;
import android.text.Spannable;
import android.text.SpannableString;
import android.text.Spanned;
import android.text.style.AbsoluteSizeSpan;
import android.text.style.ForegroundColorSpan;

import com.wanxiangdai.commonlibrary.R;


/**
 * Created by Ykai on 2018/7/7.
 */

public class StringInterception {

    public static SpannableString interception(Context context, String s, int start, int end) {
        SpannableString ss = new SpannableString(s);
        ss.setSpan(new ForegroundColorSpan(context.getResources().getColor(R.color.color_22a6ec)), start, end,
                Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);

        return ss;
    }


    public static SpannableString interception(Context context, String s, int color, int start, int end) {
        SpannableString ss = new SpannableString(s);
        ss.setSpan(new ForegroundColorSpan(context.getResources().getColor(color)), start, end,
                Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);

        return ss;
    }

    public static SpannableString setTextSize(Context context, String s, int size, int start, int end) {
        SpannableString ss = new SpannableString(s);
        ss.setSpan(new AbsoluteSizeSpan(size), start, end, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
//        ss.setSpan(new AbsoluteSizeSpan(14), 2, 4, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);

        return ss;
    }


}
