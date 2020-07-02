//
//  MessageModel.swift
//  ug
//
//  Created by xionghx on 2019/11/18.
//  Copyright © 2019 ug. All rights reserved.
//

import Foundation
import MessageKit
import ObjectMapper
import YYImage
import YYText

class MessageModel: Mappable, MessageType {
	
	var isChatWin = 0
	var code = ""
	var roomId = ""
	var username = ""
	var msg = ""
	var betModel: BetModel?
	var time = ""
	var uid = ""
	var avator = ""
	var t: TimeInterval = 0
	var isManager = false
	var level = 0
	var data_type = ""  //image: 图片
	var chat_type = 0  //0: 普通，1: 私聊
	var receiveTime = 0
	var messageCode = ""
	var betFollowFlag = 0
	var betUrl: BetModel?
	var redBag: RedpacketModel?
	
	
	var sender: SenderType {
		return Sender(senderId: uid, displayName: username)
	}
	
	var messageId: String {
		return messageCode
	}
	
	var sentDate: Date {
		return Date(timeIntervalSince1970: TimeInterval(t))
	}
	
	var kind: MessageKind = .text("")
	
	required init?(map: Map) {
		
	}
	
	func mapping(map: Map) {
		
		isChatWin <- map["isChatWin"]
		code <- map["code"]
		roomId <- map["roomId"]
		username <- map["username"]
		msg <- map["msg"]
		betModel <- map["msgJson"]
		time <- map["time"]
		uid <- map["uid"]
		avator <- map["avator"]
		t <- (map["t"], doubleTransform)
		isManager <- map["isManager"]
		level <- map["level"]
		data_type <- map["data_type"]
		chat_type <- map["chat_type"]
		
		messageCode <- map["messageCode"]
		betFollowFlag <- map["betFollowFlag"]
		betUrl <- map["betUrl"]
		redBag <- map["redBag"]

		
		if data_type == "image" {
			kind = .photo(ChatPhoto(url: URL(string: msg), image: nil, placeholderImage: UIImage(color: UIColor.red, size: CGSize(width: 40, height: 40))!, size: CGSize(width: 200, height: 200)))
		}
		else if data_type == "redBag" {
			kind = .custom(redBag)
		}
		else if betFollowFlag == 1 {
//			kind = .text(msgJson.replacingOccurrences(of: "\\n", with: "\n").replacingOccurrences(of: "\\t", with: "").replacingOccurrences(of: "\t", with: ""))
//			kind = .text(msg.replacingOccurrences(of: "\\n", with: "\n").replacingOccurrences(of: "\\t", with: "").replacingOccurrences(of: "\t", with: ""))
			kind = .custom(betModel)
		}
		else {
			let mutableAttributedString = NSMutableAttributedString(string: msg)
			let pattern = RegexParser.emoticon.pattern
			let range = NSRange(location: 0, length: msg.count)
			let matches = RegexParser.getElements(from: msg, with: pattern, range: range)
			
			guard matches.count > 0 else {
				kind = .text(msg)
				return
			}
			for match in matches.reversed() {
				let emojiBundlePath = Bundle.main.path(forResource: "Emoji", ofType: "bundle")!
				let word = (((msg as NSString).substring(with: match.range) as NSString).replacingOccurrences(of: "[em_", with: "") as NSString).replacingOccurrences(of: "]", with: "")
				let emojiFilePath = Bundle(path: emojiBundlePath)!.path(forResource: word, ofType: "gif", inDirectory: "Resource")!
				
//				let emojiData = try! Data(contentsOf: URL(fileURLWithPath: emojiFilePath))
//				let yyImage = YYImage(data: emojiData)!
//				yyImage.preloadAllAnimatedImageFrames = true
//				let yyImageView = YYAnimatedImageView(image: yyImage)
//				let yyAttachText = NSMutableAttributedString.yy_attachmentString(withContent: yyImageView, contentMode: .center, attachmentSize: yyImageView.frame.size, alignTo: UIFont.preferredFont(forTextStyle: .body), alignment: .center)
//
//				mutableAttributedString.replaceCharacters(in: match.range, with: yyAttachText)
				
				
				
				mutableAttributedString.replaceCharacters(in: match.range, with: NSAttributedString(attachment: EmoticonAttachment(emoticon: .gif(filePath: emojiFilePath))))
			}
//			kind = .custom(GifText(attributedString: mutableAttributedString))
				kind = .attributedText(mutableAttributedString.x.font(UIFont.preferredFont(forTextStyle: .body)))
			
			
		}
	}
	
	var chartType: ChatType {
		
		if isChatWin == 0 {
			return .privat(uid: uid, userName: username)
		}
		if chat_type == 0 {
			return .room(roomid: roomId, roomName: "")
		} else {
			return .privat(uid: uid, userName: username)
		}
	}
	
}

struct Sender: SenderType {
	var senderId: String
	var displayName: String
	
}

struct Room {
	var roomId: Int
	var roomName: String
	var redpacketConfig: RedpacketSettingModel
	var minepacketConfig: MinepacketSettingModel
	init(conversation: UGConversationModel) {
		roomId = conversation.roomId
		roomName = conversation.roomName
		redpacketConfig = conversation.chatRedBagSetting
		minepacketConfig = conversation.minepacketSetting
	}
	
}

struct ChatPhoto: MediaItem {
	var url: URL?
	
	var image: UIImage?
	
	var placeholderImage: UIImage
	
	var size: CGSize
	
}


struct GifText {
	let attributedString: NSAttributedString
}
protocol RedpacketSenderType: SenderType {
	var avatar: String { get }
}
