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

protocol MinePacketProduceViewDelegate: NSObject, ViewDisapearDelegate {
	func produceMinePacket(mineNumber: Int, amount: Float, onCompletion: @escaping (Bool) -> Void)
	
}

class MinePacketProduceView: UIView {
	weak var delegate: MinePacketProduceViewDelegate?
	var layoutConfig = LayoutConfig()
	var packetConfig: MinepacketSettingModel
	var selectedNumber: Int?
	struct LayoutConfig {
		var contentViewSize = CGSize(width: App.width - 20, height: 400)
		var titleHeight: CGFloat = 44
		var mineNumberCollectionSize = CGSize(width: App.width - 80, height: (App.width - 80)*2/5)
	}
	
	lazy var contentView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor(hex: "#f8f8f8")
		return view
	}()
	
	lazy var mineNumberCollectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.itemSize = CGSize(width: layoutConfig.mineNumberCollectionSize.width/5, height: layoutConfig.mineNumberCollectionSize.width/5)
		layout.minimumLineSpacing = 0
		layout.minimumInteritemSpacing = 0
		let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
		collectionView.register(MineNumberCell.self, forCellWithReuseIdentifier: "MineNumberCell")
		collectionView.backgroundColor = UIColor.white
		return collectionView
	}()
	
	lazy var titleView: UILabel = {
		let label = UILabel()
		label.textColor = .white
		label.backgroundColor = UIColor(hex: "#ff3030")
		label.text = "发红包"
		label.font = .boldSystemFont(ofSize: 17)
		label.textAlignment = .center
		return label
	}()
	
	lazy var closeButton: UIButton = {
		let button = UIButton(type: .custom)
		button.setAttributedTitle("关闭".mutableAttributedString().x.color(.white), for: .normal)
		button.rx.tap.subscribe(onNext: { [weak self] () in
			guard let weakSelf = self else { return }
			weakSelf.removeFromSuperview()
			weakSelf.delegate?.viewDidDisapear()
		}).disposed(by: disposeBag)
		
		return button
	}()
	
	let fieldMaker: (String, String, String, NSTextAlignment) -> UITextField = { (title, placeHolder, suffix, textAlignment) in
		let field = UITextField()
		let leftLabel = UILabel()
		leftLabel.attributedText = title.mutableAttributedString().x.fontSize(16).x.color(UIColor.darkText)
		field.leftView = leftLabel
		field.leftViewMode = .always
		field.placeholder = placeHolder
		field.textAlignment = textAlignment
		
		let rightLabel = UILabel()
		rightLabel.attributedText = suffix.mutableAttributedString().x.fontSize(16).x.color(UIColor.darkText)
		field.rightView = rightLabel
		field.rightViewMode = .always
		field.keyboardType = .numberPad
		
		field.borderStyle = .roundedRect
		field.backgroundColor = .white
		
		return field
	}
	
	lazy var quantityField = fieldMaker(" 总金额: ", "请输入金额(\(packetConfig.minAmount)~\(packetConfig.maxAmount))", " 元 ", .right)
	
	lazy var handleButton: UIButton = {
		let button = UIButton(type: .custom)
		button.setBackgroundImage(UIImage(color: UIColor(hex: "#ff3030")), for: .normal)
		button.layer.cornerRadius = 5
		button.layer.masksToBounds = true
		button.setAttributedTitle("塞钱进红包".mutableAttributedString().x.color(.white).x.font(.systemFont(ofSize: 17)), for: .normal)
		button.rx.tap.subscribe(onNext: { [weak self] () in
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
		return button
	}()
	
	init(packetConfig: MinepacketSettingModel, layoutConfig: LayoutConfig = LayoutConfig()) {
		self.layoutConfig = layoutConfig
		self.packetConfig  = packetConfig
		super.init(frame: CGRect.zero)
		backgroundColor = UIColor.black.withAlphaComponent(0.5)
		
		setupSubView()
		
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
		
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupSubView() {
		addSubview(contentView)
		contentView.snp.makeConstraints { (make) in
			make.size.equalTo(layoutConfig.contentViewSize)
			make.center.equalToSuperview()
		}
		
		contentView.addSubview(titleView)
		titleView.snp.makeConstraints { (make) in
			make.left.top.equalToSuperview()
			make.width.equalToSuperview()
			make.height.equalTo(layoutConfig.titleHeight)
		}
		contentView.addSubview(closeButton)
		closeButton.snp.makeConstraints { (make) in
			make.centerY.equalTo(titleView)
			make.right.equalTo(titleView)
			make.height.equalTo(titleView)
			make.width.equalTo(80)
		}
		
		contentView.addSubview(quantityField)
		quantityField.snp.makeConstraints { (make) in
			make.left.right.equalToSuperview().inset(10)
			make.top.equalTo(titleView.snp.bottom).offset(20)
			make.height.equalTo(50)
		}
		
		let mineTitleLabel = UILabel()
		mineTitleLabel.text = "雷号"
		
		let mineContentView = UIView()
		mineContentView.backgroundColor = .white
		mineContentView.layer.cornerRadius = 5
		mineContentView.layer.masksToBounds = true
		
		contentView.addSubview(mineContentView)
		mineContentView.snp.makeConstraints { (make) in
			make.left.right.equalToSuperview().inset(10)
			make.top.equalTo(quantityField.snp.bottom).offset(20)
			make.height.equalTo(200)
		}
		
		contentView.addSubview(mineTitleLabel)
		mineTitleLabel.snp.makeConstraints { (make) in
			make.left.equalTo(mineContentView).offset(5)
			make.top.equalTo(mineContentView).offset(10)
		}
		
		contentView.addSubview(mineNumberCollectionView)
		mineNumberCollectionView.snp.makeConstraints { (make) in
			make.left.equalToSuperview().offset(60)
			make.top.equalTo(mineContentView).offset(10)
			make.size.equalTo(layoutConfig.mineNumberCollectionSize)
		}
		
		contentView.addSubview(handleButton)
		handleButton.snp.makeConstraints { (make) in
			make.left.right.equalToSuperview().inset(10)
			make.bottom.equalToSuperview().offset(-10)
			make.height.equalTo(50)
		}
		
	}
}


class MineNumberCell: UICollectionViewCell {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .white
		setupSubView()
	}
	let radius: CGFloat = 20
	
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
		label.layer.borderColor = UIColor.black.cgColor
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
		label.backgroundColor = UIColor(hex: "#ff3030")
		label.textColor = .white
		
		return label
	}()
	
	func bind(number: String) {
		numberLabel.text = number
		selectedNumberLabel.text = number
	}

}
