//
//  UGHomeTitleView.h
//  ug
//
//  Created by ug on 2019/7/8.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^HomeTitleMoreBlock)(void);
typedef void(^HomeTitleTryplayBlock)(void);
typedef void(^HomeTitleLoginBlock)(void);
typedef void(^HomeTitleRegisterBlock)(void);
@interface UGHomeTitleView : UIView
@property (nonatomic, copy) HomeTitleMoreBlock moreClickBlock;
@property (nonatomic, copy) HomeTitleTryplayBlock tryPlayClickBlock;
@property (nonatomic, copy) HomeTitleLoginBlock loginClickBlock;
@property (nonatomic, copy) HomeTitleRegisterBlock registerClickBlock;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, assign) BOOL showLoginView;
@end

NS_ASSUME_NONNULL_END
