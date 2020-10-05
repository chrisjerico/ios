//
//  MinePacketProduceView.swift
//  ug
//
//  Created by xionghx on 2019/12/10.
//  Copyright © 2019 ug. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

protocol MinePacketProduceViewDelegate: ViewDisapearDelegate {
	func produceMinePacket(mineNumber: Int, amount: Float, onCompletion: @escaping (Bool) -> Void)
	
}

class MinePacketProduceView: UIView {
	@IBOutlet weak var quantityField: UITextField!
	@IBOutlet weak var closeButton: UIButton!
	@IBOutlet weak var mineNumberCollectionView: UICollectionView!
	@IBOutlet weak var handleButton: UIButton!
	@IBOutlet weak var quantityLabel: UILabel!
	weak var delegate: MinePacketProduceViewDelegate?
	var packetConfig = MinepacketSettingModel()
	var selectedNumber: Int?
	

	
	override func didMoveToSuperview() {
		super.didMoveToSuperview()
		mineNumberCollectionView.rx.setDelegate(self).disposed(by: disposeBag)

		mineNumberCollectionView.register(MineNumberCell.self, forCellWithReuseIdentifier: "MineNumberCell")
		closeButton.rx.tap.subscribe(onNext: { [weak self] () in
			guard let weakSelf = self else { return }
			weakSelf.removeFromSuperview()
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
					weakSelf.removeFromSuperview()
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
		
		quantityField.rx.text.map {$0}.subscribe {[weak self] (content) in
			self?.quantityLabel.text = "¥\(content)"
		}.disposed(by: disposeBag)
//		quantityField.rx.text.subscribe { [weak self] (content) in
//
//			self?.quantityLabel.text = "¥\(content!)"
//		}.disposed(by: disposeBag)

		
		mineNumberCollectionView.rx.itemSelected.subscribe(onNext: { [weak self] (indexPath) in
			guard let weakSelf = self else { return }
			weakSelf.selectedNumber = indexPath.item
		}).disposed(by: disposeBag)
	}
}
extension MinePacketProduceView: UICollectionViewDelegateFlowLayout {
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

class MineNumberCell: UICollectionViewCell {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .white
		setupSubView()
	}
	let radius: CGFloat = 15
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupSubView() {
		let backgroundView = UIView()
		backgroundView.backgroundColor = UIColor.white
		backgroundView.addSubview(numberLabel)
		numberLabel.snp.makeConstraints { (make) in
			make.center.equalToSuperview()
			make.size.equalTo(CGSize(width: radius*2, height: radius*2))
		}
		
		let selectedBackgroundView = UIView()
		selectedBackgroundView.backgroundColor = UIColor.white
		selectedBackgroundView.addSubview(selectedNumberLabel)
		selectedNumberLabel.snp.makeConstraints { (make) in
			make.center.equalToSuperview()
			make.size.equalTo(CGSize(width: radius*2, height: radius*2))
		}
		
		self.backgroundView = backgroundView
		self.selectedBackgroundView = selectedBackgroundView
		
	}
	lazy var numberLabel: UILabel = {
		let label = UILabel()
		label.layer.borderColor = UIColor(hex: "#BCC0CC").cgColor
		label.layer.borderWidth = 1
		label.layer.cornerRadius = radius
		label.textColor = .black
		label.backgroundColor = .white
		label.textAlignment = .center
		
		return label
		
	}()
	
	lazy var selectedNumberLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.layer.cornerRadius = radius
		label.layer.masksToBounds = true
		label.backgroundColor = UIColor(hex: "#E66262")
		label.textColor = .white
		
		return label
	}()
	
	func bind(number: String) {
		numberLabel.text = number
		selectedNumberLabel.text = number
	}
	
}
