//
//  AppKit.swift
//  XiaoJir
//
//  Created by xionghuanxin on 2018/9/29.
//  Copyright © 2018年 xionghx. All rights reserved.
//

import Foundation

public struct AppKit<Base> {
    public let base: Base

    public init(_ base: Base) {
        self.base = base
    }
}

public protocol AppKitCompatible {
//    associatedtype CompatibleType
//
//    static var x: AppKit<CompatibleType>.Type { get }
//    var x: AppKit<CompatibleType> { get }
}

extension AppKitCompatible {

    public static var x: AppKit<Self>.Type {
        get {
            return AppKit<Self>.self
        }
        set { }
    }

    public var x: AppKit<Self> {
        get {
            return AppKit(self)
        }
        set { }
    }

}

extension NSObject: AppKitCompatible { }
