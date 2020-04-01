//
//  PromoteTitleCollectionViewCell.m
//  ug
//
//  Created by ug on 2020/2/22.
//  Copyright © 2020 ug. All rights reserved.
//

#import "PromoteTitleCollectionViewCell.h"

@implementation PromoteTitleCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setBackgroundColor:Skin1.homeContentColor];
    _titleLabel.textColor = Skin1.textColor1;
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        self.titleLabel.textColor = [UIColor redColor];

    } else {
        self.titleLabel.textColor = Skin1.textColor1;

    }
    

}
@end
