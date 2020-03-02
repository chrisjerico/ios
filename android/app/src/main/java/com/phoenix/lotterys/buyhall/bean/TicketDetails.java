package com.phoenix.lotterys.buyhall.bean;

import java.util.List;

/**
 * Created by Luke
 * on 2019/6/12
 */
public class TicketDetails {
    private String endtime;
    private String lotteryTime;
    private String preLotteryTime;
    private String preNum;
    private String title;
    private String gameId;
    private String gameType;
    private String isInstant;
    private String id;
    private String roomId;
    private String roomName;
    int isChar; //是否切换到 聊天室
    private String chatId;//某个聊天室ID

    public String getChatId() {
        return chatId;
    }

    public void setChatId(String chatId) {
        this.chatId = chatId;
    }

    public String getRoomName() {
        return roomName;
    }

    public void setRoomName(String roomName) {
        this.roomName = roomName;
    }

    public String getRoomId() {
        return roomId;
    }

    public void setRoomId(String roomId) {
        this.roomId = roomId;
    }

    public int getIsChar() {
        return isChar;
    }

    public void setIsChar(int isChar) {
        this.isChar = isChar;
    }

    private List<BbsBean> bbsBean;


    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public static class BbsBean {
        String id;
        String name;
        String gameId;
        String gameType;

        public BbsBean(String id, String name,String gameId,String gameType) {
            this.id = id;
            this.name = name;
            this.gameId = gameId;
            this.gameType = gameType;
        }
        @Override
        public String toString() {
            return "BbsBean{" +
                    "id='" + id + '\'' +
                    ", name='" + name + '\'' +
                    '}';
        }

        public String getGameType() {
            return gameType;
        }

        public void setGameType(String gameType) {
            this.gameType = gameType;
        }

        public String getGameId() {
            return gameId;
        }

        public void setGameId(String gameId) {
            this.gameId = gameId;
        }

        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }
    }

    public List<BbsBean> getBbsBean() {
        return bbsBean;
    }

    public void setBbsBean(List<BbsBean> bbsBean) {
        this.bbsBean = bbsBean;
    }

    public String getIsInstant() {
        return isInstant;
    }

    public void setIsInstant(String isInstant) {
        this.isInstant = isInstant;
    }

    public String getGameType() {
        return gameType;
    }

    public void setGameType(String gameType) {
        this.gameType = gameType;
    }

    public String getGameId() {
        return gameId;
    }

    public void setGameId(String gameId) {
        this.gameId = gameId;
    }

    public String getEndtime() {
        return endtime;
    }

    public void setEndtime(String endtime) {
        this.endtime = endtime;
    }

    public String getLotteryTime() {
        return lotteryTime;
    }

    public void setLotteryTime(String lotteryTime) {
        this.lotteryTime = lotteryTime;
    }

    public String getPreLotteryTime() {
        return preLotteryTime;
    }

    public void setPreLotteryTime(String preLotteryTime) {
        this.preLotteryTime = preLotteryTime;
    }

    public String getPreNum() {
        return preNum;
    }

    public void setPreNum(String preNum) {
        this.preNum = preNum;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }
}
