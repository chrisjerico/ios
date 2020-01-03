//
//  FileDownloadAPI.swift
//  XiaoJir
//
//  Created by xionghx on 2019/8/21.
//  Copyright © 2019 xionghx. All rights reserved.
//

import Foundation
import Moya
import Alamofire

let DownloadAPI = MoyaProvider<DownLoadTarget>()

enum DownLoadTarget {
	case fileUrl(_: String, destinationURL: String)
}

extension DownLoadTarget: Moya.TargetType {
	var baseURL: URL {
		switch self {
		case .fileUrl(let urlString, _):
			return URL(string: urlString)!
		}
	}
	
	var path: String {
		return ""
	}
	
	var method: Moya.Method {
		return Moya.Method.get
	}
	
	var sampleData: Data {
		return Data()
	}
	
	var task: Moya.Task {
		
		var destinationPath = ""
		switch self {
		case .fileUrl(_, let destination):
			destinationPath = destination
		}
		
		return Task.downloadDestination({ (url, response) -> (destinationURL: URL, options: Alamofire.DownloadRequest.Options) in
			return (URL(fileURLWithPath: destinationPath), [])
		})
	}
	
	var headers: [String : String]? {
		return nil
	}
	
	
}
