package com.phoenix.lotterys.event;

import com.phoenix.lotterys.chat.entity.TicketListEntity;

/**
 * @author : W
 * @e-mail :
 * @date : 2019/12/12 09:39
 * @description :
 */
public class ShareTicketEvent {
    private TicketListEntity.DataBean bean;

    public ShareTicketEvent(TicketListEntity.DataBean bean) {
        this.bean = bean;
    }

    public TicketListEntity.DataBean getBean() {
        return bean;
    }
}
