//
//  UGLotteryAssistantTableViewCell.h
//  ug
//
//  Created by ug on 2019/5/11.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UGChanglongaideModel;
NS_ASSUME_NONNULL_BEGIN

typedef void(^ChanglongBetItemSelectBlock)(NSInteger index);
@interface UGLotteryAssistantTableViewCell : UITableViewCell

@property (nonatomic, strong) UGChanglongaideModel *item;
@property (nonatomic, copy) ChanglongBetItemSelectBlock betItemSelectBlock;
@end

NS_ASSUME_NONNULL_END
