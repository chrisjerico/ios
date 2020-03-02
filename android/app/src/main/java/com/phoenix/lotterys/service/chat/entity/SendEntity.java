package com.phoenix.lotterys.service.chat.entity;

import android.content.Context;

import com.phoenix.lotterys.my.bean.UserInfo;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.ShareUtils;

import java.util.Locale;

/**
 * @author : W
 * @e-mail :
 * @date : 2019/11/27 09:27
 * @description :
 */
public class SendEntity {

    /**
     * code : R0002
     * betFollowFlag : false
     * betUrl :
     * msg : 112
     * msgJson : null
     * roomId : 2
     * chat_type : 0
     * channel : 2
     * data_type : text
     * chatUid :
     * chatName :
     * level : 1
     * username : bob001
     * ip : 118.143.206.6
     * token : 1322dfb2acd4663a794cadeb7140881e
     * createTime : 1574056074
     * messageCode : 1574056074_63408
     */

    private String code = "R0002";
    private String channel = "2";
    private boolean betFollowFlag;
    private String betUrl;
    private String msg;
    private Object msgJson;
    private String roomId;
    private int chat_type;
    private String data_type;
    private String chatUid;
    private String chatName;
    private String level;
    private String username;
    private String ip;
    private String token;
    private String createTime;
    private String messageCode;
    private String image_path;

    public static SendEntity getPrivateText(Context context, String chatUid, String chatName, String msg, boolean isImg) {
        String token = SPConstants.getValue(context, SPConstants.SP_API_SID);
        UserInfo userInfo = (UserInfo) ShareUtils.getObject(context, SPConstants.USERINFO, UserInfo.class);

        SendEntity entity = new SendEntity();
        entity.setChat_type(1);
        entity.setData_type(isImg ? "image" : "text");

        entity.setChatUid(chatUid);
        entity.setChatName(chatName);

        entity.setLevel(userInfo.getData().getCurLevelInt());
        entity.setUsername(userInfo.getData().getUsr());
        entity.setIp(userInfo.getData().getClientIp());
        entity.setToken(token);
        String time = String.valueOf(System.currentTimeMillis() / 1000);
        entity.setCreateTime(time);
        entity.setMessageCode(String.format(Locale.getDefault(), "%s_%s", time, userInfo.getData().getUid()));

        entity.setMsg(msg);
        return entity;
    }

    public static SendEntity getGroupText(Context context, String roomId, String msg, boolean isImg) {
        String token = SPConstants.getValue(context, SPConstants.SP_API_SID);
        UserInfo userInfo = (UserInfo) ShareUtils.getObject(context, SPConstants.USERINFO, UserInfo.class);

        SendEntity entity = new SendEntity();
        entity.setChat_type(0);
        entity.setData_type(isImg ? "image" : "text");

        entity.setRoomId(roomId);

        entity.setLevel(userInfo.getData().getCurLevelInt());
        entity.setUsername(userInfo.getData().getUsr());
        entity.setIp(userInfo.getData().getClientIp());
        entity.setToken(token);
        String time = String.valueOf(System.currentTimeMillis() / 1000);
        entity.setCreateTime(time);
        entity.setMessageCode(String.format(Locale.getDefault(), "%s_%s", time, userInfo.getData().getUid()));

        entity.setMsg(msg);
        return entity;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public boolean isBetFollowFlag() {
        return betFollowFlag;
    }

    public void setBetFollowFlag(boolean betFollowFlag) {
        this.betFollowFlag = betFollowFlag;
    }

    public String getBetUrl() {
        return betUrl;
    }

    public void setBetUrl(String betUrl) {
        this.betUrl = betUrl;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public Object getMsgJson() {
        return msgJson;
    }

    public void setMsgJson(Object msgJson) {
        this.msgJson = msgJson;
    }

    public String getRoomId() {
        return roomId;
    }

    public void setRoomId(String roomId) {
        this.roomId = roomId;
    }

    public int getChat_type() {
        return chat_type;
    }

    public void setChat_type(int chat_type) {
        this.chat_type = chat_type;
    }

    public String getChannel() {
        return channel;
    }

    public void setChannel(String channel) {
        this.channel = channel;
    }

    public String getData_type() {
        return data_type;
    }

    public void setData_type(String data_type) {
        this.data_type = data_type;
    }

    public String getChatUid() {
        return chatUid;
    }

    public void setChatUid(String chatUid) {
        this.chatUid = chatUid;
    }

    public String getChatName() {
        return chatName;
    }

    public void setChatName(String chatName) {
        this.chatName = chatName;
    }

    public String getLevel() {
        return level;
    }

    public void setLevel(String level) {
        this.level = level;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getIp() {
        return ip;
    }

    public void setIp(String ip) {
        this.ip = ip;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public String getCreateTime() {
        return createTime;
    }

    public void setCreateTime(String createTime) {
        this.createTime = createTime;
    }

    public String getMessageCode() {
        return messageCode;
    }

    public void setMessageCode(String messageCode) {
        this.messageCode = messageCode;
    }

    public String getImage_path() {
        return image_path;
    }

    public void setImage_path(String image_path) {
        this.image_path = image_path;
    }
}
