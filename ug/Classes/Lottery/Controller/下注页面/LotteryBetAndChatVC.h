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

@property (nonatomic) bool selectChat;

@property (nonatomic, strong) NSMutableDictionary *jsDic ;         /**<   分享数据*/

@end

NS_ASSUME_NONNULL_END
