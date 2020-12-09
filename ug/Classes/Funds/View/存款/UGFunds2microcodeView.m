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

-(void)initSubView{
    FastSubViewCode(self);
    subLabel(@"二维码Label").textColor = Skin1.textColor1;
    subLabel(@"扫码Label").textColor = Skin1.textColor1;
}

- (instancetype) UGFunds2microcodeView {
    NSBundle *bundle=[NSBundle mainBundle];
    NSArray *objs=[bundle loadNibNamed:@"UGFunds2microcodeView" owner:nil options:nil];
    return [objs lastObject];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (!self.subviews.count) {
        self = [self UGFunds2microcodeView];
        CGRect frame = CGRectMake(0, 0, APP.Width, 208);
        self.frame = frame;
        [self initSubView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [self UGFunds2microcodeView];
        self.frame = frame;
        
        [self initSubView];
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];

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
