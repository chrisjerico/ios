//
//  CheckRedpacketView.swift
//  ug
//
//  Created by xionghx on 2019/12/8.
//  Copyright © 2019 ug. All rights reserved.
//

import Foundation

protocol CheckRedpacketViewDelegate: NSObject, ViewDisapearDelegate {
	func checkRedpacketCheckButtonTaped(sender: RedpacketSender, redpacketId: String)
	func grabButtonTaped(view:CheckRedpacketView, redpacketId: String)
}


class CheckRedpacketView: UIView {
	var layoutConfig: Config
	private var item: RedpacketModel?
	private var sender: RedpacketSender?
	weak var delegate: CheckRedpacketViewDelegate?
	init(_ layoutConfig: Config = Config()) {
		self.layoutConfig = layoutConfig
		super.init(frame: CGRect.zero)
		setupSubView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	lazy var avatarImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.layer.cornerRadius = layoutConfig.avatarSize.height/2
		imageView.layer.masksToBounds = true
		return imageView
	}()
	
	lazy var nameLabel: UILabel = {
		let label = UILabel()
		label.textColor = UIColor(hex: "#f9d32f")
		label.font = UIFont.boldSystemFont(ofSize: 18)
		
		return label
	}()
	
	lazy var desLabel: UILabel = {
		let label = UILabel()
		label.textColor = UIColor(hex: "#f9d32f")
		label.font = UIFont.systemFont(ofSize: 16)
		return label
		
	}()
	lazy var amountLabel: UILabel = {
		let label = UILabel()
		label.textColor = UIColor(hex: "#f9d32f")
		label.font = UIFont.boldSystemFont(ofSize: 18)
		return label
		
	}()
	
	lazy var grabButton: UIButton = {
		let button = UIButton(type: .custom)
		button.setImage(UIImage(named: "kai"), for: .normal)
		button.rx.tap.subscribe(onNext: {[weak self]  () in
			guard let item = self?.item, let weakSelf = self else { return }
			self?.delegate?.grabButtonTaped(view: weakSelf, redpacketId: item.id)
		}).disposed(by: disposeBag)
		return button
	}()
	
	lazy var grabButton_copy: UIButton = {
		let button = UIButton(type: .custom)
		button.setImage(UIImage(named: "kai"), for: .normal)
		
		return button
	}()
	lazy var checkButton: UIButton = {
		let button = UIButton(type: .custom)
		button.setAttributedTitle("看看大家的手气 〉".mutableAttributedString().x.color(UIColor(hex: "#f9d32f")).x.fontSize(14), for: .normal)
		button.rx.tap.subscribe(onNext: { [weak self] () in
			guard let item = self?.item, let sender = self?.sender else { return }
			self?.delegate?.checkRedpacketCheckButtonTaped(sender: sender, redpacketId: item.id)
		}).disposed(by: disposeBag)
		return button
		
	}()
	struct Config {
		var avatarSize: CGSize = CGSize(width: 60, height: 60)
	}
	
	func setupSubView() {
		
		backgroundColor = UIColor.white.withAlphaComponent(0.5)
		//		let backDropView = UIImageView(image: UIImage(named: "hongbaobeijing_kai"))
		let backDropView = UIImageView(image: UIImage(named: "hongbaobeijing"))
		
		addSubview(backDropView)
		backDropView.snp.makeConstraints { (make) in
			make.center.equalToSuperview()
		}
		
		addSubview(avatarImageView)
		avatarImageView.snp.makeConstraints { (make) in
			make.centerX.equalToSuperview()
			make.top.equalTo(backDropView).offset(40)
			make.size.equalTo(layoutConfig.avatarSize)
		}
		
		addSubview(nameLabel)
		nameLabel.snp.makeConstraints { (make) in
			make.centerX.equalToSuperview()
			make.top.equalTo(avatarImageView.snp.bottom).offset(10)
		}
		
		addSubview(desLabel)
		desLabel.snp.makeConstraints { (make) in
			make.centerX.equalToSuperview()
			make.top.equalTo(nameLabel.snp.bottom).offset(10)
		}
		addSubview(amountLabel)
		amountLabel.snp.makeConstraints { (make) in
			make.centerX.equalToSuperview()
			make.top.equalTo(desLabel.snp.bottom).offset(15)
			
		}
		addSubview(grabButton_copy)
		addSubview(grabButton)
		grabButton.snp.makeConstraints { (make) in
			make.centerX.equalToSuperview()
			make.bottom.equalTo(backDropView).offset(-50)
		}
		grabButton_copy.snp.makeConstraints { (make) in
			make.edges.equalTo(grabButton)
		}
		
		
		addSubview(checkButton)
		checkButton.snp.makeConstraints { (make) in
			make.bottom.equalTo(backDropView).offset(-10)
			make.centerX.equalToSuperview()
		}
		
		let closeButton = UIButton(type: .custom)
		closeButton.setImage(UIImage(named: "guanbi_hongbao"), for: .normal)
		addSubview(closeButton)
		closeButton.snp.makeConstraints { (make) in
			make.right.equalTo(backDropView).offset(-15)
			make.top.equalTo(backDropView).offset(10)
		}
		
		closeButton.rx.tap.subscribe(onNext: { [weak self] () in
			self?.removeFromSuperview()
			self?.delegate?.viewDidDisapear()
		}).disposed(by: disposeBag)
		
		
	}
	
	func bind(item: RedpacketModel, sender: RedpacketSender) {
		self.item = item
		self.sender = sender
		avatarImageView.kf.setImage(with: URL(string: sender.avatar), placeholder: UIImage(named: "txp"))
		nameLabel.text = sender.displayName
		desLabel.text = "发了一个\(Int(item.genre) == 1 ? "普通": "扫雷" )红包"
		
		if item.is_grab == 1 {
			amountLabel.attributedText = item.grab_amount.mutableAttributedString().x.font(UIFont.boldSystemFont(ofSize: 30)).x.color(UIColor(hex: "#f9d32f"))
				+ "元".mutableAttributedString().x.fontSize(14).x.color(UIColor(hex: "#f9d32f"))
		} else if item.status == 2 {
			amountLabel.attributedText = "红包已抢完".mutableAttributedString().x.fontSize(16).x.color(UIColor(hex: "#f9d32f"))

		} else if item.status == 3 {
			amountLabel.attributedText = "红包已过期".mutableAttributedString().x.fontSize(16).x.color(UIColor(hex: "#f9d32f"))

		} else {
			amountLabel.attributedText = item.title.mutableAttributedString().x.fontSize(18).x.color(UIColor(hex: "#f9d32f"))
		}

		
		grabButton.isHidden = !(item.is_grab == 0 && item.status == 1)
		grabButton_copy.isHidden = !(item.is_grab == 0 && item.status == 1)
		
	}
	
	func update(item: RedpacketModel) {
		self.item = item
	
		if item.is_grab == 1 {
			amountLabel.attributedText = item.grab_amount.mutableAttributedString().x.font(UIFont.boldSystemFont(ofSize: 30)).x.color(UIColor(hex: "#f9d32f"))
				+ "元".mutableAttributedString().x.fontSize(14).x.color(UIColor(hex: "#f9d32f"))
		} else if item.status == 2 {
			amountLabel.attributedText = "红包已抢完".mutableAttributedString().x.fontSize(16).x.color(UIColor(hex: "#f9d32f"))

		} else if item.status == 3 {
			amountLabel.attributedText = "红包已过期".mutableAttributedString().x.fontSize(16).x.color(UIColor(hex: "#f9d32f"))

		} else {
			amountLabel.attributedText = item.title.mutableAttributedString().x.fontSize(18).x.color(UIColor(hex: "#f9d32f"))
		}
		
		grabButton.isHidden = !(item.is_grab == 0 && item.status == 1)
		grabButton_copy.isHidden = !(item.is_grab == 0 && item.status == 1)
		
	}
	
	func startGrabAnimation() {
		let duration = 1.0
		let count = 3
		let relativeDuration = 1.0/Double(count)
		UIView.animateKeyframes(withDuration: duration, delay: 0, options: [.repeat], animations: {
			(0...count).forEach { (index) in
				UIView.addKeyframe(withRelativeStartTime: 0 + relativeDuration * Double(index), relativeDuration: relativeDuration) { [weak self] in
					guard let weakSelf = self else { return }
					weakSelf.grabButton.layer.transform = CATransform3DMakeRotation(CGFloat.pi*2/CGFloat(count) * CGFloat(index + 1), 0, 1, 0)
					weakSelf.grabButton_copy.layer.transform = CATransform3DMakeRotation(-CGFloat.pi*2/CGFloat(count) * CGFloat(index + 1), 0, 1, 0)
				}
			}
			
		}) {(finished) in
		}
	}
	
	func endGrabAnimation() {
		grabButton.layer.removeAllAnimations()
		grabButton_copy.layer.removeAllAnimations()
		grabButton.layer.transform = CATransform3DIdentity
		grabButton_copy.layer.transform = CATransform3DIdentity
	}
}

extension MessageModel: RedpacketSenderType {
	var avatar: String {
		return avator
	}
	var senderId: String {
		return uid
	}
	var displayName: String {
		return username
	}
}

struct RedpacketSender: RedpacketSenderType {
	var avatar: String
	var senderId: String
	var displayName: String
	init(item: RedpacketSenderType) {
		self.avatar = item.avatar
		self.senderId = item.senderId
		self.displayName = item.displayName
	}
	
	
}
