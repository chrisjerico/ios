//
//  UITabBarController+ShowViewController.m

#import "UITabBarController+ShowViewController.h"

@implementation UITabBarController (ShowViewController)

///
/// 显示任意控制器到当前显示的nav
///
- (void)showViewControllerInSelected:(UIViewController*)vc animated:(BOOL)animated {
    [self showViewControllerInSelected:vc atIndex:-1 animated:animated];
//    UIViewController* selectedController = self.selectedViewController;
//    if ([selectedController isKindOfClass: UINavigationController.class]) {
//        UINavigationController* nav = (id)selectedController;
//        [nav pushViewController:vc animated:animated];
//    } else {
//        [selectedController presentViewController:vc
//                                         animated:animated
//                                       completion:nil];
//    }
}

///
/// 显示任意控制器到root
///
- (void)showViewControllerInSelected:(UIViewController*)vc atIndex:(NSInteger)idx animated:(BOOL)animated {
    if (vc == nil) {
        return;
    }
    
    UIViewController* selectedController = self.selectedViewController;
    if ([selectedController isKindOfClass: UINavigationController.class]) {
        UINavigationController* nav = (id)selectedController;
        
        if (idx < 0 || idx > nav.viewControllers.count) {
            [nav pushViewController:vc animated:animated];
        } else {
            NSMutableArray* arr = [[nav.viewControllers subarrayWithRange:NSMakeRange(0, idx)] mutableCopy];
            [arr addObject:vc];
            [nav setViewControllers:arr animated:animated];
            
        }
    } else {
        [selectedController presentViewController:vc
                                         animated:animated
                                       completion:nil];
    }
}

@end
