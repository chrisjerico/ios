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
        [otherAttributedText setAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHex:0x484D52], NSFontAttributeName: [UIFont systemFontOfSize:12]} range:NSMakeRange(0, otherAttributedText.length)];
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
        [otherAttributedText setAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHex:0x484D52], NSFontAttributeName: [UIFont systemFontOfSize:12]} range:NSMakeRange(0, otherAttributedText.length)];
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
