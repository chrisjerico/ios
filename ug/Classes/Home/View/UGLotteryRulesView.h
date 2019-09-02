//
//  UGLotteryRulesView.h
//  ug
//
//  Created by ug on 2019/6/1.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGLotteryRulesView : UIView
@property (nonatomic, strong) NSString *gameId;
@property (nonatomic, strong) NSString *gameName;
@property (nonatomic, strong) NSString *content;

- (void)show;
@end

NS_ASSUME_NONNULL_END
