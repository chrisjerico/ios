package com.phoenix.lotterys.home.adapter;

import android.content.Context;
import android.graphics.drawable.Drawable;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import android.text.TextUtils;
import android.util.Log;
import android.util.SparseArray;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.home.bean.ForumBean;
import com.phoenix.lotterys.util.ReplaceUtil;
import com.phoenix.lotterys.util.StampToDate;
import com.phoenix.lotterys.view.TouchWebView;
import com.wanxiangdai.commonlibrary.util.ImageLoadUtil;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Ykai on 2019/6/5.
 */

public class ForumAdapter extends RecyclerView.Adapter<ForumAdapter.ViewHolder> {
    List<ForumBean.DataBean.ListBean> list;

    private Context context;
    private LayoutInflater inflater;
    private OnClickListener onClickListener;
//    int load = -1;
    private SparseArray<WebView> countDownMap;
    private List<String> emojiList = new ArrayList<>();

    public ForumAdapter(List<ForumBean.DataBean.ListBean> list, Context context) {
        countDownMap = new SparseArray<WebView>();
        this.list = list;
        this.context = context;
        inflater = LayoutInflater.from(context);

//        RichText.initCacheDir(context);
//        config = (ConfigBean) ShareUtils.getObject(context, SPConstants.CONFIGBEAN, ConfigBean.class);
    }

    public void setNoLoad(int load) {
//        this.load = load;
    }

    public void setListener(OnClickListener onClickListener) {
        this.onClickListener = onClickListener;
    }

    public interface OnClickListener {
        void onClickListener(View view, int position);

        void onClickItemListener(View view, int position);
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View view = inflater.inflate(R.layout.forum_item, viewGroup, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, final int position) {
//        holder.setIsRecyclable(false);
        ForumBean.DataBean.ListBean data = list.get(position);
        if (data.getHeadImg() != null) {
            ImageLoadUtil.loadRoundImage(holder.ivHead, data.getHeadImg(), 0);
        } else {
            ImageLoadUtil.ImageLoad(context, R.drawable.load_img, holder.ivHead, R.drawable.load_img);
        }

        if (!TextUtils.isEmpty(data.getIsLhcdocVip()) && data.getIsLhcdocVip().equals("1")) {
            holder.ivV.setVisibility(View.VISIBLE);
        } else {
            holder.ivV.setVisibility(View.GONE);
        }

        if (!TextUtils.isEmpty(data.getNickname())) {
            holder.tvName.setText(data.getNickname());
            if (data.getNickname().equals("管理员")) {
                holder.tvName.setTextColor(context.getResources().getColor(R.color.color_FF00001));
            } else {
                holder.tvName.setTextColor(context.getResources().getColor(R.color.black));
            }
        } else {
            holder.tvName.setText("");
            holder.tvName.setTextColor(context.getResources().getColor(R.color.black));
        }
        if (!TextUtils.isEmpty(data.getPeriods())) {
            holder.tvNum.setText(data.getPeriods());
        } else {
            holder.tvNum.setText("");
        }
        if (!TextUtils.isEmpty(data.getTitle())) {
            holder.tvTitle.setText(data.getTitle());
        } else {
            holder.tvTitle.setText("");
        }
        if (!TextUtils.isEmpty(data.getCreateTime())) {
            String time = StampToDate.getlatelyTime(data.getCreateTime());
            holder.tvData.setText(time.equals("") ? data.getCreateTime() : time);
        } else {
            holder.tvData.setText("");
        }
        if (!TextUtils.isEmpty(data.getLikeNum())) {
            holder.tvPraise.setText(data.getLikeNum().equals("0") ? "" : data.getLikeNum());
        } else {
            holder.tvPraise.setText("");
        }
        if (!TextUtils.isEmpty(data.getViewNum())) {
            holder.tvEye.setText(data.getViewNum().equals("0") ? "" : data.getViewNum());
        } else {
            holder.tvEye.setText("");
        }

        if (!TextUtils.isEmpty(data.getReplyCount())) {
            holder.tvReplay.setText(data.getReplyCount().equals("0") ? "" : data.getReplyCount());
        } else {
            holder.tvReplay.setText("");
        }

        String s = data.getContent();
        String temp = null;
//        Log.e("xxxxloadposition", position+"|" + load);
        if (!TextUtils.isEmpty(s)) {
            for (int c = 0; c < 175; c++) {
                String img = " <img src=\"file:///android_asset/emoji/" + (c + 1) + ".gif\" >";
                if (temp != null) {
                    s = temp;
                }
                temp = s.replaceAll("\\[em_" + (c + 1) + "" + "\\]", img);
            }
            if (!s.startsWith("<p>")) {
                s = "<p>" + s + "</p>";
            }
            String html = ReplaceUtil.CSS_STYLE1 + s;
//            Log.e("xxxxhtml", "" + s);
            holder.llContent.removeAllViews();
            TouchWebView webviews = new TouchWebView(context);
            webviews.setVerticalScrollBarEnabled(false);
            webviews.setHorizontalScrollBarEnabled(false);
            webviews.getSettings().setDefaultTextEncodingName("utf -8");//设置默认为utf-8
            webviews.loadDataWithBaseURL(null, html, "text/html", "utf-8", null);
            LinearLayout.LayoutParams lparams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
            webviews.setLayoutParams(lparams);
            holder.llContent.addView(webviews);
            countDownMap.put(holder.llContent.hashCode(), webviews);

            holder.llContent.setVisibility(View.VISIBLE);
//            Spanned spanned1 = Html.fromHtml(s);
//            holder.tvContent.setText(spanned1);
//            holder.tvContent.setVisibility(View.GONE);
        } else {
            holder.llContent.setVisibility(View.GONE);
//            holder.webviews.setVisibility(View.GONE);
        }

        if (data.getIsHot() != null && data.getIsHot().equals("1")) {
            holder.ivJing.setVisibility(View.VISIBLE);
        } else {
            holder.ivJing.setVisibility(View.GONE);
        }
        if (data.getIsTop() != null && data.getIsTop().equals("1")) {
            holder.ivDing.setVisibility(View.VISIBLE);
        } else {
            holder.ivDing.setVisibility(View.GONE);
        }

        if (data.getIsLike() != null && data.getIsLike().equals("1")) {
            Drawable drawable = context.getResources().getDrawable(R.mipmap.praise_red);
            drawable.setBounds(0, 0, drawable.getMinimumWidth(),
                    drawable.getMinimumHeight());
            holder.tvPraise.setCompoundDrawables(drawable, null, null, null);
        } else {
            Drawable drawable = context.getResources().getDrawable(R.mipmap.praise);
            drawable.setBounds(0, 0, drawable.getMinimumWidth(),
                    drawable.getMinimumHeight());
            holder.tvPraise.setCompoundDrawables(drawable, null, null, null);
        }

        holder.itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (onClickListener != null)
                    onClickListener.onClickItemListener(holder.itemView, position);
            }
        });

        holder.rlPraise.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (onClickListener != null)
                    onClickListener.onClickListener(holder.itemView, position);
            }
        });

        holder.iv_img3.setVisibility(View.INVISIBLE);
        holder.iv_img1.setVisibility(View.INVISIBLE);
        holder.iv_img2.setVisibility(View.INVISIBLE);

        if (data.getContentPic().length > 0) {
            for (int c = 0; c < data.getContentPic().length; c++) {
                if (c == 0) {
                    ImageLoadUtil.ImageLoad(data.getContentPic()[c], context, holder.iv_img1, "");
                } else if (c == 1) {
                    ImageLoadUtil.ImageLoad(data.getContentPic()[c], context, holder.iv_img2, "");
                } else if (c == 2) {
                    ImageLoadUtil.ImageLoad(data.getContentPic()[c], context, holder.iv_img3, "");
                }
            }
            holder.llImg.setVisibility(View.VISIBLE);
            Log.e("xxxxxlength", "" + data.getContentPic().length);
            showImg(data.getContentPic().length, holder);

//           holder.llImg.removeAllViews();
//            holder.llImg.setVisibility(View.VISIBLE);
//            LinearLayout.LayoutParams lparams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
//            lparams.setMargins(10, 0, 0, 0);
////            String num = name.substring(0, 1);
//                for (int i = 0; i < data.getContentPic().length; i++) {
//                    TextView tv1 = new TextView(context);
//                    tv1.setBackgroundResource(NumUtil.NumColor(Integer.parseInt(tail[i])));
//                    tv1.setText(tail[i]);
//                    tv1.setGravity(Gravity.CENTER);
//                    tv1.setLayoutParams(lparams);
//                    holder.llImg.addView(tv1, i);
//            }

        } else {
            holder.llImg.setVisibility(View.GONE);
        }

    }


    @Override
    public int getItemCount() {
        return list == null ? 0 : list.size();
    }

    static class ViewHolder extends RecyclerView.ViewHolder {
        @BindView(R2.id.iv_v)
        ImageView ivV;
        @BindView(R2.id.iv_img1)
        ImageView iv_img1;
        @BindView(R2.id.iv_img2)
        ImageView iv_img2;
        @BindView(R2.id.iv_img3)
        ImageView iv_img3;
        @BindView(R2.id.iv_head)
        ImageView ivHead;
        @BindView(R2.id.tv_name)
        TextView tvName;
        @BindView(R2.id.tv_data)
        TextView tvData;
        @BindView(R2.id.tv_num)
        TextView tvNum;
        @BindView(R2.id.tv_title)
        TextView tvTitle;
        @BindView(R2.id.iv_jing)
        ImageView ivJing;
        @BindView(R2.id.iv_ding)
        ImageView ivDing;
        //        @BindView(R2.id.tv_content)
//        TextView tvContent;
        @BindView(R2.id.tv_praise)
        TextView tvPraise;
        @BindView(R2.id.tv_eye)
        TextView tvEye;
        @BindView(R2.id.tv_replay)
        TextView tvReplay;
        @BindView(R2.id.ll_main)
        LinearLayout llMain;
        @BindView(R2.id.ll_content)
        LinearLayout llContent;
        @BindView(R2.id.ll_img)
        LinearLayout llImg;
        @BindView(R2.id.rl_praise)
        RelativeLayout rlPraise;

//        @BindView(R2.id.webviews)
//        WebView webviews;

        ViewHolder(View view) {
            super(view);
            ButterKnife.bind(this, view);
        }
    }

    /**
     * 清空资源
     */
    public void cancelAllWebview() {
        if (countDownMap == null) {
            return;
        }
        for (int i = 0, length = countDownMap.size(); i < length; i++) {
            WebView web = countDownMap.get(countDownMap.keyAt(i));
            if (web != null) {
                web.removeAllViews();
                web.destroy();
            }
        }
//        RichText.clear(context);
    }


    private void showImg(int length, ViewHolder holder) {
        switch (length) {
            case 1:
                if (length == 1) {
                    holder.iv_img1.setVisibility(View.VISIBLE);
                } else {
                    holder.iv_img1.setVisibility(View.INVISIBLE);
                }
                break;
            case 2:
                if (length == 2) {
                    holder.iv_img2.setVisibility(View.VISIBLE);
                    holder.iv_img1.setVisibility(View.VISIBLE);
                } else {
                    holder.iv_img2.setVisibility(View.INVISIBLE);
                    holder.iv_img1.setVisibility(View.INVISIBLE);
                }
                break;
            case 3:
                if (length == 3) {
                    holder.iv_img3.setVisibility(View.VISIBLE);
                    holder.iv_img1.setVisibility(View.VISIBLE);
                    holder.iv_img2.setVisibility(View.VISIBLE);
                } else {
                    holder.iv_img3.setVisibility(View.INVISIBLE);
                    holder.iv_img1.setVisibility(View.INVISIBLE);
                    holder.iv_img2.setVisibility(View.INVISIBLE);
                }
                break;
            default:
                break;
        }
    }


}
