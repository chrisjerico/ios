//
//  LotteryBetAndChatVC.h
//  ug
//
//  Created by fish on 2020/1/4.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LotteryBetAndChatVC : UIViewController

@property (nonatomic, strong) UGNextIssueModel *nim;

@property (nonatomic) bool selectChat;//显示聊天室

@property (nonatomic) bool isHeightLess50;//从tabbar 聊天室进入，高度-50



@end

NS_ASSUME_NONNULL_END
