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
@property (nonatomic, copy) HomeTitleMoreBlock moreClickBlock;          /**<   更多 */
@property (nonatomic, copy) HomeTitleTryplayBlock tryPlayClickBlock;    /**<   试玩 */
@property (nonatomic, copy) HomeTitleLoginBlock loginClickBlock;        /**<   登录 */
@property (nonatomic, copy) HomeTitleRegisterBlock registerClickBlock;  /**<   注册 */
@property (nonatomic, copy) void (^userNameTouchedBlock)(void);         /**<   用户名 */
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, assign) BOOL showLoginView;
@property (nonatomic, strong) NSString *imgName;
@end

NS_ASSUME_NONNULL_END
