//
//  LotteryView.h
//  UGBWApp
//
//  Created by andrew on 2020/11/22.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//typedef void(^LotteryViewCMClickBlcok)(UIControl *sender);//筹码

@interface LotteryView : UIView
@property (weak, nonatomic) IBOutlet UIView *closeView;//封盘
//@property (nonatomic, copy) LotteryViewCMClickBlcok cmllock;

@property (nonatomic, strong) NSString *gameId;


- (void)reloadData:(void (^)(BOOL succ))completion;
@end

NS_ASSUME_NONNULL_END
