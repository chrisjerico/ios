package com.phoenix.lotterys.my.bean;

import java.util.List;

/**
 * Greated by Luke
 * on 2019/8/27
 */
public class PayAisleBean {

    /**
     * code : 0
     * msg : 支付通道获取成功
     * data : {"payment":[{"id":"alipay_online","code":"6","name":"支付宝在线支付","sort":"1","prompt":"输入金额或快捷按钮后点开始充值，系统自动跳转生成收款二维码需耐心等待几秒，系统跳转的时候请不要退出，感谢您的支持！[如交易失败，请重试或使用其他通道]","tip":"支付宝在线支付","prompt_pc":"输入金额或选择快捷按钮后点开始充值，系统自动跳转生成收款二维码需耐心等待几秒，系统跳转的时候请不要退出，感谢您的支持！（如交易失败，请重试或使用其他通道）","copy_prompt":"浏览器不支持复制,点击\u201c复制\u201d后请使用Ctrl+C或者鼠标右键菜单 ","channel":[{"id":"4","account":"","payeeName":"支付宝扫码（AY） 单笔500-5000 任意金额支付,成功率高,欢迎使用","qrcode":"","domain":"","address":"支付宝（安亿支付）","name":"支付宝（安亿支付）","onlineType":"6","rechType":"onlinePayment","para":{"bankList":null,"fixedAmount":""}},{"id":"15","account":"","payeeName":"支付宝扫码（XF）100-5000，整百金额支付，支持花呗。信用卡支付，","qrcode":"","domain":"","address":"支付宝（鑫发支付）","name":"支付宝（鑫发支付）","onlineType":"6","rechType":"onlinePayment","para":{"bankList":null,"fixedAmount":""}},{"id":"28","account":"","payeeName":"支付宝Wap原生(AY)单笔200-5000固定金额支付,支持信用卡花呗付款,等待10秒,成功率高","qrcode":"","domain":"","address":"支付宝（安亿支付原生通道）","name":"支付宝（安亿支付原生通道）","onlineType":"6","rechType":"onlinePayment","para":{"bankList":null,"fixedAmount":"200 500 1000 2000 3000 5000"}},{"id":"32","account":"","payeeName":"支付宝Wap(H)10-100固定金额.支持信用卡.花呗,成功率稳定","qrcode":"","domain":"","address":"支付宝（恒润）","name":"支付宝（恒润）","onlineType":"6","rechType":"onlinePayment","para":{"bankList":null,"fixedAmount":"10 20 30 50 100"}},{"id":"37","account":"","payeeName":"支付宝wap（JF）固定金额支付，信用卡，花呗付款","qrcode":"","domain":"","address":"支付宝（金发支付）","name":"支付宝（金发支付）","onlineType":"6","rechType":"onlinePayment","para":{"bankList":null,"fixedAmount":"1000 2000 3000 5000 8000"}},{"id":"49","account":"","payeeName":"支付宝扫码（L）固金额支付，,欢迎使用","qrcode":"","domain":"","address":"支付宝（隆发支付测试6）","name":"支付宝（隆发支付测试6）","onlineType":"6","rechType":"onlinePayment","para":{"bankList":null,"fixedAmount":"200 300 500 600 800 900 1000 1300 1400 1500 1600 1700 1800 2000 2500 3000 3500 4000"}},{"id":"52","account":"","payeeName":"支付宝转卡(ZF)单笔20-9900！个位数必须为5,列:115.225.335.欢迎使用","qrcode":"","domain":"","address":"支付宝（支付通2.0）","name":"支付宝（支付通2.0）","onlineType":"6","rechType":"onlinePayment","para":{"bankList":null,"fixedAmount":""}},{"id":"59","account":"","payeeName":"支付Wap(BF)50-100金额成功率高,欢迎使用","qrcode":"","domain":"","address":"支付宝（佰富支付内测）","name":"支付宝（佰富支付内测）","onlineType":"6","rechType":"onlinePayment","para":{"bankList":null,"fixedAmount":"50 100"}},{"id":"63","account":"","payeeName":"支付宝扫码(GT)单笔100-10000","qrcode":"","domain":"","address":"支付宝（高通）","name":"支付宝（高通）","onlineType":"6","rechType":"onlinePayment","para":{"bankList":null,"fixedAmount":""}},{"id":"67","account":"","payeeName":"支付宝Wap(ZF)单笔20-3000,首次充值需绑卡，支付密码填银行卡取款密码,成功率高","qrcode":"","domain":"","address":"支付宝（支付通2.0）","name":"支付宝（支付通2.0）","onlineType":"6","rechType":"onlinePayment","para":{"bankList":null,"fixedAmount":""}},{"id":"76","account":"","payeeName":"支付宝扫码（GS）单笔200\u20143000支持信用卡.花呗单笔小额,成功率稳定","qrcode":"","domain":"","address":"支付宝（高盛支付）","name":"支付宝（高盛支付）","onlineType":"6","rechType":"onlinePayment","para":{"bankList":null,"fixedAmount":""}},{"id":"87","account":"","payeeName":"支付宝wap(XF)金额100-5000PDD整百金额，成功率稳定75+","qrcode":"","domain":"","address":"支付宝（鑫发支付）","name":"支付宝（鑫发支付）","onlineType":"6","rechType":"onlinePayment","para":{"bankList":null,"fixedAmount":""}},{"id":"92","account":"","payeeName":"支付宝Wap(GT)单笔100-10000","qrcode":"","domain":"","address":"支付宝（高通）","name":"支付宝（高通）","onlineType":"6","rechType":"onlinePayment","para":{"bankList":null,"fixedAmount":""}},{"id":"93","account":"","payeeName":"支付宝扫码(H)101-5000固定金额.支持信用卡.花呗,成功率稳定","qrcode":"","domain":"","address":"支付宝（恒润）","name":"支付宝（恒润）","onlineType":"6","rechType":"onlinePayment","para":{"bankList":null,"fixedAmount":""}},{"id":"94","account":"","payeeName":"支付宝wap(GS)200-3000PDD整百支付首次充值需绑卡,支付密码填写银行卡取款密码","qrcode":"","domain":"","address":"支付宝（高盛支付）","name":"支付宝（高盛支付）","onlineType":"6","rechType":"onlinePayment","para":{"bankList":null,"fixedAmount":"200 300 500 1000 1500 2000 3000"}},{"id":"96","account":"","payeeName":"支付宝wap(GS)10-5000","qrcode":"","domain":"","address":"支付宝（高盛支付）","name":"支付宝（高盛支付）","onlineType":"6","rechType":"onlinePayment","para":{"bankList":null,"fixedAmount":"10  20  50 100 200 500 1000 2000  5000"}}]},{"id":"wechat_online","code":"7","name":"微信扫码","sort":"2","prompt":"输入金额或快捷按钮后点开始充值，系统自动跳转生成收款二维码需耐心等待几秒，系统跳转的时候请不要退出，感谢您的支持！[如交易失败，请重试或使用其他通道]","tip":"仅支持固定金额支付","prompt_pc":"输入金额或选择快捷按钮后点开始充值，系统自动跳转生成收款二维码需耐心等待几秒，系统跳转的时候请不要退出，感谢您的支持！（如交易失败，请重试或使用其他通道）","copy_prompt":"浏览器不支持复制,点击\u201c复制\u201d后请使用Ctrl+C或者鼠标右键菜单 ","channel":[{"id":"7","account":"","payeeName":"微信wap(AY)PDD200-4000","qrcode":"","domain":"","address":"微信（安亿支付）","name":"微信（安亿支付）","onlineType":"7","rechType":"onlinePayment","para":{"bankList":null,"fixedAmount":"200 300  500  1000 2000 4000"}},{"id":"16","account":"","payeeName":"微信扫码(XF)单笔最低200-3000，任意金额","qrcode":"","domain":"","address":"微信（鑫发支付）","name":"微信（鑫发支付）","onlineType":"7","rechType":"onlinePayment","para":{"bankList":null,"fixedAmount":""}},{"id":"27","account":"","payeeName":"微信(YLT)单笔最低100最高2000","qrcode":"","domain":"","address":"微信（娱乐通）","name":"微信（娱乐通）","onlineType":"7","rechType":"onlinePayment","para":{"bankList":null,"fixedAmount":"100 200 300 500 1000 1500 2000"}},{"id":"33","account":"","payeeName":"微信扫码（H）200-3000金额支付","qrcode":"","domain":"","address":"微信（恒润）","name":"微信（恒润）","onlineType":"7","rechType":"onlinePayment","para":{"bankList":null,"fixedAmount":""}},{"id":"43","account":"","payeeName":"微信扫码（GT）单笔200-3000，成功率高。欢迎使用","qrcode":"","domain":"","address":"微信（高通）","name":"微信（高通）","onlineType":"7","rechType":"onlinePayment","para":{"bankList":null,"fixedAmount":""}},{"id":"50","account":"","payeeName":"微信wap（L）固定金额支付","qrcode":"","domain":"","address":"微信（隆发支付测试6）","name":"微信（隆发支付测试6）","onlineType":"7","rechType":"onlinePayment","para":{"bankList":null,"fixedAmount":"300 400 500 600 1000 1100 1200 1300 1500 1600 1700 2000 2500 3000 3500 4000"}},{"id":"51","account":"","payeeName":"微信wap（XF）固定金额支付10-100","qrcode":"","domain":"","address":"微信（鑫发支付）","name":"微信（鑫发支付）","onlineType":"7","rechType":"onlinePayment","para":{"bankList":null,"fixedAmount":"10 20 30 50 100"}},{"id":"60","account":"","payeeName":"微信Wap(BF)单笔10-2500整百金额支付.欢迎使用","qrcode":"","domain":"","address":"微信（佰富支付测试）","name":"微信（佰富支付测试）","onlineType":"7","rechType":"onlinePayment","para":{"bankList":null,"fixedAmount":""}},{"id":"61","account":"","payeeName":"微信扫码(BF),单笔10-2500任意金额绑卡支付,欢迎使用","qrcode":"","domain":"","address":"微信（佰富支付测试）","name":"微信（佰富支付测试）","onlineType":"7","rechType":"onlinePayment","para":{"bankList":null,"fixedAmount":""}},{"id":"66","account":"","payeeName":"微信支付(ZF) 单笔20-3000,首次绑卡充值,成功率高,欢迎使用","qrcode":"","domain":"","address":"微信（支付通2.0）","name":"微信（支付通2.0）","onlineType":"7","rechType":"onlinePayment","para":{"bankList":null,"fixedAmount":""}},{"id":"77","account":"","payeeName":"微信扫码(GS)单笔200-3000 成功率高欢迎使用","qrcode":"","domain":"","address":"微信（高盛支付）","name":"微信（高盛支付）","onlineType":"7","rechType":"onlinePayment","para":{"bankList":null,"fixedAmount":""}},{"id":"83","account":"","payeeName":"微信WAP(GS) PDD固定金额20-3000支付 .欢迎使用","qrcode":"","domain":"","address":"微信（高盛支付）","name":"微信（高盛支付）","onlineType":"7","rechType":"onlinePayment","para":{"bankList":null,"fixedAmount":"20  50 100 200 300 500 1000 2000 3000"}},{"id":"90","account":"","payeeName":"微信扫码（AY）固定金额支付","qrcode":"","domain":"","address":"微信（安亿支付）","name":"微信（安亿支付）","onlineType":"7","rechType":"onlinePayment","para":{"bankList":null,"fixedAmount":"300  500 1000 1500 2000 3000 5000"}},{"id":"91","account":"","payeeName":"微信WAP(GT)单笔200-3000，成功率高。欢迎使用","qrcode":"","domain":"","address":"微信（高通）","name":"微信（高通）","onlineType":"7","rechType":"onlinePayment","para":{"bankList":null,"fixedAmount":""}}]},{"id":"bank_transfer","code":"5","name":"银行转账[成功率100%]\t","sort":"3","prompt":"最低金额100,最高金额500000 ，公司入款账户不定时更新。请您及时删除银行保存的转账记录，以避免资金损失，入款请以平台更新卡号为主。误入停用账户资金将由您个人承担","tip":"银行转账[成功率100%]\t","prompt_pc":"最低金额100,最高金额500000， 公司入款账户不定时更新。请您及时删除银行保存的转账记录，以避免资金损失，入款请以平台更新卡号为主。误入停用账户资金将由您个人承担","copy_prompt":"浏览器不支持复制,点击\u201c复制\u201d后请使用Ctrl+C或者鼠标右键菜单","channel":[{"id":"1","account":"220836654876","payeeName":"网银、手机银行转账","qrcode":"中国银行股份有限公司菏泽市北支行","domain":"菏泽铭组电子科技有限公司","address":"中国银行","name":"","onlineType":"5","rechType":"onlinePayment","para":{"bankList":null,"fixedAmount":null}},{"id":"98","account":"2333333333333333","payeeName":"支付宝转账","qrcode":"用户","domain":"呼呼呼","address":"用户","name":"","onlineType":"5","rechType":"onlinePayment","para":{"bankList":null,"fixedAmount":null}}]},{"id":"bank_online","code":"2","name":"网银在线支付","sort":"4","prompt":"尊敬的会员为确保支付成功率，建议金额不要为10的整数倍！单笔最低10.最高20000","tip":"支持多家银行，转账更便捷","prompt_pc":"尊敬的会员为确保支付成功率，建议金额不要为10的整数倍！单笔最低10.最高20000","copy_prompt":"浏览器不支持复制,点击\u201c复制\u201d后请使用Ctrl+C或者鼠标右键菜单","channel":[{"id":"57","account":"","payeeName":"网银支付(AY)单笔100-50000欢迎使用","qrcode":"","domain":"","address":"网银（安亿支付）","name":"网银（安亿支付）","onlineType":"2","rechType":"onlinePayment","para":{"bankList":[{"code":"3002","name":"工商银行"},{"code":"3003","name":"建设银行"},{"code":"3005","name":"农业银行"},{"code":"3006","name":"民生银行"},{"code":"3022","name":"光大银行"},{"code":"3032","name":"北京银行"},{"code":"3038","name":"中国邮政储蓄"}],"fixedAmount":""}}]},{"id":"alipay_transfer","code":"16","name":"支付宝转账[成功率100%]\t","sort":"5","prompt":"最低100-500000，公司入款账户不定时更新。请您及时删除银行保存的转账记录，以避免资金损失，入款请以平台更新卡号为主。误入停用账户资金将由您个人承担","tip":"支付宝转账[成功率100%]","prompt_pc":"最低100-500000，公司入款账户不定时更新。请您及时删除银行保存的转账记录，以避免资金损失，入款请以平台更新卡号为主。误入停用账户资金将由您个人承担","copy_prompt":"浏览器不支持复制,点击\u201c复制\u201d后请使用Ctrl+C或者鼠标右键菜单 ","channel":[{"id":"2","account":"6232513322412353","payeeName":"支付宝转账","qrcode":"广州羊城花园支行 ","domain":"广州核余建材部","address":"建设银行","name":"","onlineType":"16","rechType":"onlinePayment","para":{"bankList":null,"fixedAmount":null}}]},{"id":"tenpay_transfer","code":"3","name":"财付通转账","sort":"6","prompt":"尊敬的会员为确保支付成功率，建议金额不要为10的整数倍！最低金额1,最高金额500000 ","tip":"财付通转账支付","prompt_pc":"尊敬的会员为确保支付成功率，建议金额不要为10的整数倍！最低金额1,最高金额500000 ","copy_prompt":"浏览器不支持复制,点击\u201c复制\u201d后请使用Ctrl+C或者鼠标右键菜单 ","channel":[]},{"id":"wechat_transfer","code":"4","name":"微信转账[成功率100%]\t","sort":"6","prompt":"尊敬的会员为确保支付成功率，提交时请填写微信到账成功时间,否则不到账","tip":"微信转账[成功率100%]\t","prompt_pc":"尊敬的会员为确保支付成功率，提交时请填写微信到账成功时间,否则不到账","copy_prompt":"浏览器不支持复制,点击\u201c复制\u201d后请使用Ctrl+C或者鼠标右键菜单 ","channel":[{"id":"84","account":"6232513322412353","payeeName":"微信转账(必须填写到账时间)","qrcode":"广州羊城花园支行 ","domain":"广州核余建材部","address":"建设银行","name":"","onlineType":"4","rechType":"onlinePayment","para":{"bankList":null,"fixedAmount":null}}]},{"id":"tenpay_online","code":"12","name":"银联快捷支付[成功率100%]","sort":"7","prompt":"尊敬的会员为确保支付成功率，建议金额不要为10的整数倍！最低金额1,最高金额500000 ","tip":"云闪付在线支付","prompt_pc":"尊敬的会员为确保支付成功率，建议金额不要为10的整数倍！最低金额1,最高金额500000 ","copy_prompt":"浏览器不支持复制,点击\u201c复制\u201d后请使用Ctrl+C或者鼠标右键菜单 ","channel":[{"id":"72","account":"","payeeName":"快捷支付（ZFT）单笔最低100-5000,绑卡支付.不行的换卡支付","qrcode":"","domain":"","address":"云闪付（支付通2.0）","name":"云闪付（支付通2.0）","onlineType":"12","rechType":"onlinePayment","para":{"bankList":null,"fixedAmount":""}},{"id":"89","account":"","payeeName":"云闪付扫码(YLT)单笔100-5000成功率高推荐使用","qrcode":"","domain":"","address":"云闪付（娱乐通）","name":"云闪付（娱乐通）","onlineType":"12","rechType":"onlinePayment","para":{"bankList":null,"fixedAmount":""}}]},{"id":"qq_online","code":"14","name":"QQ钱包在线支付","sort":"8","prompt":"尊敬的会员为确保支付成功率，建议金额不要为10的整数倍！最低金额10,最高金额1000","tip":"QQ钱包在线支付","prompt_pc":"尊敬的会员为确保支付成功率，建议金额不要为10的整数倍！最低金额10,最高金额1000","copy_prompt":"浏览器不支持复制,点击\u201c复制\u201d后请使用Ctrl+C或者鼠标右键菜单 ","channel":[{"id":"44","account":"","payeeName":"QQ钱包（XF）单笔限额10-1000","qrcode":"","domain":"","address":"QQ钱包（鑫发支付）","name":"QQ钱包（鑫发支付）","onlineType":"14","rechType":"onlinePayment","para":{"bankList":null,"fixedAmount":""}},{"id":"45","account":"","payeeName":"QQ扫码（H）单笔限额10-1000","qrcode":"","domain":"","address":"QQ钱包（恒润）","name":"QQ钱包（恒润）","onlineType":"14","rechType":"onlinePayment","para":{"bankList":null,"fixedAmount":""}}]},{"id":"baidu_online","code":"17","name":"百度钱包在线支付","sort":"9","prompt":"尊敬的会员为确保支付成功率，建议金额不要为10的整数倍！最低金额1,最高金额500000 ","tip":"百度钱包在线支付","prompt_pc":"尊敬的会员为确保支付成功率，建议金额不要为10的整数倍！最低金额1,最高金额500000 ","copy_prompt":"浏览器不支持复制,点击\u201c复制\u201d后请使用Ctrl+C或者鼠标右键菜单 ","channel":[]},{"id":"jingdong_online","code":"18","name":"支付宝扫码转账","sort":"10","prompt":"尊敬的会员单笔最低金额50,最高金额50000 （用浏览器扫码无需等待直接支付。支付宝扫码需等待60秒。）","tip":"支付宝扫码转账","prompt_pc":"尊敬的会员单笔最低金额50,最高金额50000 （用浏览器扫码无需等待直接支付。支付宝扫码需等待60秒。）","copy_prompt":"浏览器不支持复制,点击\u201c复制\u201d后请使用Ctrl+C或者鼠标右键菜单 ","channel":[]},{"id":"yinlian_online","code":"19","name":"银联钱包在线支付[仅支持云闪付和手机银行扫码]","sort":"11","prompt":"尊敬的会员为确保支付成功率，建议金额不要为10的整数倍！最低金额10,最高金额4995","tip":"银联钱包在线支付[仅支持云闪付和手机银行扫码]","prompt_pc":"尊敬的会员为确保支付成功率，建议金额不要为10的整数倍！最低金额10,最高金额4995","copy_prompt":"浏览器不支持复制,点击\u201c复制\u201d后请使用Ctrl+C或者鼠标右键菜单 ","channel":[{"id":"6","account":"","payeeName":"银联扫码（AY）单笔100-4500，任意银行APP扫码支付","qrcode":"","domain":"","address":"银联扫码（安亿支付）","name":"银联扫码（安亿支付）","onlineType":"19","rechType":"onlinePayment","para":{"bankList":"[{\"code\":\"3001\",\"name\":\"招商银行\"},{\"code\":\"3002\",\"name\":\"工商银行\"},{\"code\":\"3003\",\"name\":\"建设银行\"},{\"code\":\"3004\",\"name\":\"浦发银行\"},{\"code\":\"3005\",\"name\":\"农业银行\"},{\"code\":\"3006\",\"name\":\"民生银行\"},{\"code\":\"3009\",\"name\":\"兴业银行\"},{\"code\":\"3020\",\"name\":\"交通银行\"},{\"code\":\"3022\",\"name\":\"光大银行\"},{\"code\":\"3026\",\"name\":\"中国银行\"},{\"code\":\"3032\",\"name\":\"北京银行\"},{\"code\":\"3035\",\"name\":\"平安银行\"},{\"code\":\"3036\",\"name\":\"广发银行\"},{\"code\":\"3037\",\"name\":\"上海农商银行\"},{\"code\":\"3038\",\"name\":\"中国邮政储蓄\"},{\"code\":\"3039\",\"name\":\"中信银行\"}]","fixedAmount":""}},{"id":"17","account":"","payeeName":"银联扫码（XF）单笔10-1000","qrcode":"","domain":"","address":"银联钱包（鑫发支付）","name":"银联钱包（鑫发支付）","onlineType":"19","rechType":"onlinePayment","para":{"bankList":"[{\"code\":\"3001\",\"name\":\"招商银行\"},{\"code\":\"3002\",\"name\":\"工商银行\"},{\"code\":\"3003\",\"name\":\"建设银行\"},{\"code\":\"3004\",\"name\":\"浦发银行\"},{\"code\":\"3005\",\"name\":\"农业银行\"},{\"code\":\"3006\",\"name\":\"民生银行\"},{\"code\":\"3009\",\"name\":\"兴业银行\"},{\"code\":\"3020\",\"name\":\"交通银行\"},{\"code\":\"3022\",\"name\":\"光大银行\"},{\"code\":\"3026\",\"name\":\"中国银行\"},{\"code\":\"3032\",\"name\":\"北京银行\"},{\"code\":\"3035\",\"name\":\"平安银行\"},{\"code\":\"3036\",\"name\":\"广发银行\"},{\"code\":\"3037\",\"name\":\"上海农商银行\"},{\"code\":\"3038\",\"name\":\"中国邮政储蓄\"},{\"code\":\"3039\",\"name\":\"中信银行\"}]","fixedAmount":""}},{"id":"34","account":"","payeeName":"银联扫码（H）单笔151-4500","qrcode":"","domain":"","address":"银联钱包（恒润）","name":"银联钱包（恒润）","onlineType":"19","rechType":"onlinePayment","para":{"bankList":"[{\"code\":\"3001\",\"name\":\"招商银行\"},{\"code\":\"3002\",\"name\":\"工商银行\"},{\"code\":\"3003\",\"name\":\"建设银行\"},{\"code\":\"3004\",\"name\":\"浦发银行\"},{\"code\":\"3005\",\"name\":\"农业银行\"},{\"code\":\"3006\",\"name\":\"民生银行\"},{\"code\":\"3009\",\"name\":\"兴业银行\"},{\"code\":\"3020\",\"name\":\"交通银行\"},{\"code\":\"3022\",\"name\":\"光大银行\"},{\"code\":\"3026\",\"name\":\"中国银行\"},{\"code\":\"3032\",\"name\":\"北京银行\"},{\"code\":\"3035\",\"name\":\"平安银行\"},{\"code\":\"3036\",\"name\":\"广发银行\"},{\"code\":\"3037\",\"name\":\"上海农商银行\"},{\"code\":\"3038\",\"name\":\"中国邮政储蓄\"},{\"code\":\"3039\",\"name\":\"中信银行\"}]","fixedAmount":""}},{"id":"54","account":"","payeeName":"银联扫码（L）单笔100-1000，支持所有银行","qrcode":"","domain":"","address":"银联钱包（隆发支付测试6）","name":"银联钱包（隆发支付测试6）","onlineType":"19","rechType":"onlinePayment","para":{"bankList":"[{\"code\":\"3001\",\"name\":\"招商银行\"},{\"code\":\"3002\",\"name\":\"工商银行\"},{\"code\":\"3003\",\"name\":\"建设银行\"},{\"code\":\"3004\",\"name\":\"浦发银行\"},{\"code\":\"3005\",\"name\":\"农业银行\"},{\"code\":\"3006\",\"name\":\"民生银行\"},{\"code\":\"3009\",\"name\":\"兴业银行\"},{\"code\":\"3020\",\"name\":\"交通银行\"},{\"code\":\"3022\",\"name\":\"光大银行\"},{\"code\":\"3026\",\"name\":\"中国银行\"},{\"code\":\"3032\",\"name\":\"北京银行\"},{\"code\":\"3035\",\"name\":\"平安银行\"},{\"code\":\"3036\",\"name\":\"广发银行\"},{\"code\":\"3037\",\"name\":\"上海农商银行\"},{\"code\":\"3038\",\"name\":\"中国邮政储蓄\"},{\"code\":\"3039\",\"name\":\"中信银行\"}]","fixedAmount":""}},{"id":"62","account":"","payeeName":"银联扫码(BF)单笔151-1000,云闪付 扫码支付","qrcode":"","domain":"","address":"银联钱包（佰富支付）","name":"银联钱包（佰富支付）","onlineType":"19","rechType":"onlinePayment","para":{"bankList":"[{\"code\":\"3001\",\"name\":\"招商银行\"},{\"code\":\"3002\",\"name\":\"工商银行\"},{\"code\":\"3003\",\"name\":\"建设银行\"},{\"code\":\"3004\",\"name\":\"浦发银行\"},{\"code\":\"3005\",\"name\":\"农业银行\"},{\"code\":\"3006\",\"name\":\"民生银行\"},{\"code\":\"3009\",\"name\":\"兴业银行\"},{\"code\":\"3020\",\"name\":\"交通银行\"},{\"code\":\"3022\",\"name\":\"光大银行\"},{\"code\":\"3026\",\"name\":\"中国银行\"},{\"code\":\"3032\",\"name\":\"北京银行\"},{\"code\":\"3035\",\"name\":\"平安银行\"},{\"code\":\"3036\",\"name\":\"广发银行\"},{\"code\":\"3037\",\"name\":\"上海农商银行\"},{\"code\":\"3038\",\"name\":\"中国邮政储蓄\"},{\"code\":\"3039\",\"name\":\"中信银行\"}]","fixedAmount":""}},{"id":"64","account":"","payeeName":"银联扫码(GT)单笔151-4500,云闪付,手机银行app扫码支付,不要整百支付.成功率高","qrcode":"","domain":"","address":"银联钱包（高通）","name":"银联钱包（高通）","onlineType":"19","rechType":"onlinePayment","para":{"bankList":"[{\"code\":\"3001\",\"name\":\"招商银行\"},{\"code\":\"3002\",\"name\":\"工商银行\"},{\"code\":\"3003\",\"name\":\"建设银行\"},{\"code\":\"3004\",\"name\":\"浦发银行\"},{\"code\":\"3005\",\"name\":\"农业银行\"},{\"code\":\"3006\",\"name\":\"民生银行\"},{\"code\":\"3009\",\"name\":\"兴业银行\"},{\"code\":\"3020\",\"name\":\"交通银行\"},{\"code\":\"3022\",\"name\":\"光大银行\"},{\"code\":\"3026\",\"name\":\"中国银行\"},{\"code\":\"3032\",\"name\":\"北京银行\"},{\"code\":\"3035\",\"name\":\"平安银行\"},{\"code\":\"3036\",\"name\":\"广发银行\"},{\"code\":\"3037\",\"name\":\"上海农商银行\"},{\"code\":\"3038\",\"name\":\"中国邮政储蓄\"},{\"code\":\"3039\",\"name\":\"中信银行\"}]","fixedAmount":""}},{"id":"68","account":"","payeeName":"银联扫码（ZF）单笔20-4500,手机银行APP\"或者\"云闪付APP\"扫码支付欢迎使用","qrcode":"","domain":"","address":"银联钱包（支付通2.0）","name":"银联钱包（支付通2.0）","onlineType":"19","rechType":"onlinePayment","para":{"bankList":"[{\"code\":\"3001\",\"name\":\"招商银行\"},{\"code\":\"3002\",\"name\":\"工商银行\"},{\"code\":\"3003\",\"name\":\"建设银行\"},{\"code\":\"3004\",\"name\":\"浦发银行\"},{\"code\":\"3005\",\"name\":\"农业银行\"},{\"code\":\"3006\",\"name\":\"民生银行\"},{\"code\":\"3009\",\"name\":\"兴业银行\"},{\"code\":\"3020\",\"name\":\"交通银行\"},{\"code\":\"3022\",\"name\":\"光大银行\"},{\"code\":\"3026\",\"name\":\"中国银行\"},{\"code\":\"3032\",\"name\":\"北京银行\"},{\"code\":\"3035\",\"name\":\"平安银行\"},{\"code\":\"3036\",\"name\":\"广发银行\"},{\"code\":\"3037\",\"name\":\"上海农商银行\"},{\"code\":\"3038\",\"name\":\"中国邮政储蓄\"},{\"code\":\"3039\",\"name\":\"中信银行\"}]","fixedAmount":""}}]},{"id":"quick_online","code":"8","name":"银联快捷支付[成功率100%]","sort":"12","prompt":"尊敬的会员此通道无需选择银行。直接点开始充值，输入卡号即可支付。简单快捷。两步搞定。欢迎使用","tip":"快捷支付[成功率100%]支持多家银行，转账更快捷","prompt_pc":"尊敬的会员此通道无需选择银行。直接点开始充值，输入卡号即可支付。简单快捷。两步搞定。欢迎使用","copy_prompt":"浏览器不支持复制,点击\u201c复制\u201d后请使用Ctrl+C或者鼠标右键菜单 ","channel":[{"id":"5","account":"","payeeName":"快捷支付（AY）单笔100-3000,欢迎使用","qrcode":"","domain":"","address":"快捷支付（安亿支付）","name":"快捷支付（安亿支付）","onlineType":"8","rechType":"onlinePayment","para":{"bankList":"[{\"code\":\"3001\",\"name\":\"招商银行\"},{\"code\":\"3002\",\"name\":\"工商银行\"},{\"code\":\"3003\",\"name\":\"建设银行\"},{\"code\":\"3004\",\"name\":\"浦发银行\"},{\"code\":\"3005\",\"name\":\"农业银行\"},{\"code\":\"3006\",\"name\":\"民生银行\"},{\"code\":\"3009\",\"name\":\"兴业银行\"},{\"code\":\"3020\",\"name\":\"交通银行\"},{\"code\":\"3022\",\"name\":\"光大银行\"},{\"code\":\"3026\",\"name\":\"中国银行\"},{\"code\":\"3032\",\"name\":\"北京银行\"},{\"code\":\"3035\",\"name\":\"平安银行\"},{\"code\":\"3036\",\"name\":\"广发银行\"},{\"code\":\"3037\",\"name\":\"上海农商银行\"},{\"code\":\"3038\",\"name\":\"中国邮政储蓄\"},{\"code\":\"3039\",\"name\":\"中信银行\"}]","fixedAmount":""}},{"id":"23","account":"","payeeName":"银联快捷（GT）单笔最低100-5000","qrcode":"","domain":"","address":"快捷支付（高通测试）","name":"快捷支付（高通测试）","onlineType":"8","rechType":"onlinePayment","para":{"bankList":"[{\"code\":\"3001\",\"name\":\"招商银行\"},{\"code\":\"3002\",\"name\":\"工商银行\"},{\"code\":\"3003\",\"name\":\"建设银行\"},{\"code\":\"3004\",\"name\":\"浦发银行\"},{\"code\":\"3005\",\"name\":\"农业银行\"},{\"code\":\"3006\",\"name\":\"民生银行\"},{\"code\":\"3009\",\"name\":\"兴业银行\"},{\"code\":\"3020\",\"name\":\"交通银行\"},{\"code\":\"3022\",\"name\":\"光大银行\"},{\"code\":\"3026\",\"name\":\"中国银行\"},{\"code\":\"3032\",\"name\":\"北京银行\"},{\"code\":\"3035\",\"name\":\"平安银行\"},{\"code\":\"3036\",\"name\":\"广发银行\"},{\"code\":\"3037\",\"name\":\"上海农商银行\"},{\"code\":\"3038\",\"name\":\"中国邮政储蓄\"},{\"code\":\"3039\",\"name\":\"中信银行\"}]","fixedAmount":""}},{"id":"53","account":"","payeeName":"快捷支付（L）单笔100-3000","qrcode":"","domain":"","address":"快捷支付（隆发支付测试6）","name":"快捷支付（隆发支付测试6）","onlineType":"8","rechType":"onlinePayment","para":{"bankList":"[{\"code\":\"3001\",\"name\":\"招商银行\"},{\"code\":\"3002\",\"name\":\"工商银行\"},{\"code\":\"3003\",\"name\":\"建设银行\"},{\"code\":\"3004\",\"name\":\"浦发银行\"},{\"code\":\"3005\",\"name\":\"农业银行\"},{\"code\":\"3006\",\"name\":\"民生银行\"},{\"code\":\"3009\",\"name\":\"兴业银行\"},{\"code\":\"3020\",\"name\":\"交通银行\"},{\"code\":\"3022\",\"name\":\"光大银行\"},{\"code\":\"3026\",\"name\":\"中国银行\"},{\"code\":\"3032\",\"name\":\"北京银行\"},{\"code\":\"3035\",\"name\":\"平安银行\"},{\"code\":\"3036\",\"name\":\"广发银行\"},{\"code\":\"3037\",\"name\":\"上海农商银行\"},{\"code\":\"3038\",\"name\":\"中国邮政储蓄\"},{\"code\":\"3039\",\"name\":\"中信银行\"}]","fixedAmount":""}},{"id":"75","account":"","payeeName":"无卡快捷支付(GT)单笔100-3000,成功率高欢迎使用,","qrcode":"","domain":"","address":"无卡快捷（高通支付）","name":"无卡快捷（高通支付）","onlineType":"8","rechType":"onlinePayment","para":{"bankList":"[{\"code\":\"3001\",\"name\":\"招商银行\"},{\"code\":\"3002\",\"name\":\"工商银行\"},{\"code\":\"3003\",\"name\":\"建设银行\"},{\"code\":\"3004\",\"name\":\"浦发银行\"},{\"code\":\"3005\",\"name\":\"农业银行\"},{\"code\":\"3006\",\"name\":\"民生银行\"},{\"code\":\"3009\",\"name\":\"兴业银行\"},{\"code\":\"3020\",\"name\":\"交通银行\"},{\"code\":\"3022\",\"name\":\"光大银行\"},{\"code\":\"3026\",\"name\":\"中国银行\"},{\"code\":\"3032\",\"name\":\"北京银行\"},{\"code\":\"3035\",\"name\":\"平安银行\"},{\"code\":\"3036\",\"name\":\"广发银行\"},{\"code\":\"3037\",\"name\":\"上海农商银行\"},{\"code\":\"3038\",\"name\":\"中国邮政储蓄\"},{\"code\":\"3039\",\"name\":\"中信银行\"}]","fixedAmount":""}},{"id":"82","account":"","payeeName":"银联扫码(JF)单笔100-5000,成功率高.欢迎使用","qrcode":"","domain":"","address":"快捷支付（金发支付）","name":"快捷支付（金发支付）","onlineType":"8","rechType":"onlinePayment","para":{"bankList":"[{\"code\":\"3001\",\"name\":\"招商银行\"},{\"code\":\"3002\",\"name\":\"工商银行\"},{\"code\":\"3003\",\"name\":\"建设银行\"},{\"code\":\"3004\",\"name\":\"浦发银行\"},{\"code\":\"3005\",\"name\":\"农业银行\"},{\"code\":\"3006\",\"name\":\"民生银行\"},{\"code\":\"3009\",\"name\":\"兴业银行\"},{\"code\":\"3020\",\"name\":\"交通银行\"},{\"code\":\"3022\",\"name\":\"光大银行\"},{\"code\":\"3026\",\"name\":\"中国银行\"},{\"code\":\"3032\",\"name\":\"北京银行\"},{\"code\":\"3035\",\"name\":\"平安银行\"},{\"code\":\"3036\",\"name\":\"广发银行\"},{\"code\":\"3037\",\"name\":\"上海农商银行\"},{\"code\":\"3038\",\"name\":\"中国邮政储蓄\"},{\"code\":\"3039\",\"name\":\"中信银行\"}]","fixedAmount":""}}]},{"id":"yunshanfu_transfer","code":"20","name":"云闪付[成功率100%]","sort":"13","prompt":"尊敬的会员为确保支付成功率，建议金额不要为10的整数倍！最低金额1,最高金额500000 ","tip":"支付成功100%,截屏保存打开云闪付、手机银行APP扫一扫支付","prompt_pc":"尊敬的会员为确保支付成功率，建议金额不要为10的整数倍！最低金额1,最高金额500000 ","copy_prompt":"浏览器不支持复制,点击\u201c复制\u201d后请使用Ctrl+C或者鼠标右键菜单 ","channel":[]},{"id":"qqpay_transfer","code":"21","name":"QQ钱包转账","sort":"14","prompt":"尊敬的会员为确保支付成功率，建议金额不要为10的整数倍！最低金额1,最高金额500000 ","tip":"QQ钱包转账","prompt_pc":"尊敬的会员为确保支付成功率，建议金额不要为10的整数倍！最低金额1,最高金额5000","copy_prompt":"浏览器不支持复制,点击\u201c复制\u201d后请使用Ctrl+C或者鼠标右键菜单 ","channel":[]},{"id":"wechat_alipay_transfer","code":"22","name":"微信,支付宝转账[成功率100%]\t","sort":"15","prompt":"尊敬的会员为确保支付成功到账，请先转账成功在点下一步提交存款信息。最低金额100,最高金额50000","tip":"微信,支付宝转账[成功率100%]\t","prompt_pc":"尊敬的会员为确保支付成功到账，请先转账成功在点下一步提交存款信息。最低金额100,最高金额50000","copy_prompt":"浏览器不支持复制,点击\u201c复制\u201d后请使用Ctrl+C或者鼠标右键菜单 ","channel":[]},{"id":"xnb_online","code":"23","name":"微信扫码支付","sort":"16","prompt":"尊敬的会员为确保支付成功率，最低金额100,最高金额3000","tip":"微信扫码支付宝","prompt_pc":"尊敬的会员为确保支付成功率，最低金额100,最高金额3000","copy_prompt":"浏览器不支持复制,点击\u201c复制\u201d后请使用Ctrl+C或者鼠标右键菜单 ","channel":[]},{"id":"dk_online","code":"24","name":"微信扫码支付","sort":"17","prompt":"尊敬的会员为确保支付成功率，建议金额500 600 800 1000 1500 2000 2500 3000 4000 5000（仅支持十种金额）【AY 通道】","tip":"微信扫码仅支持固码支付。","prompt_pc":"尊敬的会员为确保支付成功率，建议金额500 600 800 1000 1500 2000 2500 3000 4000 5000（仅支持十种金额）【AY 通道】","copy_prompt":"浏览器不支持复制,点击\u201c复制\u201d后请使用Ctrl+C或者鼠标右键菜单 ","channel":[]},{"id":"alihb_online","code":"25","name":"支付宝扫码支付成功率100%","sort":"18","prompt":"先扫码付款。在提交订单，单笔最低10最低50000","tip":"支付宝扫码支付成功率100%","prompt_pc":"先扫码付款。在提交订单，单笔最低10最低50000","copy_prompt":"浏览器不支持复制,点击\u201c复制\u201d后请使用Ctrl+C或者鼠标右键菜单 ","channel":[]},{"id":"jdzz_transfer","code":"26","name":"京东钱包转账","sort":"19","prompt":"尊敬的会员为确保支付成功率，建议金额不要为10的整数倍！最低金额1,最高金额500000 ","tip":"京东钱包在线转账","prompt_pc":"尊敬的会员为确保支付成功率，建议金额不要为10的整数倍！最低金额1,最高金额500000 ","copy_prompt":"浏览器不支持复制,点击\u201c复制\u201d后请使用Ctrl+C或者鼠标右键菜单 ","channel":[]},{"id":"ddhb_transfer","code":"27","name":"钉钉红包","sort":"20","prompt":"尊敬的会员为确保支付成功率，建议金额不要为10的整数倍！最低金额1,最高金额500000 ","tip":"钉钉红包支付","prompt_pc":"尊敬的会员为确保支付成功率，建议金额不要为10的整数倍！最低金额1,最高金额500000 ","copy_prompt":"浏览器不支持复制,点击\u201c复制\u201d后请使用Ctrl+C或者鼠标右键菜单 ","channel":[]},{"id":"wxsm_transfer","code":"28","name":"微信扫码","sort":"21","prompt":"尊敬的会员为确保支付成功率，建议金额不要为10的整数倍！最低金额1,最高金额500000 ","tip":"微信扫码支付","prompt_pc":"尊敬的会员为确保支付成功率，建议金额不要为10的整数倍！最低金额1,最高金额500000 ","copy_prompt":"浏览器不支持复制,点击\u201c复制\u201d后请使用Ctrl+C或者鼠标右键菜单 ","channel":[]},{"id":"dshb_transfer","code":"29","name":"多闪红包","sort":"22","prompt":"尊敬的会员为确保支付成功率，建议金额不要为10的整数倍！最低金额1,最高金额500000 ","tip":"多闪红包支付","prompt_pc":"尊敬的会员为确保支付成功率，建议金额不要为10的整数倍！最低金额1,最高金额500000 ","copy_prompt":"浏览器不支持复制,点击\u201c复制\u201d后请使用Ctrl+C或者鼠标右键菜单 ","channel":[]},{"id":"xlsm_transfer","code":"30","name":"闲聊扫码","sort":23,"prompt":"尊敬的会员为确保支付成功率，建议金额不要为10的整数倍！最低金额1,最高金额500000 ","tip":"闲聊扫码支付","prompt_pc":"尊敬的会员为确保支付成功率，建议金额不要为10的整数倍！最低金额1,最高金额500000 ","copy_prompt":"浏览器不支持复制,点击\u201c复制\u201d后请使用Ctrl+C或者鼠标右键菜单 ","channel":[]},{"id":"zhifubao_transfer","code":"31","name":"支付宝扫码","sort":24,"prompt":"尊敬的会员为确保支付成功率，建议金额不要为10的整数倍！最低金额1,最高金额500000 ","tip":"支付宝扫码支付","prompt_pc":"尊敬的会员为确保支付成功率，建议金额不要为10的整数倍！最低金额1,最高金额500000 ","copy_prompt":"浏览器不支持复制,点击\u201c复制\u201d后请使用Ctrl+C或者鼠标右键菜单 ","channel":[]}],"quickAmount":["100","200","300","400","500","600","700","800","900","1000"]}
     * info : {"sqlList":["从库(5304)：SELECT id, name, title, value FROM `ssc_params`   --Spent：0.59 ms","从库(5304)：SELECT * FROM `ssc_blacklist` WHERE  `type` = :type   --Spent：0.26 ms","从库(5304)：SELECT * FROM `ssc_cache`  WHERE `name` = 'block_country'    --Spent：0.14 ms","主库(5303)：SELECT uid, parentId, admin, username, password, coinPassword, type, name, regTime, coin, email, qq, phone, testFlag, level_id, rebate, is_trial FROM `ssc_members`  WHERE `uid` = '2679'    --Spent：0.53 ms","从库(5304)：SELECT * FROM `ssc_cache`  WHERE `name` = 'bank_sort'    --Spent：0.21 ms","从库(5304)：SELECT id,account,payeeName,qrcode,domain,address,`name`,onlineType,rechType,para FROM `ssc_sysadmin_bank` WHERE  `isDelete` = :isDelete AND `enable` = :enable   --Spent：0.53 ms","主库(5303)：SELECT id, level_name, level_desc, payment_method FROM `ssc_level` WHERE  `id` = :id   --Spent：0.19 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_57', `name`) > 0  --Spent：0.29 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_4', `name`) > 0  --Spent：0.27 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_15', `name`) > 0  --Spent：0.32 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_28', `name`) > 0  --Spent：0.30 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_32', `name`) > 0  --Spent：0.21 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_37', `name`) > 0  --Spent：0.20 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_49', `name`) > 0  --Spent：0.19 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_52', `name`) > 0  --Spent：0.26 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_59', `name`) > 0  --Spent：0.30 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_63', `name`) > 0  --Spent：0.21 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_67', `name`) > 0  --Spent：0.23 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_76', `name`) > 0  --Spent：0.20 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_87', `name`) > 0  --Spent：0.24 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_92', `name`) > 0  --Spent：0.29 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_93', `name`) > 0  --Spent：0.30 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_94', `name`) > 0  --Spent：0.26 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_96', `name`) > 0  --Spent：0.21 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_7', `name`) > 0  --Spent：0.25 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_16', `name`) > 0  --Spent：0.19 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_27', `name`) > 0  --Spent：0.20 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_33', `name`) > 0  --Spent：0.23 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_43', `name`) > 0  --Spent：0.45 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_50', `name`) > 0  --Spent：0.30 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_51', `name`) > 0  --Spent：0.27 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_60', `name`) > 0  --Spent：0.28 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_61', `name`) > 0  --Spent：0.26 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_66', `name`) > 0  --Spent：0.26 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_77', `name`) > 0  --Spent：0.31 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_83', `name`) > 0  --Spent：0.26 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_90', `name`) > 0  --Spent：0.28 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_91', `name`) > 0  --Spent：0.21 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_1', `name`) > 0  --Spent：0.23 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_98', `name`) > 0  --Spent：0.30 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_2', `name`) > 0  --Spent：0.25 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_84', `name`) > 0  --Spent：0.25 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_72', `name`) > 0  --Spent：0.32 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_89', `name`) > 0  --Spent：0.23 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_44', `name`) > 0  --Spent：0.23 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_45', `name`) > 0  --Spent：0.26 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_6', `name`) > 0  --Spent：0.24 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_17', `name`) > 0  --Spent：0.29 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_34', `name`) > 0  --Spent：0.25 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_54', `name`) > 0  --Spent：0.28 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_62', `name`) > 0  --Spent：0.23 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_64', `name`) > 0  --Spent：0.24 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_68', `name`) > 0  --Spent：0.20 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_5', `name`) > 0  --Spent：0.19 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_23', `name`) > 0  --Spent：0.18 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_53', `name`) > 0  --Spent：0.22 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_75', `name`) > 0  --Spent：0.21 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_82', `name`) > 0  --Spent：0.21 ms"],"sqlTotalNum":58,"sqlTotalTime":"15.29 ms","traceBack":{"loader":"1.68 ms","initDi":"9.67 ms","settings":"29.61 ms","access":"39.43 ms","dispatch":null},"runtime":"60.34 ms"}
     */

    private int code;
    private String msg;
    private DataBean data;

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

    public DataBean getData() {
        return data;
    }

    public void setData(DataBean data) {
        this.data = data;
    }

    public static class DataBean {
        private List<PaymentBean> payment;
        private List<String> quickAmount;
        String depositPrompt;
        String transferPrompt;

        public String getDepositPrompt() {
            return depositPrompt;
        }

        public void setDepositPrompt(String depositPrompt) {
            this.depositPrompt = depositPrompt;
        }

        public String getTransferPrompt() {
            return transferPrompt;
        }

        public void setTransferPrompt(String transferPrompt) {
            this.transferPrompt = transferPrompt;
        }

        public List<PaymentBean> getPayment() {
            return payment;
        }

        public void setPayment(List<PaymentBean> payment) {
            this.payment = payment;
        }

        public List<String> getQuickAmount() {
            return quickAmount;
        }

        public void setQuickAmount(List<String> quickAmount) {
            this.quickAmount = quickAmount;
        }

//        public static class PaymentBean implements Serializable {
//            /**
//             * id : alipay_online
//             * code : 6
//             * name : 支付宝在线支付
//             * sort : 1
//             * prompt : 输入金额或快捷按钮后点开始充值，系统自动跳转生成收款二维码需耐心等待几秒，系统跳转的时候请不要退出，感谢您的支持！[如交易失败，请重试或使用其他通道]
//             * tip : 支付宝在线支付
//             * prompt_pc : 输入金额或选择快捷按钮后点开始充值，系统自动跳转生成收款二维码需耐心等待几秒，系统跳转的时候请不要退出，感谢您的支持！（如交易失败，请重试或使用其他通道）
//             * copy_prompt : 浏览器不支持复制,点击“复制”后请使用Ctrl+C或者鼠标右键菜单
//             * channel : [{"id":"4","account":"","payeeName":"支付宝扫码（AY） 单笔500-5000 任意金额支付,成功率高,欢迎使用","qrcode":"","domain":"","address":"支付宝（安亿支付）","name":"支付宝（安亿支付）","onlineType":"6","rechType":"onlinePayment","para":{"bankList":null,"fixedAmount":""}},{"id":"15","account":"","payeeName":"支付宝扫码（XF）100-5000，整百金额支付，支持花呗。信用卡支付，","qrcode":"","domain":"","address":"支付宝（鑫发支付）","name":"支付宝（鑫发支付）","onlineType":"6","rechType":"onlinePayment","para":{"bankList":null,"fixedAmount":""}},{"id":"28","account":"","payeeName":"支付宝Wap原生(AY)单笔200-5000固定金额支付,支持信用卡花呗付款,等待10秒,成功率高","qrcode":"","domain":"","address":"支付宝（安亿支付原生通道）","name":"支付宝（安亿支付原生通道）","onlineType":"6","rechType":"onlinePayment","para":{"bankList":null,"fixedAmount":"200 500 1000 2000 3000 5000"}},{"id":"32","account":"","payeeName":"支付宝Wap(H)10-100固定金额.支持信用卡.花呗,成功率稳定","qrcode":"","domain":"","address":"支付宝（恒润）","name":"支付宝（恒润）","onlineType":"6","rechType":"onlinePayment","para":{"bankList":null,"fixedAmount":"10 20 30 50 100"}},{"id":"37","account":"","payeeName":"支付宝wap（JF）固定金额支付，信用卡，花呗付款","qrcode":"","domain":"","address":"支付宝（金发支付）","name":"支付宝（金发支付）","onlineType":"6","rechType":"onlinePayment","para":{"bankList":null,"fixedAmount":"1000 2000 3000 5000 8000"}},{"id":"49","account":"","payeeName":"支付宝扫码（L）固金额支付，,欢迎使用","qrcode":"","domain":"","address":"支付宝（隆发支付测试6）","name":"支付宝（隆发支付测试6）","onlineType":"6","rechType":"onlinePayment","para":{"bankList":null,"fixedAmount":"200 300 500 600 800 900 1000 1300 1400 1500 1600 1700 1800 2000 2500 3000 3500 4000"}},{"id":"52","account":"","payeeName":"支付宝转卡(ZF)单笔20-9900！个位数必须为5,列:115.225.335.欢迎使用","qrcode":"","domain":"","address":"支付宝（支付通2.0）","name":"支付宝（支付通2.0）","onlineType":"6","rechType":"onlinePayment","para":{"bankList":null,"fixedAmount":""}},{"id":"59","account":"","payeeName":"支付Wap(BF)50-100金额成功率高,欢迎使用","qrcode":"","domain":"","address":"支付宝（佰富支付内测）","name":"支付宝（佰富支付内测）","onlineType":"6","rechType":"onlinePayment","para":{"bankList":null,"fixedAmount":"50 100"}},{"id":"63","account":"","payeeName":"支付宝扫码(GT)单笔100-10000","qrcode":"","domain":"","address":"支付宝（高通）","name":"支付宝（高通）","onlineType":"6","rechType":"onlinePayment","para":{"bankList":null,"fixedAmount":""}},{"id":"67","account":"","payeeName":"支付宝Wap(ZF)单笔20-3000,首次充值需绑卡，支付密码填银行卡取款密码,成功率高","qrcode":"","domain":"","address":"支付宝（支付通2.0）","name":"支付宝（支付通2.0）","onlineType":"6","rechType":"onlinePayment","para":{"bankList":null,"fixedAmount":""}},{"id":"76","account":"","payeeName":"支付宝扫码（GS）单笔200\u20143000支持信用卡.花呗单笔小额,成功率稳定","qrcode":"","domain":"","address":"支付宝（高盛支付）","name":"支付宝（高盛支付）","onlineType":"6","rechType":"onlinePayment","para":{"bankList":null,"fixedAmount":""}},{"id":"87","account":"","payeeName":"支付宝wap(XF)金额100-5000PDD整百金额，成功率稳定75+","qrcode":"","domain":"","address":"支付宝（鑫发支付）","name":"支付宝（鑫发支付）","onlineType":"6","rechType":"onlinePayment","para":{"bankList":null,"fixedAmount":""}},{"id":"92","account":"","payeeName":"支付宝Wap(GT)单笔100-10000","qrcode":"","domain":"","address":"支付宝（高通）","name":"支付宝（高通）","onlineType":"6","rechType":"onlinePayment","para":{"bankList":null,"fixedAmount":""}},{"id":"93","account":"","payeeName":"支付宝扫码(H)101-5000固定金额.支持信用卡.花呗,成功率稳定","qrcode":"","domain":"","address":"支付宝（恒润）","name":"支付宝（恒润）","onlineType":"6","rechType":"onlinePayment","para":{"bankList":null,"fixedAmount":""}},{"id":"94","account":"","payeeName":"支付宝wap(GS)200-3000PDD整百支付首次充值需绑卡,支付密码填写银行卡取款密码","qrcode":"","domain":"","address":"支付宝（高盛支付）","name":"支付宝（高盛支付）","onlineType":"6","rechType":"onlinePayment","para":{"bankList":null,"fixedAmount":"200 300 500 1000 1500 2000 3000"}},{"id":"96","account":"","payeeName":"支付宝wap(GS)10-5000","qrcode":"","domain":"","address":"支付宝（高盛支付）","name":"支付宝（高盛支付）","onlineType":"6","rechType":"onlinePayment","para":{"bankList":null,"fixedAmount":"10  20  50 100 200 500 1000 2000  5000"}}]
//             */
//            private static final long serialVersionUID = 1L;
//            private String id;
//            private String code;
//            private String name;
//            private String sort;
//            private String prompt;
//            private String tip;
//            private String prompt_pc;
//            private String copy_prompt;
//            private List<ChannelBean> channel;
//
//            public String getId() {
//                return id;
//            }
//
//            public void setId(String id) {
//                this.id = id;
//            }
//
//            public String getCode() {
//                return code;
//            }
//
//            public void setCode(String code) {
//                this.code = code;
//            }
//
//            public String getName() {
//                return name;
//            }
//
//            public void setName(String name) {
//                this.name = name;
//            }
//
//            public String getSort() {
//                return sort;
//            }
//
//            public void setSort(String sort) {
//                this.sort = sort;
//            }
//
//            public String getPrompt() {
//                return prompt;
//            }
//
//            public void setPrompt(String prompt) {
//                this.prompt = prompt;
//            }
//
//            public String getTip() {
//                return tip;
//            }
//
//            public void setTip(String tip) {
//                this.tip = tip;
//            }
//
//            public String getPrompt_pc() {
//                return prompt_pc;
//            }
//
//            public void setPrompt_pc(String prompt_pc) {
//                this.prompt_pc = prompt_pc;
//            }
//
//            public String getCopy_prompt() {
//                return copy_prompt;
//            }
//
//            public void setCopy_prompt(String copy_prompt) {
//                this.copy_prompt = copy_prompt;
//            }
//
//            public List<ChannelBean> getChannel() {
//                return channel;
//            }
//
//            public void setChannel(List<ChannelBean> channel) {
//                this.channel = channel;
//            }
//
//            public static class ChannelBean {
//                /**
//                 * id : 4
//                 * account :
//                 * payeeName : 支付宝扫码（AY） 单笔500-5000 任意金额支付,成功率高,欢迎使用
//                 * qrcode :
//                 * domain :
//                 * address : 支付宝（安亿支付）
//                 * name : 支付宝（安亿支付）
//                 * onlineType : 6
//                 * rechType : onlinePayment
//                 * para : {"bankList":null,"fixedAmount":""}
//                 */
//
//                private String id;
//                private String account;
//                private String payeeName;
//                private String qrcode;
//                private String domain;
//                private String address;
//                private String name;
//                private String onlineType;
//                private String rechType;
//                private ParaBean para;
//
//                public String getId() {
//                    return id;
//                }
//
//                public void setId(String id) {
//                    this.id = id;
//                }
//
//                public String getAccount() {
//                    return account;
//                }
//
//                public void setAccount(String account) {
//                    this.account = account;
//                }
//
//                public String getPayeeName() {
//                    return payeeName;
//                }
//
//                public void setPayeeName(String payeeName) {
//                    this.payeeName = payeeName;
//                }
//
//                public String getQrcode() {
//                    return qrcode;
//                }
//
//                public void setQrcode(String qrcode) {
//                    this.qrcode = qrcode;
//                }
//
//                public String getDomain() {
//                    return domain;
//                }
//
//                public void setDomain(String domain) {
//                    this.domain = domain;
//                }
//
//                public String getAddress() {
//                    return address;
//                }
//
//                public void setAddress(String address) {
//                    this.address = address;
//                }
//
//                public String getName() {
//                    return name;
//                }
//
//                public void setName(String name) {
//                    this.name = name;
//                }
//
//                public String getOnlineType() {
//                    return onlineType;
//                }
//
//                public void setOnlineType(String onlineType) {
//                    this.onlineType = onlineType;
//                }
//
//                public String getRechType() {
//                    return rechType;
//                }
//
//                public void setRechType(String rechType) {
//                    this.rechType = rechType;
//                }
//
//                public ParaBean getPara() {
//                    return para;
//                }
//
//                public void setPara(ParaBean para) {
//                    this.para = para;
//                }
//
//                public static class ParaBean {
//                    /**
//                     * bankList : null
//                     * fixedAmount :
//                     */
//
//                    private Object bankList;
//                    private String fixedAmount;
//
//                    public Object getBankList() {
//                        return bankList;
//                    }
//
//                    public void setBankList(Object bankList) {
//                        this.bankList = bankList;
//                    }
//
//                    public String getFixedAmount() {
//                        return fixedAmount;
//                    }
//
//                    public void setFixedAmount(String fixedAmount) {
//                        this.fixedAmount = fixedAmount;
//                    }
//                }
//            }
//        }
    }

    public static class InfoBean {
        /**
         * sqlList : ["从库(5304)：SELECT id, name, title, value FROM `ssc_params`   --Spent：0.59 ms","从库(5304)：SELECT * FROM `ssc_blacklist` WHERE  `type` = :type   --Spent：0.26 ms","从库(5304)：SELECT * FROM `ssc_cache`  WHERE `name` = 'block_country'    --Spent：0.14 ms","主库(5303)：SELECT uid, parentId, admin, username, password, coinPassword, type, name, regTime, coin, email, qq, phone, testFlag, level_id, rebate, is_trial FROM `ssc_members`  WHERE `uid` = '2679'    --Spent：0.53 ms","从库(5304)：SELECT * FROM `ssc_cache`  WHERE `name` = 'bank_sort'    --Spent：0.21 ms","从库(5304)：SELECT id,account,payeeName,qrcode,domain,address,`name`,onlineType,rechType,para FROM `ssc_sysadmin_bank` WHERE  `isDelete` = :isDelete AND `enable` = :enable   --Spent：0.53 ms","主库(5303)：SELECT id, level_name, level_desc, payment_method FROM `ssc_level` WHERE  `id` = :id   --Spent：0.19 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_57', `name`) > 0  --Spent：0.29 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_4', `name`) > 0  --Spent：0.27 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_15', `name`) > 0  --Spent：0.32 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_28', `name`) > 0  --Spent：0.30 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_32', `name`) > 0  --Spent：0.21 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_37', `name`) > 0  --Spent：0.20 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_49', `name`) > 0  --Spent：0.19 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_52', `name`) > 0  --Spent：0.26 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_59', `name`) > 0  --Spent：0.30 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_63', `name`) > 0  --Spent：0.21 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_67', `name`) > 0  --Spent：0.23 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_76', `name`) > 0  --Spent：0.20 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_87', `name`) > 0  --Spent：0.24 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_92', `name`) > 0  --Spent：0.29 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_93', `name`) > 0  --Spent：0.30 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_94', `name`) > 0  --Spent：0.26 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_96', `name`) > 0  --Spent：0.21 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_7', `name`) > 0  --Spent：0.25 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_16', `name`) > 0  --Spent：0.19 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_27', `name`) > 0  --Spent：0.20 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_33', `name`) > 0  --Spent：0.23 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_43', `name`) > 0  --Spent：0.45 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_50', `name`) > 0  --Spent：0.30 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_51', `name`) > 0  --Spent：0.27 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_60', `name`) > 0  --Spent：0.28 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_61', `name`) > 0  --Spent：0.26 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_66', `name`) > 0  --Spent：0.26 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_77', `name`) > 0  --Spent：0.31 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_83', `name`) > 0  --Spent：0.26 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_90', `name`) > 0  --Spent：0.28 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_91', `name`) > 0  --Spent：0.21 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_1', `name`) > 0  --Spent：0.23 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_98', `name`) > 0  --Spent：0.30 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_2', `name`) > 0  --Spent：0.25 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_84', `name`) > 0  --Spent：0.25 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_72', `name`) > 0  --Spent：0.32 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_89', `name`) > 0  --Spent：0.23 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_44', `name`) > 0  --Spent：0.23 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_45', `name`) > 0  --Spent：0.26 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_6', `name`) > 0  --Spent：0.24 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_17', `name`) > 0  --Spent：0.29 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_34', `name`) > 0  --Spent：0.25 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_54', `name`) > 0  --Spent：0.28 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_62', `name`) > 0  --Spent：0.23 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_64', `name`) > 0  --Spent：0.24 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_68', `name`) > 0  --Spent：0.20 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_5', `name`) > 0  --Spent：0.19 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_23', `name`) > 0  --Spent：0.18 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_53', `name`) > 0  --Spent：0.22 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_75', `name`) > 0  --Spent：0.21 ms","从库(5304)：SELECT name FROM `ssc_upload` WHERE locate('sysbank_82', `name`) > 0  --Spent：0.21 ms"]
         * sqlTotalNum : 58
         * sqlTotalTime : 15.29 ms
         * traceBack : {"loader":"1.68 ms","initDi":"9.67 ms","settings":"29.61 ms","access":"39.43 ms","dispatch":null}
         * runtime : 60.34 ms
         */

        private int sqlTotalNum;
        private String sqlTotalTime;
        private TraceBackBean traceBack;
        private String runtime;
        private List<String> sqlList;

        public int getSqlTotalNum() {
            return sqlTotalNum;
        }

        public void setSqlTotalNum(int sqlTotalNum) {
            this.sqlTotalNum = sqlTotalNum;
        }

        public String getSqlTotalTime() {
            return sqlTotalTime;
        }

        public void setSqlTotalTime(String sqlTotalTime) {
            this.sqlTotalTime = sqlTotalTime;
        }

        public TraceBackBean getTraceBack() {
            return traceBack;
        }

        public void setTraceBack(TraceBackBean traceBack) {
            this.traceBack = traceBack;
        }

        public String getRuntime() {
            return runtime;
        }

        public void setRuntime(String runtime) {
            this.runtime = runtime;
        }

        public List<String> getSqlList() {
            return sqlList;
        }

        public void setSqlList(List<String> sqlList) {
            this.sqlList = sqlList;
        }

        public static class TraceBackBean {
            /**
             * loader : 1.68 ms
             * initDi : 9.67 ms
             * settings : 29.61 ms
             * access : 39.43 ms
             * dispatch : null
             */

            private String loader;
            private String initDi;
            private String settings;
            private String access;
            private Object dispatch;

            public String getLoader() {
                return loader;
            }

            public void setLoader(String loader) {
                this.loader = loader;
            }

            public String getInitDi() {
                return initDi;
            }

            public void setInitDi(String initDi) {
                this.initDi = initDi;
            }

            public String getSettings() {
                return settings;
            }

            public void setSettings(String settings) {
                this.settings = settings;
            }

            public String getAccess() {
                return access;
            }

            public void setAccess(String access) {
                this.access = access;
            }

            public Object getDispatch() {
                return dispatch;
            }

            public void setDispatch(Object dispatch) {
                this.dispatch = dispatch;
            }
        }
    }
}
