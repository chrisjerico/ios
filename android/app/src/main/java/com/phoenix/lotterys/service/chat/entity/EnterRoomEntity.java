package com.phoenix.lotterys.service.chat.entity;

import android.content.Context;

import com.phoenix.lotterys.util.SPConstants;

/**
 * @author : W
 * @e-mail :
 * @date : 2019/11/29 09:40
 * @description :
 */
public class EnterRoomEntity {

    /**
     * code : R0000
     * channel : 2
     * token : a92611985de7fd765c28197b77f016b8
     * operate : 1
     * roomId : 6
     */

    private String code = "R0000";
    private String channel = "2";
    private int isLoadRecord = 1;
    private String token;
    private String operate;
    private String roomId;

    public static EnterRoomEntity create(Context context, String roomId, boolean isEnterRoom) {
        EnterRoomEntity entity = new EnterRoomEntity();
        entity.setToken(SPConstants.getValue(context, SPConstants.SP_API_SID));
        entity.setRoomId(roomId);
        entity.setOperate(isEnterRoom ? "1" : "2");
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

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public String getOperate() {
        return operate;
    }

    public void setOperate(String operate) {
        this.operate = operate;
    }

    public String getRoomId() {
        return roomId;
    }

    public void setRoomId(String roomId) {
        this.roomId = roomId;
    }

    public int getIsLoadRecord() {
        return isLoadRecord;
    }

    public void setIsLoadRecord(int isLoadRecord) {
        this.isLoadRecord = isLoadRecord;
    }
}
