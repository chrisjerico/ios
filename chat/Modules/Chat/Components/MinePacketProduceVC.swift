//
//  MinePacketProduceVC.swift
//  chat
//
//  Created by xionghx on 2020/7/1.
//  Copyright © 2020 ug. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class MinePacketProduceVC: BaseVC {
	@IBOutlet weak var quantityField: UITextField!
	@IBOutlet weak var closeButton: UIButton!
	@IBOutlet weak var mineNumberCollectionView: UICollectionView!
	@IBOutlet weak var handleButton: UIButton!
	@IBOutlet weak var describeLabel: UILabel!
	@IBOutlet weak var quantityFieldLabel: UILabel!
	weak var delegate: MinePacketProduceViewDelegate?
	var packetConfig = MinepacketSettingModel()
	var selectedNumber: Int?
	override func viewDidLoad() {
		super.viewDidLoad()
		
		mineNumberCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
		mineNumberCollectionView.register(MineNumberCell.self, forCellWithReuseIdentifier: "MineNumberCell")
		closeButton.rx.tap.subscribe(onNext: { [weak self] () in
			guard let weakSelf = self else { return }
			weakSelf.dismiss(animated: true, completion: nil)
			weakSelf.delegate?.viewDidDisapear()
		}).disposed(by: disposeBag)
		
		handleButton.rx.tap.subscribe(onNext: { [weak self] () in
			guard let weakSelf = self else { return }
			
			guard let text = weakSelf.quantityField.text, let amount = Float(text) else {
				Alert.showTip("请填写金额！")
				return
			}
			guard let number = weakSelf.selectedNumber else {
				Alert.showTip("请选择雷号！")
				return
			}
			
			weakSelf.delegate?.produceMinePacket(mineNumber: number, amount: amount, onCompletion: { (success) in
				if success {
					weakSelf.dismiss(animated: true, completion: nil)
					weakSelf.delegate?.viewDidDisapear()
				}
			})
			
		}).disposed(by: disposeBag)
		
		let items = Observable.just([SectionModel(model: "", items: (0...9).map {"\($0)"})])
		let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, String>>(configureCell: { (dataSrouce, collectionView, indexPath, item) -> UICollectionViewCell in
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MineNumberCell",  for: indexPath) as! MineNumberCell
			cell.bind(number: item)
			return cell
		})
		items.bind(to: mineNumberCollectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
		
		
		
		mineNumberCollectionView.rx.itemSelected.subscribe(onNext: { [weak self] (indexPath) in
			guard let weakSelf = self else { return }
			weakSelf.selectedNumber = indexPath.item
		}).disposed(by: disposeBag)
		
		
		quantityField.rx.text.filterNil().map { Int($0) ?? 0}.subscribe {[weak self] (number) in
			self?.describeLabel.text = "¥" + String(number)
		}.disposed(by: disposeBag)
		
	}
	
	
	
}


extension MinePacketProduceVC: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: 38, height: 38)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
	
}
