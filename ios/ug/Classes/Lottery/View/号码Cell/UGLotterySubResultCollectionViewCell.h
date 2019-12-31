//
//  UGLotterySubResultCollectionViewCell.h
//  ug
//
//  Created by ug on 2019/5/11.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGLotterySubResultCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) UIColor *titleColor;

@property (nonatomic, assign) BOOL showAdd;

@property (nonatomic, assign) BOOL win;
@end

NS_ASSUME_NONNULL_END
