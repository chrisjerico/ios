//
//  PromotionMemberRechargeVC.m
//  ug
//
//  Created by xionghx on 2020/1/10.
//  Copyright © 2020 ug. All rights reserved.
//

#import "PromotionMemberRechargeVC.h"

@interface PromotionMemberRechargeVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *relationShipLabel;
@property (weak, nonatomic) IBOutlet UILabel *memberNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *memberBalanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *myBalanceLabel;
@property (weak, nonatomic) IBOutlet UITextField *rechargeField;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@property (nonatomic, assign)BOOL isHaveDian;

@property(nonatomic, strong)UGinviteLisModel * promotionMember;

@end

@implementation PromotionMemberRechargeVC

- (void)viewDidLoad {
    [super viewDidLoad];
	self.relationShipLabel.text = nil;
	self.memberNameLabel.text = nil;
	self.memberBalanceLabel.text = nil;
	self.myBalanceLabel.text = nil;
    self.rechargeField.delegate = self;
}
- (void)bindMember:(UGinviteLisModel *)member {
	self.promotionMember = member;
	self.relationShipLabel.text = [NSString stringWithFormat:@"%@>%@", UGUserModel.currentUser.username, member.username];
	self.memberNameLabel.text = member.name.length > 0 ? member.name: member.username;
	self.memberBalanceLabel.text = member.coin;
	self.myBalanceLabel.text = UGUserModel.currentUser.balance;
}
- (IBAction)cancelButtonTaped:(id)sender {
}
- (IBAction)confirmButtonTaped:(id)sender {
    if (!SysConf.switchAgentRecharge) {
        [CMCommon showErrorTitle:@"充值功能已关闭"];
        return;
    }
    if ([CMCommon stringIsNull:_rechargeField.text]) {
        [CMCommon showErrorTitle:@"金额不能为空"];
        return;
    }
    double d = [_rechargeField.text doubleValue];
    if (d > 100000) {
        [CMCommon showErrorTitle:@"金额不能大于100000"];
        return;
    }
    
    
    NSDictionary *params = @{
        @"token":[UGUserModel currentUser].sessid,
        @"uid":self.promotionMember.uid,
        @"money":_rechargeField.text,
    };
    [SVProgressHUD showWithStatus:@"正在充值..."];
    [CMNetwork teamRechargeWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            [SVProgressHUD showSuccessWithStatus:model.msg];
            NSLog(@"model.data = %@",model.data);
//            NSDictionary *data = (NSDictionary *)model.data;



        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }];
    
    
}

/**
 *  textField的代理方法，监听textField的文字改变
 *  textField.text是当前输入字符之前的textField中的text
 *
 *  @param textField textField
 *  @param range     当前光标的位置
 *  @param string    当前输入的字符
 *
 *  @return 是否允许改变
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    /*
     * 不能输入.0-9以外的字符。
     * 设置输入框输入的内容格式
     * 只能有一个小数点
     * 小数点后最多能输入两位
     * 如果第一位是.则前面加上0.
     * 如果第一位是0则后面必须输入点，否则不能输入。
     */

    // 判断是否有小数点
    if ([textField.text containsString:@"."]) {
        self.isHaveDian = YES;
    }else{
        self.isHaveDian = NO;
    }

    if (string.length > 0) {

        //当前输入的字符
        unichar single = [string characterAtIndex:0];
        NSLog(@"single = %c",single);

        // 不能输入.0-9以外的字符
        if (!((single >= '0' && single <= '9') || single == '.'))
        {
            [CMCommon showErrorTitle:@"您的输入格式不正确"];
            return NO;
        }

        // 只能有一个小数点
        if (self.isHaveDian && single == '.') {
            [CMCommon showErrorTitle:@"最多只能输入一个小数点"];
            return NO;
        }

        // 如果第一位是.则前面加上0.
        if ((textField.text.length == 0) && (single == '.')) {
            textField.text = @"0";
        }

        // 如果第一位是0则后面必须输入点，否则不能输入。
        if ([textField.text hasPrefix:@"0"]) {
            if (textField.text.length > 1) {
                NSString *secondStr = [textField.text substringWithRange:NSMakeRange(1, 1)];
                if (![secondStr isEqualToString:@"."]) {
                    [CMCommon showErrorTitle:@"第二个字符需要是小数点"];
                    return NO;
                }
            }else{
                if (![string isEqualToString:@"."]) {
                    [CMCommon showErrorTitle:@"第二个字符需要是小数点"];
                    return NO;
                }
            }
        }

        // 小数点后最多能输入两位
//        if (self.isHaveDian) {
//            NSRange ran = [textField.text rangeOfString:@"."];
//            // 由于range.location是NSUInteger类型的，所以这里不能通过(range.location - ran.location)>2来判断
//            if (range.location > ran.location) {
//                if ((range.location - ran.location)>2) {
//                    [CMCommon showErrorTitle:@"小数点后最多有两位小数"];
//                    return NO;
//                }
//            }
//        }

    }

    return YES;
    

}

#pragma mark - 正则表达式

/**
 判断是否是两位小数

 @param str 字符串
 @return yes/no
 */
- (BOOL)checkDecimal:(NSString *)str
{
    NSString *regex = @"^[0-9]+(\\.[0-9]{1,2})?$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if([pred evaluateWithObject: str])
    {
        return YES;
    }else{
        return NO;
    }
}


@end
