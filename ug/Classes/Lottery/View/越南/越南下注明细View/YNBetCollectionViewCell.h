//
//  YNBetCollectionViewCell.h
//  UGBWApp
//
//  Created by ug on 2020/8/30.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UGGameBetModel;
NS_ASSUME_NONNULL_BEGIN

@interface YNBetCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UGGameBetModel *item;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@end

NS_ASSUME_NONNULL_END
