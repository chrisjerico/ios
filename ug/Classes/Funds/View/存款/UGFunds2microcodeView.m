//
//  UGFunds2microcodeView.m
//  ug
//
//  Created by ug on 2019/9/13.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGFunds2microcodeView.h"

@interface UGFunds2microcodeView ()
@property (strong, nonatomic)  UGFunds2microcodeView *contentView;
@end
@implementation UGFunds2microcodeView

-(void)initSubView{
    FastSubViewCode(self);
    subLabel(@"二维码Label").textColor = Skin1.textColor1;
    subLabel(@"扫码Label").textColor = Skin1.textColor1;
    self.layer.borderColor= UGRGBColor(221, 221, 221).CGColor;
    self.layer.borderWidth=1;
}

- (instancetype) UGFunds2microcodeView {
    NSBundle *bundle=[NSBundle mainBundle];
    NSArray *objs=[bundle loadNibNamed:@"UGFunds2microcodeView" owner:nil options:nil];
    return [objs lastObject];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    
    NSLog(@"self = %@",self);
//    if (!self.subviews.count) {
    if (self) {
        self.contentView = [[UGFunds2microcodeView alloc] initWithFrame:CGRectMake(0, 0,  APP.Width, 208)];
        [self addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
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
    self.contentView.headerImageStr = headerImageStr;
    FastSubViewCode(self)
    
    [subImageView(@"图片imgV") sd_setImageWithURL:[NSURL URLWithString:headerImageStr] placeholderImage:[UIImage imageNamed:@"bg_microcode"]];
    
}

- (IBAction)showClick:(id)sender {
//    if (self.showBlock) {
//        self.showBlock();
//    }
    
    if ([CMCommon stringIsNull:self.contentView.headerImageStr]) {
        return ;
    } else {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 250, 250)];
        [imgView sd_setImageWithURL:[NSURL URLWithString:self.contentView.headerImageStr] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        [LEEAlert alert].config
        .LeeTitle(@"二维码")
        .LeeAddCustomView(^(LEECustomView *custom) {
            custom.view = imgView;
            custom.isAutoWidth = YES;
        })
        .LeeCancelAction(@"关闭", nil)
        .LeeShow();
    }
    
}
@end
