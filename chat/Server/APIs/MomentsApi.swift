//
//  MomentsApi.swift
//  ug
//
//  Created by xionghx on 2019/12/20.
//  Copyright © 2019 ug. All rights reserved.
//

import Foundation
import Moya

let momentsAPI = MoyaProvider<MomentsTarget>(plugins: [APILogger.default])

enum MomentsTarget {
	case myMoments(page: Int, row: Int)
	case allMoments(page: Int, row: Int)
	case publishImages(content: String, images: [String])
	case comment(content: String, mid: Int, pid: Int)
	case addLike(mid: Int)
	case cancelLike(mid: Int)
	case delMoment(mid: Int)
	case addFollow(uid: String)
	case cancelFollow(uid: String)
	case shareBet(params: [String: Any])
	case addBetMoments(betInfo: String)
	
	case statData
	
	// 关注列表
	case followList(page: Int, rows: Int)
	
	// 粉丝列表
	case fansList(page: Int, rows: Int)
	
}


extension MomentsTarget: TargetType {
	var baseURL: URL {
		return URL(string: AppDefine.shared()!.host)!
		
	}
	
	var path: String {
		return "/wjapp/api.php"
		
	}
	
	var method: Moya.Method {
		switch self {
		case .allMoments, .myMoments:
			return .get
			
		case .publishImages, .comment, .addLike, .cancelLike, .delMoment, .addFollow, .cancelFollow, .shareBet, .addBetMoments, .followList, .fansList, .statData:
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
		case let .allMoments(page, row):
			urlParameters["c"] = "moment"
			urlParameters["a"] = "allMoment"
			
			bodyParameters["token"] = App.user.sessid
			bodyParameters["page"] = page
			bodyParameters["row"] = row
			bodyParameters["msg_type"] = 1
			
		case .publishImages(let content, let images):
			urlParameters["c"] = "moment"
			urlParameters["a"] = "addMoment"
			
			bodyParameters["token"] = App.user.sessid
			bodyParameters["content"] = content
			
			bodyParameters["images"] = images.joined(separator: ",")
			bodyParameters["msgType"] = 0
		case let .shareBet(params):
			urlParameters["c"] = "moment"
			urlParameters["a"] = "addMoment"
			
			bodyParameters["token"] = App.user.sessid
			bodyParameters["msgType"] = 1
			bodyParameters["otherData"] = String(data: try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted), encoding: .utf8)
			
			
		case .comment(let content, let mid, let pid):
			urlParameters["c"] = "moment"
			urlParameters["a"] = "addComment"
			
			bodyParameters["token"] = App.user.sessid
			bodyParameters["content"] = content
			bodyParameters["mid"] = mid
			bodyParameters["pid"] = pid
			
		case .addLike(let mid):
			urlParameters["c"] = "moment"
			urlParameters["a"] = "addLike"
			
			bodyParameters["token"] = App.user.sessid
			bodyParameters["mid"] = mid
		case .cancelLike(let mid):
			urlParameters["c"] = "moment"
			urlParameters["a"] = "cancelLike"
			
			bodyParameters["token"] = App.user.sessid
			bodyParameters["mid"] = mid
		case .delMoment(let mid):
			urlParameters["c"] = "moment"
			urlParameters["a"] = "delMoment"
			
			bodyParameters["token"] = App.user.sessid
			bodyParameters["mid"] = mid
		case .myMoments(let page, let row):
			urlParameters["c"] = "moment"
			urlParameters["a"] = "myMoment"
			
			
			bodyParameters["token"] = App.user.sessid
			bodyParameters["page"] = page
			bodyParameters["row"] = row
			bodyParameters["msg_type"] = 1
		case .addFollow(let uid):
			urlParameters["c"] = "moment"
			urlParameters["a"] = "addFollow"
			
			bodyParameters["token"] = App.user.sessid
			bodyParameters["uid"] = uid
		case .cancelFollow(let uid):
			
			urlParameters["c"] = "moment"
			urlParameters["a"] = "cancelFollow"
			
			bodyParameters["token"] = App.user.sessid
			bodyParameters["uid"] = uid
		case .addBetMoments(let betInfo):
			urlParameters["c"] = "moment"
			urlParameters["a"] = "addMoment"
			
			bodyParameters["token"] = App.user.sessid
			bodyParameters["msgType"] = 1
			bodyParameters["otherData"] = betInfo
			bodyParameters["content"] = "投注分享!"
		case .statData:
			urlParameters["c"] = "moment"
			urlParameters["a"] = "statData"
			
			bodyParameters["token"] = App.user.sessid

		case .followList(page: let page, rows: let rows):
			urlParameters["c"] = "moment"
			urlParameters["a"] = "followList"
			
			bodyParameters["token"] = App.user.sessid
			bodyParameters["page"] = page
			bodyParameters["rows"] = rows

			
		case .fansList(page: let page, rows: let rows):
			urlParameters["c"] = "moment"
			urlParameters["a"] = "fansList"
			
			bodyParameters["token"] = App.user.sessid
			bodyParameters["page"] = page
			bodyParameters["rows"] = rows
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
