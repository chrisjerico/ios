//
//  InviteCodeGenerateVC.h
//  UGBWApp
//
//  Created by xionghx on 2020/11/3.
//  Copyright © 2020 ug. All rights reserved.
//

#import "UGViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol InviteCodeGenerateDelegate <NSObject>

-(void)generated;

@end

@interface InviteCodeGenerateVC : UGViewController
@property (nonatomic, weak)id<InviteCodeGenerateDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
