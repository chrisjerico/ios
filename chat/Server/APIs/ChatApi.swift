//
//  ChatApi.swift
//  ug
//
//  Created by xionghx on 2019/10/22.
//  Copyright © 2019 ug. All rights reserved.
//

import Foundation
import Moya
import ObjectMapper

let ChatAPI = MoyaProvider<ChatTarget>(plugins: [APILogger.default])

enum ChatTarget {
	
	case test
	
	case launchPic
	case systemConfig
	case userInfo(sessid: String)
	case conversations
	case roomList
	case delConversation(parameters: [String: Any])
	case messageRecord(from: String, lastMessage: String = "", number: Int = 20)
	case creatRedPacket(amount: Float, roomId: Int, title: String, quantity: Int)
	case creatMinePacket(amount: Float, roomId: Int, mineNumber: Int)
	case grabPacket(packetId: String)
	case redPacketInfo(packetId: String)
	case betList(page: Int, pageSize: Int)
	
}

extension ChatTarget: TargetType {
	var baseURL: URL {
		if case .test = self {
			return URL(string: "http://t111f.fhptcdn.com")!
		}
		
		return URL(string: AppDefine.shared()!.host)!
		
	}
	
	var path: String {
		return "/wjapp/api.php"
	}
	
	var method: Moya.Method {
		if case .test = self {
			return .get
		}
		
		switch self {
		case .launchPic, .systemConfig, .userInfo:
			return .get
		default:
			return .post
		}
	}
	
	var sampleData: Data {
		return Data()
	}
	
	var task: Moya.Task {
		
		var urlParameters = [String: Any]()
		var bodyParameters = [String: Any]()
		
		switch self {
		case .test:
			urlParameters["c"] = "game"
			urlParameters["a"] = "homeGamesPlus"
			
		case .launchPic:
			urlParameters["c"] = "system"
			urlParameters["a"] = "launchImages"
			
		case .conversations:
			urlParameters["c"] = "chat"
			urlParameters["a"] = "conversationList"
			
			bodyParameters["scope"] = 2;
			bodyParameters["token"] = App.user.sessid;
		case .roomList:
			urlParameters["c"] = "chat"
			urlParameters["a"] = "conversationList"
			
			bodyParameters["scope"] = 1;
			bodyParameters["token"] = App.user.sessid;
			
		case let .messageRecord(from, lastMessage, number):
			urlParameters["c"] = "chat"
			urlParameters["a"] = "messageRecord"
			
			bodyParameters["number"] = number
			bodyParameters["sendUid"] = from;
			if lastMessage.count > 0 {
				bodyParameters["messageCode"] = lastMessage;
				
			}
			bodyParameters["token"] = App.user.sessid;
			
		case let .creatRedPacket(amount, roomId, title, quantity):
			urlParameters["c"] = "chat"
			urlParameters["a"] = "createRedBag"
			
			bodyParameters["genre"] = 1
			bodyParameters["amount"] = amount
			bodyParameters["roomId"] = roomId
			bodyParameters["title"] = title
			bodyParameters["quantity"] = quantity
			bodyParameters["token"] = App.user.sessid;
			
		case let .creatMinePacket(amount, roomId, mineNumber):
			urlParameters["c"] = "chat"
			urlParameters["a"] = "createRedBag"
			
			bodyParameters["genre"] = 2
			bodyParameters["amount"] = amount
			bodyParameters["roomId"] = roomId
			bodyParameters["mineNumber"] = mineNumber
			bodyParameters["token"] = App.user.sessid;
			
		case let .grabPacket(packetId):
			urlParameters["c"] = "chat"
			urlParameters["a"] = "grabRedBag"
			
			bodyParameters["redBagId"] = packetId
			bodyParameters["token"] = App.user.sessid;
			
		case .systemConfig:
			urlParameters["c"] = "system"
			urlParameters["a"] = "config"
			
			bodyParameters["token"] = App.user.sessid;
			
		case let .userInfo(sessid):
			urlParameters["c"] = "user"
			urlParameters["a"] = "info"
			
			bodyParameters["token"] = sessid
		case .betList(let page, let rows):
			urlParameters["c"] = "chat"
			urlParameters["a"] = "betList"
			
			bodyParameters["page"] = page
			bodyParameters["rows"] = rows

			bodyParameters["token"] = App.user.sessid
		case .redPacketInfo(let packetId):
			urlParameters["c"] = "chat"
			urlParameters["a"] = "redBag"
			
			bodyParameters["redBagId"] = packetId
			bodyParameters["token"] = App.user.sessid
			
		case .delConversation(let parameters):
			urlParameters["c"] = "chat"
			urlParameters["a"] = "conversationDel"

			bodyParameters["token"] = App.user.sessid
			parameters.forEach { (key,value) in
				bodyParameters[key] = value
			}
	

		}
		
		var should = checkSign == 1
		
		if case .test = self {
			should = true
		}
		
		if should {
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