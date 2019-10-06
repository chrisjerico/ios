//
//  UGCommonLotteryController.h
//  ug
//
//  Created by xionghx on 2019/10/1.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol hiddeHeader <NSObject>

-(void)hideHeader;
-(void)hideContent;

@end

// 下注页面的基类
@interface UGCommonLotteryController : UGViewController<hiddeHeader>
@property(nonatomic, assign)BOOL shoulHideHeader;
@property(nonatomic, assign)BOOL shoulHideContent;

@end

NS_ASSUME_NONNULL_END
