package com.phoenix.lotterys.chat.adapter;

import android.content.Context;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.chat.bean.ContextMsg;

import java.util.List;

public class ChatRecyAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder>{
    private List<ContextMsg> mList;
    private Context mContext;
    private LayoutInflater inflater;
    public ChatRecyAdapter(Context context, List<ContextMsg> list) {
        mList = list;
        mContext = context;
        inflater = LayoutInflater.from(context);
    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int viewType ) {
        if (viewType == ContextMsg.TYPE_SENT) {
            View view = inflater.inflate(R.layout.item_right_chat, viewGroup, false);
            RightHolder rightHolder = new RightHolder(view);
            return rightHolder;
        }else if (viewType == ContextMsg.TYPE_RECEIVED){
            View view = inflater.inflate(R.layout.item_left_chat,viewGroup,false);
            LeftHolder leftHolder = new LeftHolder(view);
            return leftHolder;
        }

        return null;
    }

    @Override
    public void onBindViewHolder(@NonNull RecyclerView.ViewHolder viewHolder, int position) {
        if (viewHolder instanceof RightHolder) {
            RightHolder rightHolder = (RightHolder) viewHolder;
            if (mList != null) {
                rightHolder.tvChatContent.setText(mList.get(position).getContent());
//                rightHolder.imgChatHead.setImageResource(R.mipmap.head_img);

            }
        }else if (viewHolder instanceof LeftHolder){
            LeftHolder leftHolder = (LeftHolder) viewHolder;
            if (mList!=null){
                leftHolder.tvChatContent.setText(mList.get(position).getContent());
//                leftHolder.imgChatHead.setImageResource(R.mipmap.head_img);
            }
        }
    }

    @Override
    public int getItemCount() {
        return mList==null?0:mList.size();
    }

    @Override
    public int getItemViewType(int position) {
        return mList.get(position).getType();
//        return 0;
    }
//    //左布局
    public class LeftHolder extends RecyclerView.ViewHolder {
        private TextView tvChatContent;
        private ImageView imgChatHead;
        public LeftHolder(View itemView) {
            super(itemView);
            tvChatContent =  itemView.findViewById(R.id.chat_content_text);
            imgChatHead =  itemView.findViewById(R.id.chat_item_header);
        }
    }
    //右布局
    public class RightHolder extends RecyclerView.ViewHolder {
        private TextView tvChatContent;
        private  ImageView imgChatHead;
        public RightHolder(View itemView) {
            super(itemView);
            tvChatContent =  itemView.findViewById(R.id.chat_content_text);
            imgChatHead =  itemView.findViewById(R.id.chat_item_header);
        }
    }

}
