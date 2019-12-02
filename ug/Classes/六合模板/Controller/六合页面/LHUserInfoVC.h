//
//  LHUserInfoVC.h
//  ug
//
//  Created by fish on 2019/12/1.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LHUserInfoVC : UIViewController

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) void (^didFollow)(BOOL follow);
@end

NS_ASSUME_NONNULL_END
