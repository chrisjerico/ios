//
//  ProfileEditVC.swift
//  chat
//
//  Created by xionghx on 2020/1/8.
//  Copyright © 2020 ug. All rights reserved.
//

import UIKit

class ProfileEditVC: BaseVC {
	
	@IBOutlet weak var nameButton: UIButton!
	@IBOutlet weak var avatarButton: UIButton!
	@IBOutlet weak var genderButton: UIButton!
	@IBOutlet weak var signatureTextView: UITextView!
	@IBOutlet weak var signaturePlaceholderLabel: UILabel!
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.title = "个人资料编辑"
		
		
		//				ChatAPI.rx.request(ChatTarget.userInfo(sessid: App.user.sessid)).subscribe(onSuccess: { (response) in
		//					logger.debug(try! response.mapString())
		//				}) { (error) in
		//					logger.debug(error.localizedDescription)
		//				}.disposed(by: disposeBag)
		
		ChatAPI.rx.request(ChatTarget.selfUserInfo(target: App.user.userId)).subscribe(onSuccess: { (response) in
			logger.debug(try! response.mapString())
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
	
	
	
}
