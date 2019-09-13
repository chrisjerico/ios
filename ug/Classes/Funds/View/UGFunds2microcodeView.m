//
//  UGFunds2microcodeView.m
//  ug
//
//  Created by ug on 2019/9/13.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGFunds2microcodeView.h"

@interface UGFunds2microcodeView ()


@property (weak, nonatomic) IBOutlet UIImageView *imageView;




@end
@implementation UGFunds2microcodeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"UGFunds2microcodeView" owner:self options:0].firstObject;
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];

    }
    return self;
    
}

- (void)setHeaderImageStr:(NSString *)headerImageStr {
    _headerImageStr= headerImageStr;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:headerImageStr] placeholderImage:[UIImage imageNamed:@"bg_microcode"]];
    
}

@end
