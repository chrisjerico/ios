//
//  UGAddressCollectionViewCell.m
//  ug
//
//  Created by ug on 2019/7/13.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGAddressCollectionViewCell.h"
#import "UGLoginAddressModel.h"
@interface UGAddressCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation UGAddressCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.cornerRadius = 15;
    self.layer.masksToBounds = YES;
      [self setBackgroundColor: [[UGSkinManagers shareInstance] setCellbgColor]];
    
}

- (void)setItem:(UGLoginAddressModel *)item {
    _item = item;
    if ([@"0" isEqualToString:item.country]) {
        self.addressLabel.text = [NSString stringWithFormat:@"中国 %@",item.province];
    }else {
        self.addressLabel.text = @"国外";
    }
    
    
}
- (IBAction)delClick:(id)sender {
    if (self.delBlock) {
        self.delBlock();
    }
}

@end
