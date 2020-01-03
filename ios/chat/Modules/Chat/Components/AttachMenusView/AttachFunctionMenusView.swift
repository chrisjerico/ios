//
//  AttachFunctionMenusView.swift
//  ug
//
//  Created by xionghx on 2019/11/21.
//  Copyright © 2019 ug. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import MessageKit
import InputBarAccessoryView

protocol AttachMenusDelegate: NSObjectProtocol {
	func attachMenusDidSelected(index: Int)
}

class AttachFunctionMenusView: UIView {

	let cofigWidth: CGFloat = App.width - 24
	weak var delegate: AttachMenusDelegate?
	lazy var collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.minimumLineSpacing = 0
		layout.minimumInteritemSpacing = 0
		layout.itemSize = CGSize(width: cofigWidth/4, height: cofigWidth/4)
		let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
		collectionView.register(AttachFunctionMenusCell.self, forCellWithReuseIdentifier: "AttachFunctionMenusCell")
		collectionView.backgroundColor = UIColor.clear
		return collectionView
		
	}()
	init(dataSource: [[String: String]], onModelSelected: @escaping(_ index: Int) -> Void) {
		super.init(frame: CGRect(x: 0, y: 0, width: cofigWidth, height: cofigWidth/2))
		setupSubView()
		let dataSource: Observable<[[String: String]]> = Observable.just(dataSource)
		dataSource.bind(to: collectionView.rx.items) { (collectionView, item, element) in
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AttachFunctionMenusCell", for: IndexPath(item: item, section: 0)) as! AttachFunctionMenusCell
			cell.bind(imageName: element["image"]!, name: element["name"]!)
			return cell
		}.disposed(by: disposeBag)
		
		collectionView.rx.itemSelected.subscribe(onNext: { [weak self] (indexPath) in
//			self?.delegate?.attachMenusDidSelected(index: indexPath.row)
			onModelSelected(indexPath.row)
		}).disposed(by: disposeBag)
				
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupSubView() {
		addSubview(collectionView)
		collectionView.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
			make.size.equalTo(CGSize(width: cofigWidth, height: cofigWidth/2))
		}
	}
}

extension AttachFunctionMenusView: InputItem {
	var inputBarAccessoryView: InputBarAccessoryView? {
		get {
			return nil
		}
		set(newValue) {
			
		}
	}
	
	var parentStackViewPosition: InputStackView.Position? {
		get {
			return nil
		}
		set(newValue) {
			
		}
	}
	
	func textViewDidChangeAction(with textView: InputTextView) {
		
	}
	
	func keyboardSwipeGestureAction(with gesture: UISwipeGestureRecognizer) {
		
	}
	
	func keyboardEditingEndsAction() {
		
	}
	
	func keyboardEditingBeginsAction() {
		
	}
	
	
}
