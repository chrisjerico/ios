//
//  UserApi.swift
//  ug
//
//  Created by xionghx on 2019/12/24.
//  Copyright © 2019 ug. All rights reserved.
//

import Foundation
import Moya

let userAPI = MoyaProvider<UserTarger>(plugins: [APILogger.default])


enum UserTarger {
	case login(usr: String, pwd: String)
}

extension UserTarger: TargetType {
	var baseURL: URL {
		return URL(string: AppDefine.shared()!.host)!
		
	}
	
	var path: String {
		return "/wjapp/api.php"
		
	}
	
	var method: Moya.Method {
		switch self {
		case .login:
			return .post
		}
	}
	
	var sampleData: Data {
		return Data()
		
	}
	
	var task: Task {
		var urlParameters = [String: Any]()
		var bodyParameters = [String: Any]()
		switch self {
		case let .login(usr, pwd):
			urlParameters["c"] = "user"
			urlParameters["a"] = "login"
			
			bodyParameters["usr"] = usr
			bodyParameters["pwd"] = pwd
			bodyParameters["device"] = 3
			
		}
		
		
		if checkSign == 1 {
			urlParameters["checkSign"] = 1
			bodyParameters = bodyParameters.count > 0 ? CMNetwork.encryptionCheckSign(bodyParameters) as! [String : Any] : bodyParameters
		}
		
		if let aValue = urlParameters["a"] as? String, aValue == "login" {
			bodyParameters.removeValue(forKey: "token")
		}
		
		if case .get = self.method {
			return Task.requestParameters(parameters: urlParameters.merging(bodyParameters, uniquingKeysWith: { $1 }), encoding: URLEncoding.default)
			
		} else {
			return Task.requestCompositeParameters(bodyParameters: bodyParameters, bodyEncoding: JSONEncoding.prettyPrinted, urlParameters: urlParameters)
		}
	}
	
	var headers: [String : String]? {
		return ["Cookie": "loginsessid=\(UGUserModel.currentUser().sessid);logintoken=\(UGUserModel.currentUser().token)"]
		
	}
	
	
	
}
