package com.phoenix.lotterys.my.adapter;

import android.content.Context;
import android.view.View;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerAdapter;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerHolder;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusUtils;

import java.io.Serializable;
import java.util.List;

/**
 * 文件描述: (公式)
 * 创建者: IAN
 * 创建时间: 2019/10/18 14:49
 */
public class PubAttentionFormulaAdapter extends BaseRecyclerAdapter<Serializable> {
    private int type;
    public PubAttentionFormulaAdapter(Context context, List<Serializable> list, int itemLayoutId) {
        super(context, list, itemLayoutId);
    }

    public PubAttentionFormulaAdapter(Context context, List<Serializable> list, int itemLayoutId, int type) {
        super(context, list, itemLayoutId);
        this.type =type;
    }

    @Override
    public void convert(BaseRecyclerHolder holder, Serializable item, int position, boolean isScrolling) {


    }
}
