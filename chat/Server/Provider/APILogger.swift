//
//  APILogger.swift
//  XiaoJir
//
//  Created by xionghuanxin on 2018/9/29.
//  Copyright © 2018年 xionghx. All rights reserved.
//

import Moya

public final class APILogger {

    public static var `default`: PluginType {
		#if DEBUG
        return NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration(logOptions: NetworkLoggerPlugin.Configuration.LogOptions.verbose))
		#else
        return NetworkLoggerPlugin()
        #endif

    }

}
