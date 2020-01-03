//
//  AttachFunctionMenusCell.swift
//  ug
//
//  Created by xionghx on 2019/11/21.
//  Copyright © 2019 ug. All rights reserved.
//

import Foundation


class AttachFunctionMenusCell: UICollectionViewCell {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupSubView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	lazy var imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.backgroundColor = UIColor.white
		imageView.layer.cornerRadius = 12
		imageView.layer.masksToBounds = true
		imageView.contentMode = .center
		return imageView
		
	}()
	
	lazy var nameLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.textColor = UIColor(hex: "#666666")
		label.font = UIFont.boldSystemFont(ofSize: 12)
		return label
	}()
	
	func setupSubView() {
		
		addSubview(imageView)
		imageView.snp.makeConstraints { (make) in
			make.top.equalTo(self).offset(10)
			make.leading.trailing.equalTo(self).inset(20)
			make.height.equalTo(imageView.snp_width)
		}
		
		addSubview(nameLabel)
		nameLabel.snp.makeConstraints { (make) in
			make.leading.trailing.equalTo(self)
			make.top.equalTo(imageView.snp.bottom).offset(5)
			make.height.equalTo(20)
			//			make.bottom.equalToSuperview()
		}
		
	}
	
	func bind(imageName: String, name: String) {
		nameLabel.text = name
		imageView.image = UIImage(named: imageName)
		
	}
	
	
	
}
