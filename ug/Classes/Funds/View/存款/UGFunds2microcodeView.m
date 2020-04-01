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
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    FastSubViewCode(self);
    subLabel(@"二维码Label").textColor = Skin1.textColor1;
    subLabel(@"扫码Label").textColor = Skin1.textColor1;
}

- (void)setHeaderImageStr:(NSString *)headerImageStr {
    _headerImageStr= headerImageStr;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:headerImageStr] placeholderImage:[UIImage imageNamed:@"bg_microcode"]];
    
}

- (IBAction)showClick:(id)sender {
    if (self.showBlock) {
        self.showBlock();
    }
    
}
@end
