package com.phoenix.lotterys.service.chat;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.IBinder;
import android.text.TextUtils;
import android.util.Log;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.phoenix.lotterys.chat.entity.ChatEntity;
import com.phoenix.lotterys.event.ToastEvent;
import com.phoenix.lotterys.util.NewNetUtils;
import com.phoenix.lotterys.util.SPConstants;

import org.greenrobot.eventbus.EventBus;
import org.jetbrains.annotations.NotNull;

import java.lang.ref.WeakReference;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.concurrent.TimeUnit;

import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import okhttp3.WebSocket;
import okhttp3.WebSocketListener;
import rx.Observable;
import rx.Subscription;
import rx.schedulers.Schedulers;

/**
 * @author : W
 * @e-mail :
 * @date : 2019/11/26 16:46
 * @description :
 */
public class ChatManager {

    private static final String TAG = "ChatManager";

    private static ChatManager INSTANCE = ChatManagerHolder.INSTANCE;

    private static class ChatManagerHolder {
        private static ChatManager INSTANCE = new ChatManager();
    }

    public static ChatManager getInstance() {
        return INSTANCE;
    }

    private final String FORMAT_URL = "ws://test03.6yc.com:811?channel=2&loginsessid=%s&logintoken=%s&isReload=%d";

    private final int DELAY_RETRY = 5;

    private OkHttpClient mOkHttpClient;

    private WebSocket mWebSocket;
    private volatile List<String> mMessageList = new ArrayList<>();

    private Subscription mRetryTimer;

    private WeakReference<Context> mContext;
    private ServiceConnection mConnection;

    private ChatManager() {
        mOkHttpClient = new OkHttpClient.Builder()
                .build();
    }

    public void bind(Context context) {
        mContext = new WeakReference<>(context);

        mConnection = new ServiceConnection() {
            @Override
            public void onServiceConnected(ComponentName name, IBinder service) {
            }

            @Override
            public void onServiceDisconnected(ComponentName name) {
            }
        };

        context.bindService(new Intent(context, ChatService.class), mConnection, Context.BIND_AUTO_CREATE);

        openSocket(false);
    }

    public void unBind() {
        mContext.get().unbindService(mConnection);
        closeSocket();
    }

    private void openSocket(boolean isReload) {
        if (mWebSocket == null) {
            String sessid = SPConstants.getValue(mContext.get(), SPConstants.SP_API_SID);
            String token = SPConstants.getValue(mContext.get(), SPConstants.SP_API_TOKEN);
            if (TextUtils.isEmpty(token)) {
                return;
            }

            String url = String.format(Locale.getDefault(), FORMAT_URL, sessid, token, isReload ? 1 : 0);
            Log.d(TAG, "url : " + url);
            Request request = new Request.Builder()
                    .url(url)
                    .build();
            mOkHttpClient.newWebSocket(request, new WebSocketListener() {
                @Override
                public void onOpen(@NotNull WebSocket webSocket, @NotNull Response response) {
                    Log.d(TAG, "onOpen");
                    if (mRetryTimer != null) {
                        mRetryTimer.unsubscribe();
                    }
                    mWebSocket = webSocket;

                    for (String msg : mMessageList) {
                        send(msg);
                    }
                    mMessageList.clear();
                }

                @Override
                public void onFailure(@NotNull WebSocket webSocket, @NotNull Throwable t, Response response) {
                    Log.d(TAG, "onFailure");
                    closeSocket();

                    if (mRetryTimer == null || mRetryTimer.isUnsubscribed()) {
                        mRetryTimer = Observable.timer(DELAY_RETRY, TimeUnit.SECONDS)
                                .delay(DELAY_RETRY, TimeUnit.SECONDS)
                                .subscribeOn(Schedulers.io())
                                .observeOn(Schedulers.io())
                                .subscribe(ignore -> {
                                    if (NewNetUtils.getNetWorkState(mContext.get()) != NewNetUtils.NETWORK_NONE) {
                                        openSocket(true);
                                    }
                                }, Throwable::printStackTrace);
                    }
                }

                @Override
                public void onMessage(@NotNull WebSocket webSocket, @NotNull String text) {
                    Log.d(TAG, "onMessage : " + text);
                    try {
                        JsonObject object = JsonParser.parseString(text).getAsJsonObject();
                        String code = object.get("code").getAsString();
                        switch (code) {
                            case "-1":
                                String msg = object.get("msg").getAsString();
                                if (!msg.equals("授权SID: 长度必须在 24位 - 64位数 之间!")) {
                                    EventBus.getDefault().post(new ToastEvent(msg));
                                }
                                break;
                            case "0001": {
                                EventBus.getDefault().post(new Gson().fromJson(text, ChatEntity.DataBean.class));
                            }
                            break;
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            });
        }
    }

    public void closeSocket() {
        if (mRetryTimer != null) {
            mRetryTimer.unsubscribe();
        }
        if (mWebSocket != null) {
            mWebSocket.close(1000, "");
            mWebSocket = null;
        }
    }

    public void send(String msg) {
        if (mWebSocket != null) {
            Log.d(TAG, "send msg : " + msg);
            mWebSocket.send(msg);
        } else {
            mMessageList.add(msg);
            openSocket(true);
        }
    }
}
