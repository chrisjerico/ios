//
//  RootViewControllerProvider.swift
//  ug
//
//  Created by xionghx on 2019/10/25.
//  Copyright © 2019 ug. All rights reserved.
//

import Foundation
import ESTabBarController_swift
@objc
class ControllerProvider: NSObject {
	
	@objc
	static func rootTabViewController() -> UITabBarController {

		return RootTabBarController()
	}
	
	@objc
	static func loginViewController() -> UIViewController {
		return BaseNav(rootViewController: LoginVC())
//		return AppDefine.viewController(withStoryboardID: "UGLoginViewController")
	}
 
	@objc
	static var currentTabController: ESTabBarController {
		guard let tabBarController = App.widow.rootViewController as? ESTabBarController else {
			fatalError("")
		}
		return tabBarController
		
	}
	
	@objc
	static var currentNavigationController: BaseNav {
		return App.currentNavigationController
		
	}
	
	
	
	
}
