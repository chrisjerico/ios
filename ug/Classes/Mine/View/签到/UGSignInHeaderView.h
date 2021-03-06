//
//  UGSignInHeaderView.h
//  ug
//
//  Created by ug on 2019/9/5.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^SignInHeaderViewBlock)(void);

@interface UGSignInHeaderView : UIView

@property (nonatomic, copy) SignInHeaderViewBlock signInHeaderViewnBlock;

-(instancetype)initView;
@end

NS_ASSUME_NONNULL_END
