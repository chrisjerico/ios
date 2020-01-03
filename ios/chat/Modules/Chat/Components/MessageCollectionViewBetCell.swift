//
//  MessageCollectionViewBetCell.swift
//  ug
//
//  Created by xionghx on 2019/11/21.
//  Copyright © 2019 ug. All rights reserved.
//

import Foundation
import MessageKit

protocol MessageCollectionViewBetCellDelegate: NSObject {
	func didTapBetFollowButton(with item: BetModel)
}


public class MessageCollectionViewBetCell: MessageContentCell {
	
	weak var betDelegate: MessageCollectionViewBetCellDelegate?
	
	lazy var betView: BetMessageContentView = {
		return Bundle.main.loadNibNamed("BetMessageContentView", owner: self, options: nil)?.first as! BetMessageContentView
	}()
	var betModel: BetModel?

	// MARK: - Methods
	open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
		super.apply(layoutAttributes)
		
	}
	
	open override func prepareForReuse() {
		super.prepareForReuse()
		betView.betBeansView.subviews.forEach{ $0.removeFromSuperview() }
		
	}
	
	open override func setupSubviews() {
		super.setupSubviews()
		addSubview(betView)
		betView.snp.makeConstraints { (make) in
			make.edges.equalTo(messageContainerView)
//			make.edges.equalToSuperview()
		}
	}
	
	open override func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
		
		super.configure(with: message, at: indexPath, and: messagesCollectionView)
		guard
			case let .custom(any) = message.kind,
			let betModel = any as? BetModel
			else
		{
			return
		}
		self.betModel = betModel
		betView.bind(item: betModel)
		
		
	}
	open override func cellContentView(canHandle touchPoint: CGPoint) -> Bool {
		if betView.handleButton.frame.contains(touchPoint), let betModel = betModel, let betDelegate = betDelegate {
			betDelegate.didTapBetFollowButton(with: betModel)
			return true
		} else {
			return false
		}
  }

}


public class BetMessageSizeCalculator: MessageSizeCalculator {
	
	open override func configure(attributes: UICollectionViewLayoutAttributes) {
		super.configure(attributes: attributes)
		guard let attributes = attributes as? MessagesCollectionViewLayoutAttributes else { return }
		attributes.avatarSize = CGSize(width: 40, height: 40)
		
	}
	
	open override func messageContainerSize(for message: MessageType) -> CGSize {
		let maxWidth = messageContainerMaxWidth(for: message)
		
		guard
			case let .custom(any) = message.kind,
			let betModel = any as? BetModel
			else
		{
			return CGSize.zero
		}
		
		return CGSize(width: maxWidth, height: CGFloat(120 + 50*betModel.betBeans.count))
	}
	
	
}
