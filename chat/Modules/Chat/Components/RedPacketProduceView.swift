//
//  RedPacketProduceView.swift
//  ug
//
//  Created by xionghx on 2019/12/10.
//  Copyright © 2019 ug. All rights reserved.
//

import Foundation

protocol RedPacketProduceViewDelegate: NSObject, ViewDisapearDelegate {
	func produceRedpacket(quantity: Int, amount: Float, comment: String, onCompletion: @escaping (Bool) -> Void)
}

class RedPacketProduceView: UIView {
	weak var delegate: RedPacketProduceViewDelegate?
	var layoutConfig = LayoutConfig()
	var packetConfig: RedpacketSettingModel
	struct LayoutConfig {
		var contentViewSize = CGSize(width: App.width - 20, height: 400)
		var titleHeight: CGFloat = 44
	}
	
	lazy var contentView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor(hex: "#f8f8f8")
		return view
	}()
	
	lazy var titleView: UILabel = {
		let label = UILabel()
		label.textColor = .white
		label.backgroundColor = UIColor(hex: "#ff3030")
		label.text = "发红包"
		label.font = .boldSystemFont(ofSize: 17)
		label.textAlignment = .center
		return label
	}()
	
	lazy var closeButton: UIButton = {
		let button = UIButton(type: .custom)
		button.setAttributedTitle("关闭".mutableAttributedString().x.color(.white), for: .normal)
		button.rx.tap.subscribe(onNext: { [weak self] () in
			guard let weakSelf = self else { return }
			weakSelf.removeFromSuperview()
			weakSelf.delegate?.viewDidDisapear()
		}).disposed(by: disposeBag)
		
		return button
	}()
	
	let fieldMaker: (String, String, String, NSTextAlignment) -> UITextField = { (title, placeHolder, suffix, textAlignment) in
		let field = UITextField()
		let leftLabel = UILabel()
		leftLabel.attributedText = title.mutableAttributedString().x.fontSize(16).x.color(UIColor.darkText)
		field.leftView = leftLabel
		field.leftViewMode = .always
		field.placeholder = placeHolder
		field.textAlignment = textAlignment
		
		let rightLabel = UILabel()
		rightLabel.attributedText = suffix.mutableAttributedString().x.fontSize(16).x.color(UIColor.darkText)
		field.rightView = rightLabel
		field.rightViewMode = .always
		field.keyboardType = .numberPad
		
		field.borderStyle = .roundedRect
		field.backgroundColor = .white
		
		return field
	}
	
	lazy var quantityField = fieldMaker(" 红包个数: ", "填写个数(最多\(packetConfig.maxQuantity)个)", " 个 ", .right)
	lazy var amountField = fieldMaker(" 红包金额: ", "填写金额(\(packetConfig.minAmount)~\(packetConfig.maxAmount))", " 元 ", .right)
	lazy var commentField: UITextField = {
		let field = UITextField()
		field.placeholder = "大吉大利，恭喜发财！"
		field.font = .systemFont(ofSize: 16)
		field.textColor = .darkText
		field.borderStyle = .roundedRect
		field.backgroundColor = .white
		field.textAlignment = .natural

		return field
	}()
	lazy var handleButton: UIButton = {
		let button = UIButton(type: .custom)
		button.setBackgroundImage(UIImage(color: UIColor(hex: "#ff3030")), for: .normal)
		button.layer.cornerRadius = 5
		button.layer.masksToBounds = true
		button.setAttributedTitle("塞钱进红包".mutableAttributedString().x.color(.white).x.font(.systemFont(ofSize: 17)), for: .normal)
		button.rx.tap.subscribe(onNext: { [weak self] () in
			guard let weakSelf = self else { return }
			weakSelf.delegate?.produceRedpacket(quantity: Int(weakSelf.quantityField.text ?? "0") ?? 0, amount: Float(weakSelf.amountField.text ?? "0") ?? 0.0, comment: weakSelf.commentField.text ?? "大吉大利，恭喜发财！", onCompletion: { (success) in
				if success {
					weakSelf.removeFromSuperview()
					weakSelf.delegate?.viewDidDisapear()
				}
			})
		}).disposed(by: disposeBag)
		return button
	}()
	
	init(packetConfig: RedpacketSettingModel, layoutConfig: LayoutConfig = LayoutConfig()) {
		self.layoutConfig = layoutConfig
		self.packetConfig  = packetConfig
		super.init(frame: CGRect.zero)
		backgroundColor = UIColor.black.withAlphaComponent(0.5)

		setupSubView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupSubView() {
		addSubview(contentView)
		contentView.snp.makeConstraints { (make) in
			make.size.equalTo(layoutConfig.contentViewSize)
			make.center.equalToSuperview()
		}
		
		contentView.addSubview(titleView)
		titleView.snp.makeConstraints { (make) in
			make.left.top.equalToSuperview()
			make.width.equalToSuperview()
			make.height.equalTo(layoutConfig.titleHeight)
		}
		contentView.addSubview(closeButton)
		closeButton.snp.makeConstraints { (make) in
			make.centerY.equalTo(titleView)
			make.right.equalTo(titleView)
			make.height.equalTo(titleView)
			make.width.equalTo(80)
		}
		
		contentView.addSubview(quantityField)
		quantityField.snp.makeConstraints { (make) in
			make.left.right.equalToSuperview().inset(10)
			make.top.equalTo(titleView.snp.bottom).offset(20)
			make.height.equalTo(50)
		}
		contentView.addSubview(amountField)
		amountField.snp.makeConstraints { (make) in
			make.left.right.equalToSuperview().inset(10)
			make.top.equalTo(quantityField.snp.bottom).offset(20)
			make.height.equalTo(50)
		}
		contentView.addSubview(commentField)
		commentField.snp.makeConstraints { (make) in
			make.left.right.equalToSuperview().inset(10)
			make.top.equalTo(amountField.snp.bottom).offset(20)
			make.height.equalTo(50)
		}
		contentView.addSubview(handleButton)
		handleButton.snp.makeConstraints { (make) in
			make.left.right.equalToSuperview().inset(10)
			make.bottom.equalToSuperview().offset(-10)
			make.height.equalTo(50)
		}
		
		
	}
}
