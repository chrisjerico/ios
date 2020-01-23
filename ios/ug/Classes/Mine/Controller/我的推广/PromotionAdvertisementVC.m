//
//  PromotionAdvertisementVC.m
//  ug
//
//  Created by xionghx on 2020/1/10.
//  Copyright © 2020 ug. All rights reserved.
//

#import "PromotionAdvertisementVC.h"
#import "UGinviteInfoModel.h"
#import "SGQRCodeObtain.h"
#import "UIImage+Extension.h"

@interface PromotionAdvertisementVC ()
@property (nonatomic, strong) UGinviteInfoModel* inviteInfo;
@end

@implementation PromotionAdvertisementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
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
    FastSubViewCode(self.view);
    UIImage * image = [SGQRCodeObtain generateQRCodeWithData:self.inviteInfo.link_i size:160.0];
    [subImageView(@"二微码ImgV") setImage:image];
    [subButton(@"备用网址Btn") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
    [subButton(@"备用网址Btn") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
       
    }];
    [subButton(@"朋友圈Btn") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
    [subButton(@"朋友圈Btn") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
       NSString *shareText = @"分享";
       UIImage *shareImage = [UIImage imageNamed:@"BM_qqwallet_payment"];
       NSURL *shareURL = [NSURL URLWithString:self.inviteInfo.link_i];
       NSArray *activityItems = [[NSArray alloc] initWithObjects:shareText, shareImage, shareURL, nil];
       
       UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
       
       UIActivityViewControllerCompletionWithItemsHandler myBlock = ^(UIActivityType activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
           NSLog(@"%@",activityType);
           if (completed) {
               NSLog(@"分享成功");
           } else {
               NSLog(@"分享失败");
           }
           [vc dismissViewControllerAnimated:YES completion:nil];
       };
       
       vc.completionWithItemsHandler = myBlock;
       
       [self presentViewController:vc animated:YES completion:nil];
    }];
    [subButton(@"微信好友Btn") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
    [subButton(@"微信好友Btn") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
       
    }];
    [subButton(@"QQ好友Btn") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
    [subButton(@"QQ好友Btn") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
       
    }];
    [subButton(@"QQ空间Btn") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
    [subButton(@"QQ空间Btn") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
       
    }];
    [subButton(@"微博Btn") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
    [subButton(@"微博Btn") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
       
    }];
    [subButton(@"分享推广图Btn") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
    [subButton(@"分享推广图Btn") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
       
    }];
    [subButton(@"复制链接Btn") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
    [subButton(@"复制链接Btn") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
       UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
       pasteboard.string = self.inviteInfo.link_i;
       [SVProgressHUD showSuccessWithStatus:@"复制成功"];
    }];
    [subButton(@"保存推广图Btn") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
    [subButton(@"保存推广图Btn") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
      //    1.获取一个截图图片
          UIImage *newImage = [ UIImage rendImageWithView:self.view];
      //    2.写入相册
          UIImageWriteToSavedPhotosAlbum(newImage, self, @selector(image:didFinishSavingWithError:contextInfo:), @"134");
    }];
    [subButton(@"说明Btn") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
    [subButton(@"说明Btn") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
       [NavController1 pushViewController:_LoadVC_from_storyboard_(@"PromotionIntroductionVC") animated:true];
    }];
    [subButton(@"我的会员Btn") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
    [subButton(@"我的会员Btn") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
        [NavController1 pushViewController:_LoadVC_from_storyboard_(@"MyPromotionMembersVC") animated:true];
    }];
    [subButton(@"会员投注Btn") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
    [subButton(@"会员投注Btn") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
[NavController1 pushViewController:_LoadVC_from_storyboard_(@"PromotionBetReportVC") animated:true];
    }];
    [subButton(@"会员交易Btn") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
    [subButton(@"会员交易Btn") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
[NavController1 pushViewController:_LoadVC_from_storyboard_(@"PromotionBetRecordVC") animated:true];
    }];


    
}

#pragma mark 用来监听图片保存到相册的状况

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        [CMCommon showToastTitle:@"保存失败"];
    }else{
        [CMCommon showToastTitle:@"保存成功"];
    
    }
    
    NSLog(@"%@",contextInfo);
    
}
@end
