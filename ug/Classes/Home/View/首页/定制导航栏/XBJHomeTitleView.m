//
//  XBJHomeTitleView.m
//  UGBWApp
//
//  Created by fish on 2020/11/17.
//  Copyright © 2020 ug. All rights reserved.
//

#import "XBJHomeTitleView.h"
#import "UGYYRightMenuView.h"

@implementation XBJHomeTitleView

- (void)awakeFromNib {
    [super awakeFromNib];
    FastSubViewCode(self)
    subLabel(@"易记域名Label").text = SysConf.easyRememberDomain;
    [subImageView(@"LogoImageView") sd_setImageWithURL:[NSURL URLWithString:SysConf.mobile_logo]];
    self.backgroundColor = Skin1.navBarBgColor;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.superview);
    }];
}

- (IBAction)onMoreBtnClick:(UIButton *)sender {
    UGYYRightMenuView *yymenuView = [[UGYYRightMenuView alloc] initWithFrame:CGRectMake(UGScreenW /2 , 0, UGScreenW / 2, UGScerrnH)];
    yymenuView.titleType = @"1";
    yymenuView.showFromLeft = true;
    [yymenuView show];
}

@end

