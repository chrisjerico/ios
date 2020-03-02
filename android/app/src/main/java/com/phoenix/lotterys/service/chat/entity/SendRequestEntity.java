package com.phoenix.lotterys.service.chat.entity;

import android.content.Context;

import com.phoenix.lotterys.my.bean.UserInfo;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.ShareUtils;

/**
 * @author : W
 * @e-mail :
 * @date : 2019/11/30 12:11
 * @description :
 */
public class SendRequestEntity {

    /**
     * code : R0010
     * channel : 2
     * chat_type : 1
     * messageCode : ”1571838080_63409”
     * sendUid : 1
     * ”readUid” : 2
     */

    private String code = "R0010";
    private String channel = "2";
    private String chat_type = "1";
    private String messageCode;
    private String sendUid;
    private String readUid;

    public static SendRequestEntity create(Context context, String mesCode, String sendUid) {
        UserInfo userInfo = (UserInfo) ShareUtils.getObject(context, SPConstants.USERINFO, UserInfo.class);

        SendRequestEntity entity = new SendRequestEntity();
        entity.setMessageCode(mesCode);
        entity.setSendUid(sendUid);
        entity.setReadUid(userInfo.getData().getUid());
        return entity;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getChannel() {
        return channel;
    }

    public void setChannel(String channel) {
        this.channel = channel;
    }

    public String getChat_type() {
        return chat_type;
    }

    public void setChat_type(String chat_type) {
        this.chat_type = chat_type;
    }

    public String getMessageCode() {
        return messageCode;
    }

    public void setMessageCode(String messageCode) {
        this.messageCode = messageCode;
    }

    public String getSendUid() {
        return sendUid;
    }

    public void setSendUid(String sendUid) {
        this.sendUid = sendUid;
    }

    public String getReadUid() {
        return readUid;
    }

    public void setReadUid(String readUid) {
        this.readUid = readUid;
    }
}
