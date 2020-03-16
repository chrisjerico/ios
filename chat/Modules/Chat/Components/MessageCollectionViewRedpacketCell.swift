//
//  MessageCollectionViewRedpacketCell.swift
//  ug
//
//  Created by xionghx on 2019/12/7.
//  Copyright © 2019 ug. All rights reserved.
//

import UIKit
import MessageKit

class MessageCollectionViewRedpacketCell: MessageContentCell {
	
	
	lazy var packetTitleLable: UILabel = {
		let label = UILabel()
		label.textColor = .white
		label.font = UIFont.boldSystemFont(ofSize: 14)
		
		return label
	}()
	
	lazy var packetHandleLable: UILabel = {
		let label = UILabel()
		label.textColor = .white
		label.font = UIFont.boldSystemFont(ofSize: 14)
		
		return label
	}()
	
	open override func setupSubviews() {
		super.setupSubviews()
		messageContainerView.addSubview(packetTitleLable)
		packetTitleLable.snp.makeConstraints { (make) in
			make.top.equalToSuperview().offset(10)
			make.left.equalToSuperview().offset(50)
			make.right.equalToSuperview().offset(-10)
		}
		
		messageContainerView.addSubview(packetHandleLable)
		packetHandleLable.snp.makeConstraints { (make) in
			make.top.equalTo(packetTitleLable.snp.bottom).offset(5)
			make.left.right.equalTo(packetTitleLable)
		}
		
	}
	
	open override func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
		super.configure(with: message, at: indexPath, and: messagesCollectionView)
		guard
			case let .custom(any) = message.kind,
			let redpacket = any as? RedpacketModel,
			let messageDataSource = messagesCollectionView.messagesDataSource
			else
		{
			return
		}
		messageContainerView.style = .custom { [weak self] iamgeView in
			guard let weakSelf = self else {
				return
			}
			if redpacket.genre == "2" {
				iamgeView.image = messageDataSource.isFromCurrentSender(message: message) ?  UIImage(named: "slhb_s") : UIImage(named: "slhb_r")
			} else if redpacket.genre == "1" {
				iamgeView.image = messageDataSource.isFromCurrentSender(message: message) ?  UIImage(named: "pthb_s") : UIImage(named: "pthb_r")
			}
			iamgeView.backgroundColor = UIColor.clear
			
			
			if redpacket.status == 1 {
				weakSelf.packetHandleLable.text = "点击领取"
				iamgeView.layer.opacity = 1.0
				
			} else if redpacket.status == 2 {
				weakSelf.packetHandleLable.text = "红包已抢完"
				iamgeView.layer.opacity = 0.5

			} else if redpacket.status == 3 {
				weakSelf.packetHandleLable.text = "红包已过期"
				iamgeView.layer.opacity = 0.5

			} else {
				weakSelf.packetHandleLable.text = "红包状态:\(redpacket.status)"
				iamgeView.layer.opacity = 0.5

			}
		}
		packetTitleLable.text = redpacket.title
		
	}
//	override func handleTapGesture(_ gesture: UIGestureRecognizer) {
//		
//	}
	
}

public class RedpacketMessageSizeCalculator: MessageSizeCalculator {
	
//	open override func configure(attributes: UICollectionViewLayoutAttributes) {
//		super.configure(attributes: attributes)
//		guard let attributes = attributes as? MessagesCollectionViewLayoutAttributes else { return }
//		attributes.avatarSize = CGSize(width: 40, height: 40)
//		
//	}
	
	open override func messageContainerSize(for message: MessageType) -> CGSize {
		return CGSize(width: 200, height: 80)
	}
	
	
}
