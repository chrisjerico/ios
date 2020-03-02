package com.phoenix.lotterys.coupons.activity;

import android.content.Context;
import android.view.View;
import android.view.inputmethod.InputMethodManager;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseActivitys;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.view.CustomTitleBar;

import org.sufficientlysecure.htmltextview.HtmlHttpImageGetter;
import org.sufficientlysecure.htmltextview.HtmlTextView;

import butterknife.BindView;
import cn.droidlover.xrichtext.XRichText;

/**
 * Created by Luke
 * on 2019/6/23
 */
public class RichTextActivity extends BaseActivitys {
    @BindView(R2.id.richText)
    XRichText richText;
    @BindView(R2.id.html_text)
    HtmlTextView htmlText;

    @BindView(R2.id.titlebar)
    CustomTitleBar titlebar;
    String mText;

    public RichTextActivity() {
        super(R.layout.activity_richtext);
    }

    @Override
    public void getIntentData() {
        mText = getIntent().getStringExtra("url");

    }

    @Override
    public void initView() {
        richText.text(mText == null ? "" : mText);
        titlebar.setLeftIconOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                finish();
            }
        });
        htmlText.setHtml(mText,
                new HtmlHttpImageGetter(htmlText));
        ConfigBean  config = (ConfigBean) ShareUtils.getObject(RichTextActivity.this, SPConstants.CONFIGBEAN, ConfigBean.class);
        if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
            if (config.getData().getMobileTemplateCategory().equals("5")) {
                htmlText.setTextColor(getResources().getColor(R.color.white));
            }
        }

        Uiutils.setBarStye0(titlebar,this);
    }

    private void hintKbTwo() {
        InputMethodManager imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
        if (imm.isActive() && getCurrentFocus() != null) {
            if (getCurrentFocus().getWindowToken() != null) {
                imm.hideSoftInputFromWindow(getCurrentFocus().getWindowToken(), InputMethodManager.HIDE_NOT_ALWAYS);
            }
        }
    }
}
