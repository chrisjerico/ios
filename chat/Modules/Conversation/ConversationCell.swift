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
	private lazy var badgeLabel: MarginLabel = {
		let label = MarginLabel()
		label.backgroundColor = UIColor.red
		label.layer.cornerRadius = 7.5
		label.layer.borderColor = UIColor.white.cgColor
		label.layer.borderWidth = 1
		label.layer.masksToBounds = true
		label.textColor = UIColor.white
		label.font = UIFont.systemFont(ofSize: 11)
		label.textAlignment = .center
		label.contentInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
		return label
		
	}()
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
//		let lineMaker = { () -> UIView in
//			let view = UIView()
//			view.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
//			return view
//		}
//
//		let line = lineMaker()
		
//		addSubview(line)
		addSubview(iconImage)
		iconImage.snp.makeConstraints { (make) in
			make.width.height.equalTo(40)
			make.top.equalTo(self).offset(10)
			make.left.equalToSuperview().offset(15)
			make.centerY.equalToSuperview()
		}
		addSubview(titleLable)
		titleLable.snp.makeConstraints { (make) in
			make.left.equalTo(iconImage.snp.right).offset(8)
			make.top.equalTo(iconImage)
			make.right.equalTo(self).offset(-60)
		}
		
		addSubview(subTitleLable)
		subTitleLable.snp.makeConstraints { (make) in
			make.left.equalTo(iconImage.snp.right).offset(8)
			make.bottom.equalTo(iconImage)
			make.right.equalToSuperview().offset(-15)
		}
				
//		addSubview(line)
//		line.snp.makeConstraints { (make) in
//			make.left.right.equalToSuperview()
//			make.top.equalTo(iconImage.snp.bottom).offset(15)
//			make.height.equalTo(0.5)
//			make.bottom.equalToSuperview()
//		}
		addSubview(timeLabel)
		timeLabel.snp.makeConstraints { (make) in
			make.right.equalToSuperview().offset(-15)
			make.bottom.equalTo(titleLable)
		}
		addSubview(badgeLabel)
		badgeLabel.snp.makeConstraints { (make) in
			make.centerX.equalTo(iconImage).offset(20/1.414)
			make.centerY.equalTo(iconImage).offset(-20/1.414)
			make.width.height.greaterThanOrEqualTo(15)

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
				iconImage.kf.setImage(with: url, placeholder: UIImage(named: "gly"))
			} else {
				iconImage.image = UIImage(named: "gly")
			}
		}
		timeLabel.text = item.lastMessageInfo?.t.x.timeTomCurrent
		badgeLabel.text = item.unreadCount > 0 ?"\(item.unreadCount)" : ""
		badgeLabel.isHidden = item.unreadCount == 0
//		badgeLabel.text = "99"

	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(false, animated: true)
	}
}

class MarginLabel: UILabel {
    
    var contentInset: UIEdgeInsets = .zero
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
		var rect: CGRect = super.textRect(forBounds: bounds.inset(by: contentInset), limitedToNumberOfLines: numberOfLines)
        rect.origin.x -= contentInset.left;
        rect.origin.y -= contentInset.top;
        rect.size.width += contentInset.left + contentInset.right;
        rect.size.height += contentInset.top + contentInset.bottom;
        return rect
    }
    
    override func drawText(in rect: CGRect) {
		super.drawText(in: rect.inset(by: contentInset))
    }
}
