//
//  OSSObjectAPI.swift
//  XiaoJir
//
//  Created by xionghx on 2019/7/1.
//  Copyright © 2019 Diao. All rights reserved.
//

import Foundation
import Moya

public enum OSSObject {
	
	case putObject(filePath: URL)
	
	case postImage(data: ImageFormData)
	
}
fileprivate extension Date {
	var dateString: String {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyyMMdd"
		return formatter.string(from: self)
	}
}

public let OSSObjectAPI = MoyaProvider<OSSObject>()


extension OSSObject: TargetType {
	
	public struct ImageFormData {
		/// 图片数据
		public let data: Data
		/// 唯一标识符
		public let token: String
		/// 创建时间
		public let date: String
		/// 图片相对路径
		public let path: String
		/// 图片全路径
		public let fullPath: String
		
		public init(data: Data) {
			self.data = data
			self.token = UUID().uuidString
			self.date = Date().dateString
			self.path = "upload/images/\(appEnv.rawValue)/\(date)/\(token).jpg"
			self.fullPath = appEnv.objectFullPath(path)
		}
		
	}
	
	
	public var baseURL: URL {
		
		switch self {
		case .putObject:
			return appEnv.objectUploadUrl
		case .postImage:
			return appEnv.objectUploadUrl

		}
	}
	
	public var path: String {
		
		switch self {
		case .putObject:
			return ""
			
		case .postImage:
			return ""
		}
	}
	
	public var method: Moya.Method {
		
		switch self {
		case .putObject:
			return .put
			
		case .postImage:
			return .post
		}
	}
	
	public var sampleData: Data {
		switch self {
		case .putObject:
			return
				#"""
					{"data":{"id":"your_new_gif_id"},
					 "meta":{"status":200,"msg":"OK"}}
				"""#.data(using: String.Encoding.utf8)!
		case .postImage:
			return
				#"""
					{"data":{"id":"your_new_gif_id"},
					 "meta":{"status":200,"msg":"OK"}}
				"""#.data(using: String.Encoding.utf8)!
		}
	}
	
	public var task: Task {
		
		switch self {
		case .putObject(let filePath):
			return Task.uploadFile(filePath)
		case .postImage(let imageFormData):
			var formDatas = [MultipartFormData]()
			
			for (key, value) in ["key": imageFormData.path] {
				let string = "\(value)"
				if let data = string.data(using: .utf8, allowLossyConversion: true) {
					formDatas.append(MultipartFormData(provider: .data(data), name: key))
				}
			}
			
			let imageData = MultipartFormData(provider: .data(imageFormData.data), name: "file")
		
			formDatas.append(imageData)
			return Task.uploadMultipart(formDatas)
		}
		
	}
	
	
	public var headers: [String: String]? {
		
		switch self {
		case .putObject:
			
			return nil
		case .postImage:
			return nil
		}
	}
	
	
}


