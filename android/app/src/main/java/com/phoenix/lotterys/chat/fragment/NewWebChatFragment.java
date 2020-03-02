package com.phoenix.lotterys.chat.fragment;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.os.Build;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.JavascriptInterface;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebViewClient;
import android.widget.FrameLayout;
import android.widget.TextView;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonParseException;
import com.google.gson.JsonParser;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.buyhall.bean.RoomListBean;
import com.phoenix.lotterys.buyhall.entity.RoomListEntity;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.CookieHelper;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.ToastUtils;
import com.phoenix.lotterys.util.Uiutils;

import butterknife.BindView;
import im.delight.android.webview.AdvancedWebView;

/**
 * @author : Wu
 * @e-mail : wu_developer@outlook.com
 * @date : 2020/01/09 15:41
 * @description :
 */
public class NewWebChatFragment extends BaseFragments implements AdvancedWebView.Listener {

    private final String TAG = "NewWebChatFragment";

    @BindView(R2.id.fl_web)
    FrameLayout flWeb;
    @BindView(R2.id.tv_refresh)
    TextView tvRefresh;

    private AdvancedWebView mWebView;

    private static RoomListBean.DataBean.ChatAryBean mRoomBean;
    private boolean isLoadEnd = false;
    private String roomId, shareBetJson, shareBetInfoJson;

    public NewWebChatFragment() {
        super(R.layout.fragment_new_web_chat, true, true);
    }

    public static NewWebChatFragment getInstance() {
        return new NewWebChatFragment();
    }

    @Override
    public void initView(View view) {
        loadMUrl(mRoomBean != null ? mRoomBean.getRoomId() : "0");
//        ToastUtils.ToastUtils("1112221111",getContext());
    }

//    public void init() {
//        if (mWebView == null) {
//            loadMUrl("0");
//        }
//    }

    /**
     * 上一次进入的聊天室
     * @return
     */
    public static RoomListBean.DataBean.ChatAryBean lastRoom() {
        return mRoomBean;
    }

    public static void setLastRoom(RoomListBean.DataBean.ChatAryBean bean) {
        mRoomBean = bean;
    }

    public void checkRoom(RoomListBean.DataBean.ChatAryBean roomBean) {
        mRoomBean = roomBean;
        if (isLoadEnd) {
            enterRoom();
        }
    }

    public void share(String roomId, String shareBetJson, String shareBetInfoJson) {
        this.roomId = roomId;
        this.shareBetJson = shareBetJson;
        this.shareBetInfoJson = shareBetInfoJson;
        if (isLoadEnd) {
            checkShareEnable();
        }
    }

    private void enterRoom() {
        if (mRoomBean != null) {
            loadJS("changeRoom(" + (new Gson().toJson(mRoomBean)) + ")", new JsResultListener() {
                @Override
                public void getResult(String result) {

                }

                @Override
                public void cannotGetResult() {

                }

                @Override
                public void onSendEnd() {
                    checkShareEnable();
                }
            });
//            mRoomBean = null;
        }
    }

    private void checkShareEnable() {
        if (shareBetJson != null && shareBetInfoJson != null) {
            Log.e("shareBet111", "" + shareBetJson);
            Log.e("shareBetInfoJson", "" + shareBetInfoJson);

            loadJS("window.canShare", new JsResultListener() {
                @Override
                public void getResult(String result) {
                    if (result.equals("true")) {
                        sendShare();
                    } else {
                        ToastUtils.ToastUtils("此房间未开启分享功能", getContext());
                    }
                }

                @Override
                public void cannotGetResult() {
                    sendShare();
                }

                @Override
                public void onSendEnd() {

                }
            });
        }
    }

    private void sendShare() {
        try {
            JsonObject jsonObject = JsonParser.parseString(shareBetInfoJson).getAsJsonObject();
            jsonObject.addProperty("roomId", roomId);
            loadJS("shareBet(" + shareBetJson + "," + jsonObject.toString() + ")", null);
        } catch (JsonParseException e) {
            e.printStackTrace();
            ToastUtils.ToastUtils("分享格式错误", getContext());
        }

        roomId = null;
        shareBetJson = null;
        shareBetInfoJson = null;
    }

    private void loadMUrl(String id) {
        if (mWebView != null) {
            flWeb.removeView(mWebView);
            mWebView.clearCache(true);
            mWebView.onDestroy();
            shareBetJson = null;
            shareBetInfoJson = null;
        }
        mWebView = new AdvancedWebView(getContext());
        flWeb.addView(mWebView, ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);

        mWebView.setListener(getActivity(), this);
        setWebView();
        mWebView.setWebChromeClient(new WebChromeClient());
        mWebView.setWebViewClient(new WebViewClient());

//        CookieHelper.setCookies(getActivity(), Constants.BaseUrl());
//        CookieHelper.setCookies(getActivity(), Constants.BaseUrl() + "/mobile");
//        CookieHelper.setCookies(getActivity(), Constants.BaseUrl() + "/mobile/init.do");
        String sid = SPConstants.getValue(getContext(), SPConstants.SP_API_SID);
        String token = SPConstants.getValue(getContext(), SPConstants.SP_API_TOKEN);
        String themeColor = Integer.toHexString(getResources().getColor(ShareUtils.getInt(getContext(), "ba_top", 0)));
        String endColor = "";
        if (themeColor.length() > 7) {
            themeColor = themeColor.substring(2, themeColor.length());

        } else {
            themeColor = themeColor;

        }

        if (Uiutils.isTheme(getContext())) {
            themeColor = "b36cff";

        }
        String url = Constants.BaseUrl() + Constants.CHATROOM_NEW + "logintoken=" + token + "&loginsessid=" + sid
                + "&color=" + themeColor + "&endColor=" + endColor + "&roomId=" + id+"";

//        String url = Constants.BaseUrl()+"/h5chat/index.php#/chatRoom?from=app&roomId=0&roomName=主聊天室";
        Log.d(TAG, "url : " + url);
        mWebView.loadUrl(url);
    }

    private void setWebView() {
        mWebView.setScrollBarStyle(View.SCROLLBARS_INSIDE_OVERLAY);
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
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            settings.setMixedContentMode(WebSettings.MIXED_CONTENT_ALWAYS_ALLOW);  //注意安卓5.0以上的权限
        }
        mWebView.addJavascriptInterface(new JavaScriptInterface(getContext()), "share");
    }

    public class JavaScriptInterface {
        Context mContext;

        JavaScriptInterface(Context c) {
            mContext = c;
        }

        @JavascriptInterface
        public void bet() {
            mWebView.postDelayed(() -> {
                isLoadEnd = true;

                enterRoom();
                Log.d(TAG, "share");
            }, 500);
        }
    }

    interface JsResultListener {
        void getResult(String result);

        void cannotGetResult();

        void onSendEnd();
    }

    private void loadJS(String js, JsResultListener listener) {
        if (mWebView != null) {
            Log.d(TAG, "js : " + js);
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                mWebView.evaluateJavascript(js, value -> {
                    Log.d(TAG, "js result : " + value);
                    if (listener != null) {
                        listener.getResult(value);
                        listener.onSendEnd();
                    }
                });
            } else {
                mWebView.loadUrl(js);
                if (listener != null) {
                    listener.cannotGetResult();
                    listener.onSendEnd();
                }
            }
        }
    }

    @SuppressLint("NewApi")
    @Override
    public void onResume() {
        super.onResume();
        if (mWebView != null) {
            mWebView.onResume();
        }
    }

    @SuppressLint("NewApi")
    @Override
    public void onPause() {
        if (mWebView != null) {
            mWebView.onPause();
        }
        super.onPause();
    }

    @Override
    public void onDestroy() {
        if (mWebView != null) {
            flWeb.removeView(mWebView);
            mWebView.clearCache(true);
            mWebView.onDestroy();
        }
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


}
