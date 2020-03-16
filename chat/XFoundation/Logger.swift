//
//  Logger.swift
//  miaomiao
//
//  Created by xionghx on 2019/12/2.
//  Copyright © 2019 xionghuanxin. All rights reserved.
//

import UIKit

public let logger = Logger()


public class Logger: NSObject {
	func debug<T>(_ message:T, file:String = #file, function:String = #function,
				  line:Int = #line) {
		#if DEBUG
		//获取文件名
		let fileName = (file as NSString).lastPathComponent
		//打印日志内容
		print("😯 DEBUG \(fileName):\(line) \(function) \n \(message)")
		#endif
	}
}
