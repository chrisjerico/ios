//
//  NewLotteryHeaderViewCollectionReusableView.m
//  UGBWApp
//
//  Created by fish on 2020/9/27.
//  Copyright © 2020 ug. All rights reserved.
//

#import "NewLotteryHeaderViewCollectionReusableView.h"

@implementation NewLotteryHeaderViewCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    self.clipsToBounds = false;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowRadius = 2;
    self.layer.shadowOpacity = 0.1;

}

@end
