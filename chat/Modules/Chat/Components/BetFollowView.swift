//
//  BetFollowView.swift
//  ug
//
//  Created by xionghx on 2019/12/14.
//  Copyright © 2019 ug. All rights reserved.
//

import UIKit

protocol BetFollowViewDelegate: ViewDisapearDelegate {
	
}

class BetFollowView: UIView {

	weak var delegate: BetFollowViewDelegate?
	@IBOutlet weak var backDropView: UIView!
	@IBOutlet weak var gameNameLabel: UILabel!
	@IBOutlet weak var gameTurnLabel: UILabel!
	@IBOutlet weak var countLabel: UILabel!
	@IBOutlet weak var amountLabel: UILabel!
	@IBOutlet weak var cancelButton: UIButton!
	@IBOutlet weak var betButton: UIButton!
	@IBOutlet weak var betBeansView: UIView!
	
	@IBOutlet weak var betBeansViewHeight: NSLayoutConstraint!
	override func awakeFromNib() {
		super.awakeFromNib()
		backgroundColor = UIColor.black.withAlphaComponent(0.5)
		
		backDropView.layer.cornerRadius = 5
		cancelButton.layer.cornerRadius = 20
		cancelButton.layer.borderWidth = 1
		cancelButton.layer.borderColor = UIColor(hex: "#2F70F1").cgColor
		betButton.layer.cornerRadius = 20
		betButton.layer.masksToBounds = true
		
		
		cancelButton.rx.tap.subscribe(onNext: { [unowned self] () in
			self.removeFromSuperview()
			self.delegate?.viewDidDisapear()
		}).disposed(by: disposeBag)
		
	}
	func bind(item: BetModel) {
		
		gameNameLabel.text = item.gameName
		gameTurnLabel.text = "\(item.trunNum)"
		countLabel.text = "\(item.totalNums)"
		amountLabel.text = "\(item.totalMoney)"
		
		betBeansView.subviews.forEach { $0.removeFromSuperview() }
		let totalHeight = CGFloat(item.betBeans.count) * CGFloat(28)
		betBeansViewHeight.constant = totalHeight
		var temp: BetBeanView?
		for bean in item.betBeans {
			let beanView = Bundle.main.loadNibNamed("BetBeanView", owner: self, options: nil)?.first as! BetBeanView
			betBeansView.addSubview(beanView)
			beanView.bind(item: bean)
			beanView.snp.makeConstraints { (make) in
//				make.leading.trailing.equalToSuperview()
				if let temp = temp {
					make.top.equalTo(temp.snp.bottom)
					make.height.equalTo(temp)
				} else {
					make.top.equalToSuperview()
				}
				make.left.right.equalToSuperview()
			}
			temp = beanView
			
		}
		temp?.snp.makeConstraints({ (make) in
			make.bottom.equalToSuperview()
		})
	}
	
	
}
