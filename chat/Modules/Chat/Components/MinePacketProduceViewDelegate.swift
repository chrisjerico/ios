//
//  MinePacketProduceView.swift
//  ug
//
//  Created by xionghx on 2019/12/10.
//  Copyright © 2019 ug. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

protocol MinePacketProduceViewDelegate: ViewDisapearDelegate {
	func produceMinePacket(mineNumber: Int, amount: Float, onCompletion: @escaping (Bool) -> Void)
	
}


class MineNumberCell: UICollectionViewCell {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .white
		setupSubView()
	}
	let radius: CGFloat = 15
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupSubView() {
		let backgroundView = UIView()
		backgroundView.backgroundColor = UIColor.white
		backgroundView.addSubview(numberLabel)
		numberLabel.snp.makeConstraints { (make) in
			make.center.equalToSuperview()
			make.size.equalTo(CGSize(width: radius*2, height: radius*2))
		}
		
		let selectedBackgroundView = UIView()
		selectedBackgroundView.backgroundColor = UIColor.white
		selectedBackgroundView.addSubview(selectedNumberLabel)
		selectedNumberLabel.snp.makeConstraints { (make) in
			make.center.equalToSuperview()
			make.size.equalTo(CGSize(width: radius*2, height: radius*2))
		}
		
		self.backgroundView = backgroundView
		self.selectedBackgroundView = selectedBackgroundView
		
	}
	lazy var numberLabel: UILabel = {
		let label = UILabel()
		label.layer.borderColor = UIColor(hex: "#BCC0CC").cgColor
		label.layer.borderWidth = 1
		label.layer.cornerRadius = radius
		label.textColor = .black
		label.backgroundColor = .white
		label.textAlignment = .center
		
		return label
		
	}()
	
	lazy var selectedNumberLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.layer.cornerRadius = radius
		label.layer.masksToBounds = true
		label.backgroundColor = UIColor(hex: "#E66262")
		label.textColor = .white
		
		return label
	}()
	
	func bind(number: String) {
		numberLabel.text = number
		selectedNumberLabel.text = number
	}
	
}
