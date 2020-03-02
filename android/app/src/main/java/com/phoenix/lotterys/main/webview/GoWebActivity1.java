package com.phoenix.lotterys.main.webview;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Build;
import android.os.Handler;
import android.os.Message;
import androidx.annotation.RequiresApi;
import android.text.TextUtils;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.webkit.DownloadListener;
import android.webkit.WebChromeClient;
import android.webkit.WebResourceError;
import android.webkit.WebResourceRequest;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseActivitys;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.util.APKVersionCodeUtils;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.CookieHelper;
import com.phoenix.lotterys.util.ReplaceUtil;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.view.CustomTitleBar;
import com.phoenix.lotterys.view.DragFloatActionButton;
import com.phoenix.lotterys.view.tddialog.TDialog;
import com.wanxiangdai.commonlibrary.util.ToastUtil;

import java.net.URLDecoder;

import butterknife.BindView;
import butterknife.OnClick;
import im.delight.android.webview.AdvancedWebView;

public class GoWebActivity1 extends BaseActivitys implements AdvancedWebView.Listener {
    @BindView(R2.id.web)
    AdvancedWebView gameWebView;
    @BindView(R2.id.tv_error)
    TextView tvError;
    @BindView(R2.id.titlebar)
    CustomTitleBar titlebar;
    @BindView(R2.id.iv_back1)
    ImageView ivBack1;
    private String url;
    private String type;
    private String title;
    @BindView(R2.id.circle_button)
    DragFloatActionButton circleButton;
    private ConfigBean config;

    //Boolean isType =true;
    public GoWebActivity1() {
        super(R.layout.go_web_activity);
    }

    @Override
    public void getIntentData() {
        url = getIntent().getStringExtra("url");
        type = getIntent().getStringExtra("type");
        title = getIntent().getStringExtra("title");

    }

    @Override
    public void initView() {
        setWebView();
        gameWebView.setListener(this, this);
        if (!TextUtils.isEmpty(type) && (type.equals("isShowTitle") || type.equals("isHideTitle") || type.equals("showClose"))) {
            CookieHelper.setCookies(GoWebActivity1.this, Constants.BaseUrl());
            CookieHelper.setCookies(GoWebActivity1.this, Constants.BaseUrl() + "/mobile");
            CookieHelper.setCookies(GoWebActivity1.this, Constants.BaseUrl() + "/mobile/init.do");
            gameWebView.loadUrl(URLDecoder.decode(url));
            titlebar.setVisibility(View.VISIBLE);

        } else if (url != null && url.startsWith("http")) {
            CookieHelper.setCookies(GoWebActivity1.this, Constants.BaseUrl());
            CookieHelper.setCookies(GoWebActivity1.this, Constants.BaseUrl() + "/mobile");
            CookieHelper.setCookies(GoWebActivity1.this, Constants.BaseUrl() + "/mobile/init.do");
            gameWebView.loadUrl(URLDecoder.decode(url));
            circleButton.setVisibility(View.VISIBLE);
        } else if (url != null) {
            titlebar.setVisibility(View.VISIBLE);
            titlebar.setText("活动详情");
            config = (ConfigBean) ShareUtils.getObject(GoWebActivity1.this, SPConstants.CONFIGBEAN, ConfigBean.class);
            if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
                if (config.getData().getMobileTemplateCategory().equals("5")) {
                    gameWebView.setBackgroundColor(0);
                }
            }
            gameWebView.getSettings().setLayoutAlgorithm(WebSettings.LayoutAlgorithm.NARROW_COLUMNS);//适应内容大小
            gameWebView.loadDataWithBaseURL(null, ReplaceUtil.getHtmlFormat(url, "", "", ""), "text/html", "utf-8", null);
        }
        if (type != null && type.equals("showClose")) {  //首页导航
            titlebar.setText(TextUtils.isEmpty(title) ? "" : title);
            ivBack1.setVisibility(View.VISIBLE);
        }
        titlebar.setLeftIconOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (gameWebView.canGoBack()) {
                    gameWebView.goBack();//返回上个页面
                    return;
                } else {
                    finish();
                }
            }
        });
        titlebar.setRightIconOnClickListener(v -> finish());


        Uiutils.setBarStye0(titlebar,this);
    }

    private void setWebView() {

        gameWebView.setScrollBarStyle(View.SCROLLBARS_INSIDE_OVERLAY); //取消滚动条白边效果
        gameWebView.setWebChromeClient(new WebChromeClient());

        gameWebView.getSettings().setDefaultTextEncodingName("UTF-8");
        gameWebView.getSettings().setBlockNetworkImage(false);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            gameWebView.getSettings().setMixedContentMode(gameWebView.getSettings().MIXED_CONTENT_ALWAYS_ALLOW);  //注意安卓5.0以上的权限
        }
        WebSettings webSettings = gameWebView.getSettings();
        webSettings.setJavaScriptEnabled(true);  //支持js
        webSettings.setDomStorageEnabled(true);
        webSettings.setPluginState(WebSettings.PluginState.ON);
        webSettings.setRenderPriority(WebSettings.RenderPriority.HIGH);  //提高渲染的优先级
//        设置自适应屏幕，两者合用
        webSettings.setUseWideViewPort(true);  //将图片调整到适合webview的大小
        webSettings.setLoadWithOverviewMode(true); // 缩放至屏幕的大小
        webSettings.setSupportZoom(true);  //支持缩放，默认为true。是下面那个的前提。
        webSettings.setBuiltInZoomControls(true); //设置内置的缩放控件。
//若上面是false，则该WebView不可缩放，这个不管设置什么都不能缩放。
        webSettings.setDisplayZoomControls(false); //隐藏原生的缩放控件
        webSettings.setLayoutAlgorithm(WebSettings.LayoutAlgorithm.SINGLE_COLUMN); //支持内容重新布局
        webSettings.supportMultipleWindows();  //多窗口
        webSettings.setCacheMode(WebSettings.LOAD_DEFAULT);  //关闭webview中缓存
        webSettings.setAllowFileAccess(true);  //设置可以访问文件
        webSettings.setNeedInitialFocus(true); //当webview调用requestFocus时为webview设置节点
        webSettings.setJavaScriptCanOpenWindowsAutomatically(true); //支持通过JS打开新窗口
        webSettings.setLoadsImagesAutomatically(true);  //支持自动加载图片
        webSettings.setGeolocationEnabled(true);
//        webSettings.setAllowContentAccess(true); // 是否可访问Content Provider的资源，默认值 true
//        webSettings.setAllowFileAccess(true);    // 是否可访问本地文件，默认值 true

//        webSettings.setBuiltInZoomControls(true);// 隐藏缩放按钮
//        webSettings.setLayoutAlgorithm(WebSettings.LayoutAlgorithm.NARROW_COLUMNS);// 排版适应屏幕
//        webSettings.setUseWideViewPort(true);// 可任意比例缩放
//        webSettings.setLoadWithOverviewMode(true);// setUseWideViewPort方法设置webview推荐使用的窗口。setLoadWithOverviewMode方法是设置webview加载的页面的模式。




        gameWebView.setWebViewClient(new WebViewClient() {
            @Override
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                tvError.setVisibility(View.GONE);
                gameWebView.setVisibility(View.VISIBLE);
                Log.e("urlonPUrlLoading1112", "" + url);
//                theNative(url);
                if (url.equals("ext:add_favorite")) {      //c085
                    return true;
                }
                if (url.equals(Constants.BaseUrl() + "/dist/index.html#/home") || url.equals(Constants.BaseUrl() + "/mobile/#/home") || url.equals(Constants.BaseUrl() + "/dist/#/user") || url.equals(Constants.BaseUrl()) || url.equals("https://0187688.com/")) {
                    GoWebActivity1.this.finish();
                    return true;
                } else {
                    return super.shouldOverrideUrlLoading(view, url);
                }
            }

            @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
            @Override
            public boolean shouldOverrideUrlLoading(WebView view, WebResourceRequest request) {
                String loadUrl = request.getUrl().toString();
                Log.e("urlonPrrideUrlLoading", "" + loadUrl);
                if (loadUrl.contains(Constants.BaseUrl() + "/mobile/#/home") || loadUrl.contains(Constants.BaseUrl() + "/dist/index.html#/home") || url.equals(Constants.BaseUrl() + "/dist/#/user")) {
                    GoWebActivity1.this.finish();
                    return true;
                }
//                theNative(url);
                if(loadUrl.equals("ext:add_favorite")){      //c085
                    return true;
                }
                return shouldOverrideUrlLoading(view, request.getUrl().toString());
            }

            @Override
            public void onPageStarted(WebView view, String url, Bitmap favicon) {

            }

            //加载错误的时候会回调
            @Override
            public void onReceivedError(WebView webView, int i, String s, String s1) {
                super.onReceivedError(webView, i, s, s1);
                tvError.setVisibility(View.GONE);
//                tvError.setText("温馨提示：\n如果已支付成功请点击返回键退出当前页面");
                gameWebView.setVisibility(View.GONE);

            }

            //加载错误的时候会回调
            @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
            @Override
            public void onReceivedError(WebView webView, WebResourceRequest webResourceRequest, WebResourceError webResourceError) {
                super.onReceivedError(webView, webResourceRequest, webResourceError);
                if (webResourceRequest.isForMainFrame()) {
                    tvError.setVisibility(View.GONE);
//                    tvError.setText("温馨提示：\n如果已支付成功请点击返回键退出当前页面");
                    gameWebView.setVisibility(View.GONE);
                }
            }

            @Override
            public void onPageFinished(WebView view, String url) {
                if (!TextUtils.isEmpty(type) && type.equals("isShowTitle")) {
                    titlebar.setVisibility(View.VISIBLE);
                    titlebar.setText(view.getTitle());
                }
                handler.sendEmptyMessageDelayed(0, 1000);
//                removeBtnBack(gameWebView);
                Log.e("urlonPageFinished1", "" + url);
            }

        });

        gameWebView.setDownloadListener(new MyDownLoad());
    }

    public static final String WX = "com.tencent.mm";
    public static final String ALIPAY = "com.eg.android.AlipayGphone";
    public static final String WANDOUJIA = "com.wandoujia.phoenix2";

    private boolean theNative(String url) {
        if (url.equals("weixin://") || url.equals("weixin") || url.equals("weixin:")) {
            if (!APKVersionCodeUtils.isAvilible(this, WX)) {
                ToastUtil.toastShortShow(this, "您还没安装微信，请安装微信后再试");
                return true;
            }
            Intent intent = new Intent();
            PackageManager packageManager = getPackageManager();
            intent = packageManager.getLaunchIntentForPackage(WX);
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_RESET_TASK_IF_NEEDED | Intent.FLAG_ACTIVITY_CLEAR_TOP);
            startActivity(intent);
            return true;
        }

        if (url.equals("alipays://") || url.equals("alipays") || url.equals("alipays:")) {
            if (!APKVersionCodeUtils.isAvilible(this, ALIPAY)) {
                ToastUtil.toastShortShow(this, "您还没安装支付宝，请安装支付宝后再试");
                return true;
            }
            Intent intent = new Intent();
            PackageManager packageManager = getPackageManager();
            intent = packageManager.getLaunchIntentForPackage(ALIPAY);
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_RESET_TASK_IF_NEEDED | Intent.FLAG_ACTIVITY_CLEAR_TOP);
            startActivity(intent);
            return true;
        }
        if (url.equals("wandoujia")) {
            if (!APKVersionCodeUtils.isAvilible(this, WANDOUJIA)) {
                ToastUtil.toastShortShow(this, "您还没安装豌豆荚，请安装豌豆荚后再试");
                return true;
            }
            Intent intent = new Intent();
            PackageManager packageManager = getPackageManager();
            intent = packageManager.getLaunchIntentForPackage(WANDOUJIA);
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_RESET_TASK_IF_NEEDED | Intent.FLAG_ACTIVITY_CLEAR_TOP);
            startActivity(intent);
            return false;
        }


        if (url.startsWith("weixin://wap/pay?")) {
            Intent intent;
            try {
                intent = Intent.parseUri(url,
                        Intent.URI_INTENT_SCHEME);
                intent.addCategory(Intent.CATEGORY_BROWSABLE);
                intent.setComponent(null);
                startActivity(intent);

            } catch (Exception e) {
                e.printStackTrace();
            }
            return true;
        }
        if (url.startsWith("alipays")) {
            Intent intent;
            try {
                intent = Intent.parseUri(url,
                        Intent.URI_INTENT_SCHEME);
                intent.addCategory(Intent.CATEGORY_BROWSABLE);
                intent.setComponent(null);
                startActivity(intent);

            } catch (Exception e) {
                e.printStackTrace();
            }
            return true;
        }
//        if (url.startsWith("wandoujia")) {

//                    Uri uri = Uri.parse(url);
//                    Intent goToMarket = new Intent(Intent.ACTION_VIEW, uri);
//                    try {
//                        GoWebActivity.this.startActivity(goToMarket);
//                    } catch (ActivityNotFoundException e) {
//                        e.printStackTrace();
//                    }
//                    shareAppShop(GoWebActivity.this,"com.unionpay");
//            return false;
//        }
        return false;
    }

    class MyDownLoad implements DownloadListener {
        @Override
        public void onDownloadStart(String url, String userAgent,
                                    String contentDisposition, String mimetype, long contentLength) {
            if (url.endsWith(".apk")) {
                /**
                 * 方法二：通过系统下载apk
                 */
                Uri uri = Uri.parse(url);
                Intent intent = new Intent(Intent.ACTION_VIEW, uri);
                startActivity(intent);
            }
        }
    }

    @SuppressLint("NewApi")
    @Override
    protected void onResume() {
        super.onResume();
        gameWebView.onResume();

    }

    @SuppressLint("NewApi")
    @Override
    protected void onPause() {
        gameWebView.onPause();
        super.onPause();
    }

    @Override
    protected void onDestroy() {
        gameWebView.onDestroy();
        handler.removeCallbacksAndMessages(null);
        super.onDestroy();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent intent) {
        super.onActivityResult(requestCode, resultCode, intent);
        gameWebView.onActivityResult(requestCode, resultCode, intent);
    }

    @Override
    public void onPageStarted(String url, Bitmap favicon) {
//        Log.e("urlonPageStarted",""+url);
    }

    @Override
    public void onPageFinished(String url) {
        removeBtnBack(gameWebView);
        Log.e("urlonPageFinished", "" + url);

    }

    @Override
    public void onPageError(int errorCode, String description, String failingUrl) {
//        Log.e("urlonPageError",""+url);
    }

    @Override
    public void onDownloadRequested(String url, String suggestedFilename, String mimeType, long contentLength, String contentDisposition, String userAgent) {

    }

    @Override
    public void onExternalPageRequest(String url) {
        Log.e("urlonRequest", "" + url);
    }

    //    boolean isfinish = false;
    @SuppressLint("HandlerLeak")
    Handler handler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
            removeBtnBack(gameWebView);
        }
    };

    private void removeBtnBack(WebView view) {
        //隐藏标题左边后退按钮
        String javascript;
        javascript = "javascript:function hideOther() {" +
                "document.getElementsByClassName('nav navbar-right')[0].style.display='none';}";
        view.loadUrl(javascript);
        view.loadUrl("javascript:hideOther();");

        javascript = "javascript:function hideOther() {" +
                "document.getElementsByClassName('label label-success')[0].style.display='none';}";
        view.loadUrl(javascript);
        view.loadUrl("javascript:hideOther();");

        javascript = "javascript:function hideOther() {" +
                "document.getElementsByClassName('label label-success')[1].style.display='none';}";
        view.loadUrl(javascript);
        view.loadUrl("javascript:hideOther();");


        if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
            if (config.getData().getMobileTemplateCategory().equals("5")) {
                javascript = "javascript:function hideOther() {" +
                        "document.body.style.color='#DDDDDD';}";
                view.loadUrl(javascript);
                view.loadUrl("javascript:hideOther();");
            }
        }

    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK && gameWebView.canGoBack()) {
            if (tvError.getVisibility() == View.VISIBLE && gameWebView.getVisibility() == View.GONE)
                finish();
            else
                gameWebView.goBack();//返回上个页面
            return true;
        }
        return super.onKeyDown(keyCode, event);//退出H5界面
    }

    @OnClick({R.id.circle_button, R.id.iv_back1,})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.circle_button:  //取消
                String[] array = getResources().getStringArray(R.array.affirm_change);
                TDialog mTDialog = new TDialog(this, TDialog.Style.Center, array,
                        getResources().getString(R.string.info), "是否退出游戏", "", new TDialog.onItemClickListener() {
                    @Override
                    public void onItemClick(Object object, int position) {
                        if (position == 1) {
                            finish();
                        }
                    }
                });
                mTDialog.setCancelable(false);
                mTDialog.show();
                break;
            case R.id.iv_back1:  //确定
                finish();
//                if (gameWebView.canGoBack()) {
//                    gameWebView.goBack();//返回上个页面
//                    return;
//                } else {
//                finish();
//                }
                break;
        }
    }

    public static void shareAppShop(Activity activity, String packageName) {
        try {
            Uri uri = Uri.parse("market://details?id=" + packageName);
            Intent intent = new Intent(Intent.ACTION_VIEW, uri);
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            activity.startActivity(intent);
        } catch (Exception e) {
            Toast.makeText(activity, "您没有安装应用市场", Toast.LENGTH_SHORT).show();
        }
    }


}
