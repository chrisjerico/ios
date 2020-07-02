//
//  NotificationMessageCell.swift
//  chat
//
//  Created by xionghx on 2020/7/2.
//  Copyright © 2020 ug. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay

class NotificationMessageCell: UITableViewCell {
	
	@IBOutlet weak var contentTextView: UITextView!
	@IBOutlet weak var arrowIcon: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var typeIcon: UIImageView!
	var index = 0
	var model: NotificationMessageModel? = nil
	
	
	override func prepareForReuse() {
		super.prepareForReuse()
		disposeBag = DisposeBag()
	}
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
//		guard let model = model else {
//			contentTextView.attributedText = nil
//			return
//		}
//		if selected {
//			let attributedText = (try? NSMutableAttributedString(data: model.content.data(using: .unicode) ?? Data(), options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)) ?? "".mutableAttributedString()
//			contentTextView.attributedText = (model.addTime + "\n\n").mutableAttributedString().x.color(UIColor(hex: "A5A8B3")).x.fontSize(12) + attributedText.x.fontSize(12).x.color(UIColor(hex: "A5A8B3"))
//		} else {
//			contentTextView.attributedText = nil
//		}
//		setNeedsUpdateConstraints()
//		updateConstraintsIfNeeded()
//		contentView.setNeedsLayout()
//		contentView.layoutIfNeeded()
		setNeedsLayout()
		layoutIfNeeded()
	}
	
	func bind(model: NotificationMessageModel) {
		typeIcon.image = UIImage(named: ["1":"zj_gonggao", "2":"zj_huodong", "3":"zj_xinwen"]["\(model.alert_type)"] ?? "zj_xinwen")
		titleLabel.text = model.title
		contentTextView.attributedText = nil
		self.model = model
	}
	
	func bind(index: Int, selectedIndex: BehaviorRelay<[Int]>) {
		guard let model = model else {
			return
		}
		selectedIndex.subscribe(onNext: { [weak self](selected) in
			
			if selected.contains(index) {
				let attributedText = (try? NSMutableAttributedString(data: model.content.data(using: .unicode) ?? Data(), options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)) ?? "".mutableAttributedString()
				self?.contentTextView.attributedText = (model.addTime + "\n\n").mutableAttributedString().x.color(UIColor(hex: "A5A8B3")).x.fontSize(12) + attributedText.x.fontSize(12).x.color(UIColor(hex: "A5A8B3"))
			} else {
				self?.contentTextView.attributedText = nil
			}
			
		}).disposed(by: disposeBag)
		
	}
	
}
