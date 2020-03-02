package com.phoenix.lotterys.my.bean;

import java.io.Serializable;

/**
 * 文件描述:
 * 创建者: IAN
 * 创建时间: 2019/7/31 13:44
 */
public class StringBean implements Serializable {


    /**
     * code : 0
     * msg : 获取游戏规则成功
     * data :
     <h2>重要声明</h2>
     <ol>
     <li>1.如果客户怀疑自己的资料被盗用，应立即通知本公司，并更改详细数据，以前的使用者名称及密码将全部无效。</li>
     <li>2.客户有责任确保自己的账户及登入资料的保密性。以使用者名称及密码进行的任何网上投注将被视为有效。 </li>
     <li>3.公布赔率时出现的任何打字错误或非故意人为失误，本公司保留改正错误和按正确赔率结算投注的权利。您居住所在地的法律有可能规定网络博弈不合法；若此情况属实，本公司将不会批准您使用付账卡进行交易。 </li>
     <li>4.每次登入时客户都应该核对自己的账户及余额。如对余额有任何疑问，请在第一时间内通知本公司。</li>
     <li>5.一旦投注被接受，则不得取消或修改。</li>
     <li>6.所有号码赔率将不时浮动，派彩时的赔率将以确认投注时之赔率为准。</li>
     <li>7.每注最高投注金额按不同[场次]及[投注项目]及[会员账号]设定浮动。如投注金额超过上述设定，本公司有权取消超过之投注金额。</li>
     <li>8.所有投注都必须在开奖前时间内进行否则投注无效。</li>
     <li>9.所有投注派彩彩金皆含本金。</li>
     </ol>
     <h2>三分时时彩规则说明</h2>
     */

    private int code;
    private String msg;
    private String data;

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public String getData() {
        return data;
    }

    public void setData(String data) {
        this.data = data;
    }
}
