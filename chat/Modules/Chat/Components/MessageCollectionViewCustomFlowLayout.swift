//
//  MessageCollectionViewCustomFlowLayout.swift
//  ug
//
//  Created by xionghx on 2019/12/7.
//  Copyright © 2019 ug. All rights reserved.
//

import Foundation
import MessageKit

public class MessageCollectionViewCustomFlowLayout: MessagesCollectionViewFlowLayout {
	public override init() {
		super.init()
		
		setMessageIncomingAvatarSize(CGSize(width: 40, height: 40))
		setMessageOutgoingAvatarSize(CGSize(width: 40, height: 40))
		
		setMessageIncomingAvatarPosition(AvatarPosition(horizontal: AvatarPosition.Horizontal.cellLeading, vertical: .messageTop))
		setMessageOutgoingAvatarPosition(AvatarPosition(horizontal: AvatarPosition.Horizontal.cellTrailing, vertical: .messageTop))
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	open lazy var gifMessageSizeCalculator = GifMessageSizeCalculator(layout: self)
	open lazy var redpacketMessageSizeCalculator = RedpacketMessageSizeCalculator(layout: self)
	open lazy var betMessageSizeCalculator = BetMessageSizeCalculator(layout: self)

	
	open override func cellSizeCalculatorForItem(at indexPath: IndexPath) -> CellSizeCalculator {
		if isSectionReservedForTypingIndicator(indexPath.section) {
			return typingIndicatorSizeCalculator
		}
		let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
		guard case let .custom(any) = message.kind else {
			return super.cellSizeCalculatorForItem(at: indexPath)
		}
		
		if let _ = any as? GifText {
			return gifMessageSizeCalculator
		} else if let _ = any as? RedpacketModel {
			return redpacketMessageSizeCalculator
		} else if let _ = any as? BetModel {
			return betMessageSizeCalculator
		} else {
			fatalError("unsported kind")
		}
	}
	
	open override func messageSizeCalculators() -> [MessageSizeCalculator] {
		var superCalculators = super.messageSizeCalculators()
		// Append any of your custom `MessageSizeCalculator` if you wish for the convenience
		// functions to work such as `setMessageIncoming...` or `setMessageOutgoing...`
		superCalculators.append(gifMessageSizeCalculator)
		superCalculators.append(redpacketMessageSizeCalculator)
		superCalculators.append(betMessageSizeCalculator)

		
		return superCalculators
	}
}
