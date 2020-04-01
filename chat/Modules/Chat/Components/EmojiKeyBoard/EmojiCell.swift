//
//  EmojiCell.swift
//  XiaoJir
//
//  Created by xionghx on 2018/11/9.
//  Copyright © 2018 xionghx. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftGifOrigin

public enum EmoticonType {
	case emoji(text: String)
	case image(image: UIImage)
	case gif(filePath: String)
}
extension EmoticonType {
	func description() -> String {
		switch self {
		case let .emoji(text):
			return text
		case let .gif(filePath):
			let fileName = ((filePath as NSString).lastPathComponent as NSString).deletingPathExtension
			return "[em_\(fileName)]"
		case .image:
			return "[图像]"
		}
	}
}

public class EmoticonAttachment: NSTextAttachment {
	var emoticon: EmoticonType
	init(emoticon: EmoticonType) {
		self.emoticon = emoticon
		
		switch emoticon {
		case let .emoji(text):
			super.init(data: nil, ofType: nil)
		case let .gif(filePath):
			let data = try! Data(contentsOf: URL(fileURLWithPath: filePath))
			//			super.init(data: data, ofType:"com.compuserve.gif")
			super.init(data: data, ofType:"public.image")
			
		default:
			super.init(data: nil, ofType: nil)
			
			break
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}


internal class EmojiCell: UICollectionViewCell {
	internal override func layoutSubviews() {
		super.layoutSubviews()
		setupSubView()
	}
	private func setupSubView() {
		backgroundColor = UIColor.clear
		contentView.addSubview(displayView)
		displayView.snp.makeConstraints { (make) in
			make.center.equalToSuperview()
		}
		contentView.addSubview(imageView)
		imageView.snp.makeConstraints { (make) in
			make.center.equalToSuperview()
		}
	}
	private lazy var displayView: UITextView = {
		let view = UITextView()
		view.isEditable = false
		view.backgroundColor = UIColor.clear
		view.font = UIFont.systemFont(ofSize: 30)
		view.isScrollEnabled = false
		view.isUserInteractionEnabled = false
		return view
	}()
	
	private lazy var imageView: UIImageView = {
		let view = UIImageView()
		view.contentMode = .center
		return view
	}()
	
	internal func bindData(emoji: EmoticonType) {
		switch emoji {
		case let .emoji(text):
			displayView.text = text
			imageView.isHidden = true
			displayView.isHidden = false
		case let .image(image):
			imageView.image = image
			displayView.isHidden = true
			imageView.isHidden = false
		case .gif(let filePath):
			let data = try! Data(contentsOf: URL(fileURLWithPath: filePath))
			imageView.image = UIImage.gif(data: data)
			displayView.isHidden = true
			imageView.isHidden = false
		}
//		if case let .gif(filePath) = emoji {
//			displayView.attributedText = NSAttributedString(attachment: EmoticonAttachment(emoticon: .gif(filePath: filePath)))
//			imageView.isHidden = true
//			displayView.isHidden = false
//		}
		
	}
}
