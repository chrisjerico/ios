//
//  BetMessageContentView.swift
//  ug
//
//  Created by xionghx on 2019/12/20.
//  Copyright © 2019 ug. All rights reserved.
//

import Foundation

class BetMessageContentView: UIView {
	
	@IBOutlet weak var backDropVIew: UIView!
	@IBOutlet weak var handleButton: UIButton!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var trunLabel: UILabel!
	@IBOutlet weak var countLabel: UILabel!
	@IBOutlet weak var amountLabel: UILabel!
	@IBOutlet weak var betBeansView: UIView!
	@IBOutlet weak var betBeansTotalHeight: NSLayoutConstraint!
	
	
	override func awakeFromNib() {
		super.awakeFromNib()
		layer.cornerRadius = 8
		layer.cornerRadius = 10
		layer.shadowColor = UIColor.darkGray.cgColor
		layer.shadowOffset = CGSize(width: 3, height: 3)
		layer.shadowOpacity = 1
		layer.shadowRadius = 3
		
		layer.masksToBounds = false
		backDropVIew.layer.cornerRadius = 8
		backDropVIew.layer.masksToBounds = true
		
	}
	
	func bind(item: BetModel) {
		
		nameLabel.text = item.gameName
		trunLabel.text = "\(item.trunNum)"
		countLabel.text = "\(item.totalNums)"
		amountLabel.text = "\(item.totalMoney)"
		
		betBeansView.subviews.forEach { $0.removeFromSuperview() }
		let totalHeight = CGFloat(item.betBeans.count) * CGFloat(28)
		betBeansTotalHeight.constant = totalHeight
		var temp: BetBeanView?
		for bean in item.betBeans {
			let beanView = Bundle.main.loadNibNamed("BetBeanView", owner: self, options: nil)?.first as! BetBeanView
			betBeansView.addSubview(beanView)
			beanView.bind(item: bean)
			beanView.snp.makeConstraints { (make) in
				make.leading.trailing.equalToSuperview()
				if let temp = temp {
					make.top.equalTo(temp.snp.bottom)
					make.height.equalTo(temp)
				} else {
					make.top.equalToSuperview()
				}
			}
			temp = beanView
			
		}
		temp?.snp.makeConstraints({ (make) in
			make.bottom.equalToSuperview()
		})
		
	}
	
	
}
