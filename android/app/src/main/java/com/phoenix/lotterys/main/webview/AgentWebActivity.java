package com.phoenix.lotterys.main.webview;

import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.net.http.SslError;
import android.os.Build;
import androidx.annotation.RequiresApi;
import androidx.appcompat.app.AlertDialog;
import android.text.TextUtils;
import android.view.KeyEvent;
import android.view.WindowManager;
import android.webkit.SslErrorHandler;
import android.webkit.WebResourceRequest;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.widget.LinearLayout;

import com.just.agentweb.AgentWeb;
import com.just.agentweb.DefaultWebClient;
import com.just.agentweb.WebChromeClient;
import com.just.agentweb.WebViewClient;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.Application;
import com.phoenix.lotterys.application.BaseActivitys;
import com.phoenix.lotterys.main.MainActivity;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.view.DragFloatActionButton;
import com.phoenix.lotterys.view.MyIntentService;
import com.phoenix.lotterys.view.tddialog.TDialog;

import java.net.URLDecoder;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * Greated by Luke
 * on 2019/7/19
 */
public class AgentWebActivity extends BaseActivitys {
    protected AgentWeb mAgentWeb;
    private LinearLayout mLinearLayout;
    private AlertDialog mAlertDialog;
    @BindView(R2.id.circle_button)
    DragFloatActionButton circleButton;
    String url,show;
    Application mApp;


    public AgentWebActivity() {
        super(true,R.layout.activity_agent_web);
    }

    @Override
    public void initImmersionBar() {
        super.initImmersionBar();
        if(mImmersionBar!=null)
        mImmersionBar.barColor("#212121");
    }

    @Override
    public void getIntentData() {
        url = getIntent().getStringExtra("url");
        show = getIntent().getStringExtra("type");


    }

    @Override
    public void initView() {
        if(TextUtils.isEmpty(show)){
            getWindow().addFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN); //隐藏状态栏
        }
        mApp = (Application) Application.getContextObject();
        mLinearLayout = (LinearLayout) this.findViewById(R.id.container);
        mAgentWeb = AgentWeb.with(this)
                .setAgentWebParent(mLinearLayout, new LinearLayout.LayoutParams(-1, -1))
                .useDefaultIndicator(2, 3)
                .setWebChromeClient(mWebChromeClient)
                .setWebViewClient(mWebViewClient)
                .setMainFrameErrorView(R.layout.agentweb_error_page, -1)
                .setSecurityType(AgentWeb.SecurityType.STRICT_CHECK)
//                .setWebLayout(new WebLayout(this))
                .setOpenOtherPageWays(DefaultWebClient.OpenOtherPageWays.ASK)//打开其他应用时，弹窗咨询用户是否前往其他应用
                .interceptUnkownUrl() //拦截找不到相关页面的Scheme
                .createAgentWeb()
                .ready()
                .go(URLDecoder.decode(url));
        mAgentWeb.getAgentWebSettings().getWebSettings().setUseWideViewPort(true); //将图片调整到适合webview的大小
        mAgentWeb.getAgentWebSettings().getWebSettings().setLoadWithOverviewMode(true); // 缩放至屏幕的大小
        mAgentWeb.getAgentWebSettings().getWebSettings().setJavaScriptEnabled(true);
        mAgentWeb.getAgentWebSettings().getWebSettings().setBuiltInZoomControls(true);
        mAgentWeb.getAgentWebSettings().getWebSettings().setDomStorageEnabled(true);

//        Android5.0上 WebView中Http和Https混合问题
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            mAgentWeb.getAgentWebSettings().getWebSettings().setMixedContentMode(WebSettings.MIXED_CONTENT_ALWAYS_ALLOW);
        }


    }


    private WebViewClient mWebViewClient = new WebViewClient() {

        @Override
        public void onPageStarted(WebView view, String url, Bitmap favicon) {

        }
        @Override
        public void onReceivedSslError(WebView view, SslErrorHandler handler, SslError error) {
            handler.proceed();
        }

        @Override
        public boolean shouldOverrideUrlLoading(WebView view, String url) {
//            Log.e("url324234",""+url);
            if (url.equals("ext:add_favorite")) {      //c085
                return true;
            }
            if (url.equals(Constants.BaseUrl() + "/dist/index.html#/home") || url.equals(Constants.BaseUrl() + "/mobile/#/home")) {
                startActivity(new Intent(AgentWebActivity.this, MainActivity.class));
                return true;
            } else {
                return false;
            }
        }


        @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
        @Override
        public boolean shouldOverrideUrlLoading(WebView view, WebResourceRequest request) {
//            Log.e("url324234",""+url);
            String loadUrl = request.getUrl().toString();
            if (loadUrl.equals("ext:add_favorite")) {      //c085
                return true;
            }
            if (loadUrl.contains(Constants.BaseUrl() + "/mobile/#/home") || loadUrl.contains(Constants.BaseUrl() + "/dist/index.html#/home")) {
                startActivity(new Intent(AgentWebActivity.this, MainActivity.class));
                return true;
            }
            return shouldOverrideUrlLoading(view, request.getUrl().toString());
        }

    };
    private WebChromeClient mWebChromeClient = new WebChromeClient() {
        @Override
        public void onReceivedTitle(WebView view, String title) {
            super.onReceivedTitle(view, title);
        }
    };

    private void showDialog() {

        if (mAlertDialog == null) {
            mAlertDialog = new AlertDialog.Builder(this)
                    .setMessage("您确定要关闭该页面吗?")
                    .setNegativeButton("再逛逛", new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialog, int which) {
                            if (mAlertDialog != null) {
                                mAlertDialog.dismiss();
                            }
                        }
                    })//
                    .setPositiveButton("确定", new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialog, int which) {

                            if (mAlertDialog != null) {
                                mAlertDialog.dismiss();
                            }
                            finish();
                        }
                    }).create();
        }
        mAlertDialog.show();

    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {

        if (mAgentWeb.handleKeyEvent(keyCode, event)) {
            return true;
        }
        return super.onKeyDown(keyCode, event);
    }

    @Override
    protected void onPause() {
        mAgentWeb.getWebLifeCycle().onPause();
        super.onPause();

    }

    @Override
    protected void onResume() {
        mAgentWeb.getWebLifeCycle().onResume();
        super.onResume();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
//        Log.i("Info", "onResult:" + requestCode + " onResult:" + resultCode);
        super.onActivityResult(requestCode, resultCode, data);
    }


    @Override
    protected void onDestroy() {
        super.onDestroy();
        //mAgentWeb.destroy();
        mAgentWeb.getWebLifeCycle().onDestroy();
        if(TextUtils.isEmpty(show)) {
            Intent intent = new Intent(mApp, MyIntentService.class);
            intent.putExtra("type", "6000");
            startService(intent);
        }
    }

    @OnClick(R.id.circle_button)
    public void onViewClicked() {
        String content  = !TextUtils.isEmpty(show)?"是否退出":"是否退出";
        String[] array = getResources().getStringArray(R.array.affirm_change);
        TDialog mTDialog = new TDialog(this, TDialog.Style.Center, array,
                getResources().getString(R.string.info), content, "", new TDialog.onItemClickListener() {
            @Override
            public void onItemClick(Object object, int position) {
                if (position == 1) {
                    finish();
                }
            }
        });
        mTDialog.setCancelable(false);
        mTDialog.show();
    }
}
