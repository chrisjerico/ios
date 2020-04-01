//
//  FileUploadAPI.swift
//  XiaoJir
//
//  Created by xionghuanxin on 2018/10/16.
//  Copyright © 2018年 xionghx. All rights reserved.
//

import Foundation
import Moya
import ObjectMapper

let FileUploadApi = MoyaProvider<FileUploadTarget>(plugins: [APILogger.default])


enum FileUploadTarget {
	case image(data: UIImage)
	case moments(images: [UIImage])
}

extension FileUploadTarget: TargetType {
	var baseURL: URL {
		return URL(string: AppDefine.shared()!.host)!
		
	}
	
	var path: String {
		return "/wjapp/api.php"
		
	}
	
	var method: Moya.Method {
		switch self {
		case .image:
			return .post
		case .moments:
			return .post
			
		}
	}
	
	var sampleData: Data {
		return Data()
		
	}
	
	var task: Task {
		var urlParameters = [String: Any]()
		
		var bodyParameters = [String: Any]()
		
		var formDatas: [MultipartFormData] = []
		
		switch self {
		case let .image(image):
			urlParameters["c"] = "chat"
			urlParameters["a"] = "uploadFile"
			
			bodyParameters["token"] = App.user.sessid
			
			let imageData = MultipartFormData(provider: .data(image.jpegData(compressionQuality: 0.65)!), name: "files", fileName: "\(UUID().uuidString).jpg", mimeType: "image/jpeg")
			formDatas.append(imageData)
			
			
			
		case let .moments(images):
			urlParameters["c"] = "moment"
			urlParameters["a"] = "uploadFile"
			
			bodyParameters["token"] = App.user.sessid
			bodyParameters["type"] = "textImg"

			for item in images.enumerated() {
				let imageData = MultipartFormData(provider: .data(item.element.jpegData(compressionQuality: 0.65)!), name: "files[\(item.offset)]", fileName: "\(UUID().uuidString).jpg", mimeType: "image/jpeg")
				formDatas.append(imageData)
			}
			
			
			
		}
		
		
		for (key, value) in bodyParameters {
			if let data = "\(value)".data(using: .utf8, allowLossyConversion: true) {
				formDatas.append(MultipartFormData(provider: .data(data), name: key))
			}
		}
		
		return Task.uploadCompositeMultipart(formDatas, urlParameters: urlParameters)
		
	}
	
	var headers: [String : String]? {
		return ["Cookie": "loginsessid=\(UGUserModel.currentUser().sessid);logintoken=\(UGUserModel.currentUser().token)"]
		
	}
	
	
}
