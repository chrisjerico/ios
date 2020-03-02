package com.phoenix.lotterys.my.adapter;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.text.TextUtils;
import android.util.SparseArray;
import android.view.View;
import android.webkit.WebView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.home.adapter.ForumAdapter;
import com.phoenix.lotterys.my.bean.HistoryContentBean;
import com.phoenix.lotterys.util.ReplaceUtil;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerAdapter;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerHolder;
import com.phoenix.lotterys.view.TouchWebView;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusUtils;
import com.wanxiangdai.commonlibrary.util.ImageLoadUtil;
import com.wanxiangdai.commonlibrary.util.StringUtils;

import java.io.Serializable;
import java.util.List;

/**
 * 文件描述: 动态
 * 创建者: IAN
 * 创建时间: 2019/10/18 14:49
 */
public class DynamicAdapter extends BaseRecyclerAdapter<Serializable>  {
    private int type;
    public DynamicAdapter(Context context, List<Serializable> list, int itemLayoutId) {
        super(context, list, itemLayoutId);
    }

    public DynamicAdapter(Context context, List<Serializable> list, int itemLayoutId, int type) {
        super(context, list, itemLayoutId);
        this.type =type;
        countDownMap = new SparseArray<WebView>();
    }

    @Override
    public void convert(BaseRecyclerHolder holder, Serializable item, int position, boolean isScrolling) {
            switch (type){
                case 3:
                    HistoryContentBean.DataBean.ListBean listBean =(HistoryContentBean.DataBean.ListBean)item;
                    if (null!=listBean){
                        if (!StringUtils.isEmpty(listBean.getHeadImg())){
                            ImageLoadUtil.loadRoundImage(holder.getView(R.id.head_img),listBean.getHeadImg(),0);
                        }else{
                            ImageLoadUtil.ImageLoad(context,R.drawable.head,holder.getView(R.id.head_img));
                        }

                        holder.setText(R.id.name_tex,listBean.getNickname());
                        holder.setText(R.id.time_tex, Uiutils.getDateStr(listBean.getCreateTime()));
                        holder.setText(R.id.name_bottom_tex,listBean.getPeriods());
                        holder.setText(R.id.context_title_tex,listBean.getTitle());
//                        holder.setText(R.id.context_tex,listBean.getContent());
                        if (StringUtils.isEmpty(listBean.getLikeNum())||StringUtils.equals("0",
                                listBean.getLikeNum())){
                            holder.setText(R.id.like_tex,"");
                        }else{
                            holder.setText(R.id.like_tex,listBean.getLikeNum());
                        }

                        if (StringUtils.isEmpty(listBean.getViewNum())||StringUtils.equals("0",
                                listBean.getViewNum())){
                            holder.setText(R.id.view_count_tex,"");
                        }else{
                            holder.setText(R.id.view_count_tex,listBean.getViewNum());
                        }

                        if (StringUtils.isEmpty(listBean.getReplyCount())||StringUtils.equals("0",
                                listBean.getReplyCount())){
                            holder.setText(R.id.relation_tex,"");
                        }else{
                            holder.setText(R.id.relation_tex,listBean.getReplyCount());
                        }

                        if (!StringUtils.isEmpty(listBean.getIsLike())&&StringUtils.equals("1",listBean
                        .getIsLike())){
                            holder.getView(R.id.like_tex).setSelected(true);
                        }else{
                            holder.getView(R.id.like_tex).setSelected(false);
                        }

                        if (!StringUtils.isEmpty(listBean.getIsLhcdocVip())&&StringUtils.equals("1",listBean
                                .getIsLhcdocVip())){
                            Drawable drawable =context.getResources().getDrawable(R.drawable.lhcdoc_vip);
                            drawable.setBounds(0, 0, drawable.getMinimumWidth(),
                                    drawable.getMinimumHeight());
                            ((TextView)holder.getView(R.id.name_tex)).setCompoundDrawables(null, null, drawable, null);
                        }else{
                            ((TextView)holder.getView(R.id.name_tex)).setCompoundDrawables(null, null, null, null);
                        }

                        holder.getView(R.id.like_tex).setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                EvenBusUtils.setEvenBus(new Even(EvenBusCode.LIKE,position));
                            }
                        });
                        holder.getView(R.id.like_tex1).setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                EvenBusUtils.setEvenBus(new Even(EvenBusCode.LIKE,position));
                            }
                        });
                        holder.getView(R.id.like_tex2).setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                EvenBusUtils.setEvenBus(new Even(EvenBusCode.LIKE,position));
                            }
                        });

                        if (null!=listBean.getContentPic()&&
                                listBean.getContentPic().size() > 0) {
                            holder.getView(R.id.ll_img).setVisibility(View.VISIBLE);
                            for (int c = 0; c < listBean.getContentPic().size(); c++) {
                                if (c == 0) {
                                    ImageLoadUtil.ImageLoad(listBean.getContentPic().get(c), context, holder.getView(R.id.iv_img1), "");
                                } else if (c == 1) {
                                    ImageLoadUtil.ImageLoad(listBean.getContentPic().get(c), context, holder.getView(R.id.iv_img2), "");
                                } else if (c == 2) {
                                    ImageLoadUtil.ImageLoad(listBean.getContentPic().get(c), context, holder.getView(R.id.iv_img3), "");
                                }
                            }
                            showImg(listBean.getContentPic().size(), holder);
                        }else {
                            holder.getView(R.id.ll_img).setVisibility(View.GONE);
                        }



                        String s = listBean.getContent();
                        String temp = null;

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

                            ((LinearLayout)holder.getView(R.id.ll_content)).removeAllViews();
                            TouchWebView webviews = new TouchWebView(context);
                            webviews.setVerticalScrollBarEnabled(false);
                            webviews.setHorizontalScrollBarEnabled(false);
                            webviews.getSettings().setDefaultTextEncodingName("utf -8");//设置默认为utf-8
                            webviews.loadDataWithBaseURL(null, html, "text/html", "utf-8", null);
                            LinearLayout.LayoutParams lparams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
                            webviews.setLayoutParams(lparams);
                            ((LinearLayout)holder.getView(R.id.ll_content)).addView(webviews);
                            countDownMap.put( ((LinearLayout)holder.getView(R.id.ll_content)).hashCode(), webviews);
                            ((LinearLayout)holder.getView(R.id.ll_content)).setVisibility(View.VISIBLE);
                        }else{
                            ((LinearLayout)holder.getView(R.id.ll_content)).setVisibility(View.GONE);
                        }


                }
                    break;
            }
    }
    private SparseArray<WebView> countDownMap;
    private void showImg(int length, BaseRecyclerHolder holder) {
        switch (length) {
            case 1:
                if (length == 1) {
                    holder.getView(R.id.iv_img1).setVisibility(View.VISIBLE);
                } else {
                    holder.getView(R.id.iv_img1).setVisibility(View.INVISIBLE);
                }
                break;
            case 2:
                if (length == 2) {
                    holder.getView(R.id.iv_img2).setVisibility(View.VISIBLE);
                    holder.getView(R.id.iv_img1).setVisibility(View.VISIBLE);
                } else {
                    holder.getView(R.id.iv_img2).setVisibility(View.INVISIBLE);
                    holder.getView(R.id.iv_img1).setVisibility(View.INVISIBLE);
                }
                break;
            case 3:
                if (length == 3) {
                    holder.getView(R.id.iv_img3).setVisibility(View.VISIBLE);
                    holder.getView(R.id.iv_img1).setVisibility(View.VISIBLE);
                    holder.getView(R.id.iv_img2).setVisibility(View.VISIBLE);
                } else {
                    holder.getView(R.id.iv_img3).setVisibility(View.INVISIBLE);
                    holder.getView(R.id.iv_img1).setVisibility(View.INVISIBLE);
                    holder.getView(R.id.iv_img2).setVisibility(View.INVISIBLE);
                }
                break;
            default:
                break;
        }
    }

}
