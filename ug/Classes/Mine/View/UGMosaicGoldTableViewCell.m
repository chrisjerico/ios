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
    // Initialization code
     self.tiltleLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    
    self.myButton.layer.cornerRadius = 5; 
    self.myButton.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItem:(UGMosaicGoldModel *)item {
    _item = item;
    self.tiltleLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:item.param.win_apply_image] placeholderImage:[UIImage imageNamed:@"winapply_default"]];
    self.tiltleLabel.text = item.name;
    
}

- (IBAction)buttonClick:(id)sender {
    if (self.myBlock) {
        self.myBlock();
    }
}
@end
