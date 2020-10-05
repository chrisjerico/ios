//
//  AppDelegate.swift
//  chat
//
//  Created by xionghx on 2020/1/3.
//  Copyright © 2020 ug. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	
	@objc
	var allowRotation = false
	@objc
	var notiveViewHasShow = false
	var window: UIWindow?

	
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.rootViewController = UGLaunchController()
		window?.makeKeyAndVisible()
		Configuration.setup(launchOptions)
		return true
	}



}
