package com.phoenix.lotterys.my.adapter;

import android.content.Context;
import android.graphics.Color;
import android.util.Log;
import android.view.View;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.my.bean.RecommendBenefitBean;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerAdapter;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerHolder;
import com.wanxiangdai.commonlibrary.util.StringUtils;

import java.util.List;

/**
 * 文件描述:
 * 创建者: IAN
 * 创建时间: 2019/8/24 19:13
 */
public class RecommendInformationAdapter extends BaseRecyclerAdapter<RecommendBenefitBean.DataBean
        .ListBean> {

    private int id;

    public void setId(int id) {
        this.id = id;
    }

    public RecommendInformationAdapter(Context context, List<RecommendBenefitBean.DataBean
            .ListBean> list, int itemLayoutId) {
        super(context, list, itemLayoutId);
    }

    @Override
    public void convert(BaseRecyclerHolder holder, RecommendBenefitBean.DataBean
            .ListBean item, int position, boolean isScrolling) {
        if (position%2!=0){
            holder.getView(R.id.main_lin).setBackgroundColor(context.getResources().getColor(R.color.my_line));
        }else{
            holder.getView(R.id.main_lin).setBackgroundColor(Color.parseColor("#e7e7e7"));
        }
        setSype(holder,item);

        Log.e("id==",id+"///");

        if (id==1) {
//            ((TextView)holder.getView(R.id.name_text6)).setOnClickListener(new View.OnClickListener() {
//                @Override
//                public void onClick(View v) {
//                    EvenBusUtils.setEvenBus(new Even(EvenBusCode.RECOMMENDED_EARNINGS,item));
//                }
//            });
            holder.getView(R.id.name_text5).setVisibility(View.GONE);
            holder.getView(R.id.name_text1_lin0).setVisibility(View.VISIBLE);
            ((TextView)holder.getView(R.id.name_text6)).setText("充值");
            if (!StringUtils.isEmpty(item.getEnable())&&StringUtils.equals("正常",item.getEnable())){
                ((TextView)holder.getView(R.id.name_text6)).setCompoundDrawablesWithIntrinsicBounds(
                        0, 0, R.drawable.ba_green_50, 0);//ba_green_50
            }else {
                ((TextView)holder.getView(R.id.name_text6)).setCompoundDrawablesWithIntrinsicBounds(
                        0, 0, R.drawable.ba_red_50, 0);//ba_red_50
            }

        }else if (id==10){
            holder.getView(R.id.name_text1_lin0).setVisibility(View.VISIBLE);
        }else{
            holder.getView(R.id.name_text1_lin0).setVisibility(View.GONE);
        }


    }

    private void setSype(BaseRecyclerHolder holder,RecommendBenefitBean.DataBean
            .ListBean item) {
        switch (id) {
            case 1:
                if (!StringUtils.isEmpty(item.getIs_online())&&StringUtils.equals("1",item.getIs_online())){
                    setTex(holder,item.getLevel(), item.getUsername(), "在线"  , Uiutils.romTwo(item.getRegtime()),  item.getCaozuo(), true);
                }else{
                    setTex(holder,item.getLevel(), item.getUsername(),"离线"    , Uiutils.romTwo(item.getRegtime()),  item.getCaozuo(), true);
                }
                break;
            case 2:
                setTex(holder,item.getLevel(), item.getDate(), item.getBet_sum(), item.getFandian_sum(), "开发者自定义", true);
                break;
            case 3:
                setTex(holder,item.getLevel(), item.getUsername(),  item.getDate(),  item.getMoney(), "开发者自定义", true);
                break;
            case 4:
                setTex(holder,"开发者自定义", "http://"+item.getDomain(), "http://"+item.getDomain()+"?r",
                        "开发者自定义", "开发者自定义", false);
                break;
            case 5:
                setTex(holder,item.getLevel(),  item.getDate(), item.getAmount(), item.getMember(), "开发者自定义", true);
                break;
            case 6:
                setTex(holder,item.getLevel(), item.getUsername(),  item.getDate(), item.getAmount(), "开发者自定义", true);
                break;
            case 7:
                setTex(holder,item.getLevel(),  item.getDate(), item.getAmount(), item.getMember(), "开发者自定义", true);
                break;
            case 8:
                setTex(holder,item.getLevel(), item.getUsername(),  item.getDate(), item.getAmount(), "开发者自定义", true);
                break;
            case 9:
                setTex(holder,item.getLevel(),  item.getDate(),  item.getValidBetAmount(),  item.getNetAmount(), "开发者自定义", true);
                break;
            case 10:
                setTex(holder,item.getLevel(),   item.getUsername()  ,item.getPlatform()  ,
                        Uiutils.romTwo(item.getDate()),  item.getValidBetAmount(),  item.getComnetAmount()+"", true);
                break;
        }
    }

    private void setTex(BaseRecyclerHolder holder,String name1, String name2, String name3, String name4, String name5, boolean isOK) {
        setTextV(name1, holder.getView(R.id.name_text1),holder);
        setTextV(name2, holder.getView(R.id.name_text2),holder);
        setTextV(name3, holder.getView(R.id.name_text3),holder);
        setTextV(name4, holder.getView(R.id.name_text4),holder);
        setTextV(name5, holder.getView(R.id.name_text5),holder);
    }

    private void setTex(BaseRecyclerHolder holder,String name1, String name2, String name3, String name4, String name5,String name6, boolean isOK) {
        setTextV(name1, holder.getView(R.id.name_text1),holder);
        setTextV(name2, holder.getView(R.id.name_text2),holder);
        setTextV(name3, holder.getView(R.id.name_text3),holder);
        setTextV(name4, holder.getView(R.id.name_text4),holder);
        setTextV(name5, holder.getView(R.id.name_text5),holder);
        setTextV(name6, holder.getView(R.id.name_text6),holder);
    }

    private void setTextV(String name1, TextView textView,BaseRecyclerHolder holder) {
        if (!StringUtils.isEmpty(name1)&&!StringUtils.equals("开发者自定义",name1)) {
            if (textView == holder.getView(R.id.name_text1)) {
                holder.getView(R.id.name_text1_lin).setVisibility(View.VISIBLE);
                switch (name1){
                    case "0": textView.setText("全部下线");break;
                    case "1": textView.setText("一级下线");break;
                    case "2": textView.setText("二级下线");break;
                    case "3": textView.setText("三级下线");break;
                    case "4": textView.setText("四级下线");break;
                    case "5": textView.setText("五级下线");break;
                    case "6": textView.setText("六级下线");break;
                    case "7": textView.setText("七级下线");break;
                    case "8": textView.setText("八级下线");break;
                    case "9": textView.setText("九级下线");break;
                    case "10": textView.setText("十级下线");break;
                    case "11": textView.setText("十一级下线");break;
                    case "12": textView.setText("十二级下线");break;
                    case "13": textView.setText("十三级下线");break;
                    case "14": textView.setText("十四级下线");break;
                    case "15": textView.setText("十五级下线");break;
                    case "16": textView.setText("十六级下线");break;
                    case "17": textView.setText("十七级下线");break;
                    case "18": textView.setText("十八级下线");break;
                    case "19": textView.setText("十九级下线");break;
                    default: textView.setText("全部下线");break;
                }
            } else {
                textView.setVisibility(View.VISIBLE);
                textView.setText(name1);
            }

        } else if (!StringUtils.isEmpty(name1)&&StringUtils.equals("开发者自定义",name1)){
            if (textView == holder.getView(R.id.name_text1)) {
                holder.getView(R.id.name_text1_lin).setVisibility(View.GONE);
            } else {
                textView.setVisibility(View.GONE);
            }
        }else{
            if (textView == holder.getView(R.id.name_text1)) {
                holder.getView(R.id.name_text1_lin).setVisibility(View.VISIBLE);
                textView.setText("全部下线");
            } else {
                textView.setVisibility(View.VISIBLE);
                textView.setText("--");
            }

        }
    }


}
