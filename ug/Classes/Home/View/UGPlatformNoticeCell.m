//
//  UGPlatformNoticeCell.m
//  ug
//
//  Created by ug on 2019/5/31.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGPlatformNoticeCell.h"
#import "UGNoticeModel.h"
@interface UGPlatformNoticeCell ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
@implementation UGPlatformNoticeCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setItem:(UGNoticeModel *)item {
    _item = item;
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
