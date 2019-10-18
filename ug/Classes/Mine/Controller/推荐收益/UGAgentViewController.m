//
//  UGAgentViewController.m
//  ug
//
//  Created by ug on 2019/9/24.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGAgentViewController.h"
#import "UGagentApplyInfo.h"

@interface UGAgentViewController ()<UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIStackView *sv1;  /**<   审核拒绝 */
@property (weak, nonatomic) IBOutlet UIStackView *sv2;  /**<   未提交、审核中 */
@end


@implementation UGAgentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = @"代理申请";
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    // 占位Label
    {
        FastSubViewCode(self.view);
        [subTextView(@"内容TextView") aspect_hookSelector:@selector(setText:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> ai) {
            subLabel(@"占位Label").hidden = subTextView(@"内容TextView").text.length;
        } error:nil];
        [self xw_addNotificationForName:UITextViewTextDidChangeNotification block:^(NSNotification * _Nonnull noti) {
            subLabel(@"占位Label").hidden = subTextView(@"内容TextView").text.length;
        }];
    }
    
    [self refreshUI];
}

- (void)refreshUI {
    int state = _item.reviewStatus.intValue;
    if (state == 0 || state == 1) {
        // 未提交、审核中
        FastSubViewCode(_sv1);
        subTextField(@"QQTextField").text = _item.qq;
        subTextField(@"联系电话TextField").text = _item.mobile;
        subTextView(@"内容TextView").text = _item.applyReason;
        subTextField(@"QQTextField").userInteractionEnabled = state == 0;
        subTextField(@"联系电话TextField").userInteractionEnabled = state == 0;
        subTextView(@"内容TextView").userInteractionEnabled = state == 0;
        subButton(@"申请Button").userInteractionEnabled = state == 0;
        subButton(@"申请Button").backgroundColor = state == 0 ? [[UGSkinManagers shareInstance] setNavbgColor] : [UIColor grayColor];
        subLabel(@"已申请提示Label").hidden = state == 0;
    }
    else if (state == 3) {
        // 审核拒绝
        FastSubViewCode(_sv2);
        subLabel(@"用户名Label").text = _item.username;
        subLabel(@"QQLabel").text = _item.qq;
        subLabel(@"联系电话Label").text = _item.mobile;
        subLabel(@"拒绝原因Label").text = _item.reviewResult;
        subButton(@"申请Button").backgroundColor = [[UGSkinManagers shareInstance] setNavbgColor];
    }
    
    _sv1.hidden = state == 3;
    _sv2.hidden = state != 3;
}

// 申请
- (IBAction)onApplyBtnClick:(UIButton *)sender {
    FastSubViewCode(_sv1);
    
    NSString *qqStr = [subTextField(@"QQTextField").text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *phoneStr = [subTextField(@"联系电话TextField").text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *remarkStr = [subTextView(@"内容TextView").text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    

    
    BOOL isOk = [CMCommon stringIsNull:phoneStr ];
    
     BOOL isOk2 = [CMCommon stringIsNull:qqStr ];
    
    if (![CMCommon stringIsNull:qqStr ] || ![CMCommon stringIsNull:phoneStr ] ) {}
    else{
        [self.view makeToast:@"QQ号和手机号必须填一个"];
        return;
    }
    if (remarkStr.length<6 ||  remarkStr.length>30) {
        [self.view makeToast:@"申请理由大于6 小于30"];
        return;
    }
    if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
        return;
    }
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"action":@"apply",
                             @"qq":qqStr,
                             @"phone":phoneStr,
                             @"content":remarkStr
                             };
    
    [SVProgressHUD showWithStatus:nil];
    [CMNetwork teamAgentApplyWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            [SVProgressHUD showSuccessWithStatus:model.msg];
            [NavController1 popViewControllerAnimated:YES];
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }];
}

// 再次申请
- (IBAction)onApplyAgainBtnClick:(UIButton *)sender {
    _item.reviewStatus = @0;
    [self refreshUI];
}

@end
