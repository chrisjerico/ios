//
//  UGLaunchController.swift
//  ug
//
//  Created by xionghx on 2019/10/26.
//  Copyright © 2019 ug. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
import SwiftyJSON
import RxRelay
@objc
class LaunchPageModel: UGModel {
	
	@objc var pic = ""
	
}

class UGLaunchController: BaseVC {
	override func viewDidLoad() {
		super.viewDidLoad()
		let imageView = UIImageView()
		view.addSubview(imageView)
		imageView.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
        
        if UGLoginIsAuthorized() {
            launch()
        } else {
            gologin()
        }
        
		if let picData = UserDefaults.standard.value(forKey: "launchImageData") as? Data, let image = UIImage(data: picData) {
			imageView.image = image
		}
        ChatAPI.rx.request(ChatTarget.launchPic).mapArray(LaunchPictureModel.self).subscribe(onSuccess: { (result) in
            
            guard let picString = result.first?.pic, let url = URL(string: picString) else { return }
//                UserDefaults.standard.set(data, forKey: "launchImageData")
//                imageView.image = UIImage(data: data)
            imageView.kf.setImage(with: url)
        }).disposed(by: disposeBag)
		view.backgroundColor = .white
	
	}
	
	func gologin() {
        App.widow.rootViewController = ControllerProvider.loginViewController()
	}
	
	func launch() {
		
		Alert.showLoading()
		let user = UGUserModel.currentUser()
		let sessid = user.sessid
		let token = user.token
		
		
		Observable.zip(ChatAPI.rx.request(ChatTarget.systemConfig).asObservable(), ChatAPI.rx.request(.userInfo(sessid: sessid)).asObservable()).subscribe(onNext: { (systemConfigResponse, userInfoResponse) in
            Alert.hide()
            let systemConfigResponseJson = JSON(systemConfigResponse.data)
			let userInfoResponseJson = JSON(userInfoResponse.data)
			
			if systemConfigResponseJson["code"].intValue != 0 {
				Alert.showTip(systemConfigResponseJson["msg"].stringValue)
				App.widow.rootViewController = ControllerProvider.loginViewController()
				
				return
			}
			
			if userInfoResponseJson["code"].intValue != 0 {
				Alert.showTip(userInfoResponseJson["msg"].stringValue)
				App.widow.rootViewController = ControllerProvider.loginViewController()
				return
			}
			
			
			guard
				let systemConfigJson = systemConfigResponseJson["data"].dictionaryObject,
				let systemConfig: UGSystemConfigModel = try? UGSystemConfigModel(dictionary: systemConfigJson),
				let userInfoJson = userInfoResponseJson["data"].dictionaryObject,
				let userInfo: UGUserModel = try? UGUserModel(dictionary: userInfoJson)
				
				else {
					Alert.showTip(APIError.invalidData.errorDescription!)
					DispatchAfter(after: 0.5) {
						App.widow.rootViewController = ControllerProvider.loginViewController()
					}
					return
			}
			
			UGSystemConfigModel.setCurrentConfig(systemConfig)
			userInfo.sessid = sessid
			userInfo.token = token
			UGUserModel.setCurrentUser(userInfo)
			App.widow.rootViewController = ControllerProvider.rootTabViewController()
			
		}, onError: { (error) in
			Alert.showTip(error.localizedDescription)
            App.widow.rootViewController = ControllerProvider.loginViewController()
		}).disposed(by: disposeBag)
		
		
	}
	
}
