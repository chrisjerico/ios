package com.phoenix.lotterys.my.fragment;

import android.annotation.SuppressLint;
import android.graphics.Bitmap;
import android.os.Build;
import android.util.Log;
import android.view.View;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.view.CustomTitleBar;
import com.wanxiangdai.commonlibrary.base.BaseFragment;
import com.wanxiangdai.commonlibrary.util.StringUtils;

import butterknife.BindView;
import im.delight.android.webview.AdvancedWebView;

/**
 * 文件描述: 公共webview 页面
 * 创建者: IAN
 * 创建时间: 2019/8/9 16:25
 */
public class PubWebviewFrag extends BaseFragment implements AdvancedWebView.Listener {
    @BindView(R2.id.web)
    AdvancedWebView web;
    @BindView(R2.id.titlebar)
    CustomTitleBar titlebar;

    @Override
    public void onPageStarted(String url, Bitmap favicon) {

    }

    @Override
    public void onPageFinished(String url) {
        removeBtnBack(web);
    }

    private void removeBtnBack(WebView view) {
        //隐藏标题左边后退按钮
        String javascript = "javascript:function hideOther() {" +
                "document.getElementsByClassName('ui-head-btn1')[0].style.display='none';}";
        view.loadUrl(javascript);
        view.loadUrl("javascript:hideOther();");
        //隐藏支付
        javascript = "javascript:function hideOther() {" +
                "document.getElementsByClassName('mu-ripple-wrapper')[0].style.display='none';}";
        view.loadUrl(javascript);
        view.loadUrl("javascript:hideOther();");
        javascript = "javascript:function hideOther() {" +
                "document.getElementsByClassName('iconfont iconfanhui1')[0].style.display='none';}";
        view.loadUrl(javascript);
        view.loadUrl("javascript:hideOther();");

        javascript = "javascript:function hideOther() {" +
                "document.getElementsByClassName('iconfont iconshouye')[0].style.display='none';}";
        view.loadUrl(javascript);
        view.loadUrl("javascript:hideOther();");
    }

    @Override
    public void onPageError(int errorCode, String description, String failingUrl) {
    }

    @Override
    public void onDownloadRequested(String url, String suggestedFilename, String mimeType, long
            contentLength, String contentDisposition, String userAgent) {
    }

    @Override
    public void onExternalPageRequest(String url) {
    }

    private String url;
    private String title;
    private int type;

    public PubWebviewFrag() {
        super(R.layout.pub_webview_frag, true, true);
    }

    @Override
    public void initView(View view) {
        url = getArguments().getString("url");
        title = getArguments().getString("title");
        type = getArguments().getInt("type");
        if (!StringUtils.isEmpty(title)) {
            titlebar.setVisibility(View.VISIBLE);
        }else{
            titlebar.setVisibility(View.GONE);
        }
        titlebar.setText(title);
        Uiutils.setBarStye(titlebar, getActivity());
        Log.e("url==", url);
//        type = getArguments().getInt("type");
        setWebView();
        web.setListener(getActivity(), this);
//        if (type == 1)
            web.loadUrl(url);
//        if (type!=0){
//            web.loadUrl(url);
//        }else {
//            if (url != null && url.startsWith("http")) {
//                CookieHelper.setCookies(getActivity(), "", Constants.BaseUrl);
//                web.loadUrl(url);
//            } else if (url != null) {
//                web.loadDataWithBaseURL(null, getHtmlData(url), "text/html", "utf-8", null);
//            }
//        }

        Uiutils.setBarStye0(titlebar,getContext());
    }

    private void setWebView() {
        web.getSettings().setJavaScriptEnabled(true);
        web.getSettings().setBuiltInZoomControls(true);
        web.getSettings().setDisplayZoomControls(false);
        web.setScrollBarStyle(View.SCROLLBARS_INSIDE_OVERLAY); //取消滚动条白边效果

        web.setWebViewClient(new WebViewClient());
        web.getSettings().setDefaultTextEncodingName("UTF-8");
        web.getSettings().setBlockNetworkImage(false);

        web.getSettings().setDomStorageEnabled(true);
        web.getSettings().setLayoutAlgorithm(WebSettings.LayoutAlgorithm.NARROW_COLUMNS);//适应内容大小
        //调试
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            web.setWebContentsDebuggingEnabled(true);
        }

//        web.addJavascriptInterface(new AndroidJs(getContext()), "android");
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            web.getSettings().setMixedContentMode(web.getSettings()
                    .MIXED_CONTENT_ALWAYS_ALLOW);  //注意安卓5.0以上的权限
        }

        web.setWebChromeClient(new WebChromeClient() {
            @Override
            public void onReceivedTitle(WebView view, String title0) {
                super.onReceivedTitle(view, title0);
                if (StringUtils.isEmpty(title)) {
                    if (!StringUtils.isEmpty(title0)&&!view.getUrl().contains(title0)){
                        title = view.getTitle();
                        titlebar.setText(title);
                        titlebar.setVisibility(View.VISIBLE);
                    }else{
                        titlebar.setVisibility(View.GONE);
                    }

                }
            }
        });


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
    public void onResume() {
        super.onResume();
        web.onResume();
    }

    @SuppressLint("NewApi")
    @Override
    public void onPause() {
        web.onPause();
        super.onPause();
    }

    @Override
    public void onDestroy() {
        web.onDestroy();
        super.onDestroy();
    }
}
