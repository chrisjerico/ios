//
//  JYGameCollectionViewCell.h
//  ug
//
//  Created by ug on 2020/2/13.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameCategoryDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JYGameCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) GameModel *item;
@end

NS_ASSUME_NONNULL_END
