//
//  MomentsBetCell.swift
//  ug
//
//  Created by xionghx on 2019/12/26.
//  Copyright © 2019 ug. All rights reserved.
//
import UIKit
import RxDataSources
import RxRelay
import SVGKit
import SKPhotoBrowser

class MomentsBetCell: UITableViewCell {
	var model: MomentsModel?
	weak var delegate: MomentsCellDelegate?
	
	@IBOutlet weak var addFollowButton: UIButton!
	@IBOutlet weak var commentBackDrop: UIView!
	@IBOutlet weak var commentCorner: UIImageView!
	@IBOutlet weak var thumbsUpButton: UIButton!
	@IBOutlet weak var commentButton: UIButton!
	@IBOutlet weak var contentLabel: UILabel!
	@IBOutlet weak var avatarImageView: UIImageView!
	@IBOutlet weak var betContainerHeight: NSLayoutConstraint!
	@IBOutlet weak var betContainerView: UIView!
	@IBOutlet weak var authorLabel: UILabel!
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var commentsStackView: UIStackView!
	@IBOutlet weak var browsCountLabel: UILabel!
	@IBOutlet weak var deleteButton: UIButton!
	lazy var betView: BetMessageContentView = {
		return Bundle.main.loadNibNamed("BetMessageContentView", owner: self, options: nil)?.first as! BetMessageContentView
	}()
	
	override func awakeFromNib() {
		super.awakeFromNib()
		selectionStyle = .none

		commentCorner.image = UIImage(named: "commentCorner")?.withRenderingMode(.alwaysTemplate)
		commentButton.setImage(SVGKImage(named: "pinglun").uiImage, for: .normal)
		thumbsUpButton.setImage(SVGKImage(named: "xihuan").uiImage, for: .normal)
			
		betContainerView.addSubview(betView)
		betView.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		for item in commentsStackView.arrangedSubviews {
			commentsStackView.removeArrangedSubview(item)
			item.removeFromSuperview()
			//			item.layer.opacity = 0
		}
		
	}
	func bind(item: MomentsModel) {
		if let betInfo = item.bet_info {
			betView.bind(item: betInfo)
			let totalHeight = CGFloat(betInfo.betBeans.count) * CGFloat(28) + 124
			betContainerHeight.constant = totalHeight
		}
		model = item
		timeLabel.text = item.create_ts
		authorLabel.text = item.usr
		avatarImageView.image = UIImage(named: "placeholder_avatar")
		contentLabel.text = item.content
		browsCountLabel.text = "浏览\(item.view_num)次"
		thumbsUpButton.isSelected = item.isLiked()
		deleteButton.isHidden = !item.isSelf()
		
		
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
	

}

extension MomentsBetCell: MomentsCellCommentLabelDelegate {
	func momentsCellCommentLabeCommented(item: MomentsCommentModel) {
		guard let delegate = delegate, var model = model else { return }
		model.comment_list.append(item)
		delegate.momentsCellDidComment(model)
	}
	
}
