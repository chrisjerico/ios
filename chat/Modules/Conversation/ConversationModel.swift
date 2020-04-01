//
//  ConversationModel.swift
//  ug
//
//  Created by xionghx on 2019/11/18.
//  Copyright © 2019 ug. All rights reserved.
//

import Foundation
import MessageKit

struct ConversationModel {
	var chatType: ChatType
	var lastMessage: MessageModel
}


enum ChatType {
	case room(roomid: String, roomName: String)
	case privat(uid: String, userName: String)
}

extension UGUserModel: SenderType {
	public var senderId: String {
		return userId
	}
	
	public var displayName: String {
		return username
	}
	
	
}
