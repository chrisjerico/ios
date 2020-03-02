package com.phoenix.lotterys.home.adapter;

import android.app.Activity;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.util.SparseArray;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.home.bean.NoticeBean;
import com.phoenix.lotterys.util.ReplaceUtil;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;


public class HomeDialogAdapter extends RecyclerView.Adapter<HomeDialogAdapter.ViewHolder> {
    List<NoticeBean.DataBean.PopupBean> list ;
    private Activity context;
    private LayoutInflater inflater;
    private OnClickListener onClickListener;
    private SparseArray<WebView> countDownMap;
    public void setListener(OnClickListener onClickListener) {
        this.onClickListener = onClickListener;
    }


    public interface OnClickListener {
        void onClickListener(View view, int position);
    }

    public HomeDialogAdapter(List<NoticeBean.DataBean.PopupBean> list, Activity context) {
        countDownMap = new SparseArray<WebView>();
        this.list = list;
        this.context = context;
        inflater = LayoutInflater.from(context);
//        RichText.initCacheDir(context);
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View view = inflater.inflate(R.layout.item_home_dialog, viewGroup, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull final ViewHolder holder, final int position) {
        holder.tvTitle.setText(list.get(position).getTitle());

//        if(!isFeatures())


        if (list.get(position).isOpen()) {
            holder.tvTitle.setSelected(true);
//            holder.tvContent.setVisibility(View.VISIBLE);
            holder.ll_content.setVisibility(View.VISIBLE);
            holder.view.setVisibility(View.VISIBLE);

        } else {
//            holder.tvContent.setVisibility(View.GONE);
            holder.ll_content.setVisibility(View.GONE);
            holder.view.setVisibility(View.GONE);
            holder.tvTitle.setSelected(false);
        }

//        holder.tvContent.setLayerType(View.LAYER_TYPE_SOFTWARE, null);
//        RichText.from(list.get(position).getContent()).bind(context)
//                .singleLoad(false)
//                .sync(false)
//                .showBorder(false)
//                .autoPlay(true) // gif图片是否自动播放
////                .size(ImageHolder.MATCH_PARENT, ImageHolder.WRAP_CONTENT)
//                .into(holder.tvContent);


        holder.ll_content.removeAllViews();
        WebView webviews = new WebView(context);
        webviews.setVerticalScrollBarEnabled(false);
        webviews.setHorizontalScrollBarEnabled(false);
        webviews.getSettings().setDefaultTextEncodingName("utf -8");//设置默认为utf-8
//        webviews.loadDataWithBaseURL(null, list.get(position).getContent(), "text/html", "utf-8", null);   (height|HEIGHT)="(.*?)"
        String data = /*Html.fromHtml*/(list.get(position).getContent()).toString();
//        data = data.replaceAll("width=\"\\d+\"", "width=\"auto\"").replaceAll("height: \"\\d+\"", "height=\"auto\"");
        data = data.replaceAll("width", "wi").replaceAll("height", "heig");
        data = data.replaceAll("nowrap", "nowrap1");
        webviews.loadDataWithBaseURL(null, ReplaceUtil.getHtmlFormat0("",data,"", ""), "text/html", "utf-8", null);

        LinearLayout.LayoutParams lparams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
        webviews.setLayoutParams(lparams);
        holder.ll_content.addView(webviews);
        countDownMap.put(holder.ll_content.hashCode(), webviews);
        holder.tvTitle.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (onClickListener != null)
                    onClickListener.onClickListener(holder.tvTitle, position);
            }
        });

    }

    @Override
    public int getItemCount() {
        return list == null ? 0:list.size();
    }

    static class ViewHolder extends RecyclerView.ViewHolder {
        @BindView(R2.id.tv_title)
        TextView tvTitle;
//        @BindView(R2.id.iv_content)
//        ImageView ivContent;
        @BindView(R2.id.view)
        View view;
//
        @BindView(R2.id.ll_content)
        LinearLayout ll_content;

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


}
