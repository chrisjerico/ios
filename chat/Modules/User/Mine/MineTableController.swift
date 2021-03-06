//
//  UGMineController.swift
//  ug
//
//  Created by xionghx on 2019/10/27.
//  Copyright © 2019 ug. All rights reserved.
//

import UIKit
import SVGKit
import SwiftyJSON

class MineTableController: BaseTableVC {
	
	@IBOutlet weak var avatarImageView: UIImageView!
	@IBOutlet weak var userIdLabel: UILabel!
	@IBOutlet weak var userNameLabel: UILabel!
	@IBOutlet weak var genderImageView: UIImageView!
	
	@IBOutlet var countLabels: [UILabel]!
	
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
		
		ChatAPI.rx.request(ChatTarget.selfUserInfo(target: App.user.userId)).subscribe(onSuccess: {[weak self] (response) in
			guard let json = try? JSON(data: response.data) else { return }
			self?.avatarImageView.kf.setImage(with: URL(string: json["data"]["avatar"].stringValue), placeholder: UIImage(named: "placeholder_avatar"))
		}) { (error) in
			logger.debug(error.localizedDescription)
		}.disposed(by: disposeBag)
		userIdLabel.text = "ID: \(App.user.userId)"
		userNameLabel.text = App.user.username as String
//		genderImageView.image = UIImage(named: App.user.)
		momentsAPI.rx.request(MomentsTarget.statData).mapJSON().subscribe { [weak self] (dic) in
			let json = JSON(dic)
			self?.countLabels[0].text = json["data"]["share_count"].stringValue
			self?.countLabels[1].text = json["data"]["fans_count"].stringValue
			self?.countLabels[2].text = json["data"]["follow_count"].stringValue

		} onError: { (error) in
			logger.debug(error.localizedDescription)
		}.disposed(by: disposeBag)

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
