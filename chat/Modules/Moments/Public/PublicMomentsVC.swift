//
//  PublicMomentsVC.swift
//  ug
//
//  Created by xionghx on 2019/12/26.
//  Copyright © 2019 ug. All rights reserved.
//

import UIKit
import RxSwift
import SwiftyJSON
import RxRelay
import RxDataSources
import RxCocoa
import SVGKit
import InputBarAccessoryView
import SKPhotoBrowser

class PublicMomentsVC: BaseVC {
	
	@IBOutlet weak var tableView: UITableView!
	var page = 1
	let pageSize = 20
	let momentsList = BehaviorRelay(value: [MomentsModel]())
	let shouldRefresh = PublishRelay<()>()
	var commentingMomentsModel: (MomentsModel, Int)?
	lazy var commentInputBar: CommentInputBar = {
		let inputBar = UINib(nibName: "CommentInputBar", bundle: nil).instantiate(withOwner: self, options: nil).first as! CommentInputBar
		inputBar.delegate = self
		return inputBar
	}()
	deinit {
		logger.debug("deinit")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.addSubview(commentInputBar)
		commentInputBar.snp.makeConstraints { (make) in
			make.left.right.bottom.equalTo(tableView)
			make.height.equalTo(54)
		}
		commentInputBar.dismiss()
		
		navigationItem.title = "看一看"
		let item = UIBarButtonItem(image: SVGKImage(named: "fabupengyouquan").uiImage, style: .plain, target: self, action: #selector(rightItemTaped))
		item.tintColor = UIColor.white
		navigationItem.rightBarButtonItem = item
		tableView.register(UINib(nibName: "MomentsBetCell", bundle: nil), forCellReuseIdentifier: "MomentsBetCell")
		tableView.register(UINib(nibName: "MomentsCell", bundle: nil), forCellReuseIdentifier: "MomentsCell")
		tableView.mj_header = RefreshHeader()
		tableView.mj_footer = RefreshFooter()
		tableView.tableFooterView = UIView()
		
		Observable.merge(tableView.mj_header.rx.refreshing.asObservable(), shouldRefresh.asObservable()).flatMap { [weak self] _ in
			return momentsAPI.rx.request(MomentsTarget.allMoments(page: 1, row: 20)).mapObject(MomentsApiDataModel.self).do( onError: { (error) in
				guard let weakSelf = self else { return }
				Alert.showTip("\(error)")
				weakSelf.tableView.mj_header.endRefreshing()
			})
		}.retry().subscribe(onNext: { [weak self] (data) in
			guard let weakSelf = self else { return }
			weakSelf.tableView.mj_header.endRefreshing()
			weakSelf.momentsList.accept(data.list)
			weakSelf.page = 2
			Alert.hide()
		}).disposed(by: disposeBag)
		
		
		tableView.mj_footer.rx.refreshing.flatMap { [weak self] _ -> Observable<MomentsApiDataModel>  in
			guard let weakSelf = self else { return Observable.empty() }
			return momentsAPI.rx.request(MomentsTarget.allMoments(page: weakSelf.page, row: weakSelf.pageSize)).asObservable().mapObject(MomentsApiDataModel.self).do( onError: {  (error) in
				Alert.showTip(error.localizedDescription)
				weakSelf.tableView.mj_footer.endRefreshing()
			})
		}.retry().subscribe(onNext: { [weak self] (data) in
			guard let weakSelf = self else { return }
			if data.list.count > 0 {
				weakSelf.momentsList.accept(weakSelf.momentsList.value + data.list)
				weakSelf.page += 1
				weakSelf.tableView.mj_footer.endRefreshing()
				
			} else {
				weakSelf.tableView.mj_footer.endRefreshingWithNoMoreData()
			}
			
		}).disposed(by: disposeBag)
		
		
		let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, MomentsModel>>(configureCell: { [weak self] (ds,tv,p,item) -> UITableViewCell in
			
			if item.msg_type == "1" {
				let cell = tv.dequeueReusableCell(withIdentifier: "MomentsBetCell", for: p) as! MomentsBetCell
				cell.delegate = self
				cell.bind(item: item)
				return cell
			} else {
				let cell = tv.dequeueReusableCell(withIdentifier: "MomentsCell", for: p) as! MomentsCell
				cell.delegate = self
				cell.bind(item: item)
				
				return cell
			}
		})
		
		
		momentsList.map { [SectionModel(model: "", items: $0)] }.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
		tableView.rx.itemSelected.subscribe(onNext: { [unowned self] (path) in
			self.tableView.deselectRow(at: path, animated: true)
			self.view.endEditing(true)
			
		}).disposed(by: disposeBag)
		
		shouldRefresh.accept(())
	}
	
	@objc func rightItemTaped() {
		let publishVC = MomentsPublishVC()
		navigationController?.present(BaseNav(rootViewController: publishVC), animated: true, completion: nil)
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		view.endEditing(true)
	}
	
	
}


extension PublicMomentsVC: MomentsCellDelegate {
	func momnetCellAddComment(item: MomentsModel, pid: Int) {
		commentingMomentsModel = (item, pid)
		commentInputBar.show()
	}
	
	func momnetCellCancelFollow(item: MomentsModel) {
		Alert.showLoading()
		momentsAPI.rx.request(MomentsTarget.cancelFollow(uid: item.uid) ).mapBool().subscribe(onSuccess: { [weak self] (success) in
			guard let weakSelf = self else { return }
			weakSelf.momentsList.accept(weakSelf.momentsList.value.map({ (model)  in
				var newModel = model
				if model.mid == item.mid {
					newModel.relation_id = "0"
				}
				return newModel
			}) )
			Alert.hide()
		}) { (error) in
			Alert.showTip(error.localizedDescription)
		}.disposed(by: disposeBag)
	}
	
	func momnetCellAddFollow(item: MomentsModel) {
		Alert.showLoading()
		momentsAPI.rx.request(MomentsTarget.addFollow(uid: item.uid) ).mapBool().subscribe(onSuccess: { [weak self] (success) in
			guard let weakSelf = self else { return }
			weakSelf.momentsList.accept(weakSelf.momentsList.value.map({ (model)  in
				var newModel = model
				if model.mid == item.mid {
					newModel.relation_id = "1"
				}
				return newModel
			}) )
			Alert.hide()
		}) { (error) in
			Alert.showTip(error.localizedDescription)
		}.disposed(by: disposeBag)
	}

	func momentsCellAddLike(item: MomentsModel) {
		Alert.showLoading()
		momentsAPI.rx.request(MomentsTarget.addLike(mid: item.mid) ).mapBool().subscribe(onSuccess: { [weak self] (success) in
			guard let weakSelf = self else { return }
			weakSelf.momentsList.accept(weakSelf.momentsList.value.map({ (model)  in
				var newModel = model
				if model.mid == item.mid {
					newModel.like_list.append(MomentsLikesModel(JSON: ["uid": App.user.userId, "usr": App.user.usr])!)
				}
				return newModel
			}) )
			Alert.hide()
		}) { (error) in
			Alert.showTip(error.localizedDescription)
		}.disposed(by: disposeBag)
	}
	
	func momentsCellCancelLike(item: MomentsModel) {
		Alert.showLoading()
		momentsAPI.rx.request(MomentsTarget.cancelLike(mid: item.mid)).mapBool().subscribe(onSuccess: { [weak self] (success) in
			guard let weakSelf = self else { return }
			weakSelf.momentsList.accept(weakSelf.momentsList.value.map({ (model)  in
				var newModel = model
				if model.mid == item.mid {
					newModel.like_list = model.like_list.filter { $0.uid != Int(App.user.userId) }
				}
				return newModel
			}) )
			Alert.hide()
		}) { (error) in
			Alert.showTip(error.localizedDescription)
		}.disposed(by: disposeBag)
	}
	
	func momentsCellDelete(item: MomentsModel) {
		Alert.showLoading()
		momentsAPI.rx.request(MomentsTarget.delMoment(mid: item.mid)).mapBool().subscribe(onSuccess: { [weak self] (success) in
			guard let weakSelf = self else { return }
			weakSelf.momentsList.accept(weakSelf.momentsList.value.filter { $0.mid != item.mid })
			Alert.hide()
		}) { (error) in
			Alert.showTip(error.localizedDescription)
		}.disposed(by: disposeBag)
		
	}
	
	func momentsCellDidComment(_ new: MomentsModel) {
		view.endEditing(true)
		momentsList.accept(momentsList.value.map { $0.mid == new.mid ? new : $0})
	}
}
extension PublicMomentsVC: CommentInputBarDelegate {
	func commentInputBarSendButtonTaped(content: String) {
		guard var commentingMomentsModel = commentingMomentsModel else {
			return
		}
		Alert.showLoading()

		momentsAPI.rx.request(MomentsTarget.comment(content: content, mid: commentingMomentsModel.0.mid, pid: commentingMomentsModel.1)).mapBool().subscribe(onSuccess: { [weak self] (success) in
			Alert.hide()
			guard let weakSelf = self else { return }
			var comment = MomentsCommentModel(JSON: [String: Any]())!
			comment.comment = content
			comment.pid = commentingMomentsModel.1
			comment.mid = commentingMomentsModel.0.mid
			comment.uid = Int(App.user.userId)!
			comment.usr = App.user.username as String
			commentingMomentsModel.0.comment_list.append(comment)
			weakSelf.momentsList.accept(weakSelf.momentsList.value.map { $0.mid == commentingMomentsModel.0.mid ? commentingMomentsModel.0 : $0})
			Alert.showTip("评论成功")
			weakSelf.commentInputBar.dismiss()
			weakSelf.commentingMomentsModel = nil
		}, onError: { (error) in
			Alert.showTip(error.localizedDescription)
		}).disposed(by: disposeBag)
		
		
	}
	
	
}
