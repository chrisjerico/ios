package com.phoenix.lotterys.my.fragment;

import android.os.Bundle;
import androidx.recyclerview.widget.RecyclerView;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.my.adapter.FeedbackRecordDetailsAdapter;
import com.phoenix.lotterys.my.bean.FeedbackRecordBean;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.GsonUtil;
import com.phoenix.lotterys.util.NetUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.view.CustomTitleBar;
import com.wanxiangdai.commonlibrary.util.StringUtils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * 文件描述:
 * 创建者: IAN
 * 创建时间: 2019/7/12 15:33
 */
public class FeedbackRecordDetailsFrag extends BaseFragments implements View.OnFocusChangeListener  {

    @BindView(R2.id.titlebar)
    CustomTitleBar titlebar;
    @BindView(R2.id.feedback_details_rec)
    RecyclerView feedbackDetailsRec;
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

    public FeedbackRecordDetailsFrag() {
        super(R.layout.feedback_record_details_frag, true, true);
    }

    private FeedbackRecordBean.DataBean.ListBean listBean;

    @Override
    public void initView(View view) {
        Bundle bundle = getArguments();
        listBean = (FeedbackRecordBean.DataBean.ListBean) bundle.getSerializable("name");
        Uiutils.setBarStye(titlebar,getActivity());

        titlebar.setText("反馈记录详情");

        setListener();

        typeNameTex.setVisibility(View.GONE);

        if (null!=listBean)
            list.add(listBean);

        Uiutils.setRec(getContext(),feedbackDetailsRec,1);
        adapter=new FeedbackRecordDetailsAdapter(getContext(),list,R.layout.feedback_record_details_adapter);
        feedbackDetailsRec.setAdapter(adapter);

        requestData();
    }

    private void requestData() {
        Map<String,Object> map =new HashMap<>();

        map.put("token",Uiutils.getToken(getContext()));
        map.put("pid",listBean.getId());

        NetUtils.get(Constants.FEEDBACKDETAIL ,map, true, getContext()
                , new NetUtils.NetCallBack() {
                    @Override
                    public void onSuccess(String object) {
                        if (!StringUtils.isEmpty(object)){
                            FeedbackRecordBean feedbackRecordBean = GsonUtil.fromJson(object,
                                    FeedbackRecordBean.class);

                            if (null!=feedbackRecordBean&&null!=feedbackRecordBean.getData()&&
                            null!=feedbackRecordBean.getData().getList()&&feedbackRecordBean
                            .getData().getList().size()>0){
                                list.addAll(feedbackRecordBean.getData().getList());
                            }

                            adapter.notifyDataSetChanged();
                        }
                    }

                    @Override
                    public void onError() {

                    }
                });


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

    private List<FeedbackRecordBean.DataBean.ListBean> list =new ArrayList<>();
    private FeedbackRecordDetailsAdapter adapter;

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

    @OnClick(R.id.commit_but)
    public void onClick() {

        if (StringUtils.isEmpty(contextEdit.getText().toString())){
            tisTex.setVisibility(View.VISIBLE);
            tisTex.setText(R.string.must_fill_in_the_contents);
        }else if (contextEdit.getText().toString().length()<10){
            tisTex.setVisibility(View.VISIBLE);
            tisTex.setText("提交内容字数必须大于10字");
        }else {
            tisTex.setVisibility(View.INVISIBLE);
            addData();
        }
    }

    private void addData() {
        Map<String,Object> map =new HashMap<>();
        map.put("pid",listBean.getId());
        map.put("type",listBean.getType());
        map.put("content",contextEdit.getText().toString());
        map.put("token",Uiutils.getToken(getContext()));

        NetUtils.post(Constants.ADDFEEDBACK, map, true, getContext(), new
                NetUtils.NetCallBack() {
                    @Override
                    public void onSuccess(String object) {
//                        if (null!=object){
//                            BaseBean baseBean = GsonUtil.fromJson(object,BaseBean.class);
//                            if (!StringUtils.isEmpty(baseBean.getMsg())){
                                Uiutils.pubFish(object,getActivity());
//                            }
//                        }
                    }
                    @Override
                    public void onError() {

                    }
                });
    }
}
