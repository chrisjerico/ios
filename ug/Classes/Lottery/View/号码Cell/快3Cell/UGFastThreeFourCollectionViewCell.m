//
//  UGFastThreeFourCollectionViewCell.m
//  ug
//
//  Created by ug on 2019/5/18.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGFastThreeFourCollectionViewCell.h"
#import "UGGameplayModel.h"

@interface UGFastThreeFourCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView0;
@property (weak, nonatomic) IBOutlet UIImageView *imgView1;
@property (weak, nonatomic) IBOutlet UIImageView *imgView2;
@property (weak, nonatomic) IBOutlet UILabel *oddsLabel;

@end
@implementation UGFastThreeFourCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    if ([Skin1.skitType isEqualToString:@"黑色模板"]) {
        [self.contentView setBackgroundColor:Skin1.bgColor];
        [self.oddsLabel setTextColor:[UIColor whiteColor]];
        self.layer.borderWidth = 0.7;
        self.layer.borderColor = Skin1.bgColor.CGColor;
    } else {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        [self.oddsLabel setTextColor:[UIColor blackColor]];
        self.layer.borderWidth = 0.7;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
    }
}

- (void)setItem:(UGGameBetModel *)item {
    _item = item;
    self.oddsLabel.text = [item.odds removeFloatAllZero];
    
    NSArray *arr = [item.name componentsSeparatedByString:@"_"];
    self.imgView0.image = [UIImage imageNamed:[NSString stringWithFormat:@"shaizi%@",arr.firstObject]];
    self.imgView1.image = [UIImage imageNamed:[NSString stringWithFormat:@"shaizi%@",arr[1]]];
    self.imgView2.image = [UIImage imageNamed:[NSString stringWithFormat:@"shaizi%@",arr[2]]];
    

    if ([Skin1.skitType isEqualToString:@"黑色模板"]) {
         if (item.select) {
             self.layer.borderColor = [UIColor whiteColor].CGColor;
             self.layer.borderWidth = 1;
         }else {
             self.layer.borderWidth = 0.7;
             self.layer.borderColor = Skin1.bgColor.CGColor;
         }
    } else {
        if (item.select) {
            self.layer.borderColor = Skin1.navBarBgColor.CGColor;
            self.layer.borderWidth = 1;
        }else {
            self.layer.borderWidth = 0.7;
            self.layer.borderColor = [UIColor whiteColor].CGColor;
        }
    }
}

@end
