//
//  EggGrenzyAwardCollectionCell.h
//  UGBWApp
//
//  Created by xionghx on 2020/8/27.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZPModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface EggGrenzyAwardCollectionCell : UICollectionViewCell
- (void)bind: (DZPprizeModel*)model;
@end

NS_ASSUME_NONNULL_END
