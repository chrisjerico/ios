//
//  UGNoticeHeaderView.m
//  ug
//
//  Created by ug on 2019/5/31.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGNoticeHeaderView.h"
#import "UGNoticeModel.h"

@interface UGNoticeHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

@end

@implementation UGNoticeHeaderView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.lineLabel.backgroundColor = UGBackgroundColor;
    
}

- (void)setItem:(UGNoticeModel *)item {
    _item = item;
    self.titleLabel.text = item.title;
    self.lineLabel.hidden = item.hiddenBottomLine;
    if (item.hiddenBottomLine) {
        CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI);
        self.arrowImageView.transform = transform;
    }else {
        CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI * 2);
        self.arrowImageView.transform = transform;
    }
    
}

- (IBAction)showDetail:(id)sender {
    
    if (self.clickBllock) {
        self.clickBllock();
    }
    
}

@end
