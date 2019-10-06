//
//  UGBankCardInfoController.m
//  ug
//
//  Created by ug on 2019/5/25.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGBankCardInfoController.h"
#import "UGCardInfoModel.h"
#import "SLWebViewController.h"
#import "UGSystemConfigModel.h"
@interface UGBankCardInfoController ()
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (nonatomic, strong) UGCardInfoModel *cardInfoModel;

@end

@implementation UGBankCardInfoController
-(void)skin{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"银行卡管理";
    SANotificationEventSubscribe(UGNotificationWithSkinSuccess, self, ^(typeof (self) self, id obj) {
        
        [self skin];
    });
    self.infoView.layer.cornerRadius = 10;
    self.infoView.layer.masksToBounds = YES;
    self.infoView.layer.borderWidth = 1;
    self.infoView.layer.borderColor = [[UIColor grayColor] CGColor];
    [self.infoView setBackgroundColor: [[UGSkinManagers shareInstance] setCellbgColor]];
    [self getCardInfo];
}

- (void)getCardInfo {
    
    [SVProgressHUD showWithStatus:nil];
    [CMNetwork getBankCardInfoWithParams:@{@"token":[UGUserModel currentUser].sessid} completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            [SVProgressHUD showSuccessWithStatus:model.msg];
             self.cardInfoModel = model.data;
            [UGCardInfoModel setCurrentBankCardInfo:model.data];
            [self setCardInfo:self.cardInfoModel];
            
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }];
}

- (void)setCardInfo:(UGCardInfoModel *)model {
    self.bankNameLabel.text = model.bankName;
    self.userNameLabel.text = [NSString stringWithFormat:@"持卡人姓名：%@",model.ownerName];
    self.accountLabel.text = [NSString stringWithFormat:@"银行账户：%@",model.bankCard];
    self.addressLabel.text = [NSString stringWithFormat:@"开卡地址：%@",model.bankAddr];
    
}

- (IBAction)eidtButtonClick:(id)sender {
    [QDAlertView showWithTitle:@"是否联系客服？" message:@"为了您的资金安全，银行卡信息一经确定，无法随意修改。请联系客服修改您的银行卡相关信息" cancelButtonTitle:@"取消" otherButtonTitle:@"确定" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex) {
            SLWebViewController *webViewVC = [[SLWebViewController alloc] init];
            UGSystemConfigModel *config = [UGSystemConfigModel currentConfig];
            if (config.zxkfUrl) {
                
                webViewVC.urlStr = config.zxkfUrl;
            }
            [self.navigationController pushViewController:webViewVC animated:YES];
        }
    }];
}


@end
