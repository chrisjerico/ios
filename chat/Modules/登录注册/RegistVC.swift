//
//  RegistVC.swift
//  chat
//
//  Created by xionghx on 2020/11/22.
//  Copyright © 2020 ug. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import WebKit
import RxOptional

class RegistVC: BaseVC {
    @IBOutlet var registTitleView: UIView!
    @IBOutlet var titleButtons: [UIButton]!
    @IBOutlet var animationLineCenterX: NSLayoutConstraint!
    @IBOutlet var registButton: UIButton!
    
    @IBOutlet var inviteCodeField: UITextField!
    @IBOutlet var inviteCodeTipsLabel: UILabel!
    
    @IBOutlet var recommendCodeField: UITextField!
    @IBOutlet var recommendCodeTipsLabel: UILabel!
    
    @IBOutlet var accountField: UITextField!
    @IBOutlet var accountTipsLabel: UILabel!
    
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var passwordTipsLabel: UILabel!
    
    @IBOutlet var passwordComfirmField: UITextField!
    @IBOutlet var passwordConfirmTipsLabel: UILabel!
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var nameTipsLabel: UILabel!
    @IBOutlet var fundPasswordField: UITextField!
    @IBOutlet var fundPasswordTipsLabel: UILabel!
    @IBOutlet var qqField: UITextField!
    @IBOutlet var qqTipsLabel: UILabel!
    
    @IBOutlet var wxField: UITextField!
    @IBOutlet var wxTipsLabel: UILabel!
    
    @IBOutlet var mailField: UITextField!
    @IBOutlet var mailTipsLabel: UILabel!
    
    @IBOutlet var phoneField: UITextField!
    @IBOutlet var phoneTipsLabel: UILabel!
    
    @IBOutlet var msgCodeFiled: UITextField!
    @IBOutlet var msgCodeTipsLabel: UILabel!
    @IBOutlet var msgCodeFetchButton: UIButton!
    
    @IBOutlet var imageCodeField: UITextField!
    @IBOutlet var imageCodeTipsLabel: UILabel!
    
    
    @IBOutlet var passwordShowButton: UIButton!
    @IBOutlet var passwordConfirmShowButton: UIButton!
    
    @IBOutlet var inviteCodeView: UIStackView!
    @IBOutlet var recommendCodeView: UIStackView!
    @IBOutlet var accountNameView: UIStackView!
    @IBOutlet var passwordView: UIStackView!
    @IBOutlet var passwordConfirmView: UIStackView!
    @IBOutlet var nameView: UIStackView!
    @IBOutlet var fundPasswordView: UIStackView!
    @IBOutlet var qqNumberView: UIStackView!
    @IBOutlet var wxNumberView: UIStackView!
    @IBOutlet var mailView: UIStackView!
    @IBOutlet var phoneNumberView: UIStackView!
    @IBOutlet var vcodeView: UIStackView!
    @IBOutlet var verifyCodeView: UIStackView!
    @IBOutlet var webBackdropView: UIView!
    
    @IBOutlet var webView: WKWebView!
    @IBOutlet var codeImageView: UITextView!
    
    
    var imgVcodeModel: UGImgVcodeModel?
    var regType = "user"
    deinit {
        webView.configuration.userContentController.removeScriptMessageHandler(forName: "postSwiperData")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Alert.showLoading()
        CMNetwork.getSystemConfig(withParams: ["sss": "sss"]) { [weak self] (result, error) in
            Alert.hide()
            if let error = error {
                Alert.showTip(error.localizedDescription,  parenter: self?.view)
            } else if let config = result?.data as? UGSystemConfigModel {
                UGSystemConfigModel.setCurrentConfig(config)
                self?.configWith(config)
                
            } else {
                Alert.showTip("获取系统配置,数据解析失败", parenter: self?.view)
            }
        }
        msgCodeFetchButton.rx.tap.subscribe(onNext: {[weak self] in self?.getMessageCode() }).disposed(by: disposeBag)
        registButton.rx.tap.delay(DispatchTimeInterval.microseconds(200), scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] in self?.registButtonAction() }).disposed(by: disposeBag)
        passwordShowButton.addTarget(self, action: #selector(passwordShowButtonAction(_:)), for: .touchUpInside)
        passwordConfirmShowButton.addTarget(self, action: #selector(passwordShowButtonAction(_:)), for: .touchUpInside)
        
    }
    
    private func configWith(_ config: UGSystemConfigModel) {
        
        if config.agentRegbutton == "1" {
            navigationItem.titleView = registTitleView
        } else {
            navigationItem.title = "注册"
        }
        
        if config.inviteCodeSwitch == 1 {
            inviteCodeView.isHidden = false
            inviteCodeField.placeholder = "请输入\(config.inviteWord)(选填)"
        } else if config.inviteCodeSwitch == 0 {
            inviteCodeView.isHidden = true
        } else {
            inviteCodeView.isHidden = false
            inviteCodeField.placeholder = "请输入\(config.inviteWord)"
        }
        
        if config.hide_reco == 0 {
            recommendCodeView.isHidden = true
        } else if config.hide_reco == 1 {
            recommendCodeView.isHidden = false
            recommendCodeField.placeholder = AppDefine.shared()?.isShowWZ ?? false ? "请输入推荐人ID(如果没有，可不填写)" : "请输入推荐人ID(选填)"
        } else {
            recommendCodeView.isHidden = false
            recommendCodeField.placeholder = "请输入推荐人ID"
        }
        
        if config.reg_name == 0 {
            nameView.isHidden = true
        } else if config.reg_name == 1 {
            nameView.isHidden = false
            nameField.placeholder = "请输入真实姓名(选填)"
        } else if config.reg_name == 2 {
            nameView.isHidden = false
            nameField.placeholder = "请输入真实姓名"
        }
        
        if config.reg_fundpwd == 0 {
            fundPasswordView.isHidden = true
        } else if config.reg_fundpwd == 1 {
            fundPasswordView.isHidden = false
            fundPasswordField.placeholder = "请输入4位数字的取款密码(选填)"
        } else if config.reg_fundpwd == 2 {
            fundPasswordView.isHidden = false
            fundPasswordField.placeholder = "请输入4位数字的取款密码"
        }
        
        if config.reg_qq == 0 {
            qqNumberView.isHidden = true
        } else if config.reg_qq == 1 {
            qqNumberView.isHidden = false
            qqField.placeholder = "请输入QQ号码(选填)"
        } else if config.reg_qq == 2 {
            qqNumberView.isHidden = false
            qqField.placeholder = "请输入QQ号码"
        }
        
        if config.reg_wx == 0 {
            wxNumberView.isHidden = true
        } else if config.reg_wx == 1 {
            wxNumberView.isHidden = false
            wxField.placeholder = "请输入微信号(选填)"
        } else if config.reg_wx == 2 {
            wxNumberView.isHidden = false
            wxField.placeholder = "请输入微信号"
        }
        
        if config.reg_phone == 0 && !config.smsVerify {
            phoneNumberView.isHidden = true
        } else if config.smsVerify || config.reg_phone == 2 {
            phoneNumberView.isHidden = false
            phoneField.placeholder = "请输入11位手机号码"
        } else if config.reg_fundpwd == 1 {
            phoneNumberView.isHidden = false
            phoneField.placeholder = "请输入11位手机号码(选填)"
        }
        
        if config.smsVerify {
            vcodeView.isHidden = false
        } else {
            vcodeView.isHidden = true
        }
        
        
        if config.reg_fundpwd == 0 {
            fundPasswordView.isHidden = true
        } else if config.reg_fundpwd == 1 {
            fundPasswordView.isHidden = false
            fundPasswordField.placeholder = "请输入4位数字的取款密码(选填)"
        } else if config.reg_fundpwd == 2 {
            fundPasswordView.isHidden = false
            fundPasswordField.placeholder = "请输入4位数字的取款密码"
        }
        
        if config.reg_email == 0 {
            mailView.isHidden = true
        } else if config.reg_email == 1 {
            mailField.placeholder = "请输入邮箱(选填)"
        }
        
        if config.reg_vcode == 2 {
            webBackdropView.isHidden = false
            verifyCodeView.isHidden = true
            webView.load(URLRequest(url: URL(string: AppDefine.shared().host + swiperVerifyUrl)!))
            webView.configuration.userContentController.add(WeakScriptMessageDelegate(self), name: "postSwiperData")
        } else if config.reg_vcode == 1 {
            verifyCodeView.isHidden = false
            verifyCodeView.isHidden = true
            getImageCode()
            codeImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(getImageCode)))
        } else if config.reg_vcode == 3 {
            verifyCodeView.isHidden = false
            verifyCodeView.isHidden = true
            codeImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(getImageCode)))
        }
        
        if config.pass_limit == 0 {
            passwordField.placeholder = "请输入\(config.pass_length_min)到\(config.pass_length_max)位长度的密码"
        } else if config.pass_limit == 1 {
            passwordField.placeholder = "请输入\(config.pass_length_min)到\(config.pass_length_max)位数字字母组成的密码"
        } else {
            passwordField.placeholder = "请输入\(config.pass_length_min)到\(config.pass_length_max)位数字字母符号组成的密码"
        }
        
        
        Observable.merge(registButton.rx.tap.asObservable(), msgCodeFetchButton.rx.tap.asObservable())
            .debug()
            .take(1)
            .subscribe(onNext: { [weak self] in
                self?.addPhoneReview(with: config)
            }).disposed(by: disposeBag)
        registButton.rx.tap
            .debug()
            .take(1)
            .subscribe(onNext: { [weak self] in
                self?.addContentReview(with: config)
            }).disposed(by: disposeBag)
        
        
        
    }
    
    private func addPhoneReview(with config: UGSystemConfigModel) {
        phoneField.rx.text.subscribe(onNext: { [unowned self] phone in
            if let phone = self.phoneField.text, phone.isPhone {
                self.phoneTipsLabel.text = nil
            } else if config.smsVerify || config.reg_phone == 2 {
                self.phoneTipsLabel.text = self.phoneField.placeholder
            } else {
                self.phoneTipsLabel.text = nil
            }
        }).disposed(by: disposeBag)
        
    }
    private func addContentReview(with config: UGSystemConfigModel) {
        
        if config.inviteCodeSwitch == 2 {
            inviteCodeField.rx.text
                .map{ $0 != nil ? nil : "请输入\(config.inviteWord)" }
                .bind(to: inviteCodeTipsLabel.rx.text)
                .disposed(by: disposeBag)
        }
        if config.hide_reco == 2 {
            recommendCodeField.rx.text
                .map{ $0 != nil ? nil : "请输入推荐人ID" }
                .bind(to: recommendCodeTipsLabel.rx.text)
                .disposed(by: disposeBag)
        }
        
        accountField.rx.text
            .map { ($0 ?? "").match("^(?=.*\\d)(?=.*[a-zA-Z])[a-zA-Z0-9]{6,15}$") ? nil : "请输入6-15位英文数字组合的用户名"}
            .bind(to: accountTipsLabel.rx.text)
            .disposed(by: disposeBag)
        
        passwordField.rx.text.subscribe(onNext: { [unowned self] password in
            logger.debug("password")
            var regexSring = ""
            if config.pass_limit == 0 {
                regexSring = "^[\\w\\W]{\(config.pass_length_min),\(config.pass_length_max)}$"
            } else if config.pass_limit == 1 {
                regexSring = "^(?=.*\\d)(?=.*[a-zA-Z])[a-zA-Z0-9]{\(config.pass_length_min),\(config.pass_length_max)}$"
            } else {
                regexSring = "^(?=.*[0-9])(?=.*[a-zA-Z])(?=.*\\W).{\(config.pass_length_min),\(config.pass_length_max)}$"
            }
            guard let password = password, password.match(regexSring) else {
                self.passwordTipsLabel.text = self.passwordField.placeholder
                return
            }
            self.passwordTipsLabel.text = nil
        }).disposed(by: disposeBag)
        
        
        passwordComfirmField.rx.text
            .map { [unowned self] in $0 == self.passwordField.text ? nil : "两次输入的密码不一致" }
            .bind(to: passwordConfirmTipsLabel.rx.text)
            .disposed(by: disposeBag)
        
        if config.reg_name == 2 {
            nameField.rx.text
                .map { ($0 ?? "").match(Regex.chinese.rawValue) ? nil : "请输入真实姓名" }
                .bind(to: nameTipsLabel.rx.text)
                .disposed(by: disposeBag)
        }
        if config.reg_fundpwd == 2 {
            fundPasswordField.rx.text
                .map{ ($0 ?? "").match("^[0-9]{4}$") ? nil : "请输入4位数字的取款密码" }
                .bind(to: fundPasswordTipsLabel.rx.text)
                .disposed(by: disposeBag)
        }
        if config.reg_qq == 2 {
            qqField.rx.text
                .map{ ($0 ?? "").match("^[0-9]*$") ? nil : "请输入QQ号码" }
                .bind(to: qqTipsLabel.rx.text)
                .disposed(by: disposeBag)
        }
        if config.reg_wx == 2 {
            wxField.rx.text
                .map{ ($0 ?? "").match("^[A-Za-z0-9]+$") ? nil : "请输入微信号" }
                .bind(to: wxTipsLabel.rx.text)
                .disposed(by: disposeBag)
        }
        
        if config.reg_email == 2 {
            mailField.rx.text
                .map { ($0 ?? "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$").match("") ? nil : "请输入合法的邮箱"}
                .bind(to: mailTipsLabel.rx.text)
                .disposed(by: disposeBag)
        }
        if config.reg_vcode == 1 || config.reg_vcode == 3 {
            imageCodeField.rx.text
                .map{ $0 != nil ? nil : "请输入验证码" }
                .bind(to: imageCodeTipsLabel.rx.text)
                .disposed(by: disposeBag)
        }
        if config.smsVerify == true {
            msgCodeFiled.rx.text
                .map{ $0 != nil ? nil : "请输入短信验证码" }
                .bind(to: msgCodeTipsLabel.rx.text)
                .disposed(by: disposeBag)
        }
        
        
        
        
    }
    
    @IBAction func titleButtonAction(_ sender: UIButton) {
        titleButtons.forEach { $0.isEnabled = true }
        sender.isEnabled = false
        NSLayoutConstraint.deactivate([animationLineCenterX])
        animationLineCenterX = NSLayoutConstraint(item: animationLineCenterX.firstItem!, attribute: animationLineCenterX.firstAttribute, relatedBy: NSLayoutConstraint.Relation.equal, toItem: sender, attribute: animationLineCenterX.secondAttribute, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([animationLineCenterX])
        regType = regType == "user" ? "agent" : "user"
    }
    private func registButtonAction() {
        
        guard (accountTipsLabel.text ?? "").count == 0,
              (passwordTipsLabel.text ?? "").count == 0,
              (passwordConfirmTipsLabel.text ?? "").count == 0,
              (nameTipsLabel.text ?? "").count == 0,
              (fundPasswordTipsLabel.text ?? "").count == 0,
              (qqTipsLabel.text ?? "").count == 0,
              (wxTipsLabel.text ?? "").count == 0,
              (imageCodeTipsLabel.text ?? "").count == 0,
              (msgCodeTipsLabel.text ?? "").count == 0
        else {
            return
        }
        
        var params: [String : Any] = ["inviter": inviteCodeField.text ?? "",
                                      "usr": accountField.text ?? "",
                                      "pwd": (passwordField.text ?? "").md5(),
                                      "funcPwd": (fundPasswordField.text ?? "").md5(),
                                      "fullName": nameField.text ?? "",
                                      "qq": qqField.text ?? "",
                                      "wx": wxField.text ?? "",
                                      "phone": phoneField.text ?? "",
                                      "device": 3,
                                      "accessToken": OpenUDID.value() as String,
                                      "smsCode":  msgCodeFiled.text ?? "",
                                      "imgCode": imageCodeField.text ?? "",
                                      "email": mailField.text ?? "",
                                      "regType": regType,
                                      "inviteCode": inviteCodeField.text ?? "" ]
        if let imgVcodeModel = imgVcodeModel {
            params["slideCode[nc_sid]"] = imgVcodeModel.nc_csessionid
            params["slideCode[nc_token]"] = imgVcodeModel.nc_token
            params["slideCode[nc_sig]"] = imgVcodeModel.nc_value
        }
        Alert.showStatus("正在注册。。。")
        CMNetwork.register(withParams: params) { [weak self] (result, error) in
            Alert.hide()
            if let error = error {
                Alert.showTip(error.localizedDescription)
                return
            }
            guard let user = result?.data as? NSObject as? UGUserModel else {
                Alert.showTip("数据解析失败")
                return
            }
            UserDefaults.standard.set(true, forKey: "isRememberPsd")
            UserDefaults.standard.set(self?.accountField.text ?? "", forKey: "userName")
            UserDefaults.standard.set(self?.passwordField.text ?? "", forKey: "userPsw")
            if user.autoLogin {
                self?.login()
            } else {
                Alert.showTip("账号注册成功")
                self?.navigationController?.popViewController(animated: true)
            }

        }
        
    }
    
    private func login() {
        Alert.showStatus("正在登录。。。")
        CMNetwork.userLogin(withParams: ["usr": accountField.text ?? "", "pwd": passwordField.text!.md5()]) { [weak self] (result, error) in
            Alert.hide()
            guard let weakSelf = self else { return }
            if let error = error {
                Alert.showTip(error.localizedDescription, parenter: weakSelf.view)
                
            } else if let user = result?.data as? UGUserModel {
                let userInfoSuccess = PublishRelay<Bool>()
                let systemConfigSuccess = PublishRelay<Bool>()
                UGUserModel.setCurrentUser(user)

                weakSelf.getUserInfo(sessid: user.sessid) { (userCopy) in
                    userCopy.sessid = user.sessid
                    userCopy.token = user.token
                    UGUserModel.setCurrentUser(userCopy)
                    userInfoSuccess.accept(true)
                }
                weakSelf.getConfigs(completion: { (config) in
                    UGSystemConfigModel.setCurrentConfig(config)
                    systemConfigSuccess.accept(true)
                    
                })
                
                Observable.combineLatest(userInfoSuccess, systemConfigSuccess).filter { $0&&$1 }.subscribe(onNext: { _ in
                    Alert.showTip("用户登录成功")
                    App.widow.rootViewController = ControllerProvider.rootTabViewController()
                }).disposed(by: weakSelf.disposeBag)
                
            }
            
        }
        
        
    }
    func getConfigs(completion: @escaping (_ config: UGSystemConfigModel) -> Void) {
        Alert.showLoading()
        CMNetwork.getSystemConfig(withParams: ["sss": "sss"]) {(result, error) in
            if let error = error {
                Alert.showTip(error.localizedDescription)
            } else if let config = result?.data as? UGSystemConfigModel {
                completion(config)
            } else {
                Alert.showTip("获取系统配置,数据解析失败")
            }
        }
        
    }
    
    func getUserInfo(sessid: String,  completion: @escaping (_ user: UGUserModel) -> Void) {
        Alert.showLoading()
        CMNetwork.getUserInfo(withParams: ["token": sessid]) {(result, error) in
            if let error = error {
                Alert.showTip(error.localizedDescription)
            } else if let user = result?.data as? UGUserModel {
                completion(user)
            } else {
                Alert.showTip("获取用户信息,数据解析失败")
            }
        }
    }
    @objc
    private func passwordShowButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        passwordField.isSecureTextEntry = !passwordShowButton.isSelected
        passwordComfirmField.isSecureTextEntry = !passwordConfirmShowButton.isSelected
    }
    
    @objc
    func getImageCode() {
        
        CMNetwork.getImgVcode(withParams: ["accessToken": OpenUDID.value() ?? ""]) { [weak self] (result, error) in
            guard let imageData = result as AnyObject as? Data else { return }
            let uriSting = String(data: imageData, encoding: String.Encoding.utf8) ?? ""
            let attributedData = "<img src='\(uriSting)' width=100 height=40>".data(using: String.Encoding.unicode)
            self?.codeImageView.attributedText = try? NSAttributedString(data: attributedData!, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        }
        
    }
    
    func getMessageCode() {
        
        guard let phone = phoneField.text, phone.isPhone else {
            Alert.showTip("请输入合法的手机号码")
            return
        }
        Alert.showLoading()
        CMNetwork.getSmsVcode(withParams: ["phone": phone]) { (result, error) in
            Alert.hide()
            if let error = error {
                Alert.showTip(error.localizedDescription)
                return
            }
            DispatchTimer(timeInterval: 1, repeatCount: 60 ) { [weak self] (timer, count)  in
                guard count >= 0 else {
                    self?.msgCodeFetchButton.setTitle("获取验证码", for: .normal)
                    return
                }
                self?.msgCodeFetchButton.setTitle("\(count)s", for: .normal)
            }
            
        }
        
    }
    
    
}

extension RegistVC: WKScriptMessageHandler {
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "postSwiperData",
           let dict = message.body as? [AnyHashable: Any],
           let imgVcodeModel = try? UGImgVcodeModel(dictionary: dict) {
            self.imgVcodeModel = imgVcodeModel
        }
        
    }
    
}
class WeakScriptMessageDelegate: NSObject, WKScriptMessageHandler {
    weak var scriptDelegate: WKScriptMessageHandler?
    init(_ scriptDelegate: WKScriptMessageHandler) {
        self.scriptDelegate = scriptDelegate
        super.init()
    }
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        scriptDelegate?.userContentController(userContentController, didReceive: message)
    }
}
