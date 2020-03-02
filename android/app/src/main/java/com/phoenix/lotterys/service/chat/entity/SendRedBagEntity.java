package com.phoenix.lotterys.service.chat.entity;

import android.content.Context;

import com.phoenix.lotterys.my.bean.UserInfo;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.ShareUtils;

/**
 * @author : W
 * @e-mail :
 * @date : 2019/11/30 13:17
 * @description :
 */
public class SendRedBagEntity {

    /**
     * code : R0011
     * channel : 2
     * roomId : 0
     * redBagId : ”1”
     * ip : 1
     * level : 2
     */

    private String code = "R0011";
    private String channel = "2";
    private String roomId;
    private String redBagId;
    private String ip;
    private String level;

    public static SendRedBagEntity create(Context context, String roomUd, String redBagId) {
        UserInfo userInfo = (UserInfo) ShareUtils.getObject(context, SPConstants.USERINFO, UserInfo.class);

        SendRedBagEntity entity = new SendRedBagEntity();
        entity.setRoomId(roomUd);
        entity.setRedBagId(redBagId);
        entity.setIp(userInfo.getData().getClientIp());
        entity.setLevel(userInfo.getData().getCurLevelInt());
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

    public String getRoomId() {
        return roomId;
    }

    public void setRoomId(String roomId) {
        this.roomId = roomId;
    }

    public String getRedBagId() {
        return redBagId;
    }

    public void setRedBagId(String redBagId) {
        this.redBagId = redBagId;
    }

    public String getIp() {
        return ip;
    }

    public void setIp(String ip) {
        this.ip = ip;
    }

    public String getLevel() {
        return level;
    }

    public void setLevel(String level) {
        this.level = level;
    }
}
