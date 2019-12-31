//
//  UGhomeRecommendCollectionViewCell.h
//  ug
//
//  Created by ug on 2019/9/30.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UGYYPlatformGames;
@class UGYYGames;
NS_ASSUME_NONNULL_BEGIN

@interface UGhomeRecommendCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UGYYPlatformGames *item;

@property (nonatomic, strong) UGYYGames *itemGame;
@end

NS_ASSUME_NONNULL_END
