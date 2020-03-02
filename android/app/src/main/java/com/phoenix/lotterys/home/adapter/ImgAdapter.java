package com.phoenix.lotterys.home.adapter;

import android.content.Context;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import com.bumptech.glide.Glide;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

public class ImgAdapter extends RecyclerView.Adapter<ImgAdapter.ViewHolder> {
    private Context context;
    private LayoutInflater inflater;
    private ImgAdapter.OnClickListener onClickListener;
    List<String> imgPath;
    public ImgAdapter(Context context, List<String> imgPath) {
        this.context = context;
        this.imgPath = imgPath;
        inflater = LayoutInflater.from(context);
    }

    public void setListener(ImgAdapter.OnClickListener onClickListener) {
        this.onClickListener = onClickListener;
    }

    public interface OnClickListener {
        void onClickListener(View view, int position);
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View view = inflater.inflate(R.layout.item_img, viewGroup, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, final int position) {
//        ImageLoadUtil.ImageLoadCircleCrop(context, list.get(position).getIcon(), holder.ivEmotion);

//        String img = "<img src=\"file:///android_asset/emoji/" + (10 + 1) + ".gif\" >";
//        ImageLoadUtil.ImageLoad(imgPath.get(position), context,holder.ivEmotion, "");


//        Glide.with(context)
//                .load("file:///android_asset/icon_sound.png")
//                .into(holder.ivEmotion);
//        Glide.with(context).load("file:///android_asset/emoji/"+(position+1)+".gif").into(holder.ivImg);
        Glide.with(context).load(imgPath.get(position)).into(holder.ivImg);
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
        return imgPath==null?0:imgPath.size();
    }

    static class ViewHolder extends RecyclerView.ViewHolder {
        @BindView(R2.id.iv_img)
        ImageView ivImg;

        ViewHolder(View view) {
            super(view);
            ButterKnife.bind(this, view);
        }
    }
}
