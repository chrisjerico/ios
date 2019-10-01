//
//  UGPlatformBalanceTableViewCell.m
//  ug
//
//  Created by ug on 2019/5/8.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGPlatformBalanceTableViewCell.h"
#import "UGPlatformGameModel.h"

@interface UGPlatformBalanceTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;

@end
@implementation UGPlatformBalanceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
      [self setBackgroundColor: [[UGSkinManagers shareInstance] setCellbgColor]];
}

-(void)setItem:(UGPlatformGameModel *)item {
    _item = item;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:item.pic]];
    self.nameLabel.text = item.title;
    if (item.balance) {
        self.balanceLabel.text = [NSString stringWithFormat:@"¥%@",item.balance];
    }else {
        self.balanceLabel.text = @"¥*****";
    }
    if (item.refreshing) {
        [self startAnimation];
    }else {
        [self.refreshButton.layer removeAllAnimations];
    }
    
}

- (IBAction)refreshClick:(id)sender {
    if (self.refreshBlock) {
        self.refreshBlock();
    }
    
}

//刷新余额动画
-(void)startAnimation
{
    
    CABasicAnimation *ReFreshAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    ReFreshAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
    ReFreshAnimation.duration = 1;
    ReFreshAnimation.repeatCount = HUGE_VALF;
    [self.refreshButton.layer addAnimation:ReFreshAnimation forKey:@"rotationAnimation"];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
