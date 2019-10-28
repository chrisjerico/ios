//
//  UGLHHomeLotteryCollectionViewCell.m
//  ug
//
//  Created by ug on 2019/10/27.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGLHHomeLotteryCollectionViewCell.h"

@implementation UGLHHomeLotteryCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setShowAdd:(BOOL)showAdd {
    _showAdd = showAdd;
    FastSubViewCode(self);
    subImageView(@"球图").hidden = showAdd;
    subLabel(@"球内文字").text = @"+";
    subLabel(@"球下文字").hidden = showAdd;
}
@end
