package com.phoenix.lotterys.chat.fragment;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Rect;
import android.os.Build;
import android.os.Handler;
import android.os.Message;
import androidx.annotation.RequiresApi;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.view.ViewTreeObserver;
import android.webkit.CookieManager;
import android.webkit.CookieSyncManager;
import android.webkit.WebResourceRequest;
import android.webkit.WebResourceResponse;
import android.webkit.WebSettings;
import android.webkit.WebStorage;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.main.BlackMainActivity;
import com.phoenix.lotterys.main.MainActivity;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.CookieHelper;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.view.CustomTitleBar;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;

import butterknife.BindView;
import butterknife.OnClick;
import im.delight.android.webview.AdvancedWebView;


/**
 * Created by Luke
 * on 2019/6/27
 */
@SuppressLint("ValidFragment")
public class ChatFragment extends BaseFragments implements AdvancedWebView.Listener {
    @BindView(R2.id.titlebar)
    CustomTitleBar titlebar;
    @BindView(R2.id.webview)
    AdvancedWebView mWebView;
    @BindView(R2.id.tv_refresh)
    TextView tvRefresh;
    private String url;
    //    @BindView(R2.id.refreshLayout)
//    SmartRefreshLayout refreshLayout;
    MainActivity mActivity;
    BlackMainActivity mBlackActivity;

    private String mRoomId;

    public ChatFragment(String mRoomId) {
        super(R.layout.fragment_chat, true, true);
        this.mRoomId = mRoomId;
    }

    public static ChatFragment getInstance(String mRoomId) {
        return new ChatFragment(mRoomId);
    }

    @Override
    public void initView(View view) {
        if (getActivity() instanceof MainActivity)
            mActivity = (MainActivity) getActivity();
        if (getActivity() instanceof BlackMainActivity)
            mBlackActivity = (BlackMainActivity) getActivity();

        titlebar.setText("聊天室");
        titlebar.setRIghtTvVisibility(0x00000008);
        mWebView.setListener(getActivity(), this);
        addOnSoftKeyBoardVisibleListener();
        setWebView();
        loadMUrl(mRoomId);
        mWebView.setWebViewClient(new WebViewClient() {
            @Override
            public boolean shouldOverrideUrlLoading(WebView view, String url) {

                return true;

            }

            @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
            @Override
            public boolean shouldOverrideUrlLoading(WebView view, WebResourceRequest request) {

                return true;

            }


            @Override
            public void onLoadResource(WebView view, String url) {
                super.onLoadResource(view, url);
            }

            @Override
            public WebResourceResponse shouldInterceptRequest(WebView view, String url) {
                return super.shouldInterceptRequest(view, url);
            }

        });
        loadMUrl(mRoomId);
        Uiutils.setBaColor(getContext(),titlebar, false, null);
        Uiutils.setBarStye0(titlebar,getContext());
    }


    private void loadMUrl(String id) {
        CookieHelper.setCookies(getActivity(), Constants.BaseUrl());
        CookieHelper.setCookies(getActivity(), Constants.BaseUrl() + "/mobile");
        CookieHelper.setCookies(getActivity(), Constants.BaseUrl() + "/mobile/init.do");
        String sid = SPConstants.getValue(getContext(), SPConstants.SP_API_SID);
        String token = SPConstants.getValue(getContext(), SPConstants.SP_API_TOKEN);
        String themeColor = Integer.toHexString(getResources().getColor(ShareUtils.getInt(getContext(), "ba_top", 0)));
        String endColor ="";
        if (themeColor.length() > 7) {
            themeColor = themeColor.substring(2, themeColor.length());
        } else {
            themeColor = themeColor;
        }

        if (Uiutils.isTheme(getContext())){
            themeColor ="b36cff";
            endColor ="87d8d1";
        }

        if (TextUtils.isEmpty(id)) {
            url = Constants.BaseUrl() + Constants.CHAT + "logintoken=" + token + "&sessiontoken=" + sid
                    + "&color=" + themeColor + "&endColor=" + endColor;
            titlebar.setVisibility(View.GONE);
        } else {
            url = Constants.BaseUrl() + Constants.CHATROOM_NEW + "logintoken=" + token + "&sessiontoken=" + sid
                    + "&color=" + themeColor + "&endColor=" + endColor + "&roomId=" + id;
        }
        Log.e("url", "///" + url);
        mWebView.loadUrl(url);
    }

    private void setWebView() {

        WebSettings settings = mWebView.getSettings();
        settings.setUseWideViewPort(true);
        settings.setLoadWithOverviewMode(true);
        settings.setDomStorageEnabled(true);
        settings.setCacheMode(WebSettings.LOAD_NO_CACHE);
        settings.setDefaultTextEncodingName("UTF-8");
        settings.setAllowContentAccess(true); // 是否可访问Content Provider的资源，默认值 true
        settings.setAllowFileAccess(true);    // 是否可访问本地文件，默认值 true
        // 是否允许通过file url加载的Javascript读取本地文件，默认值 false
        settings.setAllowFileAccessFromFileURLs(false);
        // 是否允许通过file url加载的Javascript读取全部资源(包括文件,http,https)，默认值 false
        settings.setAllowUniversalAccessFromFileURLs(false);
        //开启JavaScript支持
        settings.setJavaScriptEnabled(true);
        // 支持缩放
        settings.setSupportZoom(true);

    }

    @SuppressLint("NewApi")
    @Override
    public void onResume() {
        super.onResume();
        mWebView.onResume();
    }

    @SuppressLint("NewApi")
    @Override
    public void onPause() {
        mWebView.onPause();
        super.onPause();
    }

    @Override
    public void onDestroy() {
        mWebView.onDestroy();

        mWebView.clearCache(true);

        super.onDestroy();
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent intent) {
        super.onActivityResult(requestCode, resultCode, intent);
        if (mWebView != null) {
            mWebView.onActivityResult(requestCode, resultCode, intent);
        }
    }
    @Override
    public void onPageStarted(String url, Bitmap favicon) {
    }

    @Override
    public void onPageFinished(String url) {
//        removeBtnBack(mWebView);
    }

    @Override
    public void onPageError(int errorCode, String description, String failingUrl) {
    }

    @Override
    public void onDownloadRequested(String url, String suggestedFilename, String mimeType, long contentLength, String contentDisposition, String userAgent) {
    }

    @Override
    public void onExternalPageRequest(String url) {
    }


    @Override
    public void onDestroyView() {
        super.onDestroyView();
    }


    boolean isfinish = false;
    Handler handler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
            if (!isfinish) {
//                removeBtnBack(mWebView);
                handler.sendEmptyMessageDelayed(0, 1000);
            }
        }
    };

    private void removeBtnBack(WebView view) {
        //隐藏标题左边后退按钮
        String javascript = "javascript:function hideOther() {" +
                "document.getElementsByClassName('footer-bar-item center re')[0].style.display='none';}";
        view.loadUrl(javascript);
        view.loadUrl("javascript:hideOther();");
    }


    @OnClick(R.id.tv_refresh)
    public void onViewClicked() {
//        ObjectAnimator objectAnimator = ObjectAnimator.ofFloat(tvRefresh, "rotation", 0f, 360f);
//        objectAnimator.setDuration(1000);
//        objectAnimator.start();
//        mWebView.loadUrl(url);
    }

    private boolean isKeyBoardOpen = false;

    private void addOnSoftKeyBoardVisibleListener() {
        final View decorView = getActivity().getWindow().getDecorView();
        decorView.getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() {
            @Override
            public void onGlobalLayout() {
                Rect rect = new Rect();
                decorView.getWindowVisibleDisplayFrame(rect);
                isKeyBoardOpen = (double) (rect.bottom - rect.top) / decorView.getHeight() < 0.8;
                if (isKeyBoardOpen){
                    if (getActivity() instanceof MainActivity)
                        mActivity.setRadioGroup(View.GONE);
                    if (getActivity() instanceof BlackMainActivity)
                        mBlackActivity.setRadioGroup(View.GONE);
                }else{
                    if (getActivity() instanceof MainActivity)
                        mActivity.setRadioGroup(View.VISIBLE);
                    if (getActivity() instanceof BlackMainActivity)
                        mBlackActivity.setRadioGroup(View.VISIBLE);
                }
            }
        });
    }

    protected void onTransformResume() {
//        loadMUrl();
    }


    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    @Override
    public void getEvenMsg(Even even) {
        switch (even.getCode()) {
            case EvenBusCode.LOGIN:  //登录并获取信息

                mWebView.clearCache(true);
                CookieSyncManager.createInstance(getActivity().getApplicationContext());
                CookieManager cookieManager = CookieManager.getInstance();
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                    cookieManager.removeSessionCookies(null);
                    cookieManager.removeAllCookie();
                    cookieManager.flush();
                } else {
                    cookieManager.removeSessionCookies(null);
                    cookieManager.removeAllCookie();
                    CookieSyncManager.getInstance().sync();
                }
                WebStorage.getInstance().deleteAllData();

                mWebView.getSettings().setCacheMode(WebSettings.LOAD_NO_CACHE);
                getActivity().deleteDatabase("WebView.db");
                getActivity().deleteDatabase("WebViewCache.db");
                mWebView.clearCache(true);
                mWebView.clearFormData();

                mWebView.setWebChromeClient(null);
                mWebView.setWebViewClient(null);
                mWebView.clearCache(true);
//                CookieSyncManager.createInstance(getActivity().getApplicationContext());  //Create a singleton CookieSyncManager within a context
//                CookieManager cookieManager = CookieManager.getInstance(); // the singleton CookieManager instance
//                cookieManager.removeAllCookie();// Removes all cookies.
//                CookieSyncManager.getInstance().sync(); // forces sync manager to sync now
//                mWebView.setWebChromeClient(null);
//                mWebView.setWebViewClient(null);
//                mWebView.clearCache(true);


                loadMUrl(mRoomId);
                break;
            case EvenBusCode.CHANGE_THEME_STYLE_MYF:
                Uiutils.setBaColor(getContext(),titlebar, false, null);
                break;
        }
    }
}
