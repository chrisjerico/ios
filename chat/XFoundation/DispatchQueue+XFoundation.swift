//
//  DispatchQueue+AppKit.swift
//  XiaoJir
//
//  Created by xionghuanxin on 2018/9/29.
//  Copyright © 2018年 xionghx. All rights reserved.
//

import Foundation

private var _onceTracker = [String]()

public extension AppKit where Base: DispatchQueue {

    /// 唯一性操作
    ///
    /// - Parameters:
    ///   - token: 操作的标识符
    ///   - block: 回调的操作
	static func once(token: String, block: () -> Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }

        if _onceTracker.contains(token) {
            return
        }

        _onceTracker.append(token)
        block()
    }

    /// 主线程安全执行操作
    ///
    /// - Parameter block: 回调的操作
	func safeAsync(_ block: @escaping () -> Swift.Void) {
        if base === DispatchQueue.main && Thread.isMainThread {
            block()
        } else {
            base.async { block() }
        }
    }

    /// 主线程延时操作
    ///
    /// - Parameters:
    ///   - time: 延时的时间
    ///   - work: 回调的操作
	static func after(_ time: Double, execute work: @escaping () -> Swift.Void) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time, execute: work)
    }

    /// 主线程延时操作
    ///
    /// - Parameters:
    ///   - time: 延时的时间
    ///   - execute: 执行的工作
	static func after(_ time: Double, execute: DispatchWorkItem) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time, execute: execute)
    }

}
