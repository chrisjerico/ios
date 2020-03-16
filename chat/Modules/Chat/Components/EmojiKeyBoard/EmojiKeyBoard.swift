//
//  EmojiKeyBoard.swift
//  XiaoJir
//
//  Created by xionghx on 2018/11/9.
//  Copyright © 2018 xionghx. All rights reserved.
//

import UIKit
import RxRelay

protocol EmojiKeyBoardInputDelegate: NSObjectProtocol {
	func didSelected(emoticon: EmoticonType)
	func delButtonTaped()
	func sendButtonTaped()
}

class EmojiKeyBoard: UIView {
	
	enum KeyType {
		case emotion(key: EmoticonType)
		case del
		case send
	}
	let keyTaped = PublishRelay<KeyType>()

	private var safeAreaBottomInsets: CGFloat = 0
	
	private let cellWidth = CGFloat(App.width/8)
	
	private var allEmojis: [EmoticonType]
	
	weak var delegate: EmojiKeyBoardInputDelegate?
	
	override init(frame: CGRect) {
		
		let emojiBundlePath = Bundle.main.path(forResource: "Emoji", ofType: "bundle")!
		
		allEmojis = (1...172).map { (index) in
			let emojiFilePath = Bundle(path: emojiBundlePath)!.path(forResource: "\(index)", ofType: "gif", inDirectory: "Resource")!
			return EmoticonType.gif(filePath: emojiFilePath)
		}
		
		let	frame = CGRect(x: 0, y: 0, width: App.width, height: 250)
		super.init(frame: frame)
		
		setupSubview()
		
		collectionView.layoutIfNeeded()
	}
	internal required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private lazy var sendButton: UIButton = {
		let button = UIButton()
		button.setAttributedTitle("发送".mutableAttributedString().x.fontSize(16).x.color(UIColor.white), for: .normal)
		button.backgroundColor = UIColor(hex: "#1CA2F3")
		button.rx.tap.subscribe(onNext: { [unowned self] () in
			self.keyTaped.accept(.send)
			self.delegate?.sendButtonTaped()
		}).disposed(by: disposeBag)
		button.layer.cornerRadius = 3
		button.layer.masksToBounds = true
		return button
	}()
	private lazy var delButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage.init(named: "biaoqingshanchu"), for: .normal)
		button.backgroundColor = UIColor.white
		button.layer.cornerRadius = 3
		button.layer.masksToBounds = true
		button.rx.tap.subscribe(onNext: { [unowned self] () in
			self.delegate?.delButtonTaped()
			self.keyTaped.accept(EmojiKeyBoard.KeyType.del)
		}).disposed(by: disposeBag)
		return button
		
	}()
	
	
	private lazy var collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
		layout.minimumInteritemSpacing = 0
		layout.minimumLineSpacing = 0
		layout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: cellWidth, right: 0)
		layout.scrollDirection = .vertical
		
		let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
		view.backgroundColor = UIColor(hex: "#eaecf0")
		view.isPagingEnabled = true
		view.delegate  = self
		view.dataSource = self
		view.showsHorizontalScrollIndicator = false
		view.register(EmojiCell.self, forCellWithReuseIdentifier: "EmojiCell")
		return view
	}()
	
	internal func setupSubview() {
		
		self.backgroundColor = UIColor(hex: "#eaecf0")
		
	
		if App.isXSeriesDevices {
			safeAreaBottomInsets = 34
		}
		
		let baseScrollView = UIScrollView()
		addSubview(baseScrollView)
		baseScrollView.snp.makeConstraints { (make) in
			make.left.top.right.equalToSuperview()
			make.bottom.equalToSuperview().offset(-safeAreaBottomInsets)
			make.width.equalToSuperview()
		}
		
		let containerView = UIView()
		baseScrollView.addSubview(containerView)
		containerView.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
			make.width.equalToSuperview()
		}
		
		containerView.addSubview(collectionView)
		let height = CGFloat(((allEmojis.count - 1)/8 + 1)) * cellWidth
		collectionView.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
			make.height.equalTo(height + App.width/8 + 5)
		}
		
		addSubview(sendButton)
		sendButton.snp.makeConstraints { (make) in
			make.right.equalTo(self).offset(-3)
			make.bottom.equalTo(self).offset(-3 - safeAreaBottomInsets)
			make.size.equalTo(CGSize(width: 56, height: cellWidth))
		}
		addSubview(delButton)
		delButton.snp.makeConstraints { (make) in
			make.right.equalTo(sendButton.snp.left).offset(-5)
			make.bottom.equalTo(sendButton)
			make.size.equalTo(sendButton)
		}
		
	}
	
	@objc internal func pageControlTaped(sender: UIPageControl) {
		self.collectionView.setContentOffset(CGPoint(x: CGFloat(sender.currentPage) * App.width, y: 0), animated: true)
	}

}

extension EmojiKeyBoard: UICollectionViewDelegate, UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return allEmojis.count
	}
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCell", for: indexPath) as! EmojiCell
		cell.bindData(emoji: allEmojis[indexPath.item])
		
		return cell
	}
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		delegate?.didSelected(emoticon: allEmojis[indexPath.item])
		keyTaped.accept(EmojiKeyBoard.KeyType.emotion(key: allEmojis[indexPath.item]))
	}
	
}
