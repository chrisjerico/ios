//
//  UGMosaicGoldTableViewCell.h
//  ug
//
//  Created by ug on 2019/9/18.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MosaicGoldBlock)(void);

@class UGMosaicGoldModel;
NS_ASSUME_NONNULL_BEGIN

@interface UGMosaicGoldTableViewCell : UITableViewCell
@property (nonatomic, strong) UGMosaicGoldModel *item;
@property (nonatomic, copy) MosaicGoldBlock myBlock;


@end

NS_ASSUME_NONNULL_END
