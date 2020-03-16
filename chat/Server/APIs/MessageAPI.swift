//
//  MessageAPI.swift
//  XiaoJir
//
//  Created by xionghx on 2018/12/11.
//  Copyright © 2018 xionghx. All rights reserved.
//

import Moya
import ObjectMapper



/// RESTMessage相关API
public let messageAPI = APIProvider(endpointClosure: { (target: MessageTarget) -> Endpoint in
	return MoyaProvider.defaultEndpointMapping(for: target)
}, requestClosure: { (endpoint: Endpoint, closure: MoyaProvider.RequestResultClosure) in
	if var request = try? endpoint.urlRequest() {
		request.timeoutInterval = appEnv.timeout
		closure(.success(request))
	}
}, plugins: [APILogger.default])

// MARK: - APIs

public enum MessageTarget {
	
	/// 获取所有通知
	case feedNotifications
	
	/// 设置通知已读
	case markNotificationRead(notificationId: String)
	
	/// 删除
	case delete(notificationId: String)
	
	/// 获取聊天列表
	case conversation
	
	/// 聊天记录
	case history(conversationID: String, lastMsgID: String?, num: Int)
	
	/// 设置聊天消息已读
	case markConversationRead(conversionId: String)
	
	
}

// MARK: - TargetType

extension MessageTarget: RequestTargetType {
	
	public var baseURL: URL {
		return appEnv.baseUrl
	}
	
	public var path: String {
		switch self {
		
		case .feedNotifications:
			return "v1/notifications"
		case .markNotificationRead(let notificationId):
			return "v1/notifications/\(notificationId)"

		case .delete(let notificationId):
			return "v1/notifications/\(notificationId)"
		case .conversation:
			return "v1/messages/conversation"
		case .history:
			return "v1/messages/history"
		case .markConversationRead:
			return "v1/messages/read"
		}
	}
	
	public var method: Moya.Method {
		switch self {
			
		case .feedNotifications:
			return .get
		case .markNotificationRead:
			return .patch
		case .delete:
			return .delete
		case .conversation:
			return .get
		case .history:
			return .get
		case .markConversationRead:
			return .post
		}
	}
	
	public var encrypt: Bool {
		return false
	}
	

	public var options: CommonParameters {
		return [.token]
	}
	
	public var urlParameters: [String: Any] {
		
		if case let .history(conversationID, lastMsgID, num) = self {
			
			var parameters = [String: Any]()
			parameters["to_profile"] = conversationID
			parameters["num"] = num
			if let lastID = lastMsgID {
				parameters["last_msg_id"] = lastID

			}
			return parameters
		}
		return [:]
	}
	
	public var bodyParameters: [String: Any] {
		
		var parameters = [String: Any]()
		
		switch self {

		case .feedNotifications, .markNotificationRead, .delete, .conversation, .history:
			break
		case let .markConversationRead(conversionId):
			parameters["conversation_id"] = conversionId
		}
		
		return parameters
	}
	
}
