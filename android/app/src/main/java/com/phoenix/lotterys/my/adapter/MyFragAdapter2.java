package com.phoenix.lotterys.my.adapter;

import android.content.Context;
import androidx.recyclerview.widget.RecyclerView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.my.bean.My_item;
import com.phoenix.lotterys.my.fragment.MyFragment1;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerAdapter;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerHolder;
import com.wanxiangdai.commonlibrary.util.StringUtils;

import java.util.List;

/**
 * 文件描述:
 * 创建者: IAN
 * 创建时间: 2019/9/25 19:11
 */
public class MyFragAdapter2 extends BaseRecyclerAdapter<List<My_item>> {

    public MyFragAdapter2(Context context, List<List<My_item>> list, int itemLayoutId) {
        super(context, list, itemLayoutId);
    }

    private MyFragment1.OnItemListener onItemListener;
    public MyFragAdapter2(Context context, List<List<My_item>> list, int itemLayoutId, MyFragment1.OnItemListener onItemListener) {
        super(context, list, itemLayoutId);
        this.onItemListener=onItemListener;
    }



    @Override
    public void convert(BaseRecyclerHolder holder, List<My_item> item, int position, boolean isScrolling) {
            switch (position){
                case 0:
                    holder.setText(R.id.title_tex,"我的");
                    break;
                case 1:
                    holder.setText(R.id.title_tex,"兑换/记录");
                    break;
                case 2:
                    holder.setText(R.id.title_tex,"注单详情");
                    break;
                case 3:
                    holder.setText(R.id.title_tex,"设置");
                    break;
                case 4:
                    holder.setText(R.id.title_tex,"网站资料");
                    break;

            }

            if (null!=item&&item.size()>0){
                if (!StringUtils.isEmpty(ShareUtils.getString(context,"themid",""))&&
                        StringUtils.equals("34",ShareUtils.getString(context,"themid",""))){
//                    holder.getView(R.id.myf_theme_rec).setBackground(context.getResources().getDrawable(
//                            R.drawable.input_select2));
                    Uiutils.setRec0(context, holder.getView(R.id.myf_theme_rec), 3, R.color.colorPrimary);
                }else{
                    Uiutils.setRec0(context, holder.getView(R.id.myf_theme_rec), 3, R.color.colorPrimary);
                }
                MyFragAdapter1  adapter = new MyFragAdapter1(context, item, R.layout.my_frag_adapter1,
                        onItemListener,2);
                ((RecyclerView)holder.getView(R.id.myf_theme_rec)).setAdapter(adapter);
            }



    }
}
