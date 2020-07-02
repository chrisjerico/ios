//
//  GenderEditVC.swift
//  chat
//
//  Created by xionghx on 2020/6/30.
//  Copyright © 2020 ug. All rights reserved.
//

import UIKit
import RxDataSources
import RxRelay

class GenderEditVC: BaseVC {
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var cancelButton: UIButton!
	@IBOutlet weak var confirmButton: UIButton!
	
	let selectedValue = BehaviorRelay(value: "男")
	
	let items = BehaviorRelay(value: ["男", "女"])
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
		let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, String>>(configureCell: { [weak self] (arg0, arg1, arg2, arg3) in
			let cell = arg1.dequeueReusableCell(withIdentifier: "UITableViewCell", for: arg2)
			guard let self = self else { return  cell }
			self.selectedValue.subscribe(onNext: { (gender) in
				cell.accessoryType = gender == arg3 ? .checkmark : .none
			}).disposed(by: self.disposeBag)
			cell.textLabel?.text = arg3
			cell.selectionStyle = .none
			return cell
		})
		items.map { [SectionModel(model: "", items: $0)]}.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
		tableView.rx.modelSelected(String.self).subscribe(onNext: {[unowned self] (gender) in
			self.selectedValue.accept(gender)
		}).disposed(by: disposeBag)
		cancelButton.rx.tap.subscribe(onNext: {[unowned self] () in self.dismiss(animated: true, completion: nil) }).disposed(by: disposeBag)
		
		confirmButton.rx.tap.asObservable()
			.do(onNext: {Alert.showLoading() })
			.flatMap { [unowned self] _ in self.selectedValue }
			.flatMap { ChatAPI.rx.request(ChatTarget.updateGender(text: $0))}
			.mapBool()
			.do(onError: { (error) in
				Alert.showTip(error.localizedDescription)
			})
			.retry()
			.subscribe(onNext: { [weak self] (success) in
				guard let self = self else { return }
				Alert.showTip("性别修改成功")
				self.dismiss(animated: true, completion: nil)
			}).disposed(by: disposeBag)
		
	}
	
	
	
}
