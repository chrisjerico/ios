package com.phoenix.lotterys.my.fragment;


import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.TextView;

import com.example.zhouwei.library.CustomPopWindow;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.EditTextUtil;
import com.phoenix.lotterys.util.NetUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusUtils;
import com.wanxiangdai.commonlibrary.util.MeasureUtil;
import com.wanxiangdai.commonlibrary.util.StringUtils;
import com.wanxiangdai.commonlibrary.util.ToastUtil;

import java.util.HashMap;
import java.util.Map;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * 文件描述: 六合公共  (编辑)
 * 创建者: IAN
 * 创建时间: 2019/10/18 12:35
 */
public class PubAttentionCompileFrag extends BaseFragments implements View.OnClickListener {

    @BindView(R2.id.compile_edit)
    EditText compileEdit;
    @BindView(R2.id.compile_commit_tex)
    TextView compileCommitTex;

    public PubAttentionCompileFrag() {
        super(R.layout.pub_attention_compile_frag, true, true);
    }

    private String cid;
    private String rid;
    @Override
    public void initView(View view) {
        cid =getArguments().getString("cid");
        rid =getArguments().getString("rid");

        setPop();
    }

    @OnClick(R.id.compile_commit_tex)
    public void onClick(View v) {
        switch (v.getId()){
            case R.id.compile_commit_tex:
                if (StringUtils.isEmpty(compileEdit.getText().toString())){
                    ToastUtil.toastShortShow(getContext(),"请输入内容");
                    return;
                }
                commit();
                break;
            case R.id.clear_tex:
                if (null!=mCustomPopWindow)
                    mCustomPopWindow.dissmiss();
                break;
            case R.id.commit_tex:
                    if (null!=editText){
                        if (StringUtils.isEmpty(editText.getText().toString().trim())){
                            ToastUtil.toastShortShow(getContext(),"请输入纯汉字昵称");
                            return;
                        }
                        setNiceName();
                    }
                break;
        }
    }

    private void setNiceName() {
        Map<String,Object> map =new HashMap<>();
        map.put("nickname",editText.getText().toString().trim());
        map.put("token",Uiutils.getToken(getContext()));

        NetUtils.post(Constants.SETNICKNAME, map, true, getContext(), new NetUtils.NetCallBack() {
            @Override
            public void onSuccess(String object) {
                Uiutils.onSuccessTao(object,getContext());
                if (null!=mCustomPopWindow)
                    mCustomPopWindow.dissmiss();
            }

            @Override
            public void onError() {

            }
        });


    }


    private void commit() {
        Map<String,Object> map =new HashMap<>();
        map.put("cid",cid);
        if (!StringUtils.isEmpty(rid))
        map.put("rid",rid);
        map.put("token", Uiutils.getToken(getContext()));
        map.put("content",compileEdit.getText().toString());

        NetUtils.post(Constants.POSTCONTENTREPLY, map, true, getContext(), new NetUtils.NetCallBack() {
            @Override
            public void onSuccess(String object) {
                Uiutils.onSuccessTao(object,getContext());
                getActivity().finish();
                EvenBusUtils.setEvenBus(new Even(EvenBusCode.COMMENT2));
            }

            @Override
            public void onError() {

            }
        });

    }

    @Override
    public void getEvenMsg(Even even) {
        switch (even.getCode()){
            case EvenBusCode.NOTHASNICKNAME:
                mCustomPopWindow =popupWindowBuilder.create();
                mCustomPopWindow.showAtLocation(contentView, Gravity.CENTER, 0, 0);
                Uiutils.setStateColor(getActivity());

                break;
        }
    }
    private CustomPopWindow mCustomPopWindow;
    private CustomPopWindow.PopupWindowBuilder popupWindowBuilder;
    private View contentView;

    private EditText editText ;

    private void setPop(){
        contentView = LayoutInflater.from(getContext()).inflate(R.layout.set_nice_name, null);
        contentView.findViewById(R.id.clear_tex).setOnClickListener(this);
        contentView.findViewById(R.id.commit_tex).setOnClickListener(this);

        editText = contentView.findViewById(R.id.nice_name_edit);
        EditTextUtil.mEditTextChinese(editText);

        popupWindowBuilder = Uiutils.setPopSetting(getContext(), contentView,
                MeasureUtil.dip2px(getContext(), 300),
                ViewGroup.LayoutParams.WRAP_CONTENT,
                true, true, 0.5f);
    }

}
