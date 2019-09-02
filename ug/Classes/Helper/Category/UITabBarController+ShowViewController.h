//
//  UITabBarController+ShowViewController.h

#import <UIKit/UIKit.h>

@interface UITabBarController (ShowViewController)

///
/// 显示任意控制器到当前显示的nav
///
- (void)showViewControllerInSelected:(UIViewController*)vc animated:(BOOL)animated;

///
/// 显示任意控制器到root
///
- (void)showViewControllerInSelected:(UIViewController*)vc atIndex:(NSInteger)idx animated:(BOOL)animated;

@end
