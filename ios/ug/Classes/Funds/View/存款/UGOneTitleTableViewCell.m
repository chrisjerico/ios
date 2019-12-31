//
//  UGOneTitleTableViewCell.m
//  ug
//
//  Created by ug on 2019/9/12.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGOneTitleTableViewCell.h"
#import "UGdepositModel.h"

@interface UGOneTitleTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *title1Label;
@end

@implementation UGOneTitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setBackgroundColor: Skin1.cellBgColor];
    self.title1Label.textColor = Skin1.textColor1;
}

- (void)setItem:(UGrechargeBankModel *)item {
    _item = item;
    self.title1Label.text = item.name;
}

@end
