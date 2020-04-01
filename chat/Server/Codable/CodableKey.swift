//
//  CodableKey.swift
//  XiaoJir
//
//  Created by xionghuanxin on 2018/9/29.
//  Copyright © 2018年 xionghx. All rights reserved.
//

import Foundation

public struct CodableKey {

    /// 请求的成功码
    public static var successCode: Int = 0

    /// 登录过期状态码
    public static var loginExpiredCode: Int = -10
    /// 令牌过期状态码
    public static var tokenExpiredCode: Int = -11
	/// 账号未注册
	public static var userNotFoundCode: Int = -12
	
    /// 后台 Body 字段配置
    public struct Body {
        public static var code: String = "code"
        public static var data: String = "data"
        public static var message: String = "msg"
    }

    /// 后台 List 字段配置
    public struct List {
        public static var list: String = "data"
        public static var totalCount: String = "count"
        public static var nextURLString: String = "next"
    }

}
