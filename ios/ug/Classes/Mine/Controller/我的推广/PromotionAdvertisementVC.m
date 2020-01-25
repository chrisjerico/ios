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
@property (weak, nonatomic) IBOutlet UIView *upView;
@property (weak, nonatomic) IBOutlet UIView *midView;

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
        [NavController1 pushViewController:_LoadVC_from_storyboard_(@"MyPromotionUrlVC") animated:true];
    }];

    [subButton(@"分享推广图Btn") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
    [subButton(@"分享推广图Btn") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
        //    1.获取一个截图图片
        UIImage *newImage = [ UIImage rendImageWithView:self.view];
        UIActivityViewController *vc = [CMCommon sysSharText:@"分享" Image:newImage URL:nil type:@"1"];
        [self presentViewController:vc animated:YES completion:nil];
    }];
    [subButton(@"分享链接Btn") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
    [subButton(@"分享链接Btn") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
        UIActivityViewController *vc =[CMCommon sysSharText:@"分享" Image:nil URL:[NSURL URLWithString:self.inviteInfo.link_i ] type:@"2"];
        [self presentViewController:vc animated:YES completion:nil];
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
    NSLog(@"");
    if (error) {
        [CMCommon showToastTitle:@"保存失败"];
    }else{
        [CMCommon showToastTitle:@"保存成功"];
    
    }
    
    NSLog(@"%@",contextInfo);
    
}
@end
