//
//  MessageUnderMenuView.h
//  UGBWApp
//
//  Created by ug on 2020/6/19.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^MessageUnderMenuViewDelClickBlcok)(void);
typedef void(^MessageUnderMenuViewReadedClickBlcok)(void);
@interface MessageUnderMenuView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *arrowImg;
@property (weak, nonatomic) IBOutlet UIButton *showBtn;
@property (nonatomic, assign) CGRect oldFrame; /**<   老的fram */
- (instancetype)initView  ;           /**<    */

@property (nonatomic, copy) MessageUnderMenuViewDelClickBlcok delclickBllock;
@property (nonatomic, copy) MessageUnderMenuViewReadedClickBlcok readedclickBllock;
@end

NS_ASSUME_NONNULL_END
