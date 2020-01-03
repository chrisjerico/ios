//
//  RootTabBarController.swift
//  ug
//
//  Created by xionghx on 2019/10/26.
//  Copyright © 2019 ug. All rights reserved.
//

import Foundation
import pop
import ESTabBarController_swift
import NSObject_Rx

class RootTabBarController: ESTabBarController {
	
	init() {
		super.init(nibName: nil, bundle: nil)
		
		tabBar.shadowImage = UIImage()
		tabBar.backgroundImage = UIImage(color: UIColor.white)
		
		let v1 = UGMomentsHomeVC()
		let v2 = UGRoomListVC()
		let v3 = GameHomeVC()
		let v4 = UGConversationVC()
		let v5 = UGMineSkinViewController()
		let v6 = UIStoryboard(name: "MineTableController", bundle: nil).instantiateInitialViewController()!
		//		let v6 = UIStoryboard(name: "TestVC", bundle: nil).instantiateInitialViewController()!
		
		v1.tabBarItem = ESTabBarItem.init(BouncesContentView(), title: "发现", image: UIImage(named: "fx_1"), selectedImage: UIImage(named: "fxd"))
		v2.tabBarItem = ESTabBarItem.init(BouncesContentView(), title: "通讯录", image: UIImage(named: "qz_1"), selectedImage: UIImage(named: "qzd"))
		v3.tabBarItem = ESTabBarItem.init(IrregularityContentView(), title: "游戏大厅", image: UIImage(named: "yxdt"), selectedImage: UIImage(named: "yxdt"))
		v4.tabBarItem = ESTabBarItem.init(BouncesContentView(), title: "消息", image: UIImage(named: "xx"), selectedImage: UIImage(named: "xxd"))
		v5.tabBarItem = ESTabBarItem.init(BouncesContentView(), title: "我的", image: UIImage(named: "资源 70"), selectedImage: UIImage(named: "wdd"))
		v6.tabBarItem = ESTabBarItem.init(BouncesContentView(), title: "我的", image: UIImage(named: "资源 70"), selectedImage: UIImage(named: "wdd"))
		
		viewControllers = [v4, v2, v3, v1, v6].map { BaseNav(rootViewController: $0)}
		
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		SocketManager.shared.connect()
		App.emojiKeyBoard.layoutSubviews()

		MessageManager.shared.newNotification.subscribe(onNext: { (notification) in
			if let message = notification["msg"] as? String {
				Alert.showTip(message)
			}
		}).disposed(by: disposeBag)
		
		MessageManager.shared.newError.subscribe(onNext: { (error) in
			if let message = error["msg"] as? String {
				Alert.showTip(message)
			}
		}).disposed(by: disposeBag)
		
		
		loadLaunchPic()
	}
	
	func loadLaunchPic() {
		
		
		ChatAPI.rx.request(ChatTarget.launchPic).mapArray(LaunchPictureModel.self).subscribe(onSuccess: { (result) in
			guard let picString = result.first?.pic, let url = URL(string: picString), let data = try? Data(contentsOf: url) else { return }
			UserDefaults.standard.set(data, forKey: "launchImageData")
		}) { (error) in
			Alert.showTip(error.localizedDescription)
		}.disposed(by: disposeBag)
		
	}
	
}



class IrregularityContentView: ESTabBarItemContentView {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.renderingMode = .alwaysOriginal
		
		self.imageView.contentMode = .scaleToFill
		self.imageView.backgroundColor = UIColor.white
		self.imageView.layer.cornerRadius = 32
		self.insets = UIEdgeInsets.init(top: -50, left: 0, bottom: 0, right: 0)
		let transform = CGAffineTransform.identity
		self.imageView.transform = transform
		self.superview?.bringSubviewToFront(self)
	}
	
	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
		let p = CGPoint.init(x: point.x - imageView.frame.origin.x, y: point.y - imageView.frame.origin.y)
		return sqrt(pow(imageView.bounds.size.width / 2.0 - p.x, 2) + pow(imageView.bounds.size.height / 2.0 - p.y, 2)) < imageView.bounds.size.width / 2.0
	}
	
	override func updateLayout() {
		super.updateLayout()
		self.imageView.sizeToFit()
		self.imageView.center = CGPoint.init(x: self.bounds.size.width / 2.0, y: self.bounds.size.height / 2.0)
	}
	
	public override func selectAnimation(animated: Bool, completion: (() -> ())?) {
		let view = UIView.init(frame: CGRect.init(origin: CGPoint.zero, size: CGSize(width: 2.0, height: 2.0)))
		view.layer.cornerRadius = 1.0
		view.layer.opacity = 0.5
		view.backgroundColor = UIColor.init(red: 10/255.0, green: 66/255.0, blue: 91/255.0, alpha: 1.0)
		self.addSubview(view)
		playMaskAnimation(animateView: view, target: self.imageView, completion: {
			[weak view] in
			view?.removeFromSuperview()
			completion?()
		})
	}
	
	public override func reselectAnimation(animated: Bool, completion: (() -> ())?) {
		completion?()
	}
	
	public override func deselectAnimation(animated: Bool, completion: (() -> ())?) {
		completion?()
	}
	
	public override func highlightAnimation(animated: Bool, completion: (() -> ())?) {
		UIView.beginAnimations("small", context: nil)
		UIView.setAnimationDuration(0.2)
		let transform = self.imageView.transform.scaledBy(x: 0.8, y: 0.8)
		self.imageView.transform = transform
		UIView.commitAnimations()
		completion?()
	}
	
	public override func dehighlightAnimation(animated: Bool, completion: (() -> ())?) {
		UIView.beginAnimations("big", context: nil)
		UIView.setAnimationDuration(0.2)
		let transform = CGAffineTransform.identity
		self.imageView.transform = transform
		UIView.commitAnimations()
		completion?()
	}
	
	private func playMaskAnimation(animateView view: UIView, target: UIView, completion: (() -> ())?) {
		view.center = CGPoint.init(x: target.frame.origin.x + target.frame.size.width / 2.0, y: target.frame.origin.y + target.frame.size.height / 2.0)
		
		let scale = POPBasicAnimation.init(propertyNamed: kPOPLayerScaleXY)
		scale?.fromValue = NSValue.init(cgSize: CGSize.init(width: 1.0, height: 1.0))
		scale?.toValue = NSValue.init(cgSize: CGSize.init(width: 36.0, height: 36.0))
		scale?.beginTime = CACurrentMediaTime()
		scale?.duration = 0.3
		scale?.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeOut)
		scale?.removedOnCompletion = true
		
		let alpha = POPBasicAnimation.init(propertyNamed: kPOPLayerOpacity)
		alpha?.fromValue = 0.6
		alpha?.toValue = 0.6
		alpha?.beginTime = CACurrentMediaTime()
		alpha?.duration = 0.25
		alpha?.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeOut)
		alpha?.removedOnCompletion = true
		
		view.layer.pop_add(scale, forKey: "scale")
		view.layer.pop_add(alpha, forKey: "alpha")
		
		scale?.completionBlock = ({ animation, finished in
			completion?()
		})
	}
	
}

class BouncesContentView: BasicContentView {
	
	public var duration = 0.3
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func selectAnimation(animated: Bool, completion: (() -> ())?) {
		self.bounceAnimation()
		completion?()
	}
	
	override func reselectAnimation(animated: Bool, completion: (() -> ())?) {
		self.bounceAnimation()
		completion?()
	}
	
	func bounceAnimation() {
		let impliesAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
		impliesAnimation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
		impliesAnimation.duration = duration * 2
		impliesAnimation.calculationMode = CAAnimationCalculationMode.cubic
		imageView.layer.add(impliesAnimation, forKey: nil)
	}
}
class BasicContentView: ESTabBarItemContentView {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.renderingMode = .alwaysOriginal
		
		textColor = UIColor.x.text
		highlightTextColor = UIColor.x.main
		iconColor = UIColor.x.text
		highlightIconColor = UIColor.x.main
		backdropColor = UIColor.white
		highlightBackdropColor = UIColor.white
	}
	
	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
}
