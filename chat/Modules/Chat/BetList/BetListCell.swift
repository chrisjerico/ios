//
//  BetListCell.swift
//  ug
//
//  Created by xionghx on 2019/12/11.
//  Copyright © 2019 ug. All rights reserved.
//

import UIKit

protocol BetListCellDelegate: NSObject {
	func betListCellHandleButtonTaped(item: BetModel)
}

class BetListCell: UITableViewCell {
	weak var delegate: BetListCellDelegate?
	@IBOutlet weak var backDropView: UIView!
	@IBOutlet weak var gameNameLabel: UILabel!
	@IBOutlet weak var turnNumLabel: UILabel!
	@IBOutlet weak var betBeansView: UIView!
	@IBOutlet weak var handleButton: UIButton!
	@IBOutlet weak var amountLabel: UILabel!
	@IBOutlet weak var countLabel: UILabel!
	@IBOutlet weak var betBeansViewHeight: NSLayoutConstraint!
	private var item: BetModel?
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		backDropView.layer.cornerRadius = 10
		backDropView.layer.masksToBounds = true
		handleButton.layer.cornerRadius = 20
		handleButton.layer.masksToBounds = true
		
		handleButton.rx.tap.subscribe(onNext: { [weak self] () in
			
			guard let delegate = self?.delegate, let item = self?.item else { return }
			
			delegate.betListCellHandleButtonTaped(item: item)
			
		}).disposed(by: disposeBag)
	}
	
	func bind(item: BetModel)  {
		
		
		self.item = item
		self.gameNameLabel.text = item.gameName
		self.turnNumLabel.text = "\(item.trunNum)"
		self.countLabel.text = "\(item.totalNums)"
		self.amountLabel.text = "\(item.totalMoney)"
		
		
		betBeansView.subviews.forEach { $0.removeFromSuperview() }
		let totalHeight = CGFloat(item.betBeans.count) * CGFloat(50)
		betBeansViewHeight.constant = totalHeight
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
	
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	
}
class BetBeanView: UIView {
	
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var oddsLabel: UILabel!
	@IBOutlet weak var suffixLabel: UILabel!
	@IBOutlet weak var amountLabel: UILabel!
	
	func bind(item: BetBeanModel) {
		nameLabel.text = "【\(item.groupName)】"
		oddsLabel.text = "@" + item.odds
		amountLabel.text = item.money
	}
}
