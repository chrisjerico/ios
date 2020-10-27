//
//  TkLMoneyCollectionViewCell.h
//  UGBWApp
//
//  Created by fish on 2020/10/26.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TkLMoneyCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) NSString *menuName;
@end

NS_ASSUME_NONNULL_END
