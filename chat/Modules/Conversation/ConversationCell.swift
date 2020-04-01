//
//  ConversationCell.swift
//  ug
//
//  Created by xionghx on 2019/11/18.
//  Copyright © 2019 ug. All rights reserved.
//

import Foundation

class ConversationCell: UITableViewCell {
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupSubView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	lazy var iconImage: UIImageView = {
		let imageView = UIImageView()
		
		return imageView
	}()
	
	lazy var titleLable: UILabel = {
		let label = UILabel()
		label.textColor = UIColor(hex: "292b2e")
		label.font = UIFont.systemFont(ofSize: 18)
		
		return label
	}()
	lazy var subTitleLable: UILabel = {
		let label = UILabel()
		label.textColor = UIColor(hex:"909399")
		label.font = UIFont.systemFont(ofSize: 14)
		label.lineBreakMode = NSLineBreakMode.byTruncatingTail
		
		return label
	}()
	lazy var timeLabel: UILabel = {
		let label = UILabel()
		label.textColor = UIColor(hex:"909399")
		label.font = UIFont.systemFont(ofSize: 14)

		return label
		
		
	}()
	
	
	func setupSubView() {
		let lineMaker = { () -> UIView in
			let view = UIView()
			view.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
			return view
		}
		
		let line = lineMaker()
		
		addSubview(line)
		
		addSubview(iconImage)
		iconImage.snp.makeConstraints { (make) in
			make.width.height.equalTo(40)
			make.top.equalTo(self).offset(5)
			make.left.equalToSuperview().offset(15)
		}
		addSubview(titleLable)
		titleLable.snp.makeConstraints { (make) in
			make.left.equalTo(iconImage.snp.right).offset(8)
			make.top.equalTo(iconImage)
		}
		
		addSubview(subTitleLable)
		subTitleLable.snp.makeConstraints { (make) in
			make.left.equalTo(iconImage.snp.right).offset(8)
			make.bottom.equalTo(iconImage)
			make.right.equalToSuperview().offset(-15)
		}
				
		addSubview(line)
		line.snp.makeConstraints { (make) in
			make.left.right.equalToSuperview()
			make.top.equalTo(iconImage.snp.bottom).offset(15)
			make.height.equalTo(0.5)
			make.bottom.equalToSuperview()
		}
		addSubview(timeLabel)
		timeLabel.snp.makeConstraints { (make) in
			make.right.equalToSuperview().offset(-15)
			make.bottom.equalTo(titleLable)
		}
		
	}
	
	
	
	func bind(item: UGConversationModel)  {
		
		
		
		var content = ""
		var senderName = ""
		if let message = item.lastMessageInfo, case .photo = message.kind {
			content = "[图片]"
			senderName = message.displayName
		} else if let message = item.lastMessageInfo, case let .custom(item) = message.kind, let reppacket = item as? RedpacketModel {
			content = reppacket.genre == "2" ? "[扫雷红包]": "[红包]"
			senderName = message.displayName
		}else if let message = item.lastMessageInfo {
			content = message.msg
			senderName = message.displayName

		}
		
		switch item.chatType {
		case .room:

			titleLable.text = item.roomName
			iconImage.image = UIImage(named: "qm")
			subTitleLable.text = "\(senderName): \(content)"
			
		case let .privat(_, userName):
			titleLable.text = userName
			subTitleLable.text = content
			if let lastMessage = item.lastMessageInfo, let url = URL(string: lastMessage.avator) {
				iconImage.kf.setImage(with: url)
			} else {
				iconImage.image = UIImage(named: "gly")
			}
		}
		timeLabel.text = item.lastMessageInfo?.time
		
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(false, animated: true)
	}
}
