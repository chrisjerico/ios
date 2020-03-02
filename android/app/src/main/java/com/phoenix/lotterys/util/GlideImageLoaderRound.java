package com.phoenix.lotterys.util;

import android.annotation.SuppressLint;
import android.content.Context;
import android.widget.ImageView;
import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.bumptech.glide.load.resource.bitmap.RoundedCorners;
import com.bumptech.glide.request.RequestOptions;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.youth.banner.loader.ImageLoader;

/**
 * Created by Ykai on 2018/11/20.
 */

public class GlideImageLoaderRound extends ImageLoader {
    @SuppressLint("CheckResult")
    @Override
    public void displayImage(Context context, Object path, ImageView imageView) {
//        RequestOptions options = new RequestOptions();
//        options
//                .placeholder(R.drawable.z1)
//                .diskCacheStrategy(DiskCacheStrategy.ALL);

        RoundedCorners roundedCorners = null;
        RequestOptions options = null;
            roundedCorners = new RoundedCorners(15);
            options = RequestOptions.bitmapTransform(roundedCorners)
                    .placeholder(R.drawable.z1)
                    .fallback(R.drawable.z1).error(R.drawable.z1).diskCacheStrategy(DiskCacheStrategy.ALL);

        Glide.with(context)
                .load(path)
                .apply(options)
                .into(imageView);
    }


}
