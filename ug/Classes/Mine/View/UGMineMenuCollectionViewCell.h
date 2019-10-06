//
//  UGMineMenuCollectionViewCell.h
//  ug
//
//  Created by ug on 2019/4/30.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGMineMenuCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) NSString *menuName;

@property (nonatomic, assign) NSInteger badgeNum;

@end

NS_ASSUME_NONNULL_END
