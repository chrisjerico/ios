//
//  MJRefresh+RX.swift
//  ug
//
//  Created by xionghx on 2019/10/21.
//  Copyright © 2019 ug. All rights reserved.
//


import RxSwift
import RxCocoa
import MJRefresh

extension Reactive where Base: MJRefreshComponent {
	
	var refreshing: ControlEvent<Void> {
		let source: Observable<Void> = Observable.create {
			[weak control = self.base] observer  in
			if let control = control {
				control.refreshingBlock = {
					observer.on(.next(()))
				}
			}
			return Disposables.create()
		}
		return ControlEvent(events: source)
	}
	
	var endRefreshing: Binder<Bool> {
		return Binder(base) { refresh, isEnd in
			if isEnd {
				refresh.endRefreshing()
			}
		}
	}
}

public final class RefreshHeader: MJRefreshNormalHeader {

    public override func prepare() {
        super.prepare()

        isAutomaticallyChangeAlpha = true
        lastUpdatedTimeLabel?.isHidden = true

        setTitle("下拉刷新", for: .idle)
        setTitle("放开刷新", for: .pulling)
        setTitle("刷新中...", for: .refreshing)
    }

}

public final class RefreshFooter: MJRefreshAutoNormalFooter {

     public override func prepare() {
		 super.prepare()
		setTitle("正在获取数据中...", for: MJRefreshState.refreshing)
//		setTitle("加载更多", for: MJRefreshState.idle)
		setTitle("", for: MJRefreshState.idle)

//		setTitle("没有更多", for: MJRefreshState.noMoreData)
		setTitle("", for: MJRefreshState.noMoreData)

		stateLabel?.font = UIFont.systemFont(ofSize: 14.0)
		stateLabel?.textColor = UIColor(hex: "#999999")
	 }

	 func hideFooter() {
		stateLabel?.isHidden = true
	 }

	 func showFooter() {
		stateLabel?.isHidden = false
	 }

	override public func placeSubviews() {
		 super.placeSubviews()
		 let loadingView = self.subviews[1] as! UIActivityIndicatorView
		 var arrowCenterX = self.mj_w * 0.5
		 if !isRefreshingTitleHidden {
			 arrowCenterX -= 80
		 }
		 let arrowCenterY = self.mj_h * 0.5
		 loadingView.center = CGPoint(x: arrowCenterX, y: arrowCenterY)
	 }

}
