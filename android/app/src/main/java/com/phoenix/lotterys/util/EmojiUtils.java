package com.phoenix.lotterys.util;

import android.content.Context;
import android.text.SpannableStringBuilder;
import android.text.Spanned;

import com.bumptech.glide.Glide;
import com.bumptech.glide.request.target.Target;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.sunhapper.glide.drawable.DrawableTarget;
import com.sunhapper.x.spedit.gif.drawable.ProxyDrawable;
import com.sunhapper.x.spedit.gif.span.ResizeIsoheightImageSpan;

import java.util.Locale;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * @author : W
 * @e-mail :
 * @date : 2019/11/29 11:24
 * @description :
 */
public class EmojiUtils {
    private static final String EMOJI_REGEX = "\\[em_[1-9]\\d*]";
    private static final String FORMAT = "file:///android_asset/emoji/%s.gif";

    public static SpannableStringBuilder convert(Context context, String text) {
        text = " " + text;
        SpannableStringBuilder builder = new SpannableStringBuilder(text);
        Pattern pattern = Pattern.compile(EMOJI_REGEX);
        Matcher matcher = pattern.matcher(text);
        while (matcher.find()) {
            String tag = matcher.group();
            int start = matcher.start();
            int end = matcher.end();
            String num = tag.substring(tag.indexOf("[em_") + "[em_".length(), tag.indexOf("]"));

            ProxyDrawable proxyDrawable = new ProxyDrawable();
            Glide.with(context)
                    .load(String.format(Locale.getDefault(), FORMAT, num))
//                    .placeholder(R.drawable.icon_img_place)
//                    .override(Target.SIZE_ORIGINAL)
                    .into(new DrawableTarget(proxyDrawable));
            builder.setSpan(new ResizeIsoheightImageSpan(proxyDrawable), start, end, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
        }

        return builder;
    }
}
