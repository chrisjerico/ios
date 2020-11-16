//
//  XBJNavAndGameListVC.h
//  UGBWApp
//
//  Created by fish on 2020/10/8.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XBJNavAndGameListVC : UIViewController


- (void)reloadData:(void (^)(BOOL succ))completion;

@end

NS_ASSUME_NONNULL_END
