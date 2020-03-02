package com.phoenix.lotterys.my.fragment;

import android.os.Bundle;
import androidx.fragment.app.Fragment;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.bigkoo.pickerview.TimePickerView;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.my.bean.CommentBean;
import com.phoenix.lotterys.util.FragmentUitl;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.view.CustomTitleBar;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusUtils;
import com.wanxiangdai.commonlibrary.util.StringUtils;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * 文件描述: 六合公共(入口)
 * 创建者: IAN
 * 创建时间: 2019/10/18 12:35
 */
public class PubAttentionFrag extends BaseFragments {

    @BindView(R2.id.titlebar)
    CustomTitleBar titlebar;
    @BindView(R2.id.attention_left_tex)
    TextView attentionLeftTex;
    @BindView(R2.id.attention_right_tex)
    TextView attentionRightTex;
    @BindView(R2.id.option_lin)
    LinearLayout optionLin;
    @BindView(R2.id.framnent_lin)
    LinearLayout framnentLin;

    public PubAttentionFrag() {
        super(R.layout.pub_attention_frag, true, true);
    }

    private int type ;

    private FragmentUitl fragmentUitl;
    private List<Fragment> listFrag =new ArrayList<>();

    @Override
    public void initView(View view) {
        type = getArguments().getInt("type");

        Uiutils.setBarStye(titlebar, getActivity());
        switch (type){
            case 1:
                inivTitle("我的关注","关注专家","关注帖子");
                break;
            case 2:
                inivTitle("我的动态","","");
                break;
            case 3:
                inivTitle("我的粉丝","我的粉丝","帖子粉丝");
                break;
            case 4:
                String ty =(String)getArguments().getString("main_id");
                if (!StringUtils.isEmpty(ty)&&StringUtils.equals("5",ty)){
                    inivTitle("","","");
                    tvMore = (TextView) titlebar.getTvMore();
                    tvMore.setVisibility(View.VISIBLE);
                    tvMore.setCompoundDrawablesWithIntrinsicBounds(null,
                            null, null, null);
                    tvMore.setTextColor(getContext().getResources().getColor(R.color.color_white));
                    tvMore.setBackground(getContext().getResources().getDrawable(R.drawable.pink_3));
                    tvMore.setPadding(12,5,12,5);
                }else{
                    String name =(String)getArguments().getString("name");
                    if (!StringUtils.isEmpty(name)){
                        inivTitle(name,"","");
                    }else{
                        inivTitle("论坛详情","","");
                    }
                }
                break;
            case 10:
                inivTitle("评论编辑","","");
                break;
            case 11:
                inivTitle(getArguments().getString("name"),"","");
                break;
            case 12:
                inivTitle(getArguments().getString("name"),"图库索引","我的收藏");
                break;
            case 13:
                inivTitle(getArguments().getString("name"),"","");
                break;
            case 14:
                inivTitle(getArguments().getString("name"),"","");
                break;
            case 15:
                inivTitle(getArguments().getString("name"),"","");
                break;
            case 16:
                inivTitle("老黄历","","");
                tvMore = (TextView) titlebar.getTvMore();
                tvMore.setVisibility(View.VISIBLE);
                tvMore.setText("选择日期");
                tvMore.setCompoundDrawablesWithIntrinsicBounds(null,
                        null, null, null);

                tvMore.setTextColor(getContext().getResources().getColor(R.color.color_white));
                tvMore.setBackground(getContext().getResources().getDrawable(R.drawable.pink_3));

                tvMore.setPadding(12,5,12,5);
                int color = ShareUtils.getInt(getContext(), "ba_top", 0);
                 pvTime = new TimePickerView.Builder(getContext(), new TimePickerView.OnTimeSelectListener() {
                    @Override
                    public void onTimeSelect(Date date, View v) {//选中事件回调
                        EvenBusUtils.setEvenBus(new Even(EvenBusCode.OPTION_DATE,Uiutils.getDateStr(date,"yyyyMMdd")));
                    }
                }) .setType(new boolean[]{true, true, true, false, false, false})
                         .setContentSize(21)
                         .setSubmitColor(getContext().getResources().getColor(color))
                         .setCancelColor(getContext().getResources().getColor(color))
                        .build();
                pvTime.setDate(Calendar.getInstance());

                break;
            case 17:
                inivTitle("评论详情","","");
                break;
            case 18:
                String type00 = getArguments().getString("type1");
                if (!StringUtils.isEmpty(type00)&&StringUtils.equals("5",type00)) {
                    inivTitle("", "", "");
                    tvMore = (TextView) titlebar.getTvMore();
                    tvMore.setVisibility(View.VISIBLE);
                    tvMore.setCompoundDrawablesWithIntrinsicBounds(null,
                            null, null, null);
                    tvMore.setTextColor(getContext().getResources().getColor(R.color.color_white));
                    tvMore.setBackground(getContext().getResources().getDrawable(R.drawable.pink_3));
                    tvMore.setPadding(12, 5, 12, 5);
                }
                inivTitle("","","");
                break;
//            case 19:
//                inivTitle(getArguments().getString("name"),"","");
//                break;
              case 19:
                  inivTitle(getArguments().getString("name"),"","");
                  break;
        }
        setFrags();
    }

    private TimePickerView pvTime;
    private TextView tvMore;

    private BaseFragments baseFragments;
    private BaseFragments baseFragments1;

    private  Bundle bundle;
    private  Bundle bundle1;

    private void setFrags() {
        switch (type) {
            case 1:  //我的关注
                baseFragments = new PubAttentionSonFrag();
                baseFragments1 = new PubAttentionSonFrag();
                bundle = new Bundle();
                bundle1 = new Bundle();
                bundle.putInt("type", 1 );
                baseFragments.setArguments(bundle);
                listFrag.add(baseFragments);
                bundle1.putInt("type", 2);
                baseFragments1.setArguments(bundle1);
                listFrag.add(baseFragments1);
                break;
            case 2: //我的动态
                baseFragments = new PubAttentionSonFrag();
                bundle = new Bundle();
                bundle.putInt("type", 3 );
                baseFragments.setArguments(bundle);
                listFrag.add(baseFragments);
                break;
            case 3:  //我的粉丝
                baseFragments = new PubAttentionSonFrag();
                baseFragments1 = new PubAttentionSonFrag();
                bundle = new Bundle();
                bundle1 = new Bundle();
                bundle.putInt("type", 4 );
                baseFragments.setArguments(bundle);
                listFrag.add(baseFragments);
                bundle1.putInt("type", 5);
                baseFragments1.setArguments(bundle1);
                listFrag.add(baseFragments1);
                break;
            case 4:  //论坛详情
                baseFragments = new PubAttentionDetailsFrag();
                bundle = new Bundle();
                bundle.putString("typeid",(String)getArguments().getString("main_id"));
                bundle.putString("type2",(String)getArguments().getString("id"));
                bundle.putInt("type",type);
                baseFragments.setArguments(bundle);
                listFrag.add(baseFragments);
                break;
            case 10:  //编辑
                baseFragments = new PubAttentionCompileFrag();
                bundle = new Bundle();
                bundle.putString("cid",(String) getArguments().get("contentId"));
                bundle.putString("rid",(String) getArguments().get("replyPId"));
                baseFragments.setArguments(bundle);
                listFrag.add(baseFragments);
                break;
            case 11:  //公式
                baseFragments = new PubAttentionSonFrag();
                String alias = getArguments().getString("alias");
                bundle = new Bundle();
                bundle.putInt("type", 11);
                bundle.putString("id", "4");
                bundle.putString("alias", alias==null?"":alias);
                baseFragments.setArguments(bundle);
                listFrag.add(baseFragments);
                break;
            case 12:  //六合图库
                baseFragments = new PubAttentionSonFrag();
                baseFragments1 = new PubAttentionSonFrag();
                bundle = new Bundle();
                bundle1 = new Bundle();
                bundle.putInt("type", 12 );
                bundle.putString("main_id", (String)getArguments().get("main_id"));
                bundle.putString("id", (String)getArguments().get("id"));
                baseFragments.setArguments(bundle);
                listFrag.add(baseFragments);
                bundle1.putInt("type", 13);
                bundle1.putString("main_id", (String)getArguments().get("main_id"));
                bundle1.putString("id", (String)getArguments().get("id"));
                baseFragments1.setArguments(bundle1);
                listFrag.add(baseFragments1);
                break;
            case 13:  //四不像
                baseFragments = new PubAttentionDetailsFrag();
                bundle = new Bundle();
                bundle.putInt("type", type );
                bundle.putString("typeid", getArguments().getString("id"));
//                bundle.putString("id", (String)getArguments().get("id"));

                baseFragments.setArguments(bundle);
                listFrag.add(baseFragments);
                break;
            case 14:  //四不像
                baseFragments = new PubAttentionDetailsFrag();
                bundle = new Bundle();
                bundle.putInt("type", type );
                bundle.putString("typeid", "7");
//                bundle.putString("id", (String)getArguments().get("id"));

                baseFragments.setArguments(bundle);
                listFrag.add(baseFragments);
                break;
            case 15:  //四不像
                baseFragments = new PubAttentionDetailsFrag();
                bundle = new Bundle();
                bundle.putInt("type", type );
                bundle.putString("typeid", "8");
//                bundle.putString("id", (String)getArguments().get("id"));

                baseFragments.setArguments(bundle);
                listFrag.add(baseFragments);
                break;
            case 16:  //四不像
                baseFragments = new OldAlmanacFrag();
                bundle = new Bundle();
                bundle.putInt("type", type );
                baseFragments.setArguments(bundle);
                listFrag.add(baseFragments);
                break;
            case 17:
                baseFragments = new PubAttentionSonFrag();
                bundle = new Bundle();
                bundle.putInt("type", type );
                bundle.putString("id", (String) getArguments().get("id") );
                bundle.putString("contentId", (String) getArguments().get("contentId") );
                bundle.putSerializable("listBean", ( CommentBean.DataBean.ListBean) getArguments().
                        getSerializable("listBean") );

                baseFragments.setArguments(bundle);
                listFrag.add(baseFragments);
                break;
            case 18:  //四不像
                baseFragments = new PubAttentionDetailsFrag();
                bundle = new Bundle();
                String type00 = getArguments().getString("type1");
                if (!StringUtils.isEmpty(type00))
                bundle.putString("typeid", type00);
                bundle.putInt("type", type);
                bundle.putString("id", (String)getArguments().get("id"));
                bundle.putString("type2",getArguments().getString("type2"));
                baseFragments.setArguments(bundle);
                listFrag.add(baseFragments);
                break;
            case 19:  //L002 美女六肖
                baseFragments = new PubAttentionDetailsFrag();
                bundle = new Bundle();
                bundle.putInt("type", type );
//                bundle.putString("typeid", typeId);
                bundle.putString("typeid", (String)getArguments().get("id"));

                baseFragments.setArguments(bundle);
                listFrag.add(baseFragments);
                break;

        }

        fragmentUitl = new FragmentUitl(getActivity(), listFrag, getChildFragmentManager());
        fragmentUitl.setFrag();
    }

    private void inivTitle(String title,String left,String right) {

        titlebar.setText(title);
        attentionLeftTex.setText(left);
        attentionRightTex.setText(right);
        attentionLeftTex.setSelected(true);

        if (StringUtils.isEmpty(left)){
            optionLin.setVisibility(View.GONE);
        }
    }

    @OnClick({R.id.attention_left_tex, R.id.attention_right_tex, R.id.tv_more})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.tv_more:
                if (type==16)
               pvTime.show();
                if (type==4||type==18)
                    EvenBusUtils.setEvenBus(new Even(EvenBusCode.HEXAGON_WRENCH));

                break;
            case R.id.attention_left_tex:
                if (attentionLeftTex.isSelected())
                    return;

                attentionLeftTex.setSelected(true);
                attentionRightTex.setSelected(false);
                fragmentUitl.setFt(getActivity().getSupportFragmentManager().beginTransaction());
                fragmentUitl.showPostion(0);

                break;
            case R.id.attention_right_tex:
//                if (type==12||type==13||type==14||type==15) {
//                    ToastUtil.toastShortShow(getContext(),"敬请期待");
//                    return;
//                }

                if (attentionRightTex.isSelected())
                    return;

                attentionRightTex.setSelected(true);
                attentionLeftTex.setSelected(false);

                fragmentUitl.setFt(getActivity().getSupportFragmentManager().beginTransaction());
                fragmentUitl.showPostion(1);
                break;
        }
    }

    @Override
    public void getEvenMsg(Even even) {
        switch (even.getCode()){
            case EvenBusCode.HEXAGON_WRENCH1:
                if (type==4||type==18){
                    String name = (String) even.getData();
                    if (!StringUtils.isEmpty(name)){
                        if (StringUtils.equals("1",name)){
//                            tvMore.
                            Uiutils.setText(tvMore,"取消收藏");
                        }else{
                            Uiutils.setText(tvMore,"收藏");
                        }
                    }
                }
                break;
            case EvenBusCode.SETTITLE:
                if (type==18||type==4){
                    String name =(String) even.getData();
                    titlebar.setText(name);
                }
                break;
        }
    }
}
