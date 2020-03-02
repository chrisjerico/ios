package com.phoenix.lotterys.my.fragment;

import android.content.Context;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.NetUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.view.CustomTitleBar;
import com.wanxiangdai.commonlibrary.util.StringUtils;

import java.util.HashMap;
import java.util.Map;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * 文件描述:  编辑建议反馈
 * 创建者: IAN
 * 创建时间: 2019/7/5 19:15
 */
public class EditFeedbackFrag extends BaseFragments implements View.OnFocusChangeListener {

    @BindView(R2.id.titlebar)
    CustomTitleBar titlebar;
    @BindView(R2.id.type_name_tex)
    TextView typeNameTex;
    @BindView(R2.id.context_edit)
    EditText contextEdit;
    @BindView(R2.id.tis_tex)
    TextView tisTex;
    @BindView(R2.id.progress_tex)
    TextView progressTex;
    @BindView(R2.id.commit_but)
    Button commitBut;

    public EditFeedbackFrag() {
        super(R.layout.edit_feedback_frag, true, true);
    }

    private int type;

    @Override
    public void initView(View view) {
        titlebar.setText(getResources().getString(R.string.recommendation_feedback));
        Uiutils.setBarStye(titlebar, getActivity());

        Bundle bundle = getArguments();
        type = bundle.getInt("type");

        if (type==1){
            typeNameTex.setText(R.string.submitting_recommendations);
        }else {
            typeNameTex.setText(R.string.i_want_to_complain);
        }
        setListener();

    }

    private void setListener() {
        contextEdit.setOnFocusChangeListener(this);

        contextEdit.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
            }

            @Override
            public void afterTextChanged(Editable s) {
                if (StringUtils.isEmpty(contextEdit.getText().toString())){
                    progressTex.setText("0/50");
                }else{
                    progressTex.setText(contextEdit.getText().toString().length()+"/50");
                }
            }
        });

    }

    @OnClick(R.id.commit_but)
    public void onClick() {
        if (StringUtils.isEmpty(contextEdit.getText().toString())){
            tisTex.setVisibility(View.VISIBLE);
            tisTex.setText(R.string.must_fill_in_the_contents);
        }else if (contextEdit.getText().toString().length()<10){
            tisTex.setVisibility(View.VISIBLE);
            tisTex.setText(R.string.submitted_10_words);
        }else {
            tisTex.setVisibility(View.INVISIBLE);
            requestData();
        }
    }

    //用户留言反馈提交（type: 0=提交建议，1=我要投诉）
    private void requestData() {
        SharedPreferences sp = getContext().getSharedPreferences("User", Context.MODE_PRIVATE);
        Map<String,Object> httpParams =new HashMap<>();
        httpParams.put("pid","");
        httpParams.put("type",type-1+"");
        httpParams.put("content",contextEdit.getText().toString());
        httpParams.put("token",sp.getString("API-SID", "Null"));

        NetUtils.post(Constants.ADDFEEDBACK,httpParams,true,getContext(),new
                NetUtils.NetCallBack() {
            @Override
            public void onSuccess(String object) {
                Uiutils.pubFish(object,getActivity());
            }
            @Override
            public void onError() {
            }
        });
    }

    @Override
    public void onFocusChange(View v, boolean hasFocus) {
        if (!hasFocus){
            if (StringUtils.isEmpty(contextEdit.getText().toString())){
                tisTex.setVisibility(View.VISIBLE);
            }else {
                tisTex.setVisibility(View.INVISIBLE);
            }
        }
    }
}
