//
//  SocketManager.swift
//  ug
//
//  Created by xionghx on 2019/10/21.
//  Copyright © 2019 ug. All rights reserved.
//

import Foundation
import Starscream
import Alamofire
import RxSwift
import RxCocoa
import ObjectMapper

public class SocketManager: NSObject {
	public var shouldReconnect = true
	public let connectStatus = BehaviorRelay<SocketConnectStatus>(value: .unknow)
	private var socket: WebSocket?
	static private func initialSocket(isReload: Int = 0) -> WebSocket? {
		guard UGLoginIsAuthorized() else {
			return nil
		}
		let user = UGUserModel.currentUser()
		let url: URL = URL(string: "ws://test03.6yc.com:811?loginsessid=\(user.sessid)&logintoken=\(user.token)&channel=2&isReload=\(isReload)&isSelectRoom=0")!
		let socket: WebSocket = WebSocket(url: url)
		return socket
	}
	
	
	@objc
	static let shared = SocketManager()
	public enum SocketConnectStatus {
		case unknow
		case connected
		case disConneted
	}
	
	public override init() {
		
		super.init()
		
		Reachability.shared.status.subscribe(onNext: { [weak self] (status) in
			logger.debug("network changed \(status)")
			guard
				case .reachable = status,
				let weakSelf = self
				else {
					return
			}
			if weakSelf.shouldReconnect { weakSelf.connect() }

		}).disposed(by: disposeBag)
		
		
	}
	
	@objc
	public func connect(isReload: Int = 1) {
		guard let socket = SocketManager.initialSocket(isReload: isReload) else {
			return
		}
		shouldReconnect = true
		
		socket.delegate = self
		socket.connect()
		self.socket = socket
	}
	
	public func disconnect() {
		shouldReconnect = false
		socket?.disconnect()
	}
	
	
	public func send(_ message: [String: Any]) {
		logger.debug("will send: \(message)")
		guard let data = try? JSONSerialization.data(withJSONObject: message, options: []) else {
			fatalError("message cannot be converted to data")
		}
		socket?.write(data: data)
	}
	
	
}

extension SocketManager: WebSocketDelegate {
	
	public func websocketDidConnect(socket: WebSocketClient) {
		
		connectStatus.accept(.connected)
	}
	
	public func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
		
		connectStatus.accept(.disConneted)
		
		if shouldReconnect {
			DispatchAfter(after: 3) { [unowned self] in
				self.connect()
			}
		} else {
			logger.debug("socket disconnect: \(error.debugDescription)")
			
		}
		
	}
	
	public func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
		
		guard
			text.count > 0,
			let data = text.data(using: .utf8),
			let dic = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any]
			else
		{
			fatalError("message cannot be converted to dic")
		}
		
		guard
			let codeString = dic["code"] as? String,
			let code = Int(codeString)
			else {
				return
		}
		
		switch code {
		case ...0:
			MessageManager.shared.newError.accept(dic)
		case 1:
			MessageManager.shared.newMessage.accept(dic)
		default:
			MessageManager.shared.newNotification.accept(dic)
		}
		
		logger.debug(dic)
		
	}
	
	public func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
		logger.debug(data)
		
	}
	
}
