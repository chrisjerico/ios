//
//  UGMineController.swift
//  ug
//
//  Created by xionghx on 2019/10/27.
//  Copyright © 2019 ug. All rights reserved.
//

import UIKit
import SVGKit

class MineTableController: BaseTableVC {
	
	@IBOutlet weak var avatarImageView: UIImageView!
	@IBOutlet weak var userIdLabel: UILabel!
	@IBOutlet weak var userNameLabel: UILabel!
	
	
	@IBOutlet var itemImages: [UIImageView]!
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.title = nil
		let imageGroup = [("qianbao", "#FF5C66"), ("fenxiang_1", "#FF9F5C"), ("shezhi", "#2E87FF"), ("yijian", "#13BA74")]
		for e in itemImages.enumerated() {
			e.element.image = SVGKImage(named: imageGroup[e.offset].0).uiImage.withRenderingMode(.alwaysTemplate)
			e.element.tintColor = UIColor(hex: imageGroup[e.offset].1)
		}
		let item = UIBarButtonItem(image: SVGKImage(named: "bianji").uiImage, style: .plain, target: self, action: #selector(rightItemTaped))
		item.tintColor = UIColor.black
		navigationItem.rightBarButtonItem = item
		avatarImageView.layer.cornerRadius = 30
		avatarImageView.layer.masksToBounds = true
		avatarImageView.kf.setImage(with: URL(string: App.user.avatar), placeholder: UIImage(named: "placeholder_avatar"))
		userIdLabel.text = "ID: \(App.user.userId)"
		userNameLabel.text = App.user.username as String
		
	}
	override func awakeFromNib() {
		super.awakeFromNib()
		
		
	}
	
	
	@objc func rightItemTaped() {
		
//		let vc = UIStoryboard(name: "UGUserInfoViewController", bundle: nil).instantiateInitialViewController()!
//		navigationController?.pushViewController(vc, animated: true)
		navigationController?.pushViewController(ProfileEditVC(), animated: true)
		logger.debug("ssssssss")
	}
	
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 12
	}

}
