//
//  RedpacketGrabListVC.swift
//  ug
//
//  Created by xionghx on 2019/12/8.
//  Copyright © 2019 ug. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RxOptional

class RedpacketGrabListVC: BaseVC {
	let grabList = BehaviorRelay<RedpacketModel?>(value: nil)
	var layoutConfig = LayoutConfig()
	struct LayoutConfig {
		var topImageSize: CGSize = CGSize(width: App.width, height: 150)
		var topImageRadius = CGFloat(App.width)
		var avatarImageSize: CGSize = CGSize(width: 60, height: 60)
	}
	lazy var topImageView: UIImageView = {
		UIGraphicsBeginImageContextWithOptions(layoutConfig.topImageSize, false, 0)
		defer {
			UIGraphicsEndImageContext()
		}
		
		let radius = layoutConfig.topImageRadius
		let startAngle = CGFloat(acosf(0.5))
		let endAngle = CGFloat.pi - acos(0.5)
		let distanceY = CGFloat(sinf(Float(startAngle)))*radius
		let startY = distanceY + layoutConfig.topImageSize.height - radius
		
		let path = UIBezierPath()
		path.move(to: CGPoint.zero)
		path.addLine(to: CGPoint(x: App.width, y: 0))
		path.addLine(to: CGPoint(x: App.width, y: startY))
		path.addArc(withCenter: CGPoint(x: App.width/2, y: startY - CGFloat(distanceY)), radius: CGFloat(radius), startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: true)
		UIColor(hex: "#f7213a").setFill()
		path.fill()
		
		return UIImageView(image: UIGraphicsGetImageFromCurrentImageContext())
	}()
	
	lazy var avatarImageView: UIImageView = {
		let imageView = UIImageView()
		//		imageView.contentMode = .scaleAspectFit
		imageView.layer.cornerRadius = layoutConfig.avatarImageSize.width/2
		imageView.layer.masksToBounds = true
		imageView.backgroundColor = .gray
		return imageView
	}()
	
	lazy var nameLabel: UILabel = {
		let label = UILabel()
		label.font = .boldSystemFont(ofSize: 17)
		
		return label
	}()
	
	lazy var tableView: UITableView = {
		let tableView = UITableView(frame: CGRect.zero, style: .grouped)
		tableView.register(GrabListCell.self, forCellReuseIdentifier: "GrabListCell")
		return tableView
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		let rightItem = UIBarButtonItem(image: UIImage(named: "close_white")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: nil)
		navigationItem.rightBarButtonItem = rightItem
		
		rightItem.rx.tap.subscribe(onNext: {[weak self] () in
			self?.navigationController?.dismiss(animated: true, completion: nil)
		}).disposed(by: disposeBag)
		
		setupSubView()
		
		navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor(hex: "#f7213a"), size: CGSize(width: 1, height: 1)), for: UIBarMetrics.default)
		navigationController?.navigationBar.shadowImage = UIImage()
		let titleLabel = UILabel()
		titleLabel.attributedText = "红包详情".mutableAttributedString().x.color(.white).x.font(.boldSystemFont(ofSize: 17))
		navigationItem.titleView = titleLabel
		
		let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, PacketGrabMemberModel>>(configureCell: {
			(dataSource, tableView, indexPath, element) in
			let cell = tableView.dequeueReusableCell(withIdentifier: "GrabListCell") as! GrabListCell
			cell.bind(element)
			return cell
			})
		
		dataSource.titleForHeaderInSection = { dataSource, index in
			return dataSource.sectionModels[index].model
		}
		grabList.filterNil().map { [SectionModel(model: "共\($0.quantity)个红包，总金额\($0.amount)元，\($0.grabList.count < $0.quantity ? "剩余\($0.quantity - $0.grabList.count)个": "已被抢光" )", items: $0.grabList)]}.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
	
	}
	
	func setupSubView() {
		
		view.addSubview(topImageView)
		topImageView.snp.makeConstraints { (make) in
			make.left.top.equalToSuperview()
			make.size.equalTo(layoutConfig.topImageSize)
		}
		
		view.addSubview(avatarImageView)
		avatarImageView.snp.makeConstraints { (make) in
			make.centerX.equalToSuperview()
			make.centerY.equalTo(topImageView.snp.bottom)
			make.size.equalTo(layoutConfig.avatarImageSize)
		}
		
		view.addSubview(nameLabel)
		nameLabel.snp.makeConstraints { (make) in
			make.centerX.equalToSuperview()
			make.top.equalTo(avatarImageView.snp.bottom).offset(5)
		}
		
		view.addSubview(tableView)
		tableView.snp.makeConstraints { (make) in
			make.left.right.equalToSuperview()
			make.top.equalTo(nameLabel.snp.bottom).offset(5)
			make.bottom.equalToSuperview().offset(-App.tabBarHeight + 48)
		}
		
		
	}
	
	
	func bind(sender: RedpacketSender, item: RedpacketModel) {
		avatarImageView.kf.setImage(with: URL(string: sender.avatar), placeholder: UIImage(named: "txp"))
		nameLabel.text = sender.displayName
		grabList.accept(item)
		
	}
	
}


class GrabListCell: UITableViewCell {
	var layoutConfig = LayoutConfig()
	struct LayoutConfig {
		var avatarContains = CGRect(x: 10, y: 5, width: 50, height: 50)
		var nameLabelPosition = CGPoint(x: 15, y: 10)
	}
	lazy var avatarImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.layer.cornerRadius = layoutConfig.avatarContains.width/2
		imageView.layer.masksToBounds = true
		return imageView
	}()
	
	lazy var nameLabel: UILabel = {
		let label = UILabel()
		label.font = .boldSystemFont(ofSize: 14)
		return label
	}()
	lazy var dateLabel: UILabel = {
		let label = UILabel()
		return label
	}()
	lazy var amountLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 13)
		return label
	}()
	lazy var extraMark: UIImageView = {
		let imageView = UIImageView()
		return imageView
	}()
	
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		selectionStyle = .none
		setupSubView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupSubView() {
		addSubview(avatarImageView)
		avatarImageView.snp.makeConstraints { (make) in
			make.left.equalToSuperview().offset(layoutConfig.avatarContains.origin.x)
			make.top.bottom.equalToSuperview().inset(layoutConfig.avatarContains.origin.y)
			make.size.equalTo(layoutConfig.avatarContains.size)
			
		}
		addSubview(nameLabel)
		nameLabel.snp.makeConstraints { (make) in
			make.leading.equalTo(avatarImageView.snp.trailing).offset(layoutConfig.nameLabelPosition.x)
			make.top.equalToSuperview().offset(layoutConfig.nameLabelPosition.y)
		}
		addSubview(dateLabel)
		dateLabel.snp.makeConstraints { (make) in
			make.leading.equalTo(nameLabel)
			make.bottom.equalTo(avatarImageView).offset(-5)
		}
		addSubview(amountLabel)
		amountLabel.snp.makeConstraints { (make) in
			make.trailing.equalToSuperview().offset(-10)
			make.top.equalTo(nameLabel)
		}
		addSubview(extraMark)
		extraMark.snp.makeConstraints { (make) in
			make.trailing.equalTo(amountLabel)
			make.bottom.equalTo(dateLabel)
		}
		
	}
	func bind(_ item: PacketGrabMemberModel) {
		avatarImageView.kf.setImage(with: URL(string: item.avatar), placeholder: UIImage(named: "txp"))
		nameLabel.text = item.nickname
		dateLabel.attributedText = timeFormater.string(from: Date(timeIntervalSince1970: Double(item.time))).mutableAttributedString().x.fontSize(12).x.color(UIColor(hex: "#555555"))
		amountLabel.text = "\(item.miniRedBagAmount)元"
		
		if item.isMax == 1 {
			extraMark.image = UIImage(named: "redpacket-sqzj")
		} else if item.isMine == 1 {
			extraMark.image = UIImage(named: "redpacket-zjlz")
		} else {
			extraMark.image = nil
		}
	}
	
	let timeFormater: DateFormatter = {
		let formater = DateFormatter()
		formater.dateFormat = "yyyy-MM-dd hh:mm:ss"
		return formater
		
	}()
}
