//
//  NameEditVC.swift
//  chat
//
//  Created by xionghx on 2020/6/30.
//  Copyright © 2020 ug. All rights reserved.
//

import UIKit
import RxRelay
import RxCocoa
import RxSwift

class NameEditVC: BaseVC {
	
	@IBOutlet weak var cancelButton: UIButton!
	@IBOutlet weak var confirmButton: UIButton!
	@IBOutlet weak var editTextField: UITextField!
	
	let name = BehaviorRelay(value: "")
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		cancelButton.rx.tap.subscribe(onNext: {[unowned self] () in self.dismiss(animated: true, completion: nil) }).disposed(by: disposeBag)

		name.bind(to: editTextField.rx.text).disposed(by: disposeBag)
		editTextField.rx.text.orEmpty.bind(to: name).disposed(by: disposeBag)
		
		confirmButton.rx.tap.asObservable()
			.do(onNext: {Alert.showLoading() })
			.flatMap { [unowned self] _ in self.name }
			.flatMap { ChatAPI.rx.request(ChatTarget.updateNickname(text: $0))}
			.mapBool()
			.do(onError: { (error) in
				Alert.showTip(error.localizedDescription)
			})
			.retry()
			.subscribe(onNext: { [weak self] (success) in
				guard let self = self else { return }
				Alert.showTip("用户名修改成功")
				self.dismiss(animated: true, completion: nil)
			}).disposed(by: disposeBag)
	}
	
	
	
	
}
