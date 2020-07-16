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
	case groupMessageRecord(roomId: String, lastMessage: String = "", number: Int = 20)
	
	case creatRedPacket(amount: Float, roomId: Int, title: String, quantity: Int)
	case creatMinePacket(amount: Float, roomId: Int, mineNumber: Int)
	case grabPacket(packetId: String)
	case redPacketInfo(packetId: String)
	case betList(page: Int, pageSize: Int)
	
	
	// 公聊置顶
	case roomConversationTop(dataId: Int)
	
	// 公聊取消置顶
	case roomConversationTopCancel(dataId: Int)
	
	// 私聊置顶
	case privateConversationTop(dataId: Int)
	
	// 私聊取消置顶
	case privateConversationTopCancel(dataId: Int)
	
	// 公聊会话已读
	case roomConversationRead(roomId: Int)
	
	// 私聊会话已读
	case privateConversationRead(targetUid: Int)
	
	// 获取他人信息（聊天）
	case otherUserInfo(target: String)
	
	// 获取自己信息（聊天）
	case selfUserInfo(target: String)
	
	// 设置用户签名
	case updateSignature(text: String)
	// 设置用户昵称
	case updateNickname(text: String)
	// 设置用户性别
	case updateGender(text: String)

	// 平台公告
	case platformAlert(type: Int, page: Int, pageSize: Int)
	
}

extension ChatTarget: TargetType {
	var baseURL: URL {
		if case .test = self {
			return URL(string: "http://test10.6yc.com")!
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
			
			bodyParameters["chat_type"] = 1
			bodyParameters["number"] = number
			bodyParameters["sendUid"] = from;
			if lastMessage.count > 0 {
				bodyParameters["messageCode"] = lastMessage;
				
			}
			bodyParameters["token"] = App.user.sessid;
			
		case let .groupMessageRecord(roomId, lastMessage, number):
			urlParameters["c"] = "chat"
			urlParameters["a"] = "messageRecord"
			bodyParameters["chat_type"] = 0
			bodyParameters["roomId"] = roomId
			bodyParameters["number"] = number
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
			bodyParameters["type"] = 1
			
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
			
			
		case .roomConversationTop(dataId: let dataId):
			urlParameters["c"] = "chat"
			urlParameters["a"] = "conversationTop"
			
			bodyParameters["token"] = App.user.sessid
			bodyParameters["roomId"] = dataId
			bodyParameters["type"] = 1
			bodyParameters["operate"] = 1
			
		case .roomConversationTopCancel(dataId: let dataId):
			urlParameters["c"] = "chat"
			urlParameters["a"] = "conversationTop"
			
			bodyParameters["token"] = App.user.sessid
			bodyParameters["roomId"] = dataId
			bodyParameters["type"] = 1
			bodyParameters["operate"] = 2
			
		case .privateConversationTop(dataId: let dataId):
			urlParameters["c"] = "chat"
			urlParameters["a"] = "conversationTop"
			
			bodyParameters["token"] = App.user.sessid
			bodyParameters["targetUid"] = dataId
			bodyParameters["type"] = 2
			bodyParameters["operate"] = 1
		case .privateConversationTopCancel(dataId: let dataId):
			urlParameters["c"] = "chat"
			urlParameters["a"] = "conversationTop"
			
			bodyParameters["token"] = App.user.sessid
			bodyParameters["targetUid"] = dataId
			bodyParameters["type"] = 2
			bodyParameters["operate"] = 2
		case let .roomConversationRead(roomId):
			urlParameters["c"] = "chat"
			urlParameters["a"] = "conversationRead"
			
			bodyParameters["token"] = App.user.sessid
			bodyParameters["roomId"] = roomId
			bodyParameters["type"] = 1
		case let .privateConversationRead(targetUid):
			urlParameters["c"] = "chat"
			urlParameters["a"] = "conversationRead"
			
			bodyParameters["token"] = App.user.sessid
			bodyParameters["targetUid"] = targetUid
			bodyParameters["type"] = 2
		case let .otherUserInfo(targetUid):
			urlParameters["c"] = "chat"
			urlParameters["a"] = "userInfo"
			
			bodyParameters["token"] = App.user.sessid
			bodyParameters["targetUid"] = targetUid
			bodyParameters["type"] = 2
			
		case .selfUserInfo(target: let target):
			urlParameters["c"] = "chat"
			urlParameters["a"] = "userInfo"
			
			bodyParameters["token"] = App.user.sessid
			bodyParameters["targetUid"] = target
			bodyParameters["type"] = 1
		case let .updateSignature(text):
			urlParameters["c"] = "chat"
			urlParameters["a"] = "updateDescribe"
			
			bodyParameters["token"] = App.user.sessid
			bodyParameters["text"] = text
		case let .updateNickname(text):
			urlParameters["c"] = "chat"
			urlParameters["a"] = "updateNickname"
			
			bodyParameters["token"] = App.user.sessid
			bodyParameters["text"] = text
		
			case let .updateGender(text):
			urlParameters["c"] = "chat"
			urlParameters["a"] = "updateGender"
			
			bodyParameters["token"] = App.user.sessid
			bodyParameters["text"] = text
		case .platformAlert(type: let type, page: let page, pageSize: let pageSize):
			urlParameters["c"] = "chat"
			urlParameters["a"] = "platformAlert"
			
			bodyParameters["token"] = App.user.sessid
			bodyParameters["type"] = type
			bodyParameters["page"] = page
			bodyParameters["rows"] = pageSize
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
