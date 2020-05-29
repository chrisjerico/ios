//
//  LoginVC.swift
//  ug
//
//  Created by xionghx on 2019/12/23.
//  Copyright © 2019 ug. All rights reserved.
//

import UIKit
import SVGKit
import RxSwift
import RxCocoa
import ObjectMapper
import RxRelay
import SwiftyJSON

class LoginVC: BaseVC {
	
	@IBOutlet weak var logoImageView: UIImageView!
	@IBOutlet weak var userNameIconView: UIImageView!
	@IBOutlet weak var passwordIconView: UIImageView!
	@IBOutlet weak var userNameField: UITextField!
	@IBOutlet weak var passwordField: UITextField!
	@IBOutlet weak var secureInputButton: UIButton!
	@IBOutlet weak var remberPasswordButton: UIButton!
	@IBOutlet weak var loginButton: UIButton!
	
	@IBOutlet weak var goRegistButton: UIButton!
	@IBOutlet weak var playButton: UIButton!
	@IBOutlet weak var resetPasswordButton: UIButton!
	@IBOutlet weak var clearButton: UIButton!
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		loginButton.layer.cornerRadius = 24
		loginButton.layer.masksToBounds = true
		userNameIconView.image = SVGKImage(named: "yonghuming").uiImage.withRenderingMode(.alwaysTemplate)
		passwordIconView.image = SVGKImage(named: "mima").uiImage.withRenderingMode(.alwaysTemplate)
		logoImageView.image = SVGKImage(named: "形状").uiImage
		
		userNameField.text = UserDefaults.standard.value(forKey: "userName") as? String
		passwordField.text = UserDefaults.standard.value(forKey: "userPsw") as? String
		let loginButtonAvailable: Observable<Bool> = Observable.combineLatest(userNameField.rx.text.orEmpty.asObservable(), passwordField.rx.text.orEmpty.asObservable()).map { $0.0.count > 0 && $0.1.count > 0 }.throttle(RxTimeInterval.microseconds(300), scheduler: MainScheduler.instance).share(replay: 1)
		loginButtonAvailable.bind(to: loginButton.rx.isEnabled).disposed(by: disposeBag)
		loginButtonAvailable.map { $0 ? UIColor.x.main : UIColor.x.main.withAlphaComponent(0.6) }.bind(to: loginButton.rx.backgroundColor).disposed(by: disposeBag)
		
		remberPasswordButton.rx.tap.subscribe(onNext: { [unowned self] () in self.remberPasswordButton.isSelected = !self.remberPasswordButton.isSelected }).disposed(by: disposeBag)
		secureInputButton.rx.tap.subscribe(onNext: { [unowned self] () in
			self.passwordField.isSecureTextEntry = !self.secureInputButton.isSelected
			self.secureInputButton.isSelected = !self.secureInputButton.isSelected
			
		}).disposed(by: disposeBag)
		
		passwordField.rx.text.map { $0 == nil || $0?.count == 0 }.bind(to: clearButton.rx.isHidden).disposed(by: disposeBag)
		clearButton.rx.tap.subscribe(onNext: { [weak self] () in
			self?.passwordField.text = nil
			}).disposed(by: disposeBag)
	}
	
	@IBAction func loginButtonTaped(_ sender: Any) {
		Alert.showLoading(parenter: view)
		
		CMNetwork.userLogin(withParams: ["usr": userNameField.text!, "pwd": passwordField.text!.md5()]) { [weak self] (result, error) in
			guard let weakSelf = self else { return }
			if let error = error {
				Alert.showTip(error.localizedDescription, parenter: weakSelf.view)
				
			} else if let accessToken = result?.data as? UGUserModel {
				
				if weakSelf.remberPasswordButton.isSelected {
					UserDefaults.standard.set(weakSelf.userNameField.text!, forKey: "userName")
					UserDefaults.standard.set(weakSelf.passwordField.text!, forKey: "userPsw")
				} else {
					UserDefaults.standard.removeObject(forKey: "userName")
					UserDefaults.standard.removeObject(forKey: "userPsw")
				}
				
				
				let userInfoSuccess = PublishRelay<Bool>()
				let systemConfigSuccess = PublishRelay<Bool>()
				weakSelf.getUserInfo(sessid: accessToken.sessid) { (user) in
					user.sessid = accessToken.sessid
					user.token = accessToken.token
					UGUserModel.setCurrentUser(user)
					userInfoSuccess.accept(true)
				}
				weakSelf.getConfigs(completion: { (config) in
					UGSystemConfigModel.setCurrentConfig(config)
					systemConfigSuccess.accept(true)
					
				})
				
				Observable.combineLatest(userInfoSuccess, systemConfigSuccess).filter { $0&&$1 }.subscribe(onNext: { _ in
					Alert.showTip("信息获取完毕", parenter: weakSelf.view)
					App.widow.rootViewController = ControllerProvider.rootTabViewController()
				}).disposed(by: weakSelf.disposeBag)
				
			}
			
		}
		
	}
	
	func getConfigs(completion: @escaping (_ config: UGSystemConfigModel) -> Void) {
		Alert.showLoading(parenter: view)
		CMNetwork.getSystemConfig(withParams: ["sss": "sss"]) { [weak self] (result, error) in
			if let error = error {
				Alert.showTip(error.localizedDescription,  parenter: self?.view)
			} else if let config = result?.data as? UGSystemConfigModel {
				completion(config)
			} else {
				Alert.showTip("获取系统配置,数据解析失败", parenter: self?.view)
			}
		}
		
	}
	
	func getUserInfo(sessid: String,  completion: @escaping (_ user: UGUserModel) -> Void) {
		Alert.showLoading(parenter: view)
		CMNetwork.getUserInfo(withParams: ["token": sessid]) { [weak self] (result, error) in
			if let error = error {
				Alert.showTip(error.localizedDescription,  parenter: self?.view)
			} else if let user = result?.data as? UGUserModel {
				completion(user)
			} else {
				Alert.showTip("获取系统配置,数据解析失败", parenter: self?.view)
			}
		}
		
	}
	deinit {
		logger.debug("")
	}
	@IBAction func goRegist(_ sender: Any) {
		CMNetwork.getSystemConfig(withParams: ["sss": "sss"]) { [weak self] (result, error) in
			if let error = error {
				Alert.showTip(error.localizedDescription,  parenter: self?.view)
			} else if let config = result?.data as? UGSystemConfigModel {
				UGSystemConfigModel.setCurrentConfig(config)
				let registerVC = UIStoryboard(name: "Mine", bundle: nil).instantiateViewController(withIdentifier: "UGRegisterViewController")
				self?.navigationController?.pushViewController(registerVC, animated: true)
			} else {
				Alert.showTip("获取系统配置,数据解析失败", parenter: self?.view)
			}
		}
		
		
		
	}
	@IBAction func playButtonTaped(_ sender: Any) {
		
		Alert.showLoading(parenter: view)
		CMNetwork.guestLogin(withParams: ["usr": "46da83e1773338540e1e1c973f6c8a68", "pwd": "46da83e1773338540e1e1c973f6c8a68"]) { [weak self] (result, error) in
			guard let weakSelf = self else { return }
			if let error = error {
				Alert.showTip(error.localizedDescription, parenter: weakSelf.view)
				
			} else if let accessToken = result?.data as? UGUserModel {
				//				Alert.showTip("登录成功,获取配置信息", parenter: weakSelf.view)
				
				UserDefaults.standard.removeObject(forKey: "userName")
				UserDefaults.standard.removeObject(forKey: "userPsw")
				
				let userInfoSuccess = PublishRelay<Bool>()
				let systemConfigSuccess = PublishRelay<Bool>()
				weakSelf.getUserInfo(sessid: accessToken.sessid) { (user) in
					user.sessid = accessToken.sessid
					user.token = accessToken.token
					UGUserModel.setCurrentUser(user)
					userInfoSuccess.accept(true)
				}
				weakSelf.getConfigs(completion: { (config) in
					UGSystemConfigModel.setCurrentConfig(config)
					systemConfigSuccess.accept(true)
					
				})
				
				Observable.combineLatest(userInfoSuccess, systemConfigSuccess).filter { $0&&$1 }.subscribe(onNext: { _ in
					Alert.showTip("信息获取完毕", parenter: weakSelf.view)
					App.widow.rootViewController = ControllerProvider.rootTabViewController()
				}).disposed(by: weakSelf.disposeBag)
				
			}
		}
		
	}
}
