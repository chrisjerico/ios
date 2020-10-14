//
//  MomentsCell.swift
//  ug
//
//  Created by xionghx on 2019/12/20.
//  Copyright © 2019 ug. All rights reserved.
//

import UIKit
import RxDataSources
import RxRelay
import SVGKit
import SKPhotoBrowser
protocol MomentsCellDelegate: NSObject {
	func momentsCellDidComment(_ new: MomentsModel)
	func momentsCellDelete(item: MomentsModel)
	func momentsCellAddLike(item: MomentsModel)
	func momentsCellCancelLike(item: MomentsModel)
	func momnetCellAddFollow(item: MomentsModel)
	func momnetCellCancelFollow(item: MomentsModel)
	func momnetCellAddComment(item: MomentsModel, pid: Int)

}

class MomentsCell: UITableViewCell {
	var model: MomentsModel?
	weak var delegate: MomentsCellDelegate?
	
	@IBOutlet weak var addFollowButton: UIButton!
	@IBOutlet weak var commentBackDrop: UIView!
	@IBOutlet weak var commentCorner: UIImageView!
	@IBOutlet weak var thumbsUpButton: UIButton!
	@IBOutlet weak var commentButton: UIButton!
	@IBOutlet weak var contentLabel: UILabel!
	@IBOutlet weak var layout: UICollectionViewFlowLayout!
	@IBOutlet weak var avatarImageView: UIImageView!
	@IBOutlet weak var authorLabel: UILabel!
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var commentsStackView: UIStackView!
	@IBOutlet weak var colletionViewHeight: NSLayoutConstraint!
	@IBOutlet weak var browsCountLabel: UILabel!
	@IBOutlet weak var deleteButton: UIButton!
	let itemWidth = (App.width - 80 - 10)/3
	let items = BehaviorRelay(value: [String]())
	
	override func awakeFromNib() {
		super.awakeFromNib()
		selectionStyle = .none
		commentCorner.image = UIImage(named: "commentCorner")?.withRenderingMode(.alwaysTemplate)
		commentButton.setImage(SVGKImage(named: "pinglun").uiImage, for: .normal)
		thumbsUpButton.setImage(SVGKImage(named: "xihuan").uiImage, for: .normal)
		
		layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
		layout.minimumInteritemSpacing = 5
		layout.minimumLineSpacing = 5
		collectionView.register(UINib(nibName: "MomentsCellImageItem", bundle: nil), forCellWithReuseIdentifier: "MomentsCellImageItem")
		let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, String>>(configureCell: { (ds, cv, p, i) -> UICollectionViewCell in
			let cell = cv.dequeueReusableCell(withReuseIdentifier: "MomentsCellImageItem", for: p) as! MomentsCellImageItem
			cell.bind(item: i)
			return cell
		})
		items.map { [SectionModel(model: "", items: $0)]}.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
		
		collectionView.rx.itemSelected.subscribe(onNext: { [weak self] (path) in
			guard let weakSelf = self else { return }
			let browser = SKPhotoBrowser(photos: weakSelf.items.value.map { SKPhoto.photoWithImageURL($0)}, initialPageIndex: path.item)
			App.currentNavigationController.present(browser, animated: true, completion: nil)
			
		}).disposed(by: disposeBag)
	
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		for item in commentsStackView.arrangedSubviews {
			commentsStackView.removeArrangedSubview(item)
			//			item.layer.opacity = 0
			item.removeFromSuperview()
		}
		
	}
	func bind(item: MomentsModel) {
		
		model = item
		let lineCount = ceilf(Float(item.images.count)/Float(3.0))
		colletionViewHeight.constant = CGFloat(lineCount) * (itemWidth + 5)
		items.accept(item.images)
		timeLabel.text = item.create_ts
		authorLabel.text = item.usr
		avatarImageView.kf.setImage(with: URL(string: item.avatar),placeholder: UIImage(named: "placeholder_avatar"))
		contentLabel.text = item.content
		browsCountLabel.text = "浏览\(item.view_num)次"
		thumbsUpButton.isSelected = item.isLiked()
		deleteButton.isHidden = !item.isSelf()
//		addFollowButton.isSelected = item.relation_id == "1"
		addFollowButton.isSelected = item.is_follow
		addFollowButton.isHidden = item.uid == App.user.uid
		
		commentBackDrop.isHidden = !(item.like_list.count + item.comment_list.count > 0)
		
		if item.like_list.count > 0 {
			let likesLabel = UINib(nibName: "MomentsCellLikesLabel", bundle: nil).instantiate(withOwner: self, options: nil).first as! MomentsCellLikesLabel
			self.commentsStackView.addArrangedSubview(likesLabel)
			likesLabel.bind(item: item)
		}
		
		if item.like_list.count > 0 && item.comment_list.count > 0 {
			let line = UINib(nibName: "Line", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
			line.backgroundColor = UIColor(hex: "#E6E9F2")
			self.commentsStackView.addArrangedSubview(line)
		}
		item.comment_list.forEach { (comment) in
			//			let commentLabel = UINib(nibName: "MomentsCellCommentLabel", bundle: nil).instantiate(withOwner: self, options: nil).first as! MomentsCellCommentLabel
			//			commentLabel.delegate = self
			let commentLabel = MomentsCellCommentTextView()
			
			self.commentsStackView.addArrangedSubview(commentLabel)
			commentLabel.bind(item: comment)
		}
		
	}
	
	@IBAction func deleteButtonTaped(_ sender: Any) {
		guard let delegate = delegate, let model = model else { return }
		delegate.momentsCellDelete(item: model)
	}
	
	@IBAction func likeButtonTaped(_ sender: UIButton) {
		guard let delegate = delegate, let model = model else { return }
		
		if sender.isSelected {
			delegate.momentsCellCancelLike(item: model)
		} else {
			delegate.momentsCellAddLike(item: model)
		}
		
	}
	@IBAction func commentButtonTaped(_ sender: Any) {
		guard let delegate = delegate, let model = model else {
			return
		}
		delegate.momnetCellAddComment(item: model, pid: 0)
	}
	
	@IBAction func addFollowButtonTaped(_ sender: UIButton) {
		guard let delegate = delegate, let model = model else {
			return
		}
		if sender.isSelected {
			delegate.momnetCellCancelFollow(item: model)
		} else {
			delegate.momnetCellAddFollow(item: model)
		}
	}
}

extension MomentsCell: MomentsCellCommentLabelDelegate {
	func momentsCellCommentLabeCommented(item: MomentsCommentModel) {
		guard let delegate = delegate, var model = model else { return }
		model.comment_list.append(item)
		delegate.momentsCellDidComment(model)
	}
	
}
