//
//  Configuration.swift
//  XiaoJir
//
//  Created by xionghuanxin on 2018/9/30.
//  Copyright © 2018年 xionghx. All rights reserved.
//

import Kingfisher
import IQKeyboardManagerSwift
import UserNotifications
import SKPhotoBrowser
import MessageKit

@objc
public final class Configuration: NSObject {
	
	//	private override init() {}
	
	/// 初始化配置
	@objc
	public static func setup(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
		configBugly()
		configNetwork()
		configWebImage()
		configLogger()
		configKeyboard()
		configAmap()
		configPhotoBrowser()
		LogVC.enable()
        RxImagePickerDelegateProxy.register { RxImagePickerDelegateProxy(imagePicker: $0) }
		
	}
	
	/// 清除缓存
	public static func cleanCache(completion handler: (() -> Void)? = nil) {
		KingfisherManager.shared.cache.cleanExpiredDiskCache {
			KingfisherManager.shared.cache.clearMemoryCache()
			KingfisherManager.shared.cache.clearDiskCache(completion: {
				handler?()
			})
		}
	}
	
	/// 取消所有网络请求
	public static func cancelAllRequests() {
		
	}
	
	/// 清除用户信息
	public static func clearUserInfo() {
		UGUserModel.setCurrentUser(nil)
	}
	
	
	
	/// 注册远程推送
	public static func registerNotification() {
		
		let delegate = UIApplication.shared.delegate as? AppDelegate
		
		
		//本地
		let notificationCenter = UNUserNotificationCenter.current()
		notificationCenter.delegate = delegate
		notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (_, error) in
			
			if let error = error {
				//				logger.debug("error:\(error.localizedDescription)")
			} else {
				//				logger.debug("添加本地通知成功!")
			}
		}
		UIApplication.shared.registerForRemoteNotifications()
		
	}
	
	/// 注销APNS订阅
	public static func unRegisterNotification() {
		
		UIApplication.shared.unregisterForRemoteNotifications()
	}
	
	/// 退出登录
	public static func logout() {
		Alert.showLoading()
		CMNetwork.userLogout(withParams: ["token": App.user.token]) { (result, error) in
			if let error = error {
				Alert.showTip(error.localizedDescription)
			}
			cancelAllRequests()
			unRegisterNotification()
			SocketManager.shared.disconnect()
			clearUserInfo()
			App.widow.rootViewController = ControllerProvider.loginViewController()
		}
		cancelAllRequests()
		clearUserInfo()
		unRegisterNotification()
	}
	
	public static func configAmap() {
		//		AMapServices.shared().apiKey = "e2c7cc4de2abbb71ae6ce42bccd22df2"
	}
	
}

private extension Configuration {
	
	static func configPhotoBrowser() {
		SKPhotoBrowserOptions.displayAction = false
	}
	static func configBugly() {
		//		Bugly.start(withAppId: "9146a6a4f8")
		
	}
	
	static func configNetwork() {
		Reachability.shared.startNotifier()
	}
	
	static func configWebImage() {
		KingfisherManager.shared.defaultOptions = [.transition(.fade(0.3))]
	}
	
	static func configLogger() {
		//        let console = ConsoleDestination()
		//        #if DEBUG
		//        let file = FileDestination()
		//        if App.isSimulator {
		//            // tail -f /tmp/app_info.log
		//            file.logFileURL = URL(string: "file:///tmp/app_info.log")!
		//        }
		//        logger.addDestination(file)
		//        #else
		//        console.minLevel = .error
		//        #endif
		//
		//        logger.addDestination(console)
	}
	
	static func configKeyboard() {
		
		//		键盘与输入控件距离
		IQKeyboardManager.shared.enable = false
		let handlingClasses = [
			PublicMomentsVC.self,
			ConcernedMomentsVC.self,
			UGCommonLotteryController.self,
			LoginVC.self
		]
		IQKeyboardManager.shared.enabledDistanceHandlingClasses = handlingClasses
		
		//		点击键盘外收起键盘
		IQKeyboardManager.shared.shouldResignOnTouchOutside = true
		
		//		工具条
		IQKeyboardManager.shared.enableAutoToolbar = false
		
		
	}
	
}

extension AppDelegate: UNUserNotificationCenterDelegate  {
	
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		
		let deviceTokenString = (deviceToken as NSData).description.replacingOccurrences(of: "<", with: "").replacingOccurrences(of: ">", with: "").replacingOccurrences(of: " ", with: "")
		//		guard let user = App.user else {
		//			return
		//		}
		//		accountAPI.app.request(AccountTarget.bindDeviceToken(profileId: user.profileId, deviceToken: deviceTokenString, type: .create))
		//		.mapBool()
		//			.subscribe(onSuccess: { (result) in
		//				logger.debug("deviceToken 绑定成功: \(deviceTokenString)")
		//			}, onError: { (error) in
		//				Alert.showTip(error.localizedDescription)
		//			})
		//		.disposed(by: self.disposeBag)
		
	}
	
	func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
		if error._code != 3010 {
			//            logger.error("Register remote notifications error:\(error)")
		}
	}
	
	// MARK: UNUserNotificationCenterDelegate
	
	public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		
		
		//		NotificationManager.shared.performApplicationIconBadgeNumberUpdate()
		
		/// 远程推送
		if notification.request.trigger is UNPushNotificationTrigger {
			
			let userInfo = notification.request.content.userInfo as NSDictionary
			
			//			NotificationManager.shared.handle(.remote(touched: false, content: userInfo))
			
			
			/// 本地推送
		} else if notification.request.trigger is UNTimeIntervalNotificationTrigger {
			
			let userInfo = notification.request.content.userInfo as NSDictionary
			//			NotificationManager.shared.handle(.local(touched: false, content: userInfo))
			
		}
		
		completionHandler([.sound, .alert])
	}
	
	public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
		
		completionHandler()
		
		
		/// 远程推送
		if response.notification.request.trigger is UNPushNotificationTrigger {
			
			let userInfo = response.notification.request.content.userInfo as NSDictionary
			//			NotificationManager.shared.handle(.remote(touched: true, content: userInfo))
			
			/// 本地推送
		} else if response.notification.request.trigger is UNTimeIntervalNotificationTrigger {
			
			let userInfo = response.notification.request.content.userInfo as NSDictionary
			//			NotificationManager.shared.handle(.local(touched: true, content: userInfo))
			
		}
		
	}
	
}
