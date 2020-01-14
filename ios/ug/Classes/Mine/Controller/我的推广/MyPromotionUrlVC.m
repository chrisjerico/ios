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
	self.homePageQRCodeLabel.text = nil;
	self.registQRCodeLabel.text = nil;
	
}
- (IBAction)showHomePageUrlTaped:(UIButton *)sender {
	if (sender.isSelected) {
		self.homePageQRCodeLabel.attributedText = nil;
	} else {
//		UIImage * image = [SGQRCodeObtain generateQRCodeWithData:self.inviteInfo.link_i size:160.0];
//		NSTextAttachment * attachement = [[NSTextAttachment alloc] init];
//		attachement.image = image;
//		attachement.bounds = CGRectMake(0, 0, 70, 70);
//		NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithAttributedString: [NSAttributedString attributedStringWithAttachment:attachement]];
//		NSMutableAttributedString * otherAttributedText = [[NSMutableAttributedString alloc] initWithString:@"（二维码请使用浏览器识别打开）"];
//		[otherAttributedText setAttributes:@{} range:NSMakeRange(0, otherAttributedText.length)];
//		[attributedText appendAttributedString:otherAttributedText];
//		self.homePageQRCodeLabel.attributedText = attributedText;
	}
	[sender setSelected: !sender.isSelected];
}
- (IBAction)showRegistUrlTaped:(UIButton *)sender {
	if (sender.isSelected) {
		self.registQRCodeLabel.attributedText = nil;
	} else {
		self.registQRCodeLabel.attributedText = nil;
	}
	[sender setSelected: !sender.isSelected];
}
- (IBAction)homePageUrlCopyTaped:(id)sender {
}

- (IBAction)registUrlCopyTaped:(id)sender {
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
			
		} failure:^(id msg) {
			[SVProgressHUD dismiss];
		}];
	}];
	
}

@end
