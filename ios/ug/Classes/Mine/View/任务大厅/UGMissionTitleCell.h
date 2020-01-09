//
//  UGMissionTitleCell.h
//  ug
//
//  Created by ug on 2019/5/28.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGMissionTitleCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *imgbgView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) NSString *imgName;
@property (nonatomic, strong) NSString *title;


@end

NS_ASSUME_NONNULL_END
