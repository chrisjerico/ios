//
//  Alert.swift
//  XiaoJir
//
//  Created by xionghuanxin on 2018/9/29.
//  Copyright © 2018年 xionghx. All rights reserved.
//

import MBProgressHUD
@objc
public final class Alert: NSObject {
	
	/// 提示信息
	///
	/// - Parameters:
	///   - message: 信息文本
	///   - parentView: 显示的目标视图
	public class func showTip(_ message: String, parenter: UIView? = nil) {
		let parenter = parenter ?? App.widow
		
		let hud: MBProgressHUD
		if let oldHUD = MBProgressHUD(for: parenter) {
			hud = oldHUD
		} else {
			hud = MBProgressHUD(view: parenter)
			parenter.addSubview(hud)
		}
		
		hud.mode = .text
		hud.detailsLabel.text = message
		hud.detailsLabel.font = UIFont.systemFont(ofSize: 16)
		
		hud.isUserInteractionEnabled = false
		hud.removeFromSuperViewOnHide = true
		
		hud.show(animated: true)
		hud.hide(animated: true, afterDelay: 2.0)
	}
    /// 提示信息
    ///
    /// - Parameters:
    ///   - message: 信息文本
    ///   - parentView: 显示的目标视图
    public class func showStatus(_ message: String, parenter: UIView? = nil) {
        let parenter = parenter ?? App.widow
        
        let hud: MBProgressHUD
        if let oldHUD = MBProgressHUD(for: parenter) {
            hud = oldHUD
        } else {
            hud = MBProgressHUD(view: parenter)
            parenter.addSubview(hud)
        }
        
        hud.mode = .text
        hud.detailsLabel.text = message
        hud.detailsLabel.font = UIFont.systemFont(ofSize: 16)
        
        hud.isUserInteractionEnabled = false
        hud.removeFromSuperViewOnHide = true
        
        hud.show(animated: true)
    }
	
	/// 提示指示器
	///
	/// - Parameter parentView: 显示的目标视图
	@objc public class func showLoading(parenter: UIView? = nil) {
		let parenter = parenter ?? App.widow
		let hud: MBProgressHUD
		if let oldHUD = MBProgressHUD(for: parenter) {
			hud = oldHUD
		} else {
			hud = MBProgressHUD(view: parenter)
			parenter.addSubview(hud)
		}
		
		hud.mode = .indeterminate
		hud.removeFromSuperViewOnHide = true
		hud.show(animated: false)
	}
	
	/// 隐藏提示信息或指示器
	///
	/// - Parameter parentView: 显示的目标视图
	public class func hide(parenter: UIView? = nil) {
		let parenter = parenter ?? App.widow
		MBProgressHUD.hide(for: parenter, animated: false)
	}
	
	
	// MBProgressHUDModeAnnularDeterminate
	
	/// 进度指示器
	///
	/// - Parameter parentView: 显示的目标视图
	public class func showProgress(progress: Double, parenter: UIView? = nil) {
		let parenter = parenter ?? App.widow
		let hud: MBProgressHUD
		if let oldHUD = MBProgressHUD(for: parenter) {
			hud = oldHUD
		} else {
			hud = MBProgressHUD(view: parenter)
			parenter.addSubview(hud)
		}
		
		hud.mode = .annularDeterminate
		hud.removeFromSuperViewOnHide = true
		hud.progress = Float(progress)
		hud.show(animated: false)
		
	}
}
