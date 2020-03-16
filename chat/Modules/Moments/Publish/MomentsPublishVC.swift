//
//  MomentsPublishVC.swift
//  ug
//
//  Created by xionghx on 2019/12/23.
//  Copyright © 2019 ug. All rights reserved.
//

import UIKit
import RxRelay
import RxSwift
import RxDataSources
import RxOptional
import Moya
protocol MomentsPublishVCDelegate: NSObject {
	func MomentsPublishDidPublish()
}

class MomentsPublishVC: BaseVC {
	weak var delegate: MomentsPublishVCDelegate?
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
	@IBOutlet weak var placeHolderLabel: UILabel!
	@IBOutlet weak var contenTextView: UITextView!
	@IBOutlet weak var imageCollectionView: UICollectionView!
	let items = BehaviorRelay<[UIImage?]>(value: [nil])
	var layoutConfig = LayoutConfig()
	struct LayoutConfig {
		var itemCountPerLine = 3
		var itemSpacingInLine = 8
		var itemSize: CGSize {
			let totalWidth = App.width - 48
			let itemWidth = (totalWidth - CGFloat((itemCountPerLine - 1)*itemSpacingInLine))/CGFloat(itemCountPerLine)
			return CGSize(width: itemWidth, height: itemWidth)
		}
		func collectionViewHeight(of itemCount: Int) -> CGFloat {
			
			let lineHeight = itemSize.width + CGFloat(itemSpacingInLine)
			return CGFloat((itemCount - 1)/itemCountPerLine + 1) * lineHeight
		}
	}
	lazy var cancelItem: UIBarButtonItem = {
		let item = UIBarButtonItem(title: "取消", style: .done, target: self, action: #selector(cancelItemTaped))
		item.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], for: .normal)
		item.tintColor = UIColor.black
		return item
	}()
	lazy var publishButton: UIButton = {
		let button = UIButton(type: .custom)
		button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
		button.setTitle("发表", for: .normal)
		button.setTitleColor(.white, for: .normal)
		button.layer.cornerRadius = 3.5
		button.layer.masksToBounds = true
		button.backgroundColor = UIColor.x.main
		button.bounds = CGRect(x: 0, y: 0, width: 52, height: 26)
		button.addTarget(self, action: #selector(publishItemTaped), for: .touchUpInside)
		
		return button
		
	}()
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.leftBarButtonItem = cancelItem
		navigationItem.rightBarButtonItem = UIBarButtonItem(customView: publishButton)
		
		let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
		layout.minimumInteritemSpacing = CGFloat(layoutConfig.itemSpacingInLine)
		layout.minimumLineSpacing = CGFloat(layoutConfig.itemSpacingInLine)
		layout.itemSize = layoutConfig.itemSize
		
		collectionView.register(UINib(nibName: "MomentsPublishImageCell", bundle: nil), forCellWithReuseIdentifier: "MomentsPublishImageCell")
		
		let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, UIImage?>>(configureCell: { (ds, cv, p, i) in
			let cell = cv.dequeueReusableCell(withReuseIdentifier: "MomentsPublishImageCell", for: p) as! MomentsPublishImageCell
			cell.bind(item: i)
			return cell
		})
		
		items.map { [SectionModel(model: "", items: $0)]}.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
		contenTextView.rx.text.orEmpty.map { $0.count > 0 }.bind(to: placeHolderLabel.rx.isHidden).disposed(by: disposeBag)
		contenTextView.rx.text.orEmpty.map { $0.count > 0 }.bind(to: publishButton.rx.isEnabled).disposed(by: disposeBag)
		contenTextView.rx.text.orEmpty.map { $0.count > 0 ? UIColor.x.main : UIColor.x.main.withAlphaComponent(0.5) }.bind(to: publishButton.rx.backgroundColor).disposed(by: disposeBag)
		
		collectionView.rx.itemSelected.filter { [unowned self] index in index.item == self.items.value.count - 1 }.subscribe(onNext: { [unowned self] _ in
			self.addImage()
		}).disposed(by: disposeBag)
		
		items.subscribe(onNext: { [weak self] (items) in
			guard let weakSelf = self else { return }
			weakSelf.collectionViewHeight.constant = weakSelf.layoutConfig.collectionViewHeight(of: items.count)
		}).disposed(by: disposeBag)
		
	}
	
	@objc func cancelItemTaped() {
		navigationController?.dismiss(animated: true, completion: nil)
	}
	
	@objc func publishItemTaped() {
		
		let images = items.value.filter { $0 != nil } as! [UIImage]
		
		guard images.count > 0 else {
			momentsAPI.rx.request(MomentsTarget.publishImages(content: self.contenTextView.text ?? "", images: [String]() ))
				.mapBool().do( onError: { (error) in
					Alert.showTip(error.localizedDescription)
				}).subscribe(onSuccess: { [weak self] (success) in
					self?.navigationController?.dismiss(animated: true, completion: {
						Alert.showTip("动态发表成功")
						if let delegate = self?.delegate {
							delegate.MomentsPublishDidPublish()
						}
					})
				}).disposed(by: disposeBag)
			
			return
		}
		
		
		FileUploadApi.rx.requestWithProgress(FileUploadTarget.moments(images: images)).do( onNext: { Alert.showProgress(progress: $0.progress) }, onError: { error in
			Alert.showTip(error.localizedDescription)
		}).filter { $0.completed }.map {$0.response}.filterNil().mapObject(MomentsImageUpdateApiModel.self).do( onError: { (error) in
			Alert.showTip(error.localizedDescription)
		}).flatMap { [weak self] response in
			return momentsAPI.rx.request(MomentsTarget.publishImages(content: self?.contenTextView.text ?? "", images: response.result )) }
			.mapBool().do( onError: { (error) in
				Alert.showTip(error.localizedDescription)
			}).subscribe(onNext: { [weak self] (success) in
				self?.navigationController?.dismiss(animated: true, completion: {
					Alert.showTip("动态发表成功")
					if let delegate = self?.delegate {
						delegate.MomentsPublishDidPublish()
					}
				})
				
			}).disposed(by: disposeBag)
		
		
	}
	@objc func addImage() {
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
		.map { info in
			return info[.originalImage] as? UIImage
		}
		.filterNil()
		.subscribe(onNext: { [weak self] image in
			guard let weakSelf = self else { return }
			weakSelf.items.accept([image] + weakSelf.items.value)
		}).disposed(by: disposeBag)
		
		//		Observable.zip(image, image.flatMap { FileUploadApi.rx.requestWithProgress(FileUploadApi.image(data: $0))}.do( onNext: { Alert.showProgress(progress: $0.progress) }, onError: { error in
		//			Alert.showTip(error.localizedDescription)
		//		}).filter { $0.completed }).retry().subscribe(onNext: { [weak self] (image, response) in
		//			Alert.hide()
		//			if
		//				let weakSelf = self, response.completed,
		//				let response = response.response,
		//				let fileModel = try? response.mapObject(NetWorkFileModel.self, keyPath: nil, decrypt: false)
		//			{
		//				weakSelf.items.accept( [(fileModel.url, image)] + weakSelf.items.value)
		//			}
		//
		//		}).disposed(by: disposeBag)
		
	}
}

