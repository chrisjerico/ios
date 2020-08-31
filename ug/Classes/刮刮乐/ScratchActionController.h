//
//  ScratchActionController.h
//  UGBWApp
//
//  Created by xionghx on 2020/8/27.
//  Copyright © 2020 ug. All rights reserved.
//

#import "UGViewController.h"
#import "ScratchDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScratchActionController : UGViewController
- (void)bindNumber: (NSInteger )number resultBlock: (void(^)(NSString *))resultBlock;
@property(nonatomic, strong)ScratchWinModel* item;

@end

NS_ASSUME_NONNULL_END
