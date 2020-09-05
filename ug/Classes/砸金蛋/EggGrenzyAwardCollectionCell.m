//
//  EggGrenzyAwardCollectionCell.m
//  UGBWApp
//
//  Created by xionghx on 2020/8/27.
//  Copyright © 2020 ug. All rights reserved.
//

#import "EggGrenzyAwardCollectionCell.h"

@interface EggGrenzyAwardCollectionCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *awardImage;


@end
@implementation EggGrenzyAwardCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)bind: (DZPprizeModel*)model {
	self.nameLabel.text = model.prizeName;
	[self.awardImage sd_setImageWithURL:[NSURL URLWithString:model.prizeIcon]];
	
}
@end
