//
//  MyWalletVC.swift
//  ug
//
//  Created by xionghx on 2019/12/16.
//  Copyright © 2019 ug. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import SwiftyJSON

class MyWalletVC: BaseVC {
	var layoutConfig = LayoutConfig()
	struct LayoutConfig {
		var collectionViewEdgesInsers = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
		var interitemSpacing: CGFloat = 2.0
		var lineSpacing: CGFloat = 2.0
		
	}
	lazy var headView: MyWalletHeader = {
		let view =  Bundle.main.loadNibNamed("MyWalletHeader", owner: self, options: nil)?.first as! MyWalletHeader
		view.containerView.layer.cornerRadius = 10
		view.containerView.layer.masksToBounds = true
		return view
	}()
	
	lazy var collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		let itemWidth = (App.width - layoutConfig.collectionViewEdgesInsers.left - layoutConfig.collectionViewEdgesInsers.right - layoutConfig.interitemSpacing * 2 )/3
		
		layout.minimumLineSpacing = layoutConfig.lineSpacing
		layout.minimumInteritemSpacing = layoutConfig.interitemSpacing
		layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
		layout.headerReferenceSize = CGSize(width: App.width, height: 40)
		
		let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
		collectionView.backgroundColor = .white
		collectionView.register(WalletCollectionViewCell.self, forCellWithReuseIdentifier: "WalletCollectionViewCell")
		collectionView.register(WalletCollectionViewSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "WalletCollectionViewSectionHeader")
		collectionView.backgroundColor = UIColor(hex: "#eeeeee")
		collectionView.showsVerticalScrollIndicator = false
		
		return collectionView
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		Alert.showLoading()
		CMNetwork.getUserInfo(withParams: ["token": UGUserModel.currentUser().sessid]) { [weak self] (result, error) in
			Alert.hide()
			if let error = error {
				Alert.showTip(error.localizedDescription)
			}
			guard let result = result, let user = result.data as? UGUserModel else {
				Alert.showTip("数据格式错误")
				return
			}
			self?.headView.balanceLabel.text = "¥\(user.balance)"
		}
		view.backgroundColor = UIColor(hex: "#eeeeee")
		setupSubView()
		let items = Observable.just([SectionModel(model: "现金管理", items: ["存款","取款","利息宝","推荐收益","活动彩金","资金明细"]),
									 SectionModel(model: "注单管理", items: ["彩票注单记录","其它注单记录","红包扫雷"]),
									 SectionModel(model: "其他", items: ["站内信","任务中心","每日签到"])])
		
		let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, String>>(configureCell: { (dataSource, collectionView, indexPath, title) -> UICollectionViewCell in
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WalletCollectionViewCell", for: indexPath) as! WalletCollectionViewCell
			cell.bind(title: title)
			return cell
		}, configureSupplementaryView: {(ds ,cv, kind, ip) in
			
			let sectionHeader = cv.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "WalletCollectionViewSectionHeader", for: ip) as! WalletCollectionViewSectionHeader
			sectionHeader.bind(title: ds[ip.section].model)
			return sectionHeader
		})
		
		collectionView.rx.itemSelected.subscribe(onNext: { [weak self] (indexPath) in
			guard let weakSelf = self else { return }
			
			switch (indexPath.section, indexPath.item) {
			case (0, 0):
				let vc = UIStoryboard(name: "Funds", bundle: nil).instantiateViewController(withIdentifier: "UGFundsViewController")
				vc.navigationItem.title = "存款"
				weakSelf.navigationController?.pushViewController(vc, animated: true)
			case (0, 1):
				let vc = UIStoryboard(name: "Funds", bundle: nil).instantiateViewController(withIdentifier: "UGFundsViewController") as! UGFundsViewController
				vc.selectIndex = 1
				vc.navigationItem.title = "取款"
				weakSelf.navigationController?.pushViewController(vc, animated: true)
			case (0, 2):
				
				let config = UGSystemConfigModel.currentConfig()
				guard config.yuebaoSwitch else {
					Alert.showTip("利息宝暂时关闭，请联系管理员")
					return
				}
				let vc = UIStoryboard(name: "UGYubaoViewController", bundle: nil).instantiateViewController(withIdentifier: "UGYubaoViewController")
				weakSelf.navigationController?.pushViewController(vc, animated: true)
			case(0, 3):
				weakSelf.navigationController?.pushVC(with: UserCenterItemType.UCI_推荐收益)
			case (0, 4):
				let vc = UGActivityGoldTableViewController()
				vc.navigationItem.title = "活动彩金"
				weakSelf.navigationController?.pushViewController(vc, animated: true)
			case (0, 5):
				let vc = UGFundDetailsTableViewController()
				vc.navigationItem.title = "资金明细"
				weakSelf.navigationController?.pushViewController(vc, animated: true)
			case (1, 0):
				weakSelf.navigationController?.pushViewController(UGBetRecordViewController(), animated: true)
			case (1, 1):
				weakSelf.navigationController?.pushViewController(UIStoryboard(name: "UGRealBetRecordViewController", bundle: nil).instantiateViewController(withIdentifier: "UGRealBetRecordViewController") , animated: true)
			case (2, 0):
				weakSelf.navigationController?.pushViewController(UGMailBoxTableViewController(), animated: true)
			case (2, 1):
				let config = UGSystemConfigModel.currentConfig()
				guard config.missionSwitch == "0" else {
					Alert.showTip("签到功能暂时关闭，请联系管理员")
					return
				}
				weakSelf.navigationController?.pushViewController(UIStoryboard(name: "UGMissionCenterViewController", bundle: nil).instantiateViewController(withIdentifier: "UGMissionCenterViewController"), animated: true)
			case (2, 2):
				weakSelf.navigationController?.pushViewController(UGSigInCodeViewController(), animated: true)
			case (2, 3):
				weakSelf.navigationController?.pushViewController(UGSecurityCenterViewController(), animated: true)
			case (_, _):
				break
			}
			
			
		}).disposed(by: disposeBag)
		
		
		items.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
		
		headView.balanceItem.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(balanceItemTaped)))
		headView.bankCardMangeItem.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bankCardMangeItemTaped)))
	}
	
	func setupSubView() {
		
		view.addSubview(headView)
		headView.snp.makeConstraints { (make) in
			make.leading.trailing.top.equalToSuperview()
			make.height.equalTo(App.width/2.5)
			
		}
		view.addSubview(collectionView)
		collectionView.snp.makeConstraints { (make) in
			make.top.equalTo(headView.snp.bottom)
			make.leading.trailing.bottom.equalTo(view).inset(layoutConfig.collectionViewEdgesInsers)
		}
		
	}
	@objc
	func balanceItemTaped() {

		let vc = UIStoryboard(name: "Mine", bundle: nil).instantiateViewController(withIdentifier: "UGBalanceConversionController")
		navigationController?.pushViewController(vc, animated: true)
	}
	@objc
	func bankCardMangeItemTaped() {
		let vc = UIStoryboard(name: "UGBindCardViewController", bundle: nil).instantiateViewController(withIdentifier: "UGBindCardViewController")
		navigationController?.pushViewController(vc, animated: true)
	}
	
}

class WalletCollectionViewCell: UICollectionViewCell {
	
	lazy var itemImage: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()
	lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.boldSystemFont(ofSize: 15)
		label.textColor = UIColor(hex: "#999999")
		label.textAlignment = .center
		
		return label
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .white
		let stackView = UIStackView()
		stackView.axis = .vertical
		addSubview(stackView)
		stackView.snp.makeConstraints { (make) in
			make.edges.equalToSuperview().inset(UIEdgeInsets(top: 40, left: 0, bottom: 10, right: 0))
		}
		stackView.addArrangedSubview(itemImage)
		
		stackView.addArrangedSubview(titleLabel)
		titleLabel.snp.makeConstraints { (make) in
			make.height.equalTo(40)
		}
		
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	let imageMap: [String: String] = ["存款": "ck","取款": "qk","利息宝": "lxb","推荐收益": "tj","活动彩金": "hdcj","资金明细": "zijinmingxi","彩票注单记录": "zdjl","其它注单记录": "qtzd","红包扫雷": "hongbaosaolei_records", "站内信": "znxx","任务中心": "rwzx","每日签到": "qd","安全中心": "aqzx"]
	func bind(title: String) {
		titleLabel.text = title
		if let imageName = imageMap[title] {
			itemImage.image = UIImage(named: imageName)
		}
	}
	
}

class WalletCollectionViewSectionHeader: UICollectionReusableView {
	
	lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.boldSystemFont(ofSize: 15)
		label.textColor = UIColor(hex: "#999999")
		label.textAlignment = .left
		label.backgroundColor = .white
		
		return label
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupSubView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupSubView() {
		addSubview(titleLabel)
		titleLabel.snp.makeConstraints { (make) in
			make.leading.trailing.equalToSuperview()
			make.top.bottom.equalToSuperview().inset(2)
		}
		
	}
	
	func bind(title: String) {
		titleLabel.text = "    " + title
	}
	
}


class MyWalletHeader: UIView {
	@IBOutlet weak var balanceItem: UIView!
	@IBOutlet weak var bankCardMangeItem: UIView!
	
	@IBOutlet weak var containerView: UIView!
	@IBOutlet weak var balanceLabel: UILabel!
	
}
