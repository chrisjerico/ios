//
//  MyPromotionUrlVC.m
//  ug
//
//  Created by xionghx on 2020/1/10.
//  Copyright © 2020 ug. All rights reserved.
//

#import "MyPromotionUrlVC.h"
#import "UGinviteInfoModel.h"
#import "SGQRCodeObtain.h"

@interface MyPromotionUrlVC ()
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *homePageUrl;
@property (weak, nonatomic) IBOutlet UILabel *registUrl;
@property (weak, nonatomic) IBOutlet UILabel *homePageQRCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *registQRCodeLabel;
@property (nonatomic, strong) UGinviteInfoModel* inviteInfo;
@end

@implementation MyPromotionUrlVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    self.homePageUrl.text = self.inviteInfo.link_i;
    self.registUrl.text = self.inviteInfo.link_r;
    
     FastSubViewCode(self.bgView);
    if (Skin1.isBlack) {
        [self.bgView setBackgroundColor:Skin1.bgColor];
        [subView(@"背景1View") setBackgroundColor:Skin1.bgColor];
        [subView(@"背景2View") setBackgroundColor:Skin1.bgColor];
        [subLabel(@"首页推荐Lable") setTextColor:Skin1.textColor1];
        [subLabel(@"备注Lable") setTextColor:Skin1.textColor1];
        [subLabel(@"链接Lable") setTextColor:Skin1.textColor1];
        [subLabel(@"二维码Lable") setTextColor:Skin1.textColor1];
        [subLabel(@"大二维码Lable") setTextColor:Skin1.textColor1];
        [subLabel(@"注册推荐地址Lable") setTextColor:Skin1.textColor1];
        [subLabel(@"域名绑定Lable") setTextColor:Skin1.textColor1];
        [subLabel(@"点击显示Lable") setTextColor:Skin1.textColor1];
        [subLabel(@"urlLable") setTextColor:RGBA(28, 135, 219, 1)];

        [subButton(@"复制Btn") setBackgroundColor:Skin1.navBarBgColor];
        [subButton(@"点击Btn") setImage:[[UIImage imageNamed:@"arrow_down"] qmui_imageWithTintColor:Skin1.textColor1] forState:0];
        [subButton(@"点击Btn") setImage:[[UIImage imageNamed:@"arrow_up"] qmui_imageWithTintColor:Skin1.textColor1] forState:UIControlStateSelected];
        
        [subLabel(@"首页推荐Lable2") setTextColor:Skin1.textColor1];
        [subLabel(@"备注Lable2") setTextColor:Skin1.textColor1];
        [subLabel(@"链接Lable2") setTextColor:Skin1.textColor1];
        [subLabel(@"二维码Lable2") setTextColor:Skin1.textColor1];
        [subLabel(@"大二维码Lable2") setTextColor:Skin1.textColor1];
        [subLabel(@"注册推荐地址Lable2") setTextColor:Skin1.textColor1];
        [subLabel(@"点击显示Lable2") setTextColor:Skin1.textColor1];
        [subLabel(@"urlLable2") setTextColor:RGBA(28, 135, 219, 1)];
        
        [subButton(@"复制Btn2") setBackgroundColor:Skin1.navBarBgColor];
        [subButton(@"点击Btn2") setImage:[[UIImage imageNamed:@"arrow_down"] qmui_imageWithTintColor:Skin1.textColor1] forState:0];
        [subButton(@"点击Btn2") setImage:[[UIImage imageNamed:@"arrow_up"] qmui_imageWithTintColor:Skin1.textColor1] forState:UIControlStateSelected];
    }
    
}
- (IBAction)showHomePageUrlTaped:(UIButton *)sender {
    if (sender.isSelected) {
        self.homePageQRCodeLabel.attributedText = nil;
    } else {
        UIImage * image = [SGQRCodeObtain generateQRCodeWithData:self.inviteInfo.link_i size:160.0];
        NSTextAttachment * attachement = [[NSTextAttachment alloc] init];
        attachement.image = image;
        attachement.bounds = CGRectMake(0, 0, 70, 70);
        NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithAttributedString: [NSAttributedString attributedStringWithAttachment:attachement]];
        NSMutableAttributedString * otherAttributedText = [[NSMutableAttributedString alloc] initWithString:@"（二维码请使用浏览器识别打开）"];
        UIColor *c;
         if (Skin1.isBlack) {
             c = Skin1.textColor1;
         }
         else{
             c = [UIColor colorWithHex:0x484D52];
         }
        [otherAttributedText setAttributes:@{NSForegroundColorAttributeName: c, NSFontAttributeName: [UIFont systemFontOfSize:12]} range:NSMakeRange(0, otherAttributedText.length)];
        [attributedText appendAttributedString:otherAttributedText];
        self.homePageQRCodeLabel.attributedText = attributedText;
    }
    [sender setSelected: !sender.isSelected];
}
- (IBAction)showRegistUrlTaped:(UIButton *)sender {
    if (sender.isSelected) {
        self.registQRCodeLabel.attributedText = nil;
    } else {
        UIImage * image = [SGQRCodeObtain generateQRCodeWithData:self.inviteInfo.link_r size:160.0];
        NSTextAttachment * attachement = [[NSTextAttachment alloc] init];
        attachement.image = image;
        attachement.bounds = CGRectMake(0, 0, 70, 70);
        NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithAttributedString: [NSAttributedString attributedStringWithAttachment:attachement]];
        NSMutableAttributedString * otherAttributedText = [[NSMutableAttributedString alloc] initWithString:@"（二维码请使用浏览器识别打开）"];
        UIColor *c;
         if (Skin1.isBlack) {
             c = Skin1.textColor1;
         }
         else{
             c = [UIColor colorWithHex:0x484D52];
         }
        [otherAttributedText setAttributes:@{NSForegroundColorAttributeName:  c, NSFontAttributeName: [UIFont systemFontOfSize:12]} range:NSMakeRange(0, otherAttributedText.length)];
        [attributedText appendAttributedString:otherAttributedText];
        self.registQRCodeLabel.attributedText = attributedText;
    }
    [sender setSelected: !sender.isSelected];
}
- (IBAction)homePageUrlCopyTaped:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.inviteInfo.link_i;
    [SVProgressHUD showSuccessWithStatus:@"复制成功"];
}

- (IBAction)registUrlCopyTaped:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.inviteInfo.link_r;
    [SVProgressHUD showSuccessWithStatus:@"复制成功"];
    
}
- (void)loadData {
    if ([UGUserModel currentUser].isTest) {
        return;
    }
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid};
    
    [SVProgressHUD showWithStatus:nil];
    WeakSelf;
    [CMNetwork teamInviteInfoWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            [SVProgressHUD dismiss];
            weakSelf.inviteInfo = model.data;
            NSLog(@"rid = %@",weakSelf.inviteInfo.rid);
            [weakSelf bindData];
        } failure:^(id msg) {
            [SVProgressHUD dismiss];
        }];
    }];
    
}


- (void)bindData {
    
    self.homePageUrl.text = self.inviteInfo.link_i;
    self.registUrl.text = self.inviteInfo.link_r;
    
}
@end
