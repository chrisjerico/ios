//
//  UGTKLHomeTitleView.h
//  UGBWApp
//
//  Created by ug on 2020/9/5.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^HomeTKLTitleMoreBlock)(void);
typedef void(^HomeTKLTitleTryplayBlock)(void);
typedef void(^HomeTKLTitleLoginBlock)(void);
typedef void(^HomeTKLTitleRegisterBlock)(void);
@interface UGTKLHomeTitleView : UIView
@property (nonatomic, copy) HomeTKLTitleMoreBlock moreClickBlock;          /**<   更多 */
@property (nonatomic, copy) HomeTKLTitleTryplayBlock tryPlayClickBlock;    /**<   试玩 */
@property (nonatomic, copy) HomeTKLTitleLoginBlock loginClickBlock;        /**<   登录 */
@property (nonatomic, copy) HomeTKLTitleRegisterBlock registerClickBlock;  /**<   注册 */
@property (nonatomic, copy) void (^userNameTouchedBlock)(void);         /**<   用户名 */
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, assign) BOOL showLoginView;
@property (nonatomic, strong) NSString *imgName;
@end

NS_ASSUME_NONNULL_END
