//
//  UGGameListCollectionViewCell.h
//  ug
//
//  Created by ug on 2019/6/15.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UGSubGameModel;
NS_ASSUME_NONNULL_BEGIN

@interface UGGameListCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UGSubGameModel *item;

@end

NS_ASSUME_NONNULL_END
