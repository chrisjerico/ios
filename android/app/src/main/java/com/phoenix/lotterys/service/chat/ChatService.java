package com.phoenix.lotterys.service.chat;

import android.app.Service;
import android.content.Intent;
import android.os.Binder;
import android.os.IBinder;
import androidx.annotation.Nullable;


/**
 * @author : W
 * @e-mail :
 * @date : 2019/11/11 13:28
 * @description :
 */
public class ChatService extends Service {

    private class ChatBinder extends Binder {

    }

    private ChatBinder mBinder = new ChatBinder();

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return mBinder;
    }
}
