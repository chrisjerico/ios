package com.phoenix.lotterys.my.adapter;

import android.content.Context;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.text.Spanned;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.phoenix.lotterys.BuildConfig;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.my.bean.PaymentBean;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.ShareUtils;
import com.wanxiangdai.commonlibrary.util.StringUtils;
import com.zzhoujay.html.Html;
import com.zzhoujay.richtext.RichText;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Ykai on 2019/6/5.
 */

public class PayTypeAdapter extends RecyclerView.Adapter<PayTypeAdapter.ViewHolder> {
    List<PaymentBean> list;
    private Context context;
    private LayoutInflater inflater;
    private PayTypeAdapter.OnClickListener onClickListener;
    private final ConfigBean config;
    boolean isFlavor = false;

    public PayTypeAdapter(List<PaymentBean> list, Context context) {
        this.list = list;
        this.context = context;
        RichText.initCacheDir(context);
        inflater = LayoutInflater.from(context);
        config = (ConfigBean) ShareUtils.getObject(context, SPConstants.CONFIGBEAN, ConfigBean.class);
        if (BuildConfig.FLAVOR.equals("c208")) {
            isFlavor = true;
        }
    }

    public void setListener(PayTypeAdapter.OnClickListener onClickListener) {
        this.onClickListener = onClickListener;
    }

    public interface OnClickListener {
        void onClickListener(View view, int position);
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View view = inflater.inflate(R.layout.pay_item, viewGroup, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, final int position) {
        String name = list.get(position).getName();
        Spanned spanned1 = null;
        if (!StringUtils.isEmpty(name) && name.contains("<") && name.contains("/>")) {
            String regex = "<img[^>]*>";
            spanned1 = Html.fromHtml(list.get(position).getName().replaceAll(regex, "")+ (isFlavor ? list.get(position).getTip() : ""));
        } else {
            String tip = "<span style=\"color:#2F9CF3;font-size: 10px;\">"+list.get(position).getTip()+"</span>";
            spanned1 = Html.fromHtml((list.get(position).getName().replaceFirst("<h3><span style=\"font-size: "+"^[0-9]+(.[0-9]{2})?$"+"rem;\"><p>","").
                    replaceFirst("</span><h3>","").replaceFirst("</p>","").replaceAll("margin-top:0;","")  +
                    (isFlavor ?("<br/>"+ tip) : "")) .replaceAll("<h3>","").replaceAll("</h3>",""));
        }
        if (isFlavor) {
            holder.tvContent.setVisibility(View.GONE);
        } else {
            holder.tvContent.setVisibility(View.VISIBLE);
        }
        holder.tvTitle.setText(spanned1);
        Spanned spanned = Html.fromHtml(list.get(position).getTip());
        holder.tvContent.setText(spanned);

        if (list.get(position).getCode().equals("6"))
            holder.ivImg.setBackgroundResource(R.mipmap.zfb_icon);
        if (list.get(position).getCode().equals("7"))
            holder.ivImg.setBackgroundResource(R.mipmap.wechatpay_icon);
        if (list.get(position).getCode().equals("4"))
            holder.ivImg.setBackgroundResource(R.mipmap.wechat_online);
        if (list.get(position).getCode().equals("5"))
            holder.ivImg.setBackgroundResource(R.mipmap.transfer);
        if (list.get(position).getCode().equals("2"))
            holder.ivImg.setBackgroundResource(R.mipmap.bank_online);
        if (list.get(position).getCode().equals("16"))
            holder.ivImg.setBackgroundResource(R.mipmap.zfb_icon);
        if (list.get(position).getCode().equals("3"))   //财付通
            holder.ivImg.setBackgroundResource(R.mipmap.cft_icon);
        if (list.get(position).getCode().equals("12"))
            holder.ivImg.setBackgroundResource(R.mipmap.yunshanfu);
        if (list.get(position).getCode().equals("14"))
            holder.ivImg.setBackgroundResource(R.mipmap.qq_online);
        if (list.get(position).getCode().equals("17"))   //百度
            holder.ivImg.setBackgroundResource(R.mipmap.baidu);
        if (list.get(position).getCode().equals("18"))
            holder.ivImg.setBackgroundResource(R.mipmap.jd);
        if (list.get(position).getCode().equals("19"))
            holder.ivImg.setBackgroundResource(R.mipmap.bank_online);
        if (list.get(position).getCode().equals("8"))
            holder.ivImg.setBackgroundResource(R.mipmap.quick_online);
        if (list.get(position).getCode().equals("20"))
            holder.ivImg.setBackgroundResource(R.mipmap.yunshanfu);
        if (list.get(position).getCode().equals("21"))
            holder.ivImg.setBackgroundResource(R.mipmap.qq_online);
        if (list.get(position).getCode().equals("22"))     //微信支付宝
            holder.ivImg.setBackgroundResource(R.mipmap.wx_zfb1);
        if (list.get(position).getCode().equals("24"))
            holder.ivImg.setBackgroundResource(R.mipmap.xnb_icon);
        if (list.get(position).getCode().equals("25"))
            holder.ivImg.setBackgroundResource(R.mipmap.zfb_icon);
        if (list.get(position).getCode().equals("26"))   //京东
            holder.ivImg.setBackgroundResource(R.mipmap.jd);
        if (list.get(position).getCode().equals("27"))    //钉钉
            holder.ivImg.setBackgroundResource(R.mipmap.dingding);
        if (list.get(position).getCode().equals("28"))
            holder.ivImg.setBackgroundResource(R.mipmap.wechat_online);
        if (list.get(position).getCode().equals("29"))   //多闪红包
            holder.ivImg.setBackgroundResource(R.mipmap.duosan);
        if (list.get(position).getCode().equals("30"))   //闲聊扫码
            holder.ivImg.setBackgroundResource(R.mipmap.xlsm);
        if (list.get(position).getCode().equals("31"))
            holder.ivImg.setBackgroundResource(R.mipmap.zfb_icon);
//        if (list.get(position).getId().equals("zfbzyhk_transfer"))
//            holder.ivImg.setBackgroundResource(R.mipmap.zfb_icon);
        if (list.get(position).getCode().equals("23"))
            holder.ivImg.setBackgroundResource(R.mipmap.xnb_icon);


        if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
            if (config.getData().getMobileTemplateCategory().equals("5")) {
                holder.tvTitle.setTextColor(context.getResources().getColor(R.color.font));
            } else {
                holder.tvTitle.setTextColor(context.getResources().getColor(R.color.black));
            }
        } else {
            holder.tvTitle.setTextColor(context.getResources().getColor(R.color.black));
        }
        holder.itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (onClickListener != null)
                    onClickListener.onClickListener(holder.itemView, position);
            }
        });
    }

    @Override
    public int getItemCount() {
        return list == null ? 0 : list.size();
    }

    static class ViewHolder extends RecyclerView.ViewHolder {
        @BindView(R2.id.tv_title)
        TextView tvTitle;
        @BindView(R2.id.tv_content)
        TextView tvContent;
        @BindView(R2.id.iv_img)
        ImageView ivImg;


        ViewHolder(View view) {
            super(view);
            ButterKnife.bind(this, view);
        }
    }
}
