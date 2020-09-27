//
//  NewLotteryRightCollectionViewCell.m
//  UGBWApp
//
//  Created by fish on 2020/9/27.
//  Copyright © 2020 ug. All rights reserved.
//

#import "NewLotteryRightCollectionViewCell.h"

@implementation NewLotteryRightCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.clipsToBounds = false;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowRadius = 2;
    self.layer.shadowOpacity = 0.1;
//    self.layer.borderColor = Skin1.textColor2.CGColor;//边框颜色
//    self.layer.borderWidth = 0.5;//边框宽度
    [self setBackgroundColor:Skin1.homeContentColor];
}

@end
