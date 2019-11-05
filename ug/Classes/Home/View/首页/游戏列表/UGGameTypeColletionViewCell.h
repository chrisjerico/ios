//
//  UGGameTypeColletionViewCell.h
//  ug
//
//  Created by ug on 2019/5/2.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameCategoryDataModel.h"

@class UGPlatformGameModel;
NS_ASSUME_NONNULL_BEGIN

@interface UGGameTypeColletionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *hotImageView;
@property (nonatomic, strong)UIImageView *hasSubSign;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imgName;
@property (nonatomic, strong) GameModel *item;

@end

NS_ASSUME_NONNULL_END
