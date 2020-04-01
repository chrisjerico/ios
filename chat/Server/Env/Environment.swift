//
//  Environment.swift
//  XiaoJir
//
//  Created by xionghuanxin on 2018/9/29.
//  Copyright © 2018年 xionghx. All rights reserved.
//

import Foundation

public var appEnv: EnvironmentType = .product

/// App 环境状态
///
/// - local: 本地环境
/// - test: 测试环境
/// - develop: 开发环境
/// - product: 生产环境
public enum EnvironmentType: String {
    case local
    case test
    case develop
    case product

    /// 全部环境类型
    public static var allTypes: [EnvironmentType] {
        return [.local, .test, .develop, .product]
    }
}

public extension EnvironmentType {

    /// 请求超时时间
	var timeout: TimeInterval {
        return 30
    }

    /// 请求基本地址
	var baseUrl: URL {
        switch appEnv {
        case .local:
            return URL(string: "http://192.168.100.188:8000")!
        case .test:
			return URL(string: "http://47.104.84.192:9090")!
		case .develop:
			return URL(string: "https://api.xiaojir.com.cn")!
        case .product:
            return URL(string: "https://api.xiaojir.com.cn")!
        }
    }

	/// webSocket
	var socketHost: String {
		
		switch appEnv {
		case .local:
			return ""
		case .test:
			return "47.104.84.192:8162"
		case .develop:
			return "120.27.15.184:8162"
		case .product:
			return "120.27.15.184:8162"
			
		}
		
	}
    /// 图片上传地址
	var objectUploadUrl: URL {
        return URL(string: "https://xiaojir.oss-cn-shenzhen.aliyuncs.com")!
    }

    /// 图片前缀地址拼接
	func objectFullPath(_ path: String) -> String {
        return objectUploadUrl.appendingPathComponent(path).absoluteString
    }
	/// 用于通知的群
	var emNotificationGroup: String {
		return "68261194563585"
	}
	
	/// 环信的org_name
	var emOrgName: String {
		return "1169181024099148"
	}
	
	/// 环信的app_name
	var emAppName: String {
		return "xiaojir"
	}
	
	/// 环信Rest_BaseUrl
	var emBaseUrl: URL {
		return URL(string: "https://a1.easemob.com")!
	}

}
