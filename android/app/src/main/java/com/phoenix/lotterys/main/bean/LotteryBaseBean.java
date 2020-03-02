package com.phoenix.lotterys.main.bean;

/**
 * Greated by Luke
 * on 2019/7/13
 */
public class LotteryBaseBean {
    /**
     * id : 7
     * type : 1
     * name : ofclmmc
     * title : 秒秒彩
     * customise : 0
     * pic : https://fhptstatic02.com/upload/test/customise/images/lottery_ofclmmc.jpg?v=15629989204
     */

    private String id;
    private String type;
    private String name;
    private String title;
    private String customise;
    private String pic;
    private String isPopup;
    private String category;
    private String game_type;
    private String game_cat;

    @Override
    public String toString() {
        return "LotteryBaseBean{" +
                "id='" + id + '\'' +
                ", type='" + type + '\'' +
                ", name='" + name + '\'' +
                ", title='" + title + '\'' +
                ", customise='" + customise + '\'' +
                ", pic='" + pic + '\'' +
                ", isPopup='" + isPopup + '\'' +
                ", category='" + category + '\'' +
                ", game_type='" + game_type + '\'' +
                ", game_cat='" + game_cat + '\'' +
                '}';
    }

    public String getIsPopup() {
        return isPopup;
    }

    public void setIsPopup(String isPopup) {
        this.isPopup = isPopup;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getGame_type() {
        return game_type;
    }

    public void setGame_type(String game_type) {
        this.game_type = game_type;
    }

    public String getGame_cat() {
        return game_cat;
    }

    public void setGame_cat(String game_cat) {
        this.game_cat = game_cat;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getCustomise() {
        return customise;
    }

    public void setCustomise(String customise) {
        this.customise = customise;
    }

    public String getPic() {
        return pic;
    }

    public void setPic(String pic) {
        this.pic = pic;
    }
}
