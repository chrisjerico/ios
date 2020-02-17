//
//  UGMosaicGoldTableViewCell.m
//  ug
//
//  Created by ug on 2019/9/18.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGMosaicGoldTableViewCell.h"
#import "UGMosaicGoldModel.h"

@interface UGMosaicGoldTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *myButton;
@property (weak, nonatomic) IBOutlet UILabel *tiltleLabel;

@end
@implementation UGMosaicGoldTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _tiltleLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    
    _myButton.layer.cornerRadius = 5;
    _myButton.layer.masksToBounds = YES;
    _myButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _myButton.layer.borderWidth = 1;
    _myButton.backgroundColor = Skin1.navBarBgColor;
}

- (void)setItem:(UGMosaicGoldModel *)item {
    _item = item;
    self.tiltleLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:item.param.win_apply_image] placeholderImage:[UIImage imageNamed:@"winapply_default"]];
    
    NSString *titleShow = @"";
    switch (item.param.activity_type2.intValue) {
        case 1:
            titleShow = @"热门";
            break;
        case 2:
            titleShow = @"彩票";
            break;
        case 3:
            titleShow = @"真人";
            break;
        case 4:
            titleShow = @"捕鱼";
            break;
        case 5:
            titleShow = @"电子";
            break;
        case 6:
            titleShow = @"棋牌";
            break;
        case 7:
            titleShow = @"体育";
            break;
        case 8:
            titleShow = @"电竞";
            break;
        case 9:
            titleShow = @"其他";
            break;
        default:
            break;
    }
    
    if (SysConf.homeTypeSelect) {
        self.tiltleLabel.text = [NSString stringWithFormat:@"%@--%@",titleShow,item.name];
    }
    else{
        self.tiltleLabel.text = item.name;
    }
    
    
}

- (IBAction)buttonClick:(id)sender {
    if (self.myBlock) {
        self.myBlock();
    }
}
@end
