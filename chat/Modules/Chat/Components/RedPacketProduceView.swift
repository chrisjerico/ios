//
//  RedPacketProduceView.swift
//  ug
//
//  Created by xionghx on 2019/12/10.
//  Copyright © 2019 ug. All rights reserved.
//

import Foundation

protocol RedPacketProduceViewDelegate: ViewDisapearDelegate {
	func produceRedpacket(quantity: Int, amount: Float, comment: String, onCompletion: @escaping (Bool) -> Void)
}

class RedPacketProduceView: UIView {
	@IBOutlet weak var closeButton: UIButton!
	weak var delegate: RedPacketProduceViewDelegate?
	var packetConfig = RedpacketSettingModel()

	@IBOutlet weak var handleButton: UIButton!
	@IBOutlet weak var commentField: UITextField!
	@IBOutlet weak var amountField: UITextField!
	@IBOutlet weak var quantityField: UITextField!
	
	override func didMoveToSuperview() {
		super.didMoveToSuperview()
		handleButton.rx.tap.subscribe(onNext: { [weak self] () in
			guard let weakSelf = self else { return }
			weakSelf.delegate?.produceRedpacket(quantity: Int(weakSelf.quantityField.text ?? "0") ?? 0, amount: Float(weakSelf.amountField.text ?? "0") ?? 0.0, comment: weakSelf.commentField.text ?? "大吉大利，恭喜发财！", onCompletion: { (success) in
				if success {
					weakSelf.removeFromSuperview()
					weakSelf.delegate?.viewDidDisapear()
				}
			})
		}).disposed(by: disposeBag)
		
		closeButton.rx.tap.subscribe(onNext: { [weak self] () in
			guard let weakSelf = self else { return }
			weakSelf.removeFromSuperview()
			weakSelf.delegate?.viewDidDisapear()
		}).disposed(by: disposeBag)
	}
	
}
