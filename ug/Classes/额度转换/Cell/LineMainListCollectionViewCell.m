//
//  LineMainListCollectionViewCell.m
//  ug
//
//  Created by ug on 2020/2/21.
//  Copyright © 2020 ug. All rights reserved.
//

#import "LineMainListCollectionViewCell.h"
#import "UGPlatformGameModel.h"

@interface LineMainListCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;

@end

@implementation LineMainListCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setItem:(UGPlatformGameModel *)item {
    _item = item;
    self.nameLabel.text = item.title;
    
    if (item.balance) {
        self.balanceLabel.text = [NSString stringWithFormat:@"¥%@", item.balance];
        [_balanceLabel setHidden:NO];
        [_refreshButton setHidden:YES];
    } else {
        self.balanceLabel.text = @"加载失败";
        [_refreshButton setHidden:NO];
    }
}

- (IBAction)refreshClick:(id)sender {
    if (self.refreshBlock) {
        self.refreshBlock();
    }
}

-(void)animationFunction{
    if (_item.refreshing) {
        [self startAnimation];
    } else {
        [self.refreshButton.layer removeAllAnimations];
    }
}

//刷新余额动画
-(void)startAnimation {
    CABasicAnimation *ReFreshAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    ReFreshAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
    ReFreshAnimation.duration = 1;
    ReFreshAnimation.repeatCount = HUGE_VALF;
    [self.refreshButton.layer addAnimation:ReFreshAnimation forKey:@"rotationAnimation"];
}
@end
