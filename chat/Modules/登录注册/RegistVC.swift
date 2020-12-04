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
        registButton.rx.tap.subscribe(onNext: { [weak self] in self?.registButtonAction() }).disposed(by: disposeBag)
        passwordShowButton.addTarget(self, action: #selector(passwordShowButtonAction(_:)), for: .touchUpInside)
        passwordConfirmShowButton.addTarget(self, action: #selector(passwordShowButtonAction(_:)), for: .touchUpInside)

    }
    
    private func configWith(_ config: UGSystemConfigModel) {
        
        if config.agentRegbutton == "1" {
            navigationItem.titleView = registTitleView
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
            self?.addPhoneReview()
        }).disposed(by: disposeBag)
        registButton.rx.tap
            .debug()
            .take(1)
            .subscribe(onNext: { [weak self] in
            self?.addContentReview(with: config)
        }).disposed(by: disposeBag)
      
        

    }
    
    private func addPhoneReview() {
        phoneField.rx.text.subscribe(onNext: { [unowned self] phone in
            if let phone = self.phoneField.text, phone.isPhone {
                self.phoneTipsLabel.text = nil
            } else {
                self.phoneTipsLabel.text = self.phoneField.placeholder
            }
        }).disposed(by: disposeBag)
        
    }
    private func addContentReview(with config: UGSystemConfigModel) {
        
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
                regexSring = "^(?=.*[0-9])(?=.*[a-zA-Z])(?=.*\\W).{\(config.pass_length_min),\(config.pass_length_max)}"
            }
            guard let password = password, password.match(regexSring) else {
                self.passwordTipsLabel.text = self.passwordField.placeholder
                return
            }
            self.passwordTipsLabel.text = nil
        }).disposed(by: disposeBag)
        
        
        passwordComfirmField.rx.text
            .map { [unowned self] in $0 == self.passwordField.text ? nil: "两次输入的密码不一致" }
            .bind(to: passwordConfirmTipsLabel.rx.text)
            .disposed(by: disposeBag)
        
    }
    
    @IBAction func titleButtonAction(_ sender: UIButton) {
        titleButtons.forEach { $0.isEnabled = true }
        sender.isEnabled = false
        NSLayoutConstraint.deactivate([animationLineCenterX])
        animationLineCenterX = NSLayoutConstraint(item: animationLineCenterX.firstItem!, attribute: animationLineCenterX.firstAttribute, relatedBy: NSLayoutConstraint.Relation.equal, toItem: sender, attribute: animationLineCenterX.secondAttribute, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([animationLineCenterX])
    }
    private func registButtonAction() {
        
        
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
        
    }
    
    deinit {
        webView.configuration.userContentController.removeScriptMessageHandler(forName: "postSwiperData")
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
