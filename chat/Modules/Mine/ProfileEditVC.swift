//
//  ProfileEditVC.swift
//  chat
//
//  Created by xionghx on 2020/1/8.
//  Copyright © 2020 ug. All rights reserved.
//

import UIKit
import SwiftyJSON
import RxSwift
import RxRelay

class ProfileEditVC: BaseVC {
	
	@IBOutlet weak var nameButton: UIButton!
	@IBOutlet weak var avatarButton: UIButton!
	@IBOutlet weak var genderButton: UIButton!
	@IBOutlet weak var signatureTextView: UITextView!
	@IBOutlet weak var signaturePlaceholderLabel: UILabel!
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.title = "个人资料编辑"
		
		ChatAPI.rx.request(ChatTarget.selfUserInfo(target: App.user.userId)).subscribe(onSuccess: {[weak self] (response) in
			guard let json = try? JSON(data: response.data) else { return }
			self?.avatarButton.kf.setImage(with: URL(string: json["data"]["avatar"].stringValue), for: .normal)
		}) { (error) in
			logger.debug(error.localizedDescription)
		}.disposed(by: disposeBag)
		
		nameButton.setTitle(App.user.username, for: .normal)
		avatarButton.kf.setImage(with: URL(string: App.user.avatar), for: .normal)
		
		nameButton.rx.tap.subscribe(onNext: { [unowned self] () in
			let vc = NameEditVC()
			vc.modalPresentationStyle = .fullScreen
			vc.name.accept(App.user.username)
			self.navigationController?.present(vc, animated: true, completion: nil)
		}).disposed(by: disposeBag)
		genderButton.rx.tap.subscribe(onNext: { [unowned self] () in
			let vc = GenderEditVC()
			vc.modalPresentationStyle = .fullScreen
			vc.selectedValue.accept(App.user.sessid)
			self.navigationController?.present(vc, animated: true, completion: nil)
		}).disposed(by: disposeBag)
		
		signatureTextView.rx.text.orEmpty.map {$0.count>0}.bind(to: signaturePlaceholderLabel.rx.isHidden).disposed(by: disposeBag)
		signatureTextView.rx.didEndEditing.subscribe(onNext: { [weak self] () in
			guard let self = self else { return }
			
			ChatAPI.rx.request(ChatTarget.updateSignature(text: self.signatureTextView.text)).mapBool().subscribe(onSuccess: { (success) in
				if success {
					Alert.showTip("签名修改成功")
				}
			}) { (error) in
				Alert.showTip(error.localizedDescription)
			}.disposed(by: self.disposeBag)
			
		}).disposed(by: disposeBag)
		
	}
	
	@IBAction func avatarButtonAction(_ sender: Any) {
		var seletedImage: UIImage?
		let takePictureButton = UIAlertController.AlertButton.default("拍摄")
		let choseFromAlumButon = UIAlertController.AlertButton.default("从相册中选择")
		let cancelButton = UIAlertController.AlertButton.cancel("取消")
		UIAlertController.rx.show(in: self, title: nil, message: nil, buttons: [takePictureButton, choseFromAlumButon, cancelButton], preferredStyle: .actionSheet)
			.asObservable().filter { $0 != 2 }.flatMap { index in
				return UIImagePickerController.rx.createWithParent(self) { picker in
					picker.sourceType = index == 0 ? .camera : .photoLibrary
					picker.allowsEditing = false
				}
		}.flatMap {
			$0.rx.didFinishPickingMediaWithInfo
		}
		.take(1)
			.map { info -> UIImage? in
			let image = info[.originalImage] as? UIImage
			seletedImage = image
			return image
		}
		.filterNil()
			.flatMap{ FileUploadApi.rx.request(.avatar(data: $0)).mapBool()}.subscribe { [weak self] (success) in
				if success, let image = seletedImage {
					Alert.showTip("头像更改成功")
					self?.avatarButton.setImage(image, for: .normal)
				}
			} onError: { (error) in
				Alert.showTip(error.localizedDescription)
			}.disposed(by: disposeBag)

			
			
//		.subscribe(onNext: { [weak self] image in
//			guard let weakSelf = self else { return }
////			weakSelf.items.accept([image] + weakSelf.items.value)
//		}).disposed(by: disposeBag)
//
	}
	
	
}
