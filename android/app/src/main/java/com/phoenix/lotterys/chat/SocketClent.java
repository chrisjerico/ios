package com.phoenix.lotterys.chat;

import android.util.Log;

import org.java_websocket.client.WebSocketClient;
import org.java_websocket.handshake.ServerHandshake;

import java.net.URI;

public class SocketClent extends WebSocketClient {
    public SocketClent(URI serverUri) {
        super(serverUri);
    }

    @Override
    public void onOpen(ServerHandshake handshakedata) {
        Log.e("SocketClent", "连接打开onOpen");
    }

    @Override
    public void onMessage(String message) {
        Log.e("SocketClent", message);
    }

    @Override
    public void onClose(int code, String reason, boolean remote) {
        Log.e("SocketClent", "关闭 断开连接onClose");
    }

    @Override
    public void onError(Exception ex) {
        Log.e("SocketClent", "错误 onError");
    }
}
