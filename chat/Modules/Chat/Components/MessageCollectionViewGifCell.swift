//
//  MessageCollectionViewGifCell.swift
//  ug
//
//  Created by xionghx on 2019/11/27.
//  Copyright © 2019 ug. All rights reserved.
//

import Foundation
import MessageKit
import YYText

public class YYMessageLabel: YYLabel {
//	weak var delegate: MessageCellDelegate?
}


public class MessageCollectionViewGifCell: MessageContentCell {
	
	// MARK: - Properties
	
	// The `MessageCellDelegate` for the cell.
//	open override weak var delegate: MessageCellDelegate? {
//		didSet {
//			messageLabel.delegate = delegate
//		}
//	}
//	
	/// The label used to display the message's text.
	open var messageLabel = YYMessageLabel()
	
	// MARK: - Methods
	
	open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
		super.apply(layoutAttributes)
		if let attributes = layoutAttributes as? MessagesCollectionViewLayoutAttributes {
			messageLabel.frame = messageContainerView.bounds
			messageLabel.numberOfLines = 0
			messageLabel.textContainerInset = attributes.messageLabelInsets

		}
	}
	
	open override func prepareForReuse() {
		super.prepareForReuse()
		messageLabel.attributedText = nil
		messageLabel.text = nil
	}
	
	open override func setupSubviews() {
		super.setupSubviews()
		messageContainerView.addSubview(messageLabel)

	}
	
	open override func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
		super.configure(with: message, at: indexPath, and: messagesCollectionView)
		
		guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
			fatalError("MessageKitError.nilMessagesDisplayDelegate")
		}
		
		
		guard case let .custom(any) = message.kind, let gifText = any as? GifText else {
			return
		}
		
		let textColor = displayDelegate.textColor(for: message, at: indexPath, in: messagesCollectionView)

		let font = UIFont.preferredFont(forTextStyle: .body)
		messageLabel.attributedText = NSMutableAttributedString(attributedString: gifText.attributedString).x.font(font).x.color(textColor)
	}
	
	
	
}


public class GifMessageSizeCalculator: MessageSizeCalculator {
	
	public var incomingMessageLabelInsets = UIEdgeInsets(top: 7, left: 18, bottom: 7, right: 14)
	public var outgoingMessageLabelInsets = UIEdgeInsets(top: 7, left: 14, bottom: 7, right: 18)
	
	public var messageLabelFont = UIFont.preferredFont(forTextStyle: .body)
	
	internal func messageLabelInsets(for message: MessageType) -> UIEdgeInsets {
		let dataSource = messagesLayout.messagesDataSource
		let isFromCurrentSender = dataSource.isFromCurrentSender(message: message)
		return isFromCurrentSender ? outgoingMessageLabelInsets : incomingMessageLabelInsets
	}
	
	open override func messageContainerMaxWidth(for message: MessageType) -> CGFloat {
		let maxWidth = super.messageContainerMaxWidth(for: message)
		let textInsets = messageLabelInsets(for: message)
		return maxWidth - textInsets.horizontal
	}
	
	open override func messageContainerSize(for message: MessageType) -> CGSize {
		let maxWidth = messageContainerMaxWidth(for: message)
		
		var messageContainerSize: CGSize
		guard case let .custom(any) = message.kind, let gifText = any as? GifText else {
			return CGSize.zero
		}
		let attributedText = gifText.attributedString
		
		messageContainerSize = labelSize(for: attributedText, considering: maxWidth)
		
		let messageInsets = messageLabelInsets(for: message)
		messageContainerSize.width += messageInsets.horizontal
		messageContainerSize.height += messageInsets.vertical
		
		return messageContainerSize
	}
	
	open override func configure(attributes: UICollectionViewLayoutAttributes) {
		super.configure(attributes: attributes)
		guard let attributes = attributes as? MessagesCollectionViewLayoutAttributes else { return }
		
		let dataSource = messagesLayout.messagesDataSource
		let indexPath = attributes.indexPath
		let message = dataSource.messageForItem(at: indexPath, in: messagesLayout.messagesCollectionView)
		
		attributes.messageLabelInsets = messageLabelInsets(for: message)
		attributes.messageLabelFont = messageLabelFont
		attributes.avatarSize = CGSize(width: 40, height: 40)

	}
	internal func labelSize(for attributedText: NSAttributedString, considering maxWidth: CGFloat) -> CGSize {
		let constraintBox = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
		guard let layout = YYTextLayout(containerSize: constraintBox, text: attributedText) else { return CGSize.zero }
		return layout.textBoundingSize
		
	}
	
}


internal extension UIEdgeInsets {
	
	var vertical: CGFloat {
		return top + bottom
	}
	
	var horizontal: CGFloat {
		return left + right
	}
	
}
