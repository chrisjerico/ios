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
    self.title  = @"申请代理";
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    
    FastSubViewCode(self.view);
    // 占位Label
    {
    
        [subTextView(@"内容TextView") cc_hookSelector:@selector(setText:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> ai) {
            subLabel(@"占位Label").hidden = subTextView(@"内容TextView").text.length;
        } error:nil];
        [self xw_addNotificationForName:UITextViewTextDidChangeNotification block:^(NSNotification * _Nonnull noti) {
            subLabel(@"占位Label").hidden = subTextView(@"内容TextView").text.length;
        }];
    }
    
    [self.view setBackgroundColor:Skin1.textColor4];
    
    [subLabel(@"QQ1Label") setTextColor:Skin1.textColor1];
    [subTextField(@"QQTextField") setTextColor:Skin1.textColor1];
    subTextField(@"QQTextField").attributedPlaceholder = [[NSAttributedString alloc] initWithString:subTextField(@"QQTextField").placeholder attributes:@{NSForegroundColorAttributeName:Skin1.textColor3}];
    [subView(@"QQ1View") setBackgroundColor:Skin1.CLBgColor];
    
    [subLabel(@"联系电话1label") setTextColor:Skin1.textColor1];
    [subTextField(@"联系电话TextField") setTextColor:Skin1.textColor1];
    subTextField(@"联系电话TextField").attributedPlaceholder = [[NSAttributedString alloc] initWithString:subTextField(@"联系电话TextField").placeholder attributes:@{NSForegroundColorAttributeName:Skin1.textColor3}];
    [subView(@"联系电话1View") setBackgroundColor:Skin1.textColor4];
    
    [subLabel(@"申请内容label") setTextColor:Skin1.textColor1];
    [subView(@"申请内容View") setBackgroundColor:Skin1.CLBgColor];
    
    [subLabel(@"占位Label") setTextColor:Skin1.textColor3];
    [subTextView(@"内容TextView") setTextColor:Skin1.textColor1];
    [subView(@"申请理由View") setBackgroundColor:Skin1.textColor4];
    
    [subView(@"申请按钮View") setBackgroundColor:Skin1.textColor4];
    
    [subLabel(@"用户label") setTextColor:Skin1.textColor1];
    [subLabel(@"用户名Label") setTextColor:Skin1.textColor1];
    [subView(@"用户View") setBackgroundColor:Skin1.textColor4];
    
    [subLabel(@"QQLabel") setTextColor:Skin1.textColor1];
    [subLabel(@"QQ2Label") setTextColor:Skin1.textColor1];
    [subView(@"QQ2View") setBackgroundColor:Skin1.CLBgColor];
    
    [subLabel(@"联系电话Label") setTextColor:Skin1.textColor1];
    [subLabel(@"联系电话2Label") setTextColor:Skin1.textColor1];
    [subView(@"联系电话2View") setBackgroundColor:Skin1.textColor4];
    
    [subLabel(@"申请状态Label") setTextColor:Skin1.textColor1];
    [subLabel(@"申请状态2Label") setTextColor:Skin1.textColor1];
    [subView(@"申请状态View") setBackgroundColor:Skin1.CLBgColor];
    
    [subLabel(@"拒绝原因Label") setTextColor:Skin1.textColor1];
    [subLabel(@"拒绝原因2Label") setTextColor:Skin1.textColor1];
    [subView(@"拒绝原因View") setBackgroundColor:Skin1.textColor4];
    
    [subView(@"再次申请View") setBackgroundColor:Skin1.textColor4];
    
    [self refreshUI];
}

- (void)refreshUI {
    int state = _item.reviewStatus.intValue;
    if (state == 0 || state == 1) {
        // 未提交、审核中
        FastSubViewCode(_sv1);
        subTextField(@"QQTextField").text = state == 0 ? @"" : _item.qq;
        subTextField(@"联系电话TextField").text = state == 0 ? @"" : _item.mobile;
        subTextView(@"内容TextView").text = state == 0 ? @"" : _item.applyReason;
        subTextField(@"QQTextField").userInteractionEnabled = state == 0;
        subTextField(@"联系电话TextField").userInteractionEnabled = state == 0;
        subTextView(@"内容TextView").userInteractionEnabled = state == 0;
        subButton(@"申请Button").userInteractionEnabled = state == 0;
        subButton(@"申请Button").backgroundColor = state == 0 ? Skin1.navBarBgColor : [UIColor grayColor];
        subLabel(@"已申请提示Label").hidden = state == 0;
    }
    else if (state == 3) {
        // 审核拒绝
        FastSubViewCode(_sv2);
        subLabel(@"用户名Label").text = _item.username;
        subLabel(@"QQLabel").text = _item.qq;
        subLabel(@"联系电话Label").text = _item.mobile;
        subLabel(@"拒绝原因Label").text = _item.reviewResult;
        subButton(@"申请Button").backgroundColor = Skin1.navBarBgColor;
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
