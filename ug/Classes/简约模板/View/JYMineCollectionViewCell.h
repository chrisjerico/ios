//
//  JYMineCollectionViewCell.h
//  ug
//
//  Created by ug on 2020/2/14.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JYMineCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) NSString *menuName;

@end

NS_ASSUME_NONNULL_END
