//
//  UGSSCBetItem1Cell.h
//  ug
//
//  Created by ug on 2019/7/24.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UGGameBetModel;
NS_ASSUME_NONNULL_BEGIN

@interface UGSSCBetItem1Cell : UICollectionViewCell
@property (nonatomic, strong) UGGameBetModel *item;
@property (nonatomic, strong) UIColor *nameColor;
@property (nonatomic, assign) float nameCornerRadius;
@end

NS_ASSUME_NONNULL_END
