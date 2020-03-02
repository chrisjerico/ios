package com.phoenix.lotterys.home.bean;

/**
 * Greated by Luke
 * on 2019/7/24
 */
public class RecommendBean {
    String id;
    String category;
    String title;
    String gameType;
    String gameCat;
    int isPopup;
    String pic;
    String isInstant;

    public String getIsInstant() {
        return isInstant;
    }

    public void setIsInstant(String isInstant) {
        this.isInstant = isInstant;
    }

    public int getIsPopup() {
        return isPopup;
    }

    public void setIsPopup(int isPopup) {
        this.isPopup = isPopup;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getGameType() {
        return gameType;
    }

    public void setGameType(String gameType) {
        this.gameType = gameType;
    }

    public String getGameCat() {
        return gameCat;
    }

    public void setGameCat(String gameCat) {
        this.gameCat = gameCat;
    }

    public String getPic() {
        return pic;
    }

    public void setPic(String pic) {
        this.pic = pic;
    }
}
