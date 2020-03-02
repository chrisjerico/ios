package com.phoenix.lotterys.coupons.activity;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.os.Build;
import android.os.Handler;
import android.util.Log;
import android.view.View;
import android.webkit.JavascriptInterface;
import android.webkit.WebChromeClient;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ImageView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseActivitys;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.CookieHelper;
import com.phoenix.lotterys.util.ReplaceUtil;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.view.CustomTitleBar;
import com.phoenix.lotterys.view.MyWebView;

import butterknife.BindView;
import butterknife.OnClick;
import im.delight.android.webview.AdvancedWebView;

/**
 * Created by Luke
 * on 2019/6/23
 */

/*
 * 聊天室
 * */
public class WebActivity extends BaseActivitys implements AdvancedWebView.Listener {
    @BindView(R2.id.web)
    MyWebView gameWebView;
    @BindView(R2.id.iv_back)
    ImageView tv_back;
    @BindView(R2.id.titlebar)
    CustomTitleBar titlebar;

    private String url, type, shareBetJson, shareBetInfoJson;

    public WebActivity() {
        super(R.layout.web_activity);
    }

    @Override
    public void getIntentData() {
        url = getIntent().getStringExtra("url");
        Log.e("url", "" + url);
        type = getIntent().getStringExtra("type");
        shareBetJson = getIntent().getStringExtra("shareBetJson");
        shareBetInfoJson = getIntent().getStringExtra("shareBetInfoJson");
    }

    @Override
    public void initView() {
        setWebView();
        gameWebView.setListener(this, this);
        if (url != null && url.startsWith("http")) {
            CookieHelper.setCookies(WebActivity.this, Constants.BaseUrl());
            CookieHelper.setCookies(WebActivity.this, Constants.BaseUrl() + "/mobile");
            CookieHelper.setCookies(WebActivity.this, Constants.BaseUrl() + "/mobile/init.do");

            String themeColor = null;
            try {
                themeColor = Integer.toHexString(getResources().getColor(ShareUtils.getInt(WebActivity.this, "ba_top", 0)));
            } catch (Resources.NotFoundException e) {
                e.printStackTrace();
            }
            if (themeColor.length() > 7) {
                themeColor = themeColor.substring(2, themeColor.length());
            } else {
                themeColor = themeColor;
            }

            String endColor ="";
            if (Uiutils.isTheme(this)){
                themeColor ="b36cff";
                endColor ="87d8d1";
            }

            gameWebView.loadUrl(url + "&color=" + themeColor+ "&endColor=" + endColor+"&back=hide&from=app");
        } else if (url != null) {
            titlebar.setVisibility(View.VISIBLE);
            gameWebView.loadDataWithBaseURL(null, ReplaceUtil.getHtmlData(url), "text/html", "utf-8", null);
        }
        gameWebView.setOnDrawListener(new MyWebView.OnDrawListener() {
            @Override
            public void onDrawCallBack() {
//                removeBtnBack(gameWebView);
            }
        });

        Uiutils.setBarStye0(titlebar,this);
    }

    private void setWebView() {
        gameWebView.getSettings().setJavaScriptEnabled(true);
        gameWebView.getSettings().setBuiltInZoomControls(true);
        gameWebView.getSettings().setDisplayZoomControls(false);
        gameWebView.setScrollBarStyle(View.SCROLLBARS_INSIDE_OVERLAY); //取消滚动条白边效果
        gameWebView.setWebChromeClient(new WebChromeClient());
        gameWebView.setWebViewClient(new WebViewClient());
        gameWebView.getSettings().setDefaultTextEncodingName("UTF-8");
        gameWebView.getSettings().setBlockNetworkImage(false);
//        gameWebView.setCookiesEnabled(true);
//        gameWebView.setThirdPartyCookiesEnabled(true);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            gameWebView.getSettings().setMixedContentMode(gameWebView.getSettings()
                    .MIXED_CONTENT_ALWAYS_ALLOW);  //注意安卓5.0以上的权限
        }
        final JavaScriptInterface myJavaScriptInterface
                = new JavaScriptInterface(this);
        gameWebView.getSettings().setJavaScriptEnabled(true);
        gameWebView.addJavascriptInterface(myJavaScriptInterface, "share");
    }

    private String getHtmlData(String bodyHTML) {
        String head = "<head>"
                + "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=no\"> "
                + "<style>img{max-width: 100%; width:auto; height:auto;}</style>"
                + "</head>";
        return "<html>" + head + "<body>" + bodyHTML + "</body></html>";
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
        super.onDestroy();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent intent) {
        super.onActivityResult(requestCode, resultCode, intent);
        gameWebView.onActivityResult(requestCode, resultCode, intent);
    }

    @Override
    public void onBackPressed() {
        if (!gameWebView.onBackPressed()) {
            return;
        }
        super.onBackPressed();
    }

    @Override
    public void onPageStarted(String url, Bitmap favicon) {
        Log.e("urlonPageStarted", "" + url);
    }

    @Override
    public void onPageFinished(String url) {
        Log.e("urlononPageFinished", "" + url);
//        shareBet();
    }

    @Override
    public void onPageError(int errorCode, String description, String failingUrl) {
        Log.e("urlonPageError", "" + url);
    }

    @Override
    public void onDownloadRequested(String url, String suggestedFilename, String mimeType, long contentLength, String contentDisposition, String userAgent) {

    }

    @Override
    public void onExternalPageRequest(String url) {
        Log.e("urlonRequest", "" + url);
    }

    private void removeBtnBack(WebView view) {
        //隐藏标题左边后退按钮
        String javascript = "javascript:function hideOther() {" +
                "document.getElementsByClassName('mu-appbar-left')[0].style.display='none';}";
        view.loadUrl(javascript);
        view.loadUrl("javascript:hideOther();");
    }

    @OnClick({R.id.iv_back})
    public void onViewClicked(View view) {
        switch (view.getId()) {
            case R.id.iv_back:
                finish();
                break;

        }
    }

    boolean isShare = true;
    private void shareBet() {
        if (shareBetJson != null && shareBetInfoJson != null) {
            Log.e("shareBet111", "" + shareBetJson);
            Log.e("shareBetInfoJson", "" + shareBetInfoJson);
            Handler handler = new Handler();
            handler.postDelayed(new Runnable() {
                @Override
                public void run() {
                    gameWebView.loadUrl("javascript:shareBet(" + shareBetJson + "," + shareBetInfoJson + ")");
                }
            }, 100);//3秒后执行Runnable中的run方法
            isShare = false;
        }
    }

    public class JavaScriptInterface {
        Context mContext;
        JavaScriptInterface(Context c) {
            mContext = c;
        }
        @JavascriptInterface
        public void bet() {
            gameWebView.post(new Runnable() {
                @Override
                public void run() {
                    if(isShare)
                    shareBet();
                }
            });

        }
    }
}
