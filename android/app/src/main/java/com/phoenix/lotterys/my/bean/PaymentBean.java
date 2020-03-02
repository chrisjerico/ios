package com.phoenix.lotterys.my.bean;

import java.io.Serializable;
import java.util.List;

/**
 * Greated by Luke
 * on 2019/8/28
 */
public class PaymentBean implements Serializable {
    private static final long serialVersionUID = 1L;

    private String id;
    private String code;
    private String name;
    private String sort;
    private String prompt;
    private String tip;
    private String prompt_pc;
    private String copy_prompt;
    private String type;
    private String recharge_alarm;   //充值提示
    private String bankPayPrompt;   //银行提示
    private List<ChannelBean> channel;
    private List<String> quickAmount;

    @Override
    public String toString() {
        return "PaymentBean{" +
                "id='" + id + '\'' +
                ", code='" + code + '\'' +
                ", name='" + name + '\'' +
                ", sort='" + sort + '\'' +
                ", prompt='" + prompt + '\'' +
                ", tip='" + tip + '\'' +
                ", prompt_pc='" + prompt_pc + '\'' +
                ", copy_prompt='" + copy_prompt + '\'' +
                ", channel=" + channel +
                ", quickAmount=" + quickAmount +
                '}';
    }

    public String getRecharge_alarm() {
        return recharge_alarm;
    }

    public void setRecharge_alarm(String recharge_alarm) {
        this.recharge_alarm = recharge_alarm;
    }

    public String getBankPayPrompt() {
        return bankPayPrompt;
    }

    public void setBankPayPrompt(String bankPayPrompt) {
        this.bankPayPrompt = bankPayPrompt;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public List<String> getQuickAmount() {
        return quickAmount;
    }

    public void setQuickAmount(List<String> quickAmount) {
        this.quickAmount = quickAmount;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getSort() {
        return sort;
    }

    public void setSort(String sort) {
        this.sort = sort;
    }

    public String getPrompt() {
        return prompt;
    }

    public void setPrompt(String prompt) {
        this.prompt = prompt;
    }

    public String getTip() {
        return tip;
    }

    public void setTip(String tip) {
        this.tip = tip;
    }

    public String getPrompt_pc() {
        return prompt_pc;
    }

    public void setPrompt_pc(String prompt_pc) {
        this.prompt_pc = prompt_pc;
    }

    public String getCopy_prompt() {
        return copy_prompt;
    }

    public void setCopy_prompt(String copy_prompt) {
        this.copy_prompt = copy_prompt;
    }

    public List<ChannelBean> getChannel() {
        return channel;
    }

    public void setChannel(List<ChannelBean> channel) {
        this.channel = channel;
    }

    public static class ChannelBean implements Serializable {
        /**
         * id : 4
         * account :
         * payeeName : 支付宝扫码（AY） 单笔500-5000 任意金额支付,成功率高,欢迎使用
         * qrcode :
         * domain :
         * address : 支付宝（安亿支付）
         * name : 支付宝（安亿支付）
         * onlineType : 6
         * rechType : onlinePayment
         * para : {"bankList":null,"fixedAmount":""}
         */

        private String id;
        private String account;
        private String payeeName;
        private String qrcode;
        private String domain;
        private String address;
        private String name;
        private String onlineType;
        private String rechType;
        private String branchAddress;
        private ParaBean para;
        boolean isSelect;

        @Override
        public String toString() {
            return "ChannelBean{" +
                    "id='" + id + '\'' +
                    ", account='" + account + '\'' +
                    ", payeeName='" + payeeName + '\'' +
                    ", qrcode='" + qrcode + '\'' +
                    ", domain='" + domain + '\'' +
                    ", address='" + address + '\'' +
                    ", name='" + name + '\'' +
                    ", onlineType='" + onlineType + '\'' +
                    ", rechType='" + rechType + '\'' +
                    ", para=" + para +
                    '}';
        }

        public String getBranchAddress() {
            return branchAddress;
        }

        public void setBranchAddress(String branchAddress) {
            this.branchAddress = branchAddress;
        }

        public boolean isSelect() {
            return isSelect;
        }

        public void setSelect(boolean select) {
            isSelect = select;
        }

        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }

        public String getAccount() {
            return account;
        }

        public void setAccount(String account) {
            this.account = account;
        }

        public String getPayeeName() {
            return payeeName;
        }

        public void setPayeeName(String payeeName) {
            this.payeeName = payeeName;
        }

        public String getQrcode() {
            return qrcode;
        }

        public void setQrcode(String qrcode) {
            this.qrcode = qrcode;
        }

        public String getDomain() {
            return domain;
        }

        public void setDomain(String domain) {
            this.domain = domain;
        }

        public String getAddress() {
            return address;
        }

        public void setAddress(String address) {
            this.address = address;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getOnlineType() {
            return onlineType;
        }

        public void setOnlineType(String onlineType) {
            this.onlineType = onlineType;
        }

        public String getRechType() {
            return rechType;
        }

        public void setRechType(String rechType) {
            this.rechType = rechType;
        }

        public ParaBean getPara() {
            return para;
        }

        public void setPara(ParaBean para) {
            this.para = para;
        }

        public static class ParaBean implements Serializable{
            /**
             * bankList : null
             * fixedAmount :
             */

            private String fixedAmount;
            private List<BankListBean> bankList;

            public List<BankListBean> getBankList() {
                return bankList;
            }

            public void setBankList(List<BankListBean> bankList) {
                this.bankList = bankList;
            }

            public static class BankListBean implements Serializable {
                private String code;
                private String name;
                boolean isSelect;
                @Override
                public String toString() {
                    return "BankListBean{" +
                            "code='" + code + '\'' +
                            ", name='" + name + '\'' +
                            '}';
                }

                public boolean isSelect() {
                    return isSelect;
                }

                public void setSelect(boolean select) {
                    isSelect = select;
                }

                public String getCode() {
                    return code;
                }

                public void setCode(String code) {
                    this.code = code;
                }

                public String getName() {
                    return name;
                }

                public void setName(String name) {
                    this.name = name;
                }
            }
            public String getFixedAmount() {
                return fixedAmount;
            }

            public void setFixedAmount(String fixedAmount) {
                this.fixedAmount = fixedAmount;
            }
        }
    }
}

